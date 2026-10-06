// Is a spot inside something solid? (plugin 0.3.0, Idle Life 1.2.0)
//
// Nexus user fR1eNd (2026-10-06): people "go inside pillars and do things -- basically ignoring walls". Every spot
// ends on the walkable navmesh (MoveToNearestNavmeshLocation), and the navmesh often runs straight under posts and
// pillars: Bethesda did not cut it around thin objects, the actors' own collision kept them out. A spot there is a
// pose inside the pillar. So the spot's body -- knee and chest height above it -- is tested against the boxes of the
// compact, upright objects of its cell. No physics ray (CommonLibF4RD's cell pick crashed, VATS Bullets 0.7/0.9).
//
// Which objects: statics, containers, activators whose footprint is at most kMaxFootprint and
// that stand at least kMinHeight tall -- pillars, posts, machines, shelves, lockers. Bigger pieces (a wall, a whole
// shack, a static collection) have boxes that cover the room, so a box test says nothing about them.
// How: with the object's 3D loaded, exactly in its frame (an engine matrix keeps its local axes in its ROWS,
// measured in VATS Bullets 0.9.7); a precombined object has no 3D of its own, so then only the circle that fits
// inside its footprint, which needs no rotation -- enough for a pillar or a post.

#include "Solid.h"

namespace IL::Solid
{
	namespace
	{
		constexpr float kMaxFootprint = 400.0f;   // the longer side of the box, in the world
		constexpr float kMinHeight = 60.0f;       // shorter than this, a spot may stand beside it on it
		constexpr float kMargin = 4.0f;           // a hair inside the box before it counts
		constexpr float kHeights[] = { 40.0f, 110.0f };   // knee and chest above the spot
		constexpr float kReach = 600.0f;          // objects further than this cannot hold the spot

		bool Compact(RE::ENUM_FORM_ID a_type)
		{
			using T = RE::ENUM_FORM_ID;
			// Not movable statics: in the game they are fog, smoke, flames and tarps -- no body to stand in. The first
			// test dropped spots "inside" MistLargeRoundDustyDim and DiamondRedTarp03ms (owner's DC log, 10-06).
			return a_type == T::kSTAT || a_type == T::kCONT || a_type == T::kACTI;
		}

		bool InsideRef(RE::TESObjectREFR* a_ref, const RE::NiPoint3& a_spot)
		{
			auto* base = a_ref->GetObjectReference();
			if (!base || !Compact(base->GetFormType()) || base->GetFormID() < 0x800) {
				return false;   // < 0x800: the engine's own forms -- XMarker, XMarkerHeading and the like, bodiless
			}
			const auto& b = base->boundData;
			const float scale = a_ref->refScale > 0 ? a_ref->refScale / 100.0f : 1.0f;
			const float lo[3] = { static_cast<float>(b.boundMin.x), static_cast<float>(b.boundMin.y), static_cast<float>(b.boundMin.z) };
			const float hi[3] = { static_cast<float>(b.boundMax.x), static_cast<float>(b.boundMax.y), static_cast<float>(b.boundMax.z) };
			const float dx = (hi[0] - lo[0]) * scale, dy = (hi[1] - lo[1]) * scale, dz = (hi[2] - lo[2]) * scale;
			if (dx <= 0.0f || dy <= 0.0f || std::max(dx, dy) > kMaxFootprint || dz < kMinHeight) {
				return false;
			}
			const auto pos = a_ref->GetPosition();
			const float ox = a_spot.x - pos.x, oy = a_spot.y - pos.y;
			if (ox * ox + oy * oy > kReach * kReach) {
				return false;
			}
			if (auto* obj = a_ref->Get3D()) {
				const auto& m = obj->world.rotate;
				const auto& t = obj->world.translate;
				const float s = obj->world.scale > 0.0f ? obj->world.scale : 1.0f;
				for (const float h : kHeights) {
					const float w[3] = { a_spot.x - t.x, a_spot.y - t.y, a_spot.z + h - t.z };
					bool in = true;
					for (int k = 0; k < 3 && in; ++k) {
						const float local = (w[0] * m.entry[k].pt[0] + w[1] * m.entry[k].pt[1] + w[2] * m.entry[k].pt[2]) / s;
						in = local > lo[k] + kMargin && local < hi[k] - kMargin;
					}
					if (in) {
						return true;
					}
				}
				return false;
			}
			// Precombined (no 3D of its own): upright objects only, the inscribed circle around the box's centre.
			if (std::abs(a_ref->data.angle.x) > 0.05f || std::abs(a_ref->data.angle.y) > 0.05f) {
				return false;
			}
			const float cx = (lo[0] + hi[0]) * 0.5f * scale, cy = (lo[1] + hi[1]) * 0.5f * scale;
			if (cx * cx + cy * cy > 20.0f * 20.0f) {
				return false;   // a box well off its origin: its centre would need the rotation
			}
			const float r = std::min(dx, dy) * 0.5f - kMargin;
			if (r <= 0.0f || ox * ox + oy * oy > r * r) {
				return false;
			}
			for (const float h : kHeights) {
				const float z = a_spot.z + h - pos.z;
				if (z > lo[2] * scale + kMargin && z < hi[2] * scale - kMargin) {
					return true;
				}
			}
			return false;
		}
	}

	RE::TESObjectREFR* Inside(RE::TESObjectREFR* a_spot)
	{
		auto* cell = a_spot ? a_spot->GetParentCell() : nullptr;
		if (!cell) {
			return nullptr;
		}
		const auto spot = a_spot->GetPosition();
		RE::BSAutoLock lock{ cell->spinLock };
		for (const auto& ptr : cell->references) {
			auto* ref = ptr.get();
			if (!ref || ref == a_spot || (ref->formFlags & 0x800) != 0 || (ref->formFlags & 0x20) != 0) {   // disabled, deleted
				continue;
			}
			if (InsideRef(ref, spot)) {
				return ref;
			}
		}
		return nullptr;
	}
}
