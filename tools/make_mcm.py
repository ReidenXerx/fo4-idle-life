"""The MCM page: <out>/MCM/Config/IdleLife/config.json

    python tools/make_mcm.py [out_root]

Controls write the plugin's globals directly (sourceType GlobalValue); buttons call the spawner quest's
script. Form ids come from make_esp.build(), so the page and the plugin cannot drift apart. Shape from
fo4-an76-toilets tools/make_mcm.py (working in game there).
"""
import json
import pathlib
import sys

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
import make_esp  # noqa: E402

PLUGIN = 'IdleLife.esp'


def form(ids, key):
    return f'{PLUGIN}|{ids[key] & 0xFFF:X}'


def build():
    _, ids = make_esp.build()

    def button(text, function, help_text):
        return {'text': text, 'type': 'button', 'help': help_text,
                'action': {'type': 'CallFunction', 'form': form(ids, 'Spawner'), 'function': function}}

    content = [
        {'type': 'spacer', 'numLines': 2},
        {'text': "<p align='center'><font size='28'><b>IDLE LIFE</b></font><br>"
                 "<font size='12'>More spots for people to spend their time</font></p>",
         'html': True, 'type': 'text'},
        {'text': 'Spots', 'type': 'section'},
        {'text': 'On', 'type': 'switcher',
         'help': 'Near you, people get new places to spend their time: warming their hands at fires, a coffee '
                 'or noodles at counters, leaning on railings and fences, tinkering at workbenches, standing '
                 'about by benches, dancing by a playing radio. Off takes every spot away again.',
         'valueOptions': {'sourceType': 'GlobalValue', 'sourceForm': form(ids, 'Setting_On')}},
    ]
    testing = [
        {'text': 'For testing: see the spots taken without waiting for the locals. Buttons that play out '
                 'in the world wait until you close the menu.', 'type': 'text'},
        {'text': 'Test settlers', 'type': 'section'},
        button('Spawn test settlers here', 'DebugSpawnTesters',
               'Four harmless settlers appear a few steps around you and sandbox right there: they wander, '
               'sit, and take the spots near you. Stand near a fire, counter, bench or radio first.'),
        button('Remove test settlers', 'DebugRemoveTesters', 'Deletes every test settler.'),
        {'text': 'Status', 'type': 'section'},
        button('Show status', 'DebugStatus',
               'Fires near you with spots, how many spots, how many are in use right now, and the testers.'),
    ]
    return {
        'modName': 'IdleLife',
        'displayName': 'Idle Life',
        'minMcmVersion': 2,
        'pluginRequirements': [PLUGIN],
        'content': content,
        'pages': [{'pageDisplayName': 'Testing', 'content': testing}],
    }


def main():
    root = pathlib.Path(sys.argv[1] if len(sys.argv) > 1 else 'build/data')
    out = root / 'MCM' / 'Config' / 'IdleLife' / 'config.json'
    out.parent.mkdir(parents=True, exist_ok=True)
    out.write_text(json.dumps(build(), indent=2), encoding='utf-8')
    print(f'{out}: MCM page')


if __name__ == '__main__':
    main()
