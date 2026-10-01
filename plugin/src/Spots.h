#pragma once

namespace IL::Spots
{
	// The navmesh can be read on this runtime (Runtime Database present and knows the NavMesh type).
	[[nodiscard]] bool Ready();

	// Spots along walls: on walkable navmesh right beside a wall, facing away from it -- for wall-lean
	// markers. Packed {x, y, z, heading degrees} per spot, the ones nearest the given people first, at
	// least a_spacing apart, at most a_max. Empty when the navmesh cannot be read (the log says why).
	[[nodiscard]] std::vector<float> Wall(RE::TESObjectREFR* a_centre, const std::vector<RE::TESObjectREFR*>& a_near,
		float a_radius, float a_spacing, std::int32_t a_max);

	// Open ground: flat walkable points at least a_clearance from any edge of the walkable area -- the
	// middle of a sitting circle. Packed {x, y, z, 0} per spot, nearest the people first, at most a_max.
	[[nodiscard]] std::vector<float> Open(RE::TESObjectREFR* a_centre, const std::vector<RE::TESObjectREFR*>& a_near,
		float a_radius, float a_clearance, std::int32_t a_max);
}
