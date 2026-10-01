"""Builds IdleLife.esp: the fire anchors, the setting, the spawner quest.

    python tools/make_esp.py [out.esp]

A light plugin (ESL), one master (Fallout4.esm). The markers it places are vanilla records; DLC anchors
are looked up by form id at run time, so the plugin needs no DLC. Writer helpers and the quest shape are
those of fo4-an76-toilets tools/make_esp.py (verified in game there).
"""
import json
import pathlib
import struct
import sys

AUTHOR = 'Idle Life'
MASTER = 'Fallout4.esm'
TES4_LIGHT = 0x200
FIRST_ID = 0x01000800

# Phase 2: fires (research/anchors.md, idlm_catalog.md, 2026-09-30). Lit fire barrels and the workshop
# cooking fire; the campfires in the game are all unlit statics ("_Off_") and wait for sit-on-ground.
FIRE_ANCHORS = [
    0x048280,   # MetalBarrel01Fire01_Static      19 placed
    0x048281,   # MetalBarrel01Fire02_Static     379 placed (the standard fire barrel)
    0x048282,   # MetalBarrel01Fire03_Static      13 placed
    0x048283,   # MetalBarrel01FireGrating_Static 352 placed
    0x2476B7,   # WorkbenchCookingFireWorkshop    33 placed, buildable
]
# Most fires in the game are not a fire model at all: a plain barrel or a burn pile lit by a fire LIGHT
# (Diamond City: 0 fire barrels, 17 fire lights). Vanilla's hand-warming spots stand a median 68 units
# below the light (research/calib). The script places spots at the light's height minus that.
FIRE_LIGHTS = [
    0x101183,   # defaultLightFire01NSNonSpec   2472 placed
    0x08ADFA,   # defaultLightFire01NSFlicker    1935 placed
    0x0C581B,   # defaultLightFire01NS           1384 placed
    0x12B52C,   # defaultLightFire01FlickerGoboWireBarrel 303 placed (the wire-barrel flame)
    0x08ADF9,   # defaultLightFire01Flicker       122 placed
]
# The spots: vanilla markers, placed as they are.
WARM_STANDING = 0x1B40BD   # FURN NPCHandWarmingStanding (AnimFurnNPCHandWarming), 68 placed
WARM_KNEELING = 0x1B40BE   # FURN NPCHandWarmingKneeling, 6 placed
SMOKE = 0x0E210E           # IDLM NPCSmokeIdleMarker (FurnitureClassRelaxation), 418 placed

SETTINGS = [('On', 1.0)]

# ---- phase 3: spots by object kind (research/cal2_*, 2026-10-01) -------------------------------------
# Vanilla has no fixed rule for counters, workbenches or benches (its few spots near them sit at random);
# railings have one (lean spot ~12 out, back to the rail). The placement rules are ours, built from
# vanilla spots and vanilla distances; the script reads each base's bounds from the arrays baked here.
import re
ANCHORS = json.loads((pathlib.Path(__file__).resolve().parents[1] / 'research' / 'anchors.json').read_text())


def pick(kind, keep, drop, min_long, limit):
    out = []
    for a in sorted(ANCHORS[kind], key=lambda a: -a['refs']):
        if a['plugin'] != 'Fallout4.esm' or not re.search(keep, a['edid']) or (drop and re.search(drop, a['edid'])):
            continue
        x1, y1, _, x2, y2, _ = a['obnd']
        if max(x2 - x1, y2 - y1) < min_long or min(x2 - x1, y2 - y1) < 4:
            continue
        if a['refs'] == 0 and not a.get('cobj'):
            continue
        out.append((int(a['fid'], 16), a['edid'], (x1, y1, x2, y2)))
        if len(out) == limit:
            break
    return out


KINDS = {
    'Counter': pick('bar', r'Counter', r'Panel|Cap|Corner|End|Door|Inner|NoCounter', 60, 30),
    'Rail': pick('lean', r'Railing|Fence', r'Post|Gate|Pole|Wire|Destroyed|Dest', 100, 40),
    'Work': pick('work', r'^[Ww]orkbench|^WorkshopWorkbench', r'Cooking', 40, 25),
    'Bench': pick('bench', r'Bench', r'[Ww]orkbench', 100, 20),
    # Diamond City's market has no counters at all: its stalls are fences, stools, metal and picnic
    # tables (log 2026-10-01). People standing at a table with a coffee or noodles cover it.
    'Table': pick('table', r'Table', r'End|Night|Side|Lamp|Dress|Egg|Pool|Work|Small|Coffee|Desk', 80, 25),
}
RADIOS = [0x082447, 0x1B2370, 0x143AD1, 0x0CA89D, 0x14507B]   # DC radio (on, new, workshop off), Institute on/off

