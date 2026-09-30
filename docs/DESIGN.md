# Idle Life — design

Working name. Fallout 4. Owner's idea, 2026-09-30: use the idle-marker mechanic to its full potential by
placing idle markers at run time, all over the world, each type where it belongs.

## The mechanic Bethesda built and barely used

An **idle marker** (IDLM record) is an invisible spot with a list of animations: lean on a wall, smoke,
drink, dance, warm hands, sit on the ground, inspect, pray. An NPC running a **sandbox package**
(settlers, townspeople, raiders at camp) wanders its area and now and then walks to a free marker or piece
of furniture nearby, plays what the marker offers for a while, then picks something else.

The engine does not care who placed a marker or when. Bethesda hand-placed a few thousand; the system
itself is general. So markers placed by a script at run time should be taken up exactly like the ones in
the plugin, the way settlers use furniture the moment the player builds it.

**Measured 2026-09-30 (research/idlm_catalog.md): most of these spots are not IDLM records.** The 7
masters hold only 51 IDLMs, and they are mostly patrol spots (PatrolIdleMarker, 12,763 placed) plus smoke
(NPCSmokeIdleMarker 0E210E, 418). The poses this mod is about are **invisible furniture markers** (FURN
with AnimFurn* keywords): NPCHandWarmingStanding 1B40BD / Kneeling 1B40BE, NPCInvWallLean01 024572 (578
placed), NPCInvGroundSit 0299C2, NPCStandDrinkCoffee 1A6AFC, NPCEatingNoodlesStanding 1411CB,
NpcBenchChurchSit01 089505 (pray), NPCStandHammerVertical 0D96C9 (chores). Sandbox takes up both kinds;
the mod places both. There is **no dance and no chat marker** in the game: those need our own marker
(a FURN or IDLM pointing at vanilla dance idles) -- a phase 3 question. No workshop recipe builds any of
the pose markers, which is part of why settlements feel static.

**Premise 0 (proved first, before anything else is built):** an idle marker placed at run time near
sandboxing NPCs is walked to and used.

## What the mod does

Around the player, and only there, it places idle markers where they fit, keeps them while the player is
near, and deletes them when the player leaves. The world gets many more small moments: people warming
their hands at every fire barrel, leaning on bar counters, smoking on benches, dancing by a radio at night.

## Placement: every type where it belongs

A lean marker in an open field, or a sit spot inside a rock, breaks the illusion. So each marker type
has a placement rule. Two kinds:

1. **Anchored to objects.** Find objects of known kinds near the player and place markers relative to
   each one, by its position, facing and size:
   - fire barrel, campfire: a ring of warm-hands markers, facing the fire;
   - bar counter: lean and drink spots along its customer edge;
   - radio, jukebox: dance spots around it;
   - car wreck, railing, fence: lean spots along it;
   - bench: smoke spots, chat pairs;
   - workbench: tinkering spots in front of it;
   - open sky: sit on the ground; stargaze at night.
   Papyrus can do this: FindAllReferencesOfType on form lists of anchor bases, then trigonometry.
2. **Anchored to the terrain.** For open ground and walls anywhere (other mods' places too): a small
   F4SE DLL reads the navmesh around the player — where NPCs can walk, where a walkable edge meets a wall,
   where a flat open patch is. Lean markers go along real walls, dance circles on real open floor.
   Papyrus cannot see geometry; C++ can. (Phase 3.)

## What makes it feel alive

- **Time and weather.** Morning coffee and smokes, evening drinks, dancing by a radio at night, huddling
  under cover in rain.
- **Who is there.** Raiders drink, dance, shoot at cans; settlers do chores and chat; Diamond City leans,
  smokes and gossips. Rules keyed on the location's keywords and the nearby NPCs' factions.
- **Pairs and groups.** Two facing chat spots; a circle around a fire. Sandboxing NPCs next to each other
  already play idle chatter.
- **Stable but fresh.** The layout is seeded from the place and the in-game day: the bar crowd is the same
  when you come back tomorrow, different next week.
- **Clean.** Markers exist only around the player and are deleted as the player leaves (the pattern of
  AN76 Toilets' world-toilet spawner: PlaceAtMe not forced-persistent, delete-when-able, pruned by
  distance and by cell). No save bloat.

## Limits, stated up front

- **Animations are the vanilla library** (and DLC). Larger than it looks — many markers Bethesda made are
  used once or never; phase 1 catalogs them all. New animations would need AAF or new behaviour files.
- **NPCs with fixed jobs** (vendors behind counters, patrolling guards) keep them. This helps everyone who
  sandboxes.
- **The engine chooses** which NPC takes which spot. The mod shapes where the choices are, not who makes
  them.

## Phases

1. **Catalog.** Every IDLM in Fallout4.esm and the DLC: its animations, keywords, flags, how many are
   placed, and what it needs around it (a wall, a seat, a fire, open ground, a partner). Every base object
   that can anchor one (fire barrels, campfires, counters, radios, benches, wrecks, workbenches).
2. **Prototype — fire barrels only.** Rings of warm-hands (and smoke) markers around fire barrels and
   campfires near the player. Proves premise 0 in a settlement and a raider camp.
3. **Object rules.** The rest of the anchor table; time of day and weather; who-is-there; pairs and groups;
   seeding; MCM (on/off per rule, density, radius).
4. **Terrain rules.** The navmesh DLL: walls and open ground anywhere.

## Anchors

- Repo: `C:\Users\DuduPhudu\Documents\Projects\fo4-idle-life` (local git).
- Build pattern, ESP writer and Papyrus build: copied from fo4-an76-toilets (tools/make_esp.py,
  scripts/build-papyrus.ps1); form ids permanent in tools/formids.json.
- Game: AE at `D:\SteamFreeGames\Fallout 4 AE`, GOG OG at `D:\GOGGames\Fallout 4 GOTY`; staging through
  Vortex (`D:\Vortex\fallout4\mods\<Name>-dev`), deploy with Event Horizon, only while the game is closed.
