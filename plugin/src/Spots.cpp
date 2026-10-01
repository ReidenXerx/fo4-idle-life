// Walls and open ground from the loaded navmesh.
//
// THE NAVMESH. CommonLibF4 lays out NavMesh (vertices, triangles with their three neighbour links and
// flags) but only forward-declares TESObjectCELL::navMeshes. It is read the way fo4-rapport's
// Placement.cpp reads it (shipped there): as the BSTArray<NiPointer<NavMesh>> it is in the sister
// titles, data at +0x00, size at +0x10, every entry trusted only if its vtable is the game's NavMesh
// vtable, all raw reads behind a structured-exception guard. A wrong guess costs the spots, never the
// game.
//
// THE EDGES. A triangle edge with no neighbour (0xFFFF) whose "links to another navmesh" bit is clear
// (triangle flags 0x01/0x02/0x04 for edges 0-1, 1-2, 2-0, as xEdit names them) is the border of the
// walkable area: a wall, or a drop. Doors (0x400) and water (0x200) are not walls. A drop is told from a
// wall by looking just past the edge: if walkable navmesh lies well below, it is a ledge, not a wall.

#include "Spots.h"

namespace IL::Spots
{
	bool Ready()
	{
		static const auto resolved = REL::IDDatabase::get().resolve(RE::VTABLE::NavMesh[0]);
		return static_cast<bool>(resolved);
	}

	namespace
	{
		// Dev only: with Data/F4SE/Plugins/IdleLife_dump.txt present (never shipped), every wall query is written
		// as JSON beside the log -- the navmesh card is rendered from it (Publisher-bud, 2026-10-02).
		[[nodiscard]] bool DumpWanted()
		{
			std::error_code ec;
			return std::filesystem::exists("Data/F4SE/Plugins/IdleLife_dump.txt", ec);
		}

		void Dump(const char* a_what, const std::string& a_json)
		{
			auto dir = logger::log_directory();
			if (!dir) {
				return;
			}
			static int n = 0;
			*dir /= std::format("IdleLife-navmesh-{}-{}.json", a_what, ++n);
			std::ofstream(*dir, std::ios::binary) << a_json;
			logger::info("dumped {}", dir->filename().string());
		}

		constexpr std::uint16_t kNoNeighbour = 0xFFFF;
		constexpr std::uint32_t kWater = 0x200;
		constexpr std::uint32_t kDoor = 0x400;
		constexpr float         kStorey = 150.0f;   // a floor this far above or below is another floor
		constexpr float         kLeanOut = 14.0f;   // vanilla's lean spots at railings: ~12 out, back to it
		constexpr float         kMinWall = 90.0f;   // an edge shorter than this is clutter, not a wall
		constexpr float         kProbe = 60.0f;     // how far past an edge to look for a drop

		struct Tri
		{
			RE::NiPoint3  a, b, c;     // the corners
			std::uint16_t nb[3];       // neighbours across a-b, b-c, c-a
			std::uint32_t flags;
		};

		struct Edge
		{
			RE::NiPoint3 a, b;
			RE::NiPoint3 in;   // unit, horizontal, pointing into the walkable side
			float        length;
		};

		bool ReadNavmeshPointers(const void* a_array, std::uintptr_t a_vtable, void** a_out, std::uint32_t a_max,
			std::uint32_t* a_count) noexcept
		{
			__try {
				const auto* bytes = static_cast<const std::uint8_t*>(a_array);
				const auto  data = *reinterpret_cast<void* const*>(bytes + 0x00);
				const auto  size = *reinterpret_cast<const std::uint32_t*>(bytes + 0x10);
				if (!data || size == 0 || size > a_max) {
					*a_count = 0;
					return size == 0;
				}
				std::uint32_t n = 0;
				for (std::uint32_t i = 0; i < size; ++i) {
					void* mesh = static_cast<void* const*>(data)[i];
					if (mesh && *static_cast<std::uintptr_t*>(mesh) == a_vtable) {
						a_out[n++] = mesh;
					}
				}
				*a_count = n;
				return true;
			} __except (1) {
				*a_count = 0;
				return false;
			}
		}

		[[nodiscard]] std::vector<RE::TESObjectCELL*> Cells(RE::TESObjectREFR* a_centre, const std::vector<RE::TESObjectREFR*>& a_near)
		{
			std::vector<RE::TESObjectCELL*> cells;
			auto add = [&](RE::TESObjectREFR* a_ref) {
				if (!a_ref) {
					return;
				}
				if (auto* cell = a_ref->GetParentCell(); cell && std::ranges::find(cells, cell) == cells.end()) {
					cells.push_back(cell);
				}
			};
			add(a_centre);
			for (auto* ref : a_near) {
				add(ref);
			}
			return cells;
		}

