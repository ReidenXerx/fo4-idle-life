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
    body = group('GLOB', glob) + group('FLST', flst) + group('QUST', quest)
    return record('TES4', 0, header, flags=TES4_LIGHT) + body, ids


def main():
    out = pathlib.Path(sys.argv[1] if len(sys.argv) > 1 else 'build/data/IdleLife.esp')
    out.parent.mkdir(parents=True, exist_ok=True)
    data, ids = build()
    out.write_bytes(data)
    print(f'{out}: {len(data)} bytes, light, {len(ids)} records')


if __name__ == '__main__':
    main()
