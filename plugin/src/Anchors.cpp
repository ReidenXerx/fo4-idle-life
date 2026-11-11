#include "Anchors.h"

#include <unordered_set>

extern "C" const std::byte __ImageBase;   // this DLL's own base (the linker's)

namespace IL::Anchors
{
	namespace
	{
		// The kinds of record an anchor can be: what the vanilla lists hold, and what settlement mods use.
		constexpr std::array kTypes{
			RE::ENUM_FORM_ID::kSTAT, RE::ENUM_FORM_ID::kMSTT, RE::ENUM_FORM_ID::kFURN, RE::ENUM_FORM_ID::kACTI,
			RE::ENUM_FORM_ID::kCONT, RE::ENUM_FORM_ID::kLIGH, RE::ENUM_FORM_ID::kTERM, RE::ENUM_FORM_ID::kMISC,
		};

		// "Meshes\SetDressing\FireBarrel01.nif" and "setdressing/firebarrel01.nif" are one model.
		std::string ModelKey(const RE::TESForm* a_form)
		{
			const auto* model = a_form ? a_form->As<RE::TESModel>() : nullptr;
			const char* raw = model ? model->GetModel() : nullptr;
			if (!raw || !*raw) {
				return {};
			}
			std::string key(raw);
			for (auto& c : key) {
				c = c == '/' ? '\\' : static_cast<char>(std::tolower(static_cast<unsigned char>(c)));
			}
			for (const std::string_view prefix : { "data\\"sv, "meshes\\"sv }) {
				if (key.starts_with(prefix)) {
					key.erase(0, prefix.size());
				}
			}
			return key;
		}

		// Every object of those kinds by model, built once (the records do not change during a run).
		const std::unordered_map<std::string, std::vector<RE::TESForm*>>& ByModel()
		{
			static std::unordered_map<std::string, std::vector<RE::TESForm*>> index;
			static bool built = false;
			if (built) {
				return index;
			}
			built = true;
			auto* data = RE::TESDataHandler::GetSingleton();
			if (!data) {
				return index;
			}
			const auto start = std::chrono::steady_clock::now();
			std::size_t forms = 0;
			for (const auto type : kTypes) {
				for (auto* form : data->formArrays[std::to_underlying(type)]) {
					if (auto key = ModelKey(form); !key.empty()) {
						index[std::move(key)].push_back(form);
						++forms;
					}
				}
			}
			const auto ms = std::chrono::duration_cast<std::chrono::milliseconds>(std::chrono::steady_clock::now() - start).count();
			logger::info("anchors: {} objects with a model indexed by {} models in {} ms", forms, index.size(), ms);
			return index;
		}

		// The base game and its DLCs (Creation Club content counts as another mod).
		bool Official(const RE::TESForm* a_form)
		{
			const auto* file = a_form ? a_form->GetFile(0) : nullptr;
			if (!file) {
				return true;   // made at run time: not an object a mod placed
			}
			static constexpr std::array kOfficial{ "fallout4.esm"sv, "dlcrobot.esm"sv, "dlcworkshop01.esm"sv, "dlccoast.esm"sv,
				"dlcworkshop02.esm"sv, "dlcworkshop03.esm"sv, "dlcnukaworld.esm"sv, "dlcultrahighresolution.esm"sv };
			std::string name(file->GetFilename());
			for (auto& c : name) {
				c = static_cast<char>(std::tolower(static_cast<unsigned char>(c)));
			}
			return std::ranges::find(kOfficial, std::string_view{ name }) != kOfficial.end();
		}

		std::string Name(const RE::TESForm* a_form)
		{
			const auto* file = a_form->GetFile(0);
			return std::format("{}:{:X}", file ? file->GetFilename() : "?"sv, a_form->GetFormID() & (file && file->IsLight() ? 0xFFFu : 0xFFFFFFu));
		}

		bool Has(const RE::BGSListForm* a_list, const RE::TESForm* a_form)
		{
			return a_list->ContainsItem(a_form);
		}

		std::string Lower(std::string_view a_text)
		{
			std::string out(a_text);
			for (auto& c : out) {
				c = static_cast<char>(std::tolower(static_cast<unsigned char>(c)));
			}
			return out;
		}

		std::string_view Trim(std::string_view a_text)
		{
			while (!a_text.empty() && std::isspace(static_cast<unsigned char>(a_text.front()))) {
				a_text.remove_prefix(1);
			}
			while (!a_text.empty() && std::isspace(static_cast<unsigned char>(a_text.back()))) {
				a_text.remove_suffix(1);
			}
			return a_text;
		}

		struct Listed
		{
			std::string plugin;
			std::uint32_t id{ 0 };
			std::string kind;   // lower case
			std::string where;  // file:line, for the log
		};