		// Every triangle of every navmesh in these cells, with its neighbour links and flags.
		[[nodiscard]] std::vector<Tri> Triangles(const std::vector<RE::TESObjectCELL*>& a_cells, std::string& a_why)
		{
			static const auto vtableResolved = REL::IDDatabase::get().resolve(RE::VTABLE::NavMesh[0]);
			if (!vtableResolved) {
				a_why = std::format("the navmesh type has no address on this game version ({})",
					REL::id_resolve_status_text(vtableResolved.status));
				return {};
			}
			const std::uintptr_t vtable = REL::Module::get().base() + *vtableResolved.rva;
			std::vector<Tri>     tris;
			for (auto* cell : a_cells) {
				if (!cell->navMeshes) {
					continue;
				}
				void*         meshes[64]{};
				std::uint32_t count = 0;
				if (!ReadNavmeshPointers(cell->navMeshes, vtable, meshes, 64, &count)) {
					a_why = "a cell's navmesh list did not read as expected";
					return {};
				}
				for (std::uint32_t i = 0; i < count; ++i) {
					auto*       mesh = static_cast<RE::NavMesh*>(meshes[i]);
					const auto& verts = mesh->vertices;
					for (const auto& t : mesh->triangles) {
						if (t.vertices[0] >= verts.size() || t.vertices[1] >= verts.size() || t.vertices[2] >= verts.size()) {
							continue;
						}
						tris.push_back(Tri{ verts[t.vertices[0]].location, verts[t.vertices[1]].location, verts[t.vertices[2]].location,
							{ t.triangles[0], t.triangles[1], t.triangles[2] }, t.triangleFlags });
					}
				}
			}
			if (tris.empty() && a_why.empty()) {
				a_why = "no navmesh in the cells near the people";
			}
			return tris;
		}

		[[nodiscard]] float Dist2D(const RE::NiPoint3& a_a, const RE::NiPoint3& a_b) noexcept
		{
			return std::hypot(a_a.x - a_b.x, a_a.y - a_b.y);
		}

		// The walkable floor under (x, y) nearest a_near in height, from these triangles.
		[[nodiscard]] std::optional<float> FloorAt(const std::vector<Tri>& a_tris, float a_x, float a_y, float a_near, float a_within)
		{
			std::optional<float> best;
			for (const auto& t : a_tris) {
				const float d = (t.b.y - t.c.y) * (t.a.x - t.c.x) + (t.c.x - t.b.x) * (t.a.y - t.c.y);
				if (std::fabs(d) < 1e-3f) {
					continue;
				}
				const float l1 = ((t.b.y - t.c.y) * (a_x - t.c.x) + (t.c.x - t.b.x) * (a_y - t.c.y)) / d;
				const float l2 = ((t.c.y - t.a.y) * (a_x - t.c.x) + (t.a.x - t.c.x) * (a_y - t.c.y)) / d;
				const float l3 = 1.0f - l1 - l2;
				if (l1 < -1e-4f || l2 < -1e-4f || l3 < -1e-4f) {
					continue;
				}
				const float z = l1 * t.a.z + l2 * t.b.z + l3 * t.c.z;
				if (std::fabs(z - a_near) > a_within) {
					continue;
				}
				if (!best || std::fabs(z - a_near) < std::fabs(*best - a_near)) {
					best = z;
				}
			}
			return best;
		}

		// The border edges of the walkable area near the centre (a_minLength drops clutter).
		[[nodiscard]] std::vector<Edge> Borders(const std::vector<Tri>& a_tris, const RE::NiPoint3& a_centre, float a_radius, float a_minLength)
		{
			std::vector<Edge> out;
			for (const auto& t : a_tris) {
				if (t.flags & (kDoor | kWater)) {
					continue;
				}
				const RE::NiPoint3* corner[3] = { &t.a, &t.b, &t.c };
				for (int e = 0; e < 3; ++e) {
					if (t.nb[e] != kNoNeighbour || (t.flags & (1u << e))) {
						continue;
					}
					const auto& a = *corner[e];
					const auto& b = *corner[(e + 1) % 3];
					const auto& c = *corner[(e + 2) % 3];
					const RE::NiPoint3 mid{ (a.x + b.x) / 2, (a.y + b.y) / 2, (a.z + b.z) / 2 };
					if (Dist2D(mid, a_centre) > a_radius || std::fabs(mid.z - a_centre.z) > kStorey * 2) {
						continue;
					}
					const float len = Dist2D(a, b);
					if (len < a_minLength) {
						continue;
					}
					RE::NiPoint3 in{ -(b.y - a.y) / len, (b.x - a.x) / len, 0.0f };
					if (in.x * (c.x - a.x) + in.y * (c.y - a.y) < 0.0f) {
						in.x = -in.x;
						in.y = -in.y;
					}
					out.push_back(Edge{ a, b, in, len });
				}
			}
			return out;
		}