# Spots per kind: vanilla FURN/IDLM (idlm_catalog, cal2_*).
COFFEE = 0x1A6AFC      # NPCStandDrinkCoffee
NOODLES = 0x1411CB     # NPCEatingNoodlesStanding
LEAN = 0x024572        # NPCInvWallLean01 (578 placed)
NEWSPAPER = 0x1338FC   # NPCNewspaperStanding
GROUND_SIT = 0x0299C2  # NPCInvGroundSit (153 placed): for spots next to people where nothing else is
TOOLS = [0x0D96C9, 0x0D96C7, 0x0D96CD, 0x0D96C5, 0x0D96C3, 0x0D96C1, 0x0D96BF]   # stand/kneel hammer/wrench
# Our dance spot: no dance marker exists in the game. An IDLM cloned from vanilla's shape (IDLF 08, a timer,
# an idle list) listing the two dance loops nothing in vanilla uses, the drunk sway and the clap.
DANCE_IDLES = [0x083BE4, 0x083BE5, 0x083BE3, 0x141F3C]   # IdleDrunkDancing, ...Drunker, IdleDrunkFaster, IdleClapping
KW_RELAXATION = 0x18F692   # FurnitureClassRelaxation (vanilla's smoke IDLM carries it)

# ---- wave 2 (owner 2026-10-01: "scale our covered idle markers on maximum") -------------------------
# Anchors placed by ring or in front, no bounds needed (research/anc2_*). Unlit campfires (every vanilla
# campfire is an "_Off_" static; flames are separate effects) and the doused cooking fire: sitters round them.
CAMPFIRES = [0x065582, 0x065584, 0x06356D, 0x060D53, 0x065585, 0x065583, 0x0F3923, 0x10C3B6, 0x14FBCD]
CROPS = [0x1C400C, 0x0A2958, 0x1C400A, 0x1C4014, 0x1C400B, 0x1C4008, 0x1C4009, 0x1C4BEF, 0x09D107, 0x0EF24A, 0x0F5D8F, 0x0FAFE7]
HEDGES = [0x13385C, 0x13385E, 0x13385D, 0x13385F, 0x0F40F5, 0x048287, 0x0F40EA]
POOLS = [0x10907A]                                   # PoolTable01
TVS = [0x075F38, 0x075F3A, 0x22C66B, 0x22C66F]       # ruin TVs 1/2, workshop TV, TV on a table
GATES = [0x07CE79, 0x094731, 0x0223DD, 0x075314]     # security gate, latched gate, chainlink gate, picket gate
# Spots, vetted (research/vet_*): any human unless noted.
WAVE2_SPOTS = {
    'Examine': 0x14B737,     # IDLM NPCStandingExamineIdleMarker
    'Shopping': 0x01F86D,    # IDLM NPCShoppingIdleMarker
    'Military': 0x161F26,    # IDLM NPCMilitaryPoseIdleMarker (AnimFlavorMilitary)
    'Clipboard': 0x122F9E,   # IDLM NPCHoldingClipboardIdleMarker
    'NeedlePrep': 0x15EFB8,  # IDLM NPCNeedlePrepIdleMarker
    'PipBoy': 0x1CB006,      # IDLM NPCUsePipBoy (sex picks the idle)
    'UseJet': 0x1B9B83,      # IDLM NPCUseJet
    'Search': 0x1A03E4,      # FURN NPCSearchStanding
    'KneelSit': 0x1CC203,    # FURN NPCKneelSit
    'SadSit': 0x05A47A,      # FURN NpcInvGroundSadSit
    'PAExamine': 0x197E67,   # IDLM NPCPowerArmorExamineIdleMarker: power armor only
    'HandyGarden': 0x1B19B8, # IDLM MrHandyGardening: robots only
    'HandyTrim': 0x068041,   # IDLM MrHandyTrimHedgesIdleMarker: robots only
    'DogSniff': 0x19FCCA,    # IDLM DogmeatIdleMarkerSniffScratch: dogs only
}

# The MCM Testing page (owner 2026-10-01: "spawn idiotic npcs ... to test it without wasting time"):
# harmless settlers placed around the player, held in a reference collection whose package makes them
# sandbox right there, so they wander and pick up the spots.
TEST_NPC = 0x113341         # LVLN LCharWorkshopNPC: settlers, male and female, no scripts (research)
SANDBOX_PACKAGE = 0x089605  # PACK DefaultSandboxCurrentLocation: near self, 512, every activity on, no conditions


def field(sig, data):
    if len(data) > 0xFFFF:
        raise ValueError(f'{sig} too large')
    return sig.encode('ascii') + struct.pack('<H', len(data)) + data


