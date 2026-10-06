"""Idle Life's FOMOD installer, written into a release folder (nexus-tools/docs/FOMOD-STANDARD.md, the owner's
house standard of 2026-10-01). Shape and checks from fo4-silhouette tools/fomod_pack.py.

    python tools/fomod_pack.py <release folder> <version> [--draft]

Writes <release folder>/fomod/: ModuleConfig.xml, info.xml, images/*.png and screenshot.png.
- The install is REFUSED below game 1.10.163 (rule 2); Idle Life has no plugin masters beyond Fallout4.esm. F4SE,
  Runtime Database and MCM are checked in game (Spawner.psc CheckSetup) and named on the first page (rule 4a).
- Every top-level entry of the release folder is installed as it is, read from the folder.
- Pages: "Checking your setup" (ONE Required option holding the whole checklist), then one page per feature, its
  card and text shown without a click (rule 4: one Required option alone in the step's first group).
- Cards: Publisher-bud's renders, D:/F4Output/cards/general/idlelife/<card>.png, resized to 1000 px.
  --draft builds without them (no images) to check everything else; a release never uses it.
Validates ModuleConfig.xml against the 5.0 schema and checks every image and source it names exists.
"""
import html
import pathlib
import sys

from PIL import Image

ROOT = pathlib.Path(__file__).resolve().parent.parent
XSD = ROOT.parent / 'fo4-silhouette' / 'tools' / 'fomod' / 'ModuleConfig5.0.xsd'   # the schema Vortex validates with
CARDS = pathlib.Path(r'D:\F4Output\cards\general\idlelife')
SCHEMA = 'http://qconsulting.ca/fo3/ModConfig5.0.xsd'   # exactly: Vortex reads the version out of this text
NAME = 'Idle Life'

# (step name, card file, plain-text description). Facts as README.md has them.
FEATURES = [
    ('Spots where they belong', 'the-rule.png',
     'Near you, people get new places to spend their time, each kind where it belongs, placed by rules measured from '
     'Bethesda\'s own: hands warmed 69 units from a fire and facing it, sitters 131 out round a campfire, leaning '
     'with their back to a rail. NPCs who sandbox nearby walk over, stay a minute or so and move on, often to the next '
     'spot. Placed around you at run time, deleted as you leave.'),
    ('Walls and open ground', 'navmesh.png',
     'A small F4SE plugin reads the walkable area around you: its border edges are walls (a drop beyond one is left '
     'out), so people lean on real walls and read a paper; flat ground far from every edge gets a sitting circle. '
     'Anywhere, other mods\' places included.'),
    ('People stop and talk', 'chat.png',
     'Two people standing about turn to each other and talk with their hands, no words: nods, head shakes, '
     'pointing, a laugh, taking turns. Too far apart, one walks over first and stops at talking distance; now and '
     'then it is a person and a dog that answers with its barks. One chat at a time, a couple of minutes apart '
     '(MCM: Chatting). The idea came from fR1eNd on the Nexus Posts tab.'),
    ('Busy where it is busy', 'how-many.png',
     'The number of spots follows the people near you: 1.5 each, at least 3, at most 40, drawn from one pool across '
     'every kind with weights for the hour and the place. A crowded market gets a mix, never twelve of one kind; a '
     'lone settler still gets a smoke and a sit. Recounted every 30 s.'),
    ('Eighteen kinds', None,
     'Fires, campfires, counters, tables, benches, railings, walls, open ground, workbenches by type (power armor, '
     'chems, tools), playing radios with a dance spot made from two vanilla dance loops nothing used, pool tables, '
     'TVs, gates, crops, boxes and crates, Mr Handys gardening and trimming hedges, dogs, and spots next to people '
     'that suit the place.\n'
     'Every vanilla pose that fits a place: hands on a rail looking out, bent over a map, rummaging a crate, '
     'welding, painting a wall, sweeping, hoeing and weeding, a guard post, push-ups, a prayer, a lookout; '
     'children sit on the ground.'),
]
EXTRAS = ('Settings',
          'MCM: spots per person, the most at once, a daily reshuffle (a place keeps its spots for the day), a switch '
          'for every kind.\nA Testing page spawns a few settlers to watch it work, and shows what is placed and used.')
SETUP = ('Your setup',
         'F4SE: check this yourself -- runs the navmesh plugin (f4se.silverlock.org).\n'
         'Runtime Database: check this yourself -- finds the game\'s functions on 1.10.163, next-gen and Anniversary '
         '(Nexus 108394).\n'
         'MCM: check this yourself -- the settings (Nexus 21497).\n'
         'Without F4SE or Runtime Database only the spots along walls and in the open are off. Idle Life checks all '
         'three in game and says what is missing.')


def esc(text):
    return html.escape(text, quote=True)


