# Which fire lights are fires (2026-10-06, 1.2.0)

Trigger: Nexus user fR1eNd, "they'll warm their hands in the Diamond City inn out of nowhere". Idle Life read
every `defaultLightFire01*` light as a fire. Bethesda also lights rooms with these lights.

**The Dugout Inn (DmndDugoutInn01):** 19 fire lights, none of them a fire.
- About 7 sit over an `OilLampOn` on a table (27 units or less above it).
- The rest are bare fill light over cinder blocks, a wrench pile, picture frames, or nothing within 140 units.

**Fallout4.esm, every fire light** (`fire_sources_scan.py` collects the refs; we then classify by what stands near
each light):

| radius | fire | oil lamp (<= 60) | nothing | vanilla warm spots' lights counted as fire |
| --- | --- | --- | --- | --- |
| 120 | 737 | 458 | 3518 | 33 of 37 |
| 160 | 1002 | 456 | 3255 | 36 of 37 |
| 200 | 1129 | 451 | 3133 | 36 of 37 |

- Fire sources found: MetalBarrel01Fire02 (510), FireGrating (468), FXFireSmall01 (80), FXFireMedSmokey01 (52),
  WorkbenchCookingFire (39), MetalBarrel01Fire01 (20), FXFireMed01 (20), Fire03 (16), FXFireLargeMarker (5),
  FXFireBigWallFlames (2).
- The one vanilla warm light with no source (cell 0000E053) has only a curb, a crate and a clipboard near it.
- A name regex was rejected: "ember" matched RaiderDismemberedHead and "burn" matched burnt magazines.

**Rule (radius 160):**
- a fire source near the light: a fire;
- else an oil lamp within 60: one standing spot (the owner likes warming hands at lamps);
- else: room light, no spot.