def zstring(text):
    return text.encode('ascii') + b'\0'


def wstring(text):
    raw = text.encode('ascii')
    return struct.pack('<H', len(raw)) + raw


def record(sig, form_id, blob, flags=0):
    return (sig.encode('ascii') + struct.pack('<III', len(blob), flags, form_id)
            + struct.pack('<IHH', 0, 131, 0) + blob)


def group(label, blob):
    return (b'GRUP' + struct.pack('<I', 24 + len(blob)) + label.encode('ascii')
            + struct.pack('<I', 0) + struct.pack('<IHH', 0, 0, 0) + blob)


def obj(form_id):
    return struct.pack('<HhI', 0, -1, form_id)


def vmad(script, props):
    """props: list of (name, type, payload bytes). Types: 1 object, 5 bool, 11 object array."""
    out = struct.pack('<hhH', 6, 2, 1) + wstring(script) + struct.pack('<BH', 0, len(props))
    for name, typ, payload in props:
        out += wstring(name) + struct.pack('<BB', typ, 1) + payload
    return out


def build():
    # Form ids are PERMANENT (a save binds script instances to them): tools/formids.json is the only
    # source, a new record appends after the highest id, an existing one never moves.
    table_path = pathlib.Path(__file__).resolve().parent / 'formids.json'
    table = json.loads(table_path.read_text()) if table_path.is_file() else {}
    ids = {}

    def new_id(key):
        if key not in table:
            table[key] = f'{max([int(v, 16) for v in table.values()] + [0x7FF]) + 1:03X}'
            table_path.write_text(json.dumps(table, indent=1) + '\n')
            print(f'new form id {table[key]} for {key} (commit tools/formids.json)')
        ids[key] = FIRST_ID & 0xFF000000 | int(table[key], 16)
        return ids[key]

    quest_id = new_id('Spawner')

    glob = b''
    for name, default in SETTINGS:
        gid = new_id('Setting_' + name)
        blob = field('EDID', zstring('IL_' + name))
        blob += field('FNAM', b'f')
        blob += field('FLTV', struct.pack('<f', default))
        glob += record('GLOB', gid, blob)

    fire_id = new_id('FireAnchors')
    flst = field('EDID', zstring('IL_FireAnchors'))
    for base in FIRE_ANCHORS:
        flst += field('LNAM', struct.pack('<I', base))
    flst = record('FLST', fire_id, flst)

    lights_id = new_id('FireLights')
    fl = field('EDID', zstring('IL_FireLights'))
    for base in FIRE_LIGHTS:
        fl += field('LNAM', struct.pack('<I', base))
    flst += record('FLST', lights_id, fl)

    test_quest_id = new_id('TestQuest')

    kind_lists = {}
    for kind, rows in KINDS.items():
        kid = new_id('Anchors' + kind)
        kl = field('EDID', zstring('IL_Anchors' + kind))
        for base, _, _ in rows:
            kl += field('LNAM', struct.pack('<I', base))
        flst += record('FLST', kid, kl)
        kind_lists[kind] = kid
    radio_id = new_id('AnchorsRadio')
    rl = field('EDID', zstring('IL_AnchorsRadio'))
    for base in RADIOS:
        rl += field('LNAM', struct.pack('<I', base))
    flst += record('FLST', radio_id, rl)

    dance_id = new_id('DanceMarker')
    dm = field('EDID', zstring('IL_DanceMarker'))
    dm += field('OBND', struct.pack('<6h', -54, -1, 0, 54, 89, 13))
    dm += field('KSIZ', struct.pack('<I', 1))
    dm += field('KWDA', struct.pack('<I', KW_RELAXATION))
    dm += field('IDLF', b'\x08')
    dm += field('IDLC', struct.pack('<B', len(DANCE_IDLES)))
    dm += field('IDLT', struct.pack('<f', 8.0))
    dm += field('IDLA', b''.join(struct.pack('<I', i) for i in DANCE_IDLES))
    idlm = record('IDLM', dance_id, dm)

    # Bounds of every counter/rail/work/bench base, one table (<= 128 entries: a Papyrus array's limit).
    geo = [(b, box) for kind in KINDS for b, _, box in KINDS[kind]]
    assert len(geo) <= 128, len(geo)

    def objs(xs):
        return struct.pack('<I', len(xs)) + b''.join(obj(x) for x in xs)

    def floats(xs):
        return struct.pack('<I', len(xs)) + b''.join(struct.pack('<f', float(x)) for x in xs)

    wave2_lists = {}
    for kind, bases in (('Campfire', CAMPFIRES), ('Crop', CROPS), ('Hedge', HEDGES), ('Pool', POOLS),
                        ('Tv', TVS), ('Gate', GATES)):
        kid = new_id('Anchors' + kind)
        kl = field('EDID', zstring('IL_Anchors' + kind))
        for base in bases:
            kl += field('LNAM', struct.pack('<I', base))
        flst += record('FLST', kid, kl)
        wave2_lists[kind] = kid

    q = field('EDID', zstring('IL_Spawner'))
    q += field('VMAD', vmad('IdleLife:Spawner', [
        ('FireAnchors', 1, obj(fire_id)),
        ('FireLights', 1, obj(lights_id)),
        ('WarmStanding', 1, obj(WARM_STANDING)),
        ('WarmKneeling', 1, obj(WARM_KNEELING)),
        ('Smoke', 1, obj(SMOKE)),
        ('Enabled', 1, obj(ids['Setting_On'])),
        ('TestQuest', 1, obj(test_quest_id)),
        ('Testers', 1, struct.pack('<HhI', 0, 0, test_quest_id)),
        ('TestNpc', 1, obj(TEST_NPC)),
        ('CounterAnchors', 1, obj(kind_lists['Counter'])),
        ('RailAnchors', 1, obj(kind_lists['Rail'])),
        ('WorkAnchors', 1, obj(kind_lists['Work'])),
        ('BenchAnchors', 1, obj(kind_lists['Bench'])),
        ('TableAnchors', 1, obj(kind_lists['Table'])),
        ('RadioAnchors', 1, obj(radio_id)),
        ('GeoBases', 11, objs([b for b, _ in geo])),
        ('GeoX1', 14, floats([box[0] for _, box in geo])),
        ('GeoY1', 14, floats([box[1] for _, box in geo])),
        ('GeoX2', 14, floats([box[2] for _, box in geo])),
        ('GeoY2', 14, floats([box[3] for _, box in geo])),
        ('Coffee', 1, obj(COFFEE)),
        ('Noodles', 1, obj(NOODLES)),
        ('Lean', 1, obj(LEAN)),
        ('Newspaper', 1, obj(NEWSPAPER)),
        ('Tools', 11, objs(TOOLS)),
        ('Dance', 1, obj(dance_id)),
        ('GroundSit', 1, obj(GROUND_SIT)),
    ] + [(k + 'Anchors', 1, obj(v)) for k, v in wave2_lists.items()]
      + [(k, 1, obj(v)) for k, v in WAVE2_SPOTS.items()] + [
    ]))
    q += field('DNAM', bytes.fromhex('110064670000000000000000'))   # start game enabled
    q += field('NEXT', b'')
    quest = record('QUST', quest_id, q)

    # The testers' quest: not start-game enabled -- the Testing page starts it, so its alias is fresh.
    # Alias shape from fo4-an76-toilets (its Panicked collection, verified in game): one reference
    # collection, empty until the script adds people, optional, its package on everyone in it.
    t = field('EDID', zstring('IL_Testers'))
    t += field('DNAM', bytes.fromhex('100064670000000000000000'))   # the spawner's flags minus start-game (0x01)
    t += field('NEXT', b'')
    t += field('ANAM', struct.pack('<I', 1))
    t += field('ALCS', struct.pack('<I', 0))
    t += field('ALMI', b'\x00')
    t += field('ALST', struct.pack('<I', 0))
    t += field('ALID', zstring('Testers'))
    t += field('FNAM', struct.pack('<I', 0x202))
    t += field('ALPC', struct.pack('<I', SANDBOX_PACKAGE))
    t += field('VTCK', struct.pack('<I', 0))
    t += field('ALED', b'')
    quest += record('QUST', test_quest_id, t)

    for fid in ids.values():
        if not 0x800 <= (fid & 0xFFFFFF) <= 0xFFF:
            raise SystemExit(f'{fid:08X} is outside 0x800-0xFFF, the range a light plugin holds')

    header = field('HEDR', struct.pack('<fiI', 1.0, len(ids), max(ids.values()) + 1))
    header += field('CNAM', zstring(AUTHOR))
    header += field('MAST', zstring(MASTER))
    header += field('DATA', struct.pack('<Q', 0))
    body = group('GLOB', glob) + group('IDLM', idlm) + group('FLST', flst) + group('QUST', quest)
    return record('TES4', 0, header, flags=TES4_LIGHT) + body, ids


def main():
    out = pathlib.Path(sys.argv[1] if len(sys.argv) > 1 else 'build/data/IdleLife.esp')
    out.parent.mkdir(parents=True, exist_ok=True)
    data, ids = build()
    out.write_bytes(data)
    print(f'{out}: {len(data)} bytes, light, {len(ids)} records; ' + ', '.join(f'{k} {len(v)}' for k, v in KINDS.items()))


if __name__ == '__main__':
    main()