def option(name, description, image=None, flag='shown'):
    picture = f'\n              <image path="fomod\\images\\{image}"/>' if image else ''
    return f'''            <plugin name="{esc(name)}">
              <description>{esc(description)}</description>{picture}
              <conditionFlags><flag name="{flag}">1</flag></conditionFlags>
              <typeDescriptor><type name="Required"/></typeDescriptor>
            </plugin>'''


def page(step, group, opt):
    return f'''    <installStep name="{esc(step)}">
      <optionalFileGroups order="Explicit">
        <group name="{esc(group)}" type="SelectAll">
          <plugins order="Explicit">
{opt}
          </plugins>
        </group>
      </optionalFileGroups>
    </installStep>'''


def module_config(entries, images):
    installs = []
    for e in entries:
        kind = 'folder' if e.is_dir() else 'file'
        installs.append(f'    <{kind} source="{esc(e.name)}" destination="{esc(e.name)}" priority="0"/>')
    pages = [page('Checking your setup', 'Requirements', option(SETUP[0], SETUP[1], flag='setup'))]
    pages += [page(n, n, option(n, d, img if images and img else None)) for n, img, d in FEATURES]
    pages.append(page(EXTRAS[0], EXTRAS[0], option(EXTRAS[0], EXTRAS[1])))
    module_image = f'\n  <moduleImage path="fomod\\images\\{FEATURES[0][1]}"/>' if images else ''
    return f'''<?xml version="1.0" encoding="UTF-8"?>
<!-- GENERATED by tools/fomod_pack.py (nexus-tools/docs/FOMOD-STANDARD.md). Edit the tool, not this file. -->
<config xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="{SCHEMA}">
  <moduleName>{esc(NAME)}</moduleName>{module_image}
  <moduleDependencies operator="And">
    <gameDependency version="1.10.163.0"/>
  </moduleDependencies>
  <requiredInstallFiles>
{chr(10).join(installs)}
  </requiredInstallFiles>
  <installSteps order="Explicit">
{chr(10).join(pages)}
  </installSteps>
</config>
'''


def main():
    args = [a for a in sys.argv[1:] if not a.startswith('--')]
    draft = '--draft' in sys.argv
    if len(args) != 2:
        sys.exit(__doc__)
    out, version = pathlib.Path(args[0]), args[1]
    entries = sorted((e for e in out.iterdir() if e.name.lower() != 'fomod'), key=lambda e: e.name.lower())
    if not entries:
        sys.exit(f'{out} holds nothing to install')
    fomod = out / 'fomod'
    (fomod / 'images').mkdir(parents=True, exist_ok=True)
    images = not draft
    if images:
        for _n, card, _d in FEATURES:
            if card is None:
                continue   # a text-only page
            src = CARDS / card
            if not src.exists():
                sys.exit(f'no card {src} -- Publisher-bud renders them; --draft builds without')
            pic = Image.open(src).convert('RGB')
            pic.resize((1000, round(1000 * pic.height / pic.width)), Image.LANCZOS).save(fomod / 'images' / card)
        first = Image.open(fomod / 'images' / FEATURES[0][1])
        first.save(fomod / 'screenshot.png')   # MO2 shows this, not moduleImage
    (fomod / 'ModuleConfig.xml').write_text(module_config(entries, images), encoding='utf-8-sig')
    (fomod / 'info.xml').write_text(f'''<?xml version="1.0" encoding="UTF-8"?>
<fomod>
  <Name>{esc(NAME)}</Name>
  <Author>Dudu'sButt</Author>
  <Version>{esc(version)}</Version>
  <Website>https://github.com/ReidenXerx/fo4-idle-life</Website>
  <Description>The game's idle spots put to full use: people get new places to spend their time, each kind where it belongs.</Description>
</fomod>
''', encoding='utf-8-sig')

    from lxml import etree
    schema = etree.XMLSchema(etree.parse(str(XSD)))
    doc = etree.parse(str(fomod / 'ModuleConfig.xml'))
    if not schema.validate(doc):
        sys.exit('ModuleConfig.xml fails the 5.0 schema:\n' + '\n'.join(str(e) for e in schema.error_log))
    for el in doc.iter('image', 'moduleImage'):
        if not (out / el.get('path').replace('\\', '/')).exists():
            sys.exit(f'the installer shows {el.get("path")}, which is not in the release')
    for el in doc.iter('file', 'folder'):
        if not (out / el.get('source')).exists():
            sys.exit(f'the installer installs {el.get("source")}, which is not in the release')
    print(f'fomod: {len(entries)} entries installed as they are, the setup page, {len(FEATURES)} feature pages + the '
          f'rest{" (DRAFT: no cards)" if draft else ""}; valid against {XSD.name}')


if __name__ == '__main__':
    main()
