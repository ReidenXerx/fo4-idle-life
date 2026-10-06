#pragma once

namespace IL::Solid
{
	// The compact object (pillar, post, machine, shelf) whose box holds the spot's body, or null: a pose there
	// would play inside it (Solid.cpp says how and why).
	[[nodiscard]] RE::TESObjectREFR* Inside(RE::TESObjectREFR* a_spot);
}
