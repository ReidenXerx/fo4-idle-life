# Changelog

## Unreleased

Every vanilla pose spot that fits a place, none of them used before by the mod (20 more):

- Railings: vanilla's four hand-rail poses, back to the rail or hands on it looking out.
- Tables: bent over the table as over a map.
- Workbenches: welding and writing on a clipboard.
- Gates: a guard post watching the gate.
- Crops: people hoeing and weeding them (they were robots only).
- Boxes and crates, a new kind: someone rummaging through one (its own MCM switch).
- Walls in settlements: painting or welding them.
- Open ground: someone sweeping, doing push-ups, praying, or a raider on the lookout.
- Next to people: a broom, a clipboard and pen, push-ups, a prayer; children get their own sit on the ground.

## 1.0.0 (2026-10-02)

First release.

- Spots placed at run time around the player, each kind where it belongs, by rules measured from Bethesda's own
  placements: fires, campfires, counters, tables, benches, railings, workbenches by type, playing radios (a dance
  spot from vanilla's two unused dance loops), pool tables, TVs, gates, Mr Handy gardening and hedge trimming, dogs,
  and spots next to people that suit the place.
- An F4SE plugin (IdleLife.dll, Runtime Database) that reads the navmesh: spots along real walls (drops left out)
  and sitting circles on open ground, anywhere.
- A budget that follows the people (1.5 spots each, at least 3, at most 40), one weighted pool across every kind
  with the hour and the place, per-kind spacing and caps; recounted every 30 s.
- Spots only around the player, deleted as they leave; the same place keeps its spots for the day.
- MCM: spots per person, the most at once, daily reshuffle, a switch per kind; a Testing page.
- F4SE, Runtime Database and MCM are checked in game.
