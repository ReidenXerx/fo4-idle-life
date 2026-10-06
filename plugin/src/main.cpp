// Idle Life's F4SE plugin: walls and open ground from the navmesh, for the Papyrus spawner.
//
// Papyrus asks, C++ answers: three global natives on IdleLife:Navmesh, each returning plain floats.
// The plugin never calls into the Papyrus VM (fo4-rapport's first rule: it crashed the game twice).

#include "Solid.h"
#include "Spots.h"

namespace
{
	constexpr auto kScript = "IdleLife:Navmesh"sv;

	std::vector<float> Papyrus_WallSpots(std::monostate, RE::TESObjectREFR* a_centre, std::vector<RE::TESObjectREFR*> a_near,
		float a_radius, float a_spacing, std::int32_t a_max)
	{
		try {
			return IL::Spots::Wall(a_centre, a_near, a_radius, a_spacing, a_max);
		} catch (const std::exception& e) {
			logger::critical("WallSpots threw: {}", e.what());
		} catch (...) {
			logger::critical("WallSpots threw");
		}
		return {};
	}

	std::vector<float> Papyrus_OpenSpots(std::monostate, RE::TESObjectREFR* a_centre, std::vector<RE::TESObjectREFR*> a_near,
		float a_radius, float a_clearance, std::int32_t a_max)
	{
		try {
			return IL::Spots::Open(a_centre, a_near, a_radius, a_clearance, a_max);
		} catch (const std::exception& e) {
			logger::critical("OpenSpots threw: {}", e.what());
		} catch (...) {
			logger::critical("OpenSpots threw");
		}
		return {};
	}

	RE::TESObjectREFR* Papyrus_Inside(std::monostate, RE::TESObjectREFR* a_spot)
	{
		try {
			return IL::Solid::Inside(a_spot);
		} catch (...) {
			logger::critical("Inside threw");
		}
		return nullptr;
	}

	bool Papyrus_Ready(std::monostate)
	{
		return IL::Spots::Ready();
	}

	std::int32_t Papyrus_Version(std::monostate)
	{
		return IL_VERSION_MAJOR * 10000 + IL_VERSION_MINOR * 100 + IL_VERSION_PATCH;
	}

	bool RegisterNatives(RE::BSScript::IVirtualMachine* a_vm)
	{
		if (!a_vm) {
			return false;
		}
		a_vm->BindNativeMethod(kScript, "WallSpots"sv, Papyrus_WallSpots, std::nullopt, false);
		a_vm->BindNativeMethod(kScript, "OpenSpots"sv, Papyrus_OpenSpots, std::nullopt, false);
		a_vm->BindNativeMethod(kScript, "Inside"sv, Papyrus_Inside, std::nullopt, false);
		a_vm->BindNativeMethod(kScript, "Version"sv, Papyrus_Version, std::nullopt, false);
		a_vm->BindNativeMethod(kScript, "Ready"sv, Papyrus_Ready, std::nullopt, false);
		logger::info("papyrus functions registered on {}", kScript);
		return true;
	}

	class FileSink final : public spdlog::sinks::base_sink<std::mutex>
	{
	public:
		explicit FileSink(const std::filesystem::path& a_path) :
			_out(a_path, std::ios::binary | std::ios::trunc)
		{}

	protected:
		void sink_it_(const spdlog::details::log_msg& a_msg) override
		{
			spdlog::memory_buf_t formatted;
			formatter_->format(a_msg, formatted);
			_out.write(formatted.data(), static_cast<std::streamsize>(formatted.size()));
		}

		void flush_() override { _out.flush(); }

	private:
		std::ofstream _out;
	};

	void InitLogging()
	{
		auto path = logger::log_directory();
		if (!path) {
			return;
		}
		*path /= IL_PROJECT_NAME ".log"sv;
		// By its wide path, never path::string(): a user name outside the ANSI code page throws, and a
		// throw in F4SEPlugin_Load disables the plugin with no log (Rapport, 2026-09-24).
		auto sink = std::make_shared<FileSink>(*path);
		auto log = std::make_shared<spdlog::logger>("global log"s, std::move(sink));
		log->set_level(spdlog::level::info);
		log->flush_on(spdlog::level::info);
		spdlog::set_default_logger(std::move(log));
		spdlog::set_pattern("[%H:%M:%S] %v"s);
	}

	constexpr F4SE::PluginVersionData MakeVersionData() noexcept
	{
		F4SE::PluginVersionData data{};
		data.pluginVersion = (IL_VERSION_MAJOR << 24) | (IL_VERSION_MINOR << 16) | (IL_VERSION_PATCH << 4);
		constexpr std::string_view name = IL_PROJECT_NAME;
		for (std::size_t i = 0; i < name.size() && i < std::size(data.name) - 1; ++i) {
			data.name[i] = name[i];
		}
		data.addressIndependence = F4SE::PluginVersionData::kAddressIndependence_Signatures;
		data.structureIndependence = F4SE::PluginVersionData::kStructureIndependence_1_10_980Layout |
		                             F4SE::PluginVersionData::kStructureIndependence_1_11_137Layout;
		return data;
	}
}

// OG's F4SE (0.6.23) loads a plugin by Query; NG's and AE's read F4SEPlugin_Version.
extern "C" DLLEXPORT bool F4SEAPI F4SEPlugin_Query(const F4SE::QueryInterface* a_f4se, F4SE::PluginInfo* a_info)
{
	a_info->infoVersion = F4SE::PluginInfo::kVersion;
	a_info->name = IL_PROJECT_NAME;
	a_info->version = IL_VERSION_MAJOR * 10000 + IL_VERSION_MINOR * 100 + IL_VERSION_PATCH;
	return !a_f4se->IsEditor();
}

extern "C" DLLEXPORT constinit F4SE::PluginVersionData F4SEPlugin_Version = MakeVersionData();

extern "C" DLLEXPORT bool F4SEAPI F4SEPlugin_Load(const F4SE::LoadInterface* a_f4se)
{
	F4SE::Init(a_f4se);
	try {
		InitLogging();
	} catch (...) {
	}
	logger::info("{} {} on runtime {}", IL_PROJECT_NAME, IL_VERSION_STRING, a_f4se->RuntimeVersion().string());
	const auto* papyrus = F4SE::GetPapyrusInterface();
	if (!papyrus || !papyrus->Register(RegisterNatives)) {
		logger::critical("could not register the papyrus functions");
		return false;
	}
	return true;
}
