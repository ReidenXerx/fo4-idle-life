# Idle Life

Fallout 4. The game's idle-spot system put to full use: near you, people get new places to spend their time, each
kind where it belongs -- warming their hands at fires, a coffee at a counter, leaning on real walls, sitting round a
campfire, a Mr Handy tending the crops. Placed at run time around you, gone when you leave.

## What it does

- **Spots where they belong.** The game has only 51 idle markers; the poses (warming hands, leaning, sitting on the
  ground) are invisible furniture. Idle Life places them by measured rules: hand-warming spots 69 units from the fire
  and facing it, as Bethesda's 66 do; campfire sitters 131 out; rail leans with their back to the rail. NPCs who
  sandbox nearby walk over, stay a minute or so (32-111 s measured), and move on -- often to another spot.
- **18 kinds:** fires and burning barrels, campfires, counters, tables, benches, railings and fences, walls, open
  ground, workbenches by type (power armor, chems, tools), playing radios (dancing), pool tables, TVs, gates, crops,
  boxes and crates, robots (Mr Handy gardening and trimming hedges), dogs, and spots next to the people themselves
  that suit the place (raiders: Jet and knives; settlers: clipboards and brooms; townsfolk: newspapers and
  Pip-Boys; children: a sit on the ground).
- **Every vanilla pose that fits a place** (1.1.0): hands on a rail looking out, bent over a map, rummaging a crate,
  welding, painting a wall, sweeping, hoeing and weeding, a guard post, push-ups, a prayer, a lookout -- placed by
  the distances measured from Bethesda's own placements.
- **Walls and open ground from the navmesh.** A small F4SE plugin reads the walkable area around you: its border
  edges are walls (a drop beyond one is left out), and flat ground far from every edge gets a sitting circle. Works
  anywhere, other mods' places included.
- **No overspam, something even in quiet places.** The number of spots follows the people near you (1.5 each, at
  least 3, at most 40), drawn from one pool across every kind with weights for the hour and the place, so a crowded
  market gets a mix and a lone settler still gets a smoke and a sit. Recounted every 30 s.
- **Clean.** Spots exist only around you and are deleted as you leave; the same place keeps its spots for the day.
- **MCM:** spots per person, the most at once, a daily reshuffle, a switch for every kind; a Testing page that
  spawns a few settlers to watch it work.

## Requirements

- **F4SE.**
- **Runtime Database** (Nexus 108394): the navmesh plugin finds the game's functions through it, on 1.10.163,
  next-gen and the Anniversary Edition.
- **MCM** (Nexus 21497) for the settings; without it they keep their defaults.

Without F4SE or Runtime Database the spots along walls and in the open are off and Idle Life says so in game; every
other kind still works. Install with Vortex or Mod Organizer 2; manual installs are not supported.

## Build

```
python tools/make_esp.py && python tools/make_mcm.py
powershell -File scripts/build-papyrus.ps1
cmake -S plugin -B plugin/build-rd -G "Visual Studio 17 2022" -A x64 -DCMAKE_TOOLCHAIN_FILE=<vcpkg>/scripts/buildsystems/vcpkg.cmake
cmake --build plugin/build-rd --config Release
pwsh scripts/make-release.ps1
```

The design, the research and every measured number: `docs/DESIGN.md`, `research/`.

## Licence

PolyForm Noncommercial 1.0.0, see `LICENSE`. CommonLibF4RD (plugin/extern) carries its own licence.