		[[nodiscard]] float NearestPerson(const RE::NiPoint3& a_p, const std::vector<RE::NiPoint3>& a_people) noexcept
		{
			float best = 1e9f;
			for (const auto& p : a_people) {
				best = std::min(best, Dist2D(a_p, p));
			}
			return best;
		}

		[[nodiscard]] std::vector<RE::NiPoint3> Positions(RE::TESObjectREFR* a_centre, const std::vector<RE::TESObjectREFR*>& a_near)
		{
			std::vector<RE::NiPoint3> out;
			for (auto* ref : a_near) {
				if (ref) {
					out.push_back(ref->GetPosition());
				}
			}
			if (out.empty() && a_centre) {
				out.push_back(a_centre->GetPosition());
			}
			return out;
		}

		struct Candidate
		{
			RE::NiPoint3 at;
			float        heading;
			float        score;   // distance to the nearest person: smaller first
		};

		[[nodiscard]] std::vector<float> Pick(std::vector<Candidate>& a_cands, float a_spacing, std::int32_t a_max)
		{
			std::ranges::sort(a_cands, {}, &Candidate::score);
			std::vector<Candidate> chosen;
			for (const auto& c : a_cands) {
				if (static_cast<std::int32_t>(chosen.size()) >= a_max) {
					break;
				}
				const bool clear = std::ranges::none_of(chosen, [&](const Candidate& o) { return Dist2D(o.at, c.at) < a_spacing; });
				if (clear) {
					chosen.push_back(c);
				}
			}
			std::vector<float> out;
			for (const auto& c : chosen) {
				out.insert(out.end(), { c.at.x, c.at.y, c.at.z, c.heading });
			}
			return out;
		}
	}

	std::vector<float> Wall(RE::TESObjectREFR* a_centre, const std::vector<RE::TESObjectREFR*>& a_near, float a_radius, float a_spacing, std::int32_t a_max)
	{
		if (!a_centre || a_max <= 0) {
			return {};
		}
		std::string why;
		const auto  tris = Triangles(Cells(a_centre, a_near), why);
		if (tris.empty()) {
			logger::info("wall spots: none - {}", why);
			return {};
		}
		const auto centre = a_centre->GetPosition();
		const auto people = Positions(a_centre, a_near);
		const auto edges = Borders(tris, centre, a_radius, kMinWall);
		std::vector<Candidate> cands;
		std::size_t            ledges = 0;
		std::vector<RE::NiPoint3> dropAt;
		for (const auto& e : edges) {
			// Along a long wall, a spot every ~200 units; a short one gets its middle.
			const int n = std::max(1, static_cast<int>(e.length / 200.0f));
			for (int k = 0; k < n; ++k) {
				const float  t = (k + 0.5f) / n;
				RE::NiPoint3 on{ e.a.x + (e.b.x - e.a.x) * t, e.a.y + (e.b.y - e.a.y) * t, e.a.z + (e.b.z - e.a.z) * t };
				// Just past the edge: walkable floor well below = a drop, not a wall.
				const float px = on.x - e.in.x * kProbe;
				const float py = on.y - e.in.y * kProbe;
				// (40 to 1000 units down: a step is not a drop; a floor further down than that is another storey.)
				if (FloorAt(tris, px, py, on.z - 520.0f, 480.0f)) {
					++ledges;
					dropAt.push_back(on);
					continue;
				}
				RE::NiPoint3 at{ on.x + e.in.x * kLeanOut, on.y + e.in.y * kLeanOut, on.z };
				const auto   floor = FloorAt(tris, at.x, at.y, on.z, 40.0f);
				if (!floor) {
					continue;
				}
				at.z = *floor;
				// FO4 heading: degrees clockwise from north (+Y); facing away from the wall = along "in".
				const float heading = std::atan2(e.in.x, e.in.y) * 180.0f / std::numbers::pi_v<float>;
				cands.push_back(Candidate{ at, heading, NearestPerson(at, people) });
			}
		}
		auto out = Pick(cands, a_spacing, a_max);
		if (DumpWanted()) {
			std::string j = "{\"centre\":[" + std::format("{:.1f},{:.1f},{:.1f}", centre.x, centre.y, centre.z) + "],\"triangles\":[";
			for (std::size_t i = 0; i < tris.size(); ++i) {
				const auto& t = tris[i];
				j += std::format("{}[{:.1f},{:.1f},{:.1f},{:.1f},{:.1f},{:.1f},{:.1f},{:.1f},{:.1f}]", i ? "," : "", t.a.x, t.a.y,
					t.a.z, t.b.x, t.b.y, t.b.z, t.c.x, t.c.y, t.c.z);
			}
			j += "],\"borders\":[";
			for (std::size_t i = 0; i < edges.size(); ++i) {
				const auto& e = edges[i];
				j += std::format("{}[{:.1f},{:.1f},{:.1f},{:.1f},{:.1f},{:.1f}]", i ? "," : "", e.a.x, e.a.y, e.a.z, e.b.x, e.b.y, e.b.z);
			}
			j += "],\"drops\":[";
			for (std::size_t i = 0; i < dropAt.size(); ++i) {
				j += std::format("{}[{:.1f},{:.1f},{:.1f}]", i ? "," : "", dropAt[i].x, dropAt[i].y, dropAt[i].z);
			}
			j += "],\"spots\":[";
			for (std::size_t i = 0; i + 3 < out.size(); i += 4) {
				j += std::format("{}[{:.1f},{:.1f},{:.1f},{:.1f}]", i ? "," : "", out[i], out[i + 1], out[i + 2], out[i + 3]);
			}
			j += "]}";
			Dump("walls", j);
		}
		logger::info("wall spots: {} triangles, {} border edges, {} drops left out, {} candidates, {} chosen", tris.size(),
			edges.size(), ledges, cands.size(), out.size() / 4);
		return out;
	}

