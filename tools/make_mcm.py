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

    def switcher(text, key, help_text):
        return {'text': text, 'type': 'switcher', 'help': help_text,
                'valueOptions': {'sourceType': 'GlobalValue', 'sourceForm': form(ids, key)}}

    def slider(text, key, lo, hi, step, help_text):
        return {'text': text, 'type': 'slider', 'help': help_text,
                'valueOptions': {'min': lo, 'max': hi, 'step': step,
                                 'sourceType': 'GlobalValue', 'sourceForm': form(ids, key)}}

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
                 'about by benches, dancing by a playing radio, sitting round campfires, watching TV, '
                 'at pool tables, on guard by gates, with clipboards, Jet among raiders, Mr Handys gardening '
                 'and trimming hedges, dogs sniffing about. Off takes every spot away again.',
         'valueOptions': {'sourceType': 'GlobalValue', 'sourceForm': form(ids, 'Setting_On')}},
        {'text': 'How many', 'type': 'section'},
        slider('Spots per person', 'Setting_SpotsPerPerson', 0.5, 3.0, 0.1,
               'Spots near you follow the people near you: this many for each of them (at least 3 when '
               'anyone is there). More: more choice and livelier, more spots unused. Default 1.5.'),
        slider('Most spots at once', 'Setting_MaxBudget', 10.0, 60.0, 1.0,
               'However crowded the place, never more than this. Default 40.'),
        switcher('Change a little every day', 'Setting_DailyReshuffle',
                 'On: a place looks the same all day and a little different the next. Off: a place always '
                 'gets the same spots.'),
        {'text': 'What kinds', 'type': 'section'},
    ] + [switcher(label, 'Setting_Kind' + key, help_text) for key, label, help_text in (
        ('Fire', 'Fires', 'Warming hands at fire barrels and burning piles; a smoker.'),
        ('Camp', 'Campfires', 'Sitting round campfires; among raiders, one on Jet.'),
        ('Counter', 'Counters', 'Standing with a coffee or noodles at counters.'),
        ('Table', 'Tables', 'Standing with a coffee or noodles at tables, or bent over one as over a map.'),
        ('Bench', 'Benches', 'Two standing about by benches, a smoker.'),
        ('Rail', 'Railings and fences', 'Leaning back against them, or hands on the rail looking out.'),
        ('Work', 'Workbenches', 'Hammers, wrenches and welding; power armor checks, chems, clipboards.'),
        ('Radio', 'Radios', 'Dancing by a radio that is playing.'),
        ('PoolTv', 'Pool tables and TVs', 'Standing at pool tables, watching TV from the floor.'),
        ('Gate', 'Gates', 'Someone on guard by a gate, or watching it from a guard post.'),
        ('Robots', 'Crops and hedges', 'People hoeing and weeding crops; Mr Handys gardening and trimming hedges.'),
        ('Crate', 'Boxes and crates', 'Someone rummaging through a box or a crate.'),
        ('Dogs', 'Dogs', 'Dogs sniffing and scratching about.'),
        ('Chat', 'Chatting', 'Two people standing about turn to each other and talk with their hands: nods, shrugs, '
                 'pointing, a laugh, no words. Now and then a person and a dog.'),
        ('Wall', 'Along walls', 'Leaning back on walls, reading a paper; in settlements painting or welding '
                 'them. Needs the Idle Life plugin (F4SE) that reads the navmesh.'),
        ('Open', 'In the open', 'A sitting circle on flat open ground; someone sweeping, doing push-ups, '
                 'praying or on the lookout. Needs the Idle Life plugin.'),
        ('People', 'Next to people', 'Where nothing else is: a smoke, a newspaper, a sit, a coffee, a broom or '
                   'a clipboard by the people themselves; children sit on the ground.'),
    )]
    testing = [
        {'text': 'For testing: see the spots taken without waiting for the locals. Buttons that play out '
                 'in the world wait until you close the menu.', 'type': 'text'},
        {'text': 'Test settlers', 'type': 'section'},
        button('Spawn test settlers here', 'DebugSpawnTesters',
               'Four harmless settlers appear a few steps around you and sandbox right there: they wander, '
               'sit, and take the spots near you. Stand near a fire, counter, bench or radio first.'),
        button('Remove test settlers', 'DebugRemoveTesters', 'Deletes every test settler.'),
        button('Start a chat here', 'DebugPlaceChat',
               'Two people standing about near each other (or a person and a dog) turn face to face and talk with '
               'their hands for half a minute, no words. Nobody near standing still: nothing happens.'),
        button('Draw spots again', 'DebugRedraw', 'Takes away every spot near you and draws them all again, e.g. after changing the settings.'),
        {'text': 'Log', 'type': 'section'},
        switcher('Detailed log', 'Setting_DetailedLog',
                 'For a bug report: the Papyrus log gets a line for every spot placed (which pose, for which '
                 'place, where), besides who takes which spot and for how long. Needs Papyrus logging on in '
                 'Fallout4Custom.ini. Off by default.'),
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