		// Every line of every list file, read once.
		const std::vector<Listed>& Lines()
		{
			static std::vector<Listed> lines;
			static bool read = false;
			if (read) {
				return lines;
			}
			read = true;
			// Beside this DLL (Data\F4SE\Plugins), wherever the game was started from or a mod manager put it.
			std::error_code ec;
			std::wstring self(1024, L'\0');
			const auto length = F4SE::WinAPI::GetModuleFileName(const_cast<std::byte*>(&__ImageBase), self.data(), static_cast<std::uint32_t>(self.size()));
			self.resize(length);
			const auto folder = std::filesystem::path(self).parent_path() / L"IdleLife";
			if (length == 0 || !std::filesystem::is_directory(folder, ec)) {
				logger::info("anchors: no list folder ({})", "Data\\F4SE\\Plugins\\IdleLife");
				return lines;
			}
			std::vector<std::filesystem::path> files;
			for (const auto& entry : std::filesystem::directory_iterator(folder, ec)) {
				if (entry.is_regular_file(ec) && Lower(entry.path().extension().string()) == ".txt") {
					files.push_back(entry.path());
				}
			}
			std::ranges::sort(files);
			for (const auto& file : files) {
				std::ifstream in(file);
				std::string line;
				int number = 0;
				const auto name = file.filename().string();
				while (std::getline(in, line)) {
					++number;
					auto text = Trim(line);
					if (text.empty() || text.front() == '#' || text.front() == ';') {
						continue;
					}
					const auto a = text.find('|');
					const auto b = a == std::string_view::npos ? a : text.find('|', a + 1);
					if (b == std::string_view::npos) {
						logger::warn("anchors: {}:{} is not Plugin|id|kind - skipped", name, number);
						continue;
					}
					Listed entry;
					entry.plugin = std::string{ Trim(text.substr(0, a)) };
					const auto id = std::string{ Trim(text.substr(a + 1, b - a - 1)) };
					entry.kind = Lower(Trim(text.substr(b + 1)));
					entry.where = std::format("{}:{}", name, number);
					try {
						entry.id = static_cast<std::uint32_t>(std::stoul(id, nullptr, 16));
					} catch (...) {
						logger::warn("anchors: {} has no hex id ({}) - skipped", entry.where, id);
						continue;
					}
					lines.push_back(std::move(entry));
				}
			}
			logger::info("anchors: {} line(s) in {} list file(s)", lines.size(), files.size());
			return lines;
		}
	}

	std::int32_t AdoptLookalikes(RE::BGSListForm* a_list)
	{
		if (!a_list) {
			return 0;
		}
		const auto& index = ByModel();
		// The list's own objects first: what joins must not be matched again in the same pass.
		std::vector<RE::TESForm*> own(a_list->arrayOfForms.begin(), a_list->arrayOfForms.end());
		if (a_list->scriptAddedTempForms) {
			for (const auto id : *a_list->scriptAddedTempForms) {
				if (auto* form = RE::TESForm::GetFormByID(id)) {
					own.push_back(form);
				}
			}
		}
		std::int32_t added = 0;
		std::string examples;
		std::unordered_set<std::string> seen;
		for (const auto* form : own) {
			auto key = ModelKey(form);
			if (key.empty() || !seen.insert(key).second) {
				continue;
			}
			const auto it = index.find(key);
			if (it == index.end()) {
				continue;
			}
			for (auto* twin : it->second) {
				// Only other mods' objects: the base game's and the DLCs' were sorted by hand (a lookalike there
				// was left out on purpose).
				if (Official(twin) || Has(a_list, twin)) {
					continue;
				}
				a_list->arrayOfForms.push_back(twin);
				if (++added <= 3) {
					examples += std::format("{}{}", examples.empty() ? "" : ", ", Name(twin));
				}
			}
		}
		if (added) {
			logger::info("anchors: list {:08X} +{} lookalike(s) ({}{})", a_list->GetFormID(), added, examples, added > 3 ? ", ..." : "");
		}
		return added;
	}

	std::int32_t AdoptListed(RE::BGSListForm* a_list, std::string_view a_kind)
	{
		if (!a_list) {
			return 0;
		}
		auto* data = RE::TESDataHandler::GetSingleton();
		if (!data) {
			return 0;
		}
		const auto kind = Lower(a_kind);
		std::int32_t added = 0;
		for (const auto& line : Lines()) {
			if (line.kind != kind) {
				continue;
			}
			const auto* file = data->LookupModByName(line.plugin);
			if (!file || file->compileIndex == 0xFF) {
				continue;   // that mod is not loaded: nothing to say
			}
			const auto local = file->IsLight() ? (line.id & 0xFFF) : (line.id & 0xFFFFFF);
			auto* form = data->LookupForm(local, line.plugin);
			if (!form || !form->As<RE::TESBoundObject>()) {
				logger::warn("anchors: {} names no object in {} - skipped", line.where, line.plugin);
				continue;
			}
			if (!Has(a_list, form)) {
				a_list->arrayOfForms.push_back(form);
				++added;
				logger::info("anchors: {} {} joins as '{}'", line.where, Name(form), kind);
			}
		}
		return added;
	}

	std::vector<float> Bounds(RE::TESForm* a_base)
	{
		const auto* bound = a_base ? a_base->As<RE::TESBoundObject>() : nullptr;
		if (!bound) {
			return {};
		}
		const auto& b = bound->boundData;
		if (b.boundMin.x == b.boundMax.x && b.boundMin.y == b.boundMax.y) {
			return {};
		}
		return { static_cast<float>(b.boundMin.x), static_cast<float>(b.boundMin.y), static_cast<float>(b.boundMax.x),
			static_cast<float>(b.boundMax.y) };
	}
}
