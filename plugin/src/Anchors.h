#pragma once

// Other mods' objects as spot anchors (1.3.0; dferstat and hang50 on Nexus, owner 11-11: "auto + a list file").
// - Lookalikes: an object of any plugin that uses the same 3D model as one already in an anchor list joins that list.
//   Settlement-building mods mostly give vanilla meshes new records, so their fire barrels, counters and benches are
//   found with no patch.
// - Lists: Data\F4SE\Plugins\IdleLife\*.txt names objects with new models, one per line: Plugin.esp|0x001234|kind.
// Both add to the list's record array for this game run only: nothing is written into saves, and every launch finds
// them again (a mod removed is simply not found).
namespace IL::Anchors
{
	// Adds every lookalike of the list's objects; answers how many joined.
	std::int32_t AdoptLookalikes(RE::BGSListForm* a_list);

	// Adds the objects the list files name for this kind (case-insensitive); answers how many joined.
	std::int32_t AdoptListed(RE::BGSListForm* a_list, std::string_view a_kind);

	// The object's size box from its record (OBND): x1, y1, x2, y2; empty when it has none.
	std::vector<float> Bounds(RE::TESForm* a_base);
}