	std::vector<float> Open(RE::TESObjectREFR* a_centre, const std::vector<RE::TESObjectREFR*>& a_near, float a_radius, float a_clearance, std::int32_t a_max)
	{
		if (!a_centre || a_max <= 0) {
			return {};
		}
		std::string why;
		const auto  tris = Triangles(Cells(a_centre, a_near), why);
		if (tris.empty()) {
			logger::info("open ground: none - {}", why);
			return {};
		}
		const auto centre = a_centre->GetPosition();
		const auto people = Positions(a_centre, a_near);
		// Every border counts against clearance here, short ones and drops included.
		const auto edges = Borders(tris, centre, a_radius + a_clearance, 0.0f);
		std::vector<Candidate> cands;
		for (const auto& t : tris) {
			const RE::NiPoint3 mid{ (t.a.x + t.b.x + t.c.x) / 3, (t.a.y + t.b.y + t.c.y) / 3, (t.a.z + t.b.z + t.c.z) / 3 };
			if (Dist2D(mid, centre) > a_radius || std::fabs(mid.z - centre.z) > kStorey) {
				continue;
			}
			const float zlo = std::min({ t.a.z, t.b.z, t.c.z });
			const float zhi = std::max({ t.a.z, t.b.z, t.c.z });
			if (zhi - zlo > 16.0f || (t.flags & kWater)) {
				continue;   // not flat, or wet
			}
			bool clear = true;
			for (const auto& e : edges) {
				if (std::fabs((e.a.z + e.b.z) / 2 - mid.z) > kStorey) {
					continue;
				}
				// Distance from the point to the segment, in plan.
				const float ex = e.b.x - e.a.x, ey = e.b.y - e.a.y;
				const float len2 = ex * ex + ey * ey;
				float       u = len2 > 0 ? ((mid.x - e.a.x) * ex + (mid.y - e.a.y) * ey) / len2 : 0.0f;
				u = std::clamp(u, 0.0f, 1.0f);
				if (std::hypot(mid.x - (e.a.x + u * ex), mid.y - (e.a.y + u * ey)) < a_clearance) {
					clear = false;
					break;
				}
			}
			if (clear) {
				cands.push_back(Candidate{ mid, 0.0f, NearestPerson(mid, people) });
			}
		}
		auto out = Pick(cands, a_clearance * 2.0f, a_max);
		logger::info("open ground: {} triangles, {} border edges, {} clear flat points, {} chosen", tris.size(), edges.size(),
			cands.size(), out.size() / 4);
		return out;
	}
}
