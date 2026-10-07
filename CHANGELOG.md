# Changelog

## 1.2.1 (2026-10-07)

- Fixed: chatting could pull a person out of an AAF scene. Anyone in an AAF scene (or held by another mod through AAF) is left alone.

## 1.2.0 (2026-10-07)

- New: people standing about turn to each other and talk with their hands, no words; one walks over if they stand apart, and now and then it is a person and a dog (MCM: Chatting). Idea by fR1eNd.
- Fixed: hands warmed at room lights with no fire (Diamond City inn); oil lamps still get one spot.
- Fixed: spots inside pillars and posts.
- "Draw spots again" now redraws everything near you.

## 1.1.2 (2026-10-04)

- The stutter fix now reads the whole loaded navmesh again, so wall and open-ground spots are exactly as before 1.1.1, just as fast.

## 1.1.1 (2026-10-04)

- Fixed stutter in busy places: the wall and open-ground search now looks only at the nearby navmesh, not every triangle loaded.

## 1.1.0 (2026-10-02)

Every vanilla pose spot that fits a place, none of them used before by the mod (20 more):

- Railings: vanilla's four hand-rail poses, back to the rail or hands on it looking out.
- Tables: bent over the table as over a map.
- Workbenches: welding and writing on a clipboard.
- Gates: a guard post watching the gate.
- Crops: people hoeing and weeding them (they were robots only).
- Testing page: a detailed log for bug reports (every spot placed, with its pose and its place).
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
