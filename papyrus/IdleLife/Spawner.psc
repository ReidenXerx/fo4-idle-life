Scriptname IdleLife:Spawner extends Quest
{Idle Life: spots where people spend their time, placed at run time around the player, each kind where it
belongs. Fires get people warming their hands (and a smoker); counters, people with a coffee or a bowl of
noodles; railings and fences, people leaning on them; workbenches, someone tinkering; benches, a pair
standing about and a smoker; a playing radio, dancers. Anyone sandboxing nearby walks over and uses them
(premise 0, proved 2026-10-01). The spots exist only around the player: placed when a place comes in range,
deleted when the player leaves; the same place always gets the same spots (seeded from the object itself).
Every 30 s the log says how many spots are taken.

How many and where (owner 2026-10-01: "even in poor places something, in rich places no overspam"): a
BUDGET of spots follows the people nearby (1.5 per person, at least 3, at most 40); every candidate place
of every kind near those people goes into one pool and is drawn greedily by score -- kind weight (times
the time of day and the kind of place) x how many people are near it x a decay per kind already drawn x
a penalty for any place already dressed close by. Spots left over with nothing to anchor them go next to
the people themselves (a smoke, a newspaper, a sit on the ground). The draw runs when the player arrives
somewhere (a new cell, or 1000 units moved), not on every scan; ties break by the place and the day.}

FormList Property FireAnchors Auto Const Mandatory
{Lit fire barrels and the workshop cooking fire (Fallout4.esm); DLC braziers and barrels join at run time.}
FormList Property FireLights Auto Const Mandatory
{Fire lights: most fires in the game are a plain barrel or a burn pile lit by one of these.}
FormList Property FireSources Auto Const Mandatory
{What burns under a fire light: flame effects and the cooking fire (the fire barrels are FireAnchors). A light with
 none of these near is room light, not a fire (1.2.0).}
FormList Property LampSources Auto Const Mandatory
{Oil lamps: a fire light over one gets a single spot at the lamp.}
Float Property FireSourceRadius = 160.0 Auto Const
{How far from a fire light its fire may be: 36 of the 37 lights vanilla warms hands at (research/fire_sources.md).}
Float Property LampRadius = 60.0 Auto Const
FormList Property CounterAnchors Auto Const Mandatory
FormList Property RailAnchors Auto Const Mandatory
FormList Property WorkAnchors Auto Const Mandatory
FormList Property BenchAnchors Auto Const Mandatory
FormList Property TableAnchors Auto Const Mandatory
FormList Property RadioAnchors Auto Const Mandatory
Form[] Property GeoBases Auto Const Mandatory
{Every counter, rail, workbench and bench base, with its bounds in the four arrays below (OBND, local).}
Float[] Property GeoX1 Auto Const Mandatory
Float[] Property GeoY1 Auto Const Mandatory
Float[] Property GeoX2 Auto Const Mandatory
Float[] Property GeoY2 Auto Const Mandatory

Form Property WarmStanding Auto Const Mandatory
Form Property WarmKneeling Auto Const Mandatory
Form Property Smoke Auto Const Mandatory
Form Property Coffee Auto Const Mandatory
Form Property Noodles Auto Const Mandatory
Form Property Lean Auto Const Mandatory
Form Property Newspaper Auto Const Mandatory
Form[] Property Tools Auto Const Mandatory
Form Property Dance Auto Const Mandatory
{Our own idle marker: vanilla's two unused dance loops, the drunk sway and the clap.}
FormList Property CampfireAnchors Auto Const Mandatory
FormList Property CropAnchors Auto Const Mandatory
FormList Property HedgeAnchors Auto Const Mandatory
FormList Property PoolAnchors Auto Const Mandatory
FormList Property TvAnchors Auto Const Mandatory
FormList Property GateAnchors Auto Const Mandatory
Form Property Examine Auto Const Mandatory
Form Property Shopping Auto Const Mandatory
Form Property Military Auto Const Mandatory
Form Property Clipboard Auto Const Mandatory
Form Property NeedlePrep Auto Const Mandatory
Form Property PipBoy Auto Const Mandatory
Form Property UseJet Auto Const Mandatory
Form Property Search Auto Const Mandatory
Form Property KneelSit Auto Const Mandatory
Form Property SadSit Auto Const Mandatory
Form Property PAExamine Auto Const Mandatory
Form Property HandyGarden Auto Const Mandatory
Form Property HandyTrim Auto Const Mandatory
Form Property NewsLeanRight Auto Const Mandatory
Form Property NewsLeanLeft Auto Const Mandatory
Form Property DogSniff Auto Const Mandatory
{Wave 2 (research/vet_*): any human unless noted -- PAExamine power armor only, the two Handy spots robots
only, DogSniff dogs only.}
Form Property HandRailA Auto Const Mandatory
Form Property HandRailB Auto Const Mandatory
Form Property HandRailC Auto Const Mandatory
Form Property HandRailD Auto Const Mandatory
Form Property MapLean Auto Const Mandatory
Form Property BoxSearch Auto Const Mandatory
Form Property WeldMed Auto Const Mandatory
Form Property WeldHigh Auto Const Mandatory
Form Property PaintWall Auto Const Mandatory
Form Property GuardPost Auto Const Mandatory
Form Property Hoe Auto Const Mandatory
Form Property WeedA Auto Const Mandatory
Form Property WeedB Auto Const Mandatory
Form Property ClipboardPen Auto Const Mandatory
Form Property Broom Auto Const Mandatory
Form Property BroomConst Auto Const Mandatory
Form Property PushUps Auto Const Mandatory
Form Property Pray Auto Const Mandatory
Form Property KidSit Auto Const Mandatory
Form Property Patrol Auto Const Mandatory
{Wave 3 (owner 2026-10-02: "use all we can found"; research/wave3): every vanilla pose spot that fits a
place, none restricted in its record. KidSit is the children's; Patrol is vanilla's patrol idle marker.}
FormList Property CrateAnchors Auto Const Mandatory
{Boxes and crates: someone rummaging through one (vanilla's box search, 18 off the box, facing it).}

Quest Property TestQuest Auto Const Mandatory
RefCollectionAlias Property Testers Auto Const Mandatory
{The MCM Testing page's settlers: their alias package makes them sandbox where they stand.}
Form Property TestNpc Auto Const Mandatory
Form Property Chat Auto Const Mandatory
{Our chat spot: nods, head shakes, shrugs, pointing, a laugh -- no words (an IDLM like Dance). A pair faces each other.}
Form Property ChatDog Auto Const Mandatory
{A dog's half of a chat: it answers with its yes and no barks.}
Form Property ChatHandy Auto Const Mandatory
{A Mr. Handy's half of a chat: it scans the one talking to it.}
Quest Property ChatQuest Auto Const Mandatory
RefCollectionAlias Property Chatters Auto Const Mandatory
{The two in a chat: its package is HoldPosition, so their sandbox package does not walk them off mid-gesture.}
Int Property TesterCount = 4 Auto Const
GlobalVariable Property Enabled Auto Const Mandatory
{IL_On: 0 takes every spot away again.}

Float Property ScanSeconds = 5.0 Auto Const
Float Property Radius = 3000.0 Auto Const
{About 43 m around the player.}
Float Property Ring = 70.0 Auto Const
{Units from a fire's centre to a hand-warming spot. Vanilla's 74: median 69, facing the fire (research).}
Float Property SmokeRing = 170.0 Auto Const
Float Property LightDrop = 68.0 Auto Const
{How far below a fire light the floor is: vanilla's hand-warming spots, median (research/calib).}
Float Property SameFire = 150.0 Auto Const
{A fire light this close to a fire that already has spots is that fire's flame, not another fire.}
Float Property CounterOut = 30.0 Auto Const
Float Property RailOut = 12.0 Auto Const
{Vanilla's lean spots at railings: ~12 out, back to the rail (research/cal2_counter).}
Float Property WorkOut = 50.0 Auto Const
Float Property BenchOut = 110.0 Auto Const
{Vanilla's standing spots near benches: ~110 out (research/cal2_work).}
Float Property PairGap = 110.0 Auto Const
Float Property RailBackOut = 14.0 Auto Const
{Vanilla's hand-rail poses A/B: back to the rail, 11-16 out (research/wave3, n=24/27).}
Float Property RailFaceOut = 38.0 Auto Const
{Vanilla's hand-rail poses C/D: facing the rail, 37-41 out (n=37/26).}
Float Property MapLeanOut = 20.0 Auto Const
{Vanilla's map lean: 20 off the table's edge, facing it (n=11).}
Int Property MaxCrateCandidates = 8 Auto Const
{Boxes and crates are everywhere (thousands placed): only this many go into one draw's pool.}
Form Property GroundSit Auto Const Mandatory
{NPCInvGroundSit: for the spots that go next to the people where nothing else is.}
GlobalVariable Property SpotsPerPersonSetting Auto Const Mandatory
GlobalVariable Property MaxBudgetSetting Auto Const Mandatory
GlobalVariable Property DailyReshuffle Auto Const Mandatory
GlobalVariable Property DetailedLog Auto Const Mandatory
{MCM Testing page (owner 2026-10-02, for testers' reports): every spot placed, with its pose and its place.}
GlobalVariable[] Property KindOn Auto Const Mandatory
{MCM: one switch per kind, in kind order (crops+hedges share one, pool tables+TVs share one).}
Int Property MinBudget = 3 Auto Const
Float Property PeopleReach = 800.0 Auto Const
{A place counts as near a person within this.}
Float Property Crowding = 250.0 Auto Const
{Any place drawn makes every candidate of any kind this close worth less (x0.3).}
Float Property KindDecay = 0.6 Auto Const
{Each place of a kind drawn makes the next of that kind worth this much less.}
Float Property RedrawMove = 1000.0 Auto Const
Int Property MaxPeopleSpots = 6 Auto Const
Int Property MaxChatPairs = 3 Auto Const
{Chat pairs at a time: one per PeoplePerChat people, at most this many (each pair is two spots of the budget).}
Int Property PeoplePerChat = 5 Auto Const
Float Property ChatGap = 110.0 Auto Const
{How far apart the two of a chat stand: vanilla's conversation distance, as our bench pairs.}
Int Property MaxSpots = 120 Auto Const
{Inside Papyrus' 128-element arrays.}

Int Property K_FIRE = 0 AutoReadOnly
Int Property K_COUNTER = 1 AutoReadOnly
Int Property K_RAIL = 2 AutoReadOnly
Int Property K_WORK = 3 AutoReadOnly
Int Property K_BENCH = 4 AutoReadOnly
Int Property K_RADIO = 5 AutoReadOnly
Int Property K_PEOPLE = 6 AutoReadOnly
Int Property K_TABLE = 7 AutoReadOnly
Int Property K_CAMP = 8 AutoReadOnly
Int Property K_CROP = 9 AutoReadOnly
Int Property K_HEDGE = 10 AutoReadOnly
Int Property K_POOL = 11 AutoReadOnly
Int Property K_TV = 12 AutoReadOnly
Int Property K_GATE = 13 AutoReadOnly
Int Property K_DOG = 14 AutoReadOnly
Int Property K_WALL = 15 AutoReadOnly      ; from the navmesh DLL
Int Property K_OPEN = 16 AutoReadOnly      ; from the navmesh DLL
Int Property K_CRATE = 17 AutoReadOnly     ; wave 3
Int Property K_CHAT = 18 AutoReadOnly      ; 1.2.0: chat pairs
Int Property KIND_COUNT = 18 AutoReadOnly
Int Property KW_ROBOT = 0x02CB73 AutoReadOnly          ; ActorTypeRobot
Int Property KW_DOG = 0x021AD0 AutoReadOnly            ; ActorTypeDog
Int Property KW_CHILD = 0x1157E8 AutoReadOnly          ; ActorTypeChild
Int Property CHEM_A = 0x12F2F5 AutoReadOnly            ; WorkbenchChemistryA
Int Property CHEM_B = 0x1487C1 AutoReadOnly            ; WorkbenchChemistryB
Int Property PA_STATION = 0x157FEB AutoReadOnly        ; WorkbenchPowerArmor
Int Property PA_SMALL = 0x13BD08 AutoReadOnly          ; WorkbenchPowerArmorSmall
Int Property DLC04_KNIFE_CLEAN = 0x024211 AutoReadOnly ; DLCNukaWorld DLC04NPCDiscipleCleaningKnifeIdleMarker
Int Property DLC04_KNIFE_PLAY = 0x024212 AutoReadOnly  ; DLCNukaWorld DLC04NPCDisciplePlayingKnifeIdleMarker
Int Property DLC04_BOTTLE = 0x053928 AutoReadOnly      ; DLCNukaWorld DLC04BottleChuggingIdleMarker
Int Property DLC05_CAMPFIRE = 0x00091A AutoReadOnly    ; DLCworkshop01 WorkshopCampFire01 (buildable)
; Fallout4.esm
Int Property KW_HUMAN = 0x02CB72 AutoReadOnly
Int Property KW_GHOUL = 0x0EAFB7 AutoReadOnly
Int Property GAME_HOUR = 0x000038 AutoReadOnly
Int Property LOC_TOWN = 0x022611 AutoReadOnly          ; LocTypeSettlement (Diamond City, Goodneighbor...)
Int Property LOC_WORKSHOP = 0x083C9A AutoReadOnly      ; LocTypeWorkshopSettlement
Int Property LOC_RAIDERS = 0x030855 AutoReadOnly       ; LocEncRaiders
Int Property LOC_BAR = 0x022632 AutoReadOnly           ; LocTypeBar

Int Property SCAN_TIMER = 1 AutoReadOnly
Int Property DEBUG_SPAWN_TIMER = 10 AutoReadOnly
Int Property DEBUG_STATUS_TIMER = 11 AutoReadOnly
Int Property CHAT_TIMER = 12 AutoReadOnly       ; the chat director's next gesture
Int Property RECOUNT_EVERY = 6 AutoReadOnly    ; scans between two people recounts (30 s)
Int Property REPORT_EVERY = 3 AutoReadOnly     ; scans between two reports (15 s: who is on which spot)
Int Property SPAWNER_QUEST = 0x000800 AutoReadOnly
; DLC fires and radios, by form id.
Int Property DLC01_BRAZIER01 = 0x00A5DD AutoReadOnly
Int Property DLC01_BRAZIER02 = 0x00A5DE AutoReadOnly
Int Property DLC01_BRAZIER03 = 0x00A5DF AutoReadOnly
Int Property DLC05_FIRE_BARREL = 0x000918 AutoReadOnly   ; DLCworkshop01 workshopMetalFireBarrel (buildable)
Int Property DLC06_FIRE_BARREL = 0x0052E7 AutoReadOnly   ; DLCworkshop03 DLC06ScrapableMetalBarrel01Fire02_Static
Int Property DLC04_RAIDER_RADIO = 0x025B40 AutoReadOnly  ; DLCNukaWorld DLC04RaiderRadioReceiver
Int Property DLC04_CAFE_RADIO = 0x0557EF AutoReadOnly    ; DLCNukaWorld DLC04RadioRaiderAmplifierCafeOn

ObjectReference[] _anchors     ; places that have their spots
Int[] _anchorKind              ; K_* of each (same index)
ObjectReference[] _spots       ; every spot placed
ObjectReference[] _spotFire    ; the place each spot belongs to (same index as _spots)
Int _scans = 0
Cell _drawCell = None
Float _drawX = 0.0
Float _drawY = 0.0
Int _budget = 0
Bool _native = False         ; IdleLife.dll is loaded: walls and open ground
ObjectReference _mixedChat = None   ; the creature's half of the one mixed chat
Bool _solid = False          ; ... and it can tell a spot inside a pillar (plugin 0.3.0)
Int _robots = 0               ; robots near at the last draw: the Handy spots only when there are some
ObjectReference[] _dwSpot    ; furniture spots in use at the last report, who was on each, and since when
Actor[] _dwUser
Float[] _dwSince
Int _lastSeen = -1
Bool _toldInUse = False

Event OnQuestInit()
	Begin()
EndEvent

Event Actor.OnPlayerLoadGame(Actor akSender)
	If !OnOwnRecord()
		Return
	EndIf
	Begin()
EndEvent

; Only ever run on our own quest: a save made while a build renumbered the plugin can bind this script to
; another record (AN76 Toilets, 2026-09-29).
Bool Function OnOwnRecord()
	If Game.GetFormFromFile(SPAWNER_QUEST, "IdleLife.esp") == Self as Form
		Return True
	EndIf
	Debug.Trace("Idle Life: a stray spawner instance on " + Self + " - stopped", 0)
	UnregisterForAllEvents()
	Return False
EndFunction

Function Begin()
	RegisterForRemoteEvent(Game.GetPlayer(), "OnPlayerLoadGame")
	If !_anchors
		_anchors = new ObjectReference[0]
		_spots = new ObjectReference[0]
		_spotFire = new ObjectReference[0]
	EndIf
	; A save from the fires-only build has spots but no kinds: every one of them was a fire.
	If !_anchorKind || _anchorKind.Length != _anchors.Length
		_anchorKind = new Int[0]
		Int i = 0
		While i < _anchors.Length
			_anchorKind.Add(K_FIRE)
			i += 1
		EndWhile
	EndIf
	; Real time starts over with the game: who-sat-since-when from before a load means nothing.
	_dwSpot = new ObjectReference[0]
	_dwUser = new Actor[0]
	_dwSince = new Float[0]
	_drawCell = None   ; draw again on the first scan after a load
	AddAnchor(FireAnchors, DLC01_BRAZIER01, "DLCRobot.esm")
	AddAnchor(FireAnchors, DLC01_BRAZIER02, "DLCRobot.esm")
	AddAnchor(FireAnchors, DLC01_BRAZIER03, "DLCRobot.esm")
	AddAnchor(FireAnchors, DLC05_FIRE_BARREL, "DLCworkshop01.esm")
	AddAnchor(FireAnchors, DLC06_FIRE_BARREL, "DLCworkshop03.esm")
	AddAnchor(RadioAnchors, DLC04_RAIDER_RADIO, "DLCNukaWorld.esm")
	AddAnchor(RadioAnchors, DLC04_CAFE_RADIO, "DLCNukaWorld.esm")
	AddAnchor(CampfireAnchors, DLC05_CAMPFIRE, "DLCworkshop01.esm")
	CheckSetup()
	Debug.Trace("Idle Life: started - " + FireAnchors.GetSize() + " fires, " + CounterAnchors.GetSize() + " counters, " + RailAnchors.GetSize() + " rails, " + WorkAnchors.GetSize() + " workbenches, " + BenchAnchors.GetSize() + " benches, " + RadioAnchors.GetSize() + " radios known; " + _anchors.Length + " places dressed, " + _spots.Length + " spots", 0)
	StartTimer(ScanSeconds, SCAN_TIMER)
EndFunction

Function AddAnchor(FormList akList, Int aiFormID, String asPlugin)
	If Game.IsPluginInstalled(asPlugin)
		Form f = Game.GetFormFromFile(aiFormID, asPlugin)
		If f && !akList.HasForm(f)
			akList.AddForm(f)
		EndIf
	EndIf
EndFunction

Event OnTimer(Int aiTimerID)
	If !OnOwnRecord()
		Return
	EndIf
	If aiTimerID == DEBUG_SPAWN_TIMER
		SpawnTesters()
		Return
	ElseIf aiTimerID == DEBUG_STATUS_TIMER
		Debug.MessageBox(StatusText())
		Return
	ElseIf aiTimerID == CHAT_TIMER
		ChatStep()
		Return
	ElseIf aiTimerID != SCAN_TIMER
		Return
	EndIf
	Actor player = Game.GetPlayer()
	Prune(player, Enabled.GetValueInt() == 0)
	If Enabled.GetValueInt() == 1 && !player.IsInCombat()
		If Arrived(player)
			Draw(player)
		ElseIf _scans % RECOUNT_EVERY == 0
			; Every 30 s, cheaply: does the budget still fit the people here? Only a change of 2 or more
			; draws again (people arriving get spots, people leaving free them) -- no flapping as one
			; wanders in and out of range (owner 2026-10-01).
			Int b = BudgetFor(People(player).Length + CountRobots(player))
			If b - _budget >= 2 || _budget - b >= 2
				Debug.Trace("Idle Life: the people here changed - budget " + _budget + " -> " + b, 0)
				Draw(player)
			EndIf
		EndIf
	EndIf
	If !_chA && Chatters.GetCount() > 0
		LetGo()      ; a save made mid-chat: nobody stays held
	EndIf
	If _chA && !_chBegun && Utility.GetCurrentRealTime() - _chSince > ChatWalkSeconds
		; a walk that does not arrive (owner's DC test 10-06: Cathy, 72 units short, still walking after 20 s):
		; near enough by now, they talk where they are; not, it is called off -- never a stuck director
		If _chB && _chA.GetDistance(_chB) <= ChatTalkMax
			Debug.Trace("Idle Life: the walk-over ran long - the chat starts where they are", 0)
			BeginChat(_chId)
		Else
			Debug.Trace("Idle Life: a chat called off - " + _chA + " still walking after " + (ChatWalkSeconds as Int) + " s", 0)
			EndChat()
		EndIf
	EndIf
	If Enabled.GetValueInt() == 1 && !player.IsInCombat() && KindIsOn(K_CHAT) && !_chA
		StartChat(player, False)
	EndIf
	_scans += 1
	If _scans % REPORT_EVERY == 0 && _spots.Length > 0
		Report()
	EndIf
	StartTimer(ScanSeconds, SCAN_TIMER)
EndEvent

; ---- finding places ------------------------------------------------------------------------------

; Not Is3DLoaded: an object baked into precombined meshes reads unloaded while it is right there (AN76
; Toilets' world toilets, 2026-09-29). Its cell being attached is what "near and real" means here.
Bool Function Usable(ObjectReference akRef)
	Return akRef && !akRef.IsDisabled() && _anchors.Find(akRef) < 0 && akRef.GetParentCell() && akRef.GetParentCell().IsAttached()
EndFunction

; ---- the draw ------------------------------------------------------------------------------------

; Somewhere new: a new cell, or far enough from where the last draw was.
Bool Function Arrived(Actor akPlayer)
	If akPlayer.GetParentCell() != _drawCell
		Return True
	EndIf
	Float dx = akPlayer.GetPositionX() - _drawX
	Float dy = akPlayer.GetPositionY() - _drawY
	Return dx * dx + dy * dy > RedrawMove * RedrawMove
EndFunction

; Who could use a spot: people near the player, alive, calm, not hostile.
Actor[] Function People(Actor akPlayer)
	Actor[] out = new Actor[0]
	AddPeople(out, akPlayer.FindAllReferencesWithKeyword(Game.GetFormFromFile(KW_HUMAN, "Fallout4.esm"), Radius), akPlayer)
	AddPeople(out, akPlayer.FindAllReferencesWithKeyword(Game.GetFormFromFile(KW_GHOUL, "Fallout4.esm"), Radius), akPlayer)
	Return out
EndFunction

Function AddPeople(Actor[] akOut, ObjectReference[] akRefs, Actor akPlayer)
	Int i = 0
	While i < akRefs.Length && akOut.Length < 30
		Actor a = akRefs[i] as Actor
		If a && a != akPlayer && a.Is3DLoaded() && !a.IsDead() && !a.IsInCombat() && !a.IsHostileToActor(akPlayer) && akOut.Find(a) < 0
			akOut.Add(a)
		EndIf
		i += 1
	EndWhile
EndFunction

Function Draw(Actor akPlayer)
	_drawCell = akPlayer.GetParentCell()
	_drawX = akPlayer.GetPositionX()
	_drawY = akPlayer.GetPositionY()
	Actor[] people = People(akPlayer)
	_robots = CountRobots(akPlayer)
	_budget = BudgetFor(people.Length + _robots)
	Trim(akPlayer)
	Int before = _spots.Length
	If _spots.Length < _budget
		WallAndOpen(akPlayer, people)
	EndIf
	If _spots.Length < _budget
		FillFromPool(akPlayer, people)
	EndIf
	If _spots.Length < _budget
		PeopleSpots(akPlayer, people)
	EndIf
	DogSpots(akPlayer)
	Debug.Trace("Idle Life: draw - " + people.Length + " people, budget " + _budget + " spots, " + (_spots.Length - before) + " new; " + KindCounts() + " in " + _drawCell, 0)
EndFunction

; Nobody here: nothing to dress. Somebody: at least MinBudget, SpotsPerPerson each, never over MaxBudget.
Int Function BudgetFor(Int aiPeople)
	If aiPeople <= 0
		Return 0
	EndIf
	Int b = Math.Ceiling(aiPeople * SpotsPerPersonSetting.GetValue())
	Int most = MaxBudgetSetting.GetValueInt()
	If b < MinBudget
		b = MinBudget
	ElseIf b > most
		b = most
	EndIf
	If b > MaxSpots - 4
		b = MaxSpots - 4
	EndIf
	Return b
EndFunction

; Over budget (fewer people now): the places farthest from the player go first.
Function Trim(Actor akPlayer)
	While _spots.Length > _budget && _anchors.Length > 0
		Int far = 0
		Float farD = -1.0
		Int i = 0
		While i < _anchors.Length
			Float d = 999999.0
			If _anchors[i]
				d = _anchors[i].GetDistance(akPlayer)
			EndIf
			If d > farD
				farD = d
				far = i
			EndIf
			i += 1
		EndWhile
		RemovePlace(_anchors[far], far)
	EndWhile
EndFunction

Function RemovePlace(ObjectReference akPlace, Int aiIndex)
	Int i = _spots.Length - 1
	While i >= 0
		If _spotFire[i] == akPlace
			If _spots[i]
				_spots[i].Disable(False)
				_spots[i].Delete()
			EndIf
			_spots.Remove(i, 1)
			_spotFire.Remove(i, 1)
		EndIf
		i -= 1
	EndWhile
	_anchors.Remove(aiIndex, 1)
	_anchorKind.Remove(aiIndex, 1)
EndFunction

; Every candidate of every kind near the people, scored by how many people are near it, then drawn one by
; one: kind weight x people near x KindDecay per place of that kind already drawn x crowding x a little
; jitter from the place and the day.
Function FillFromPool(Actor akPlayer, Actor[] akPeople)
	ObjectReference[] cand = new ObjectReference[0]
	Int[] kind = new Int[0]
	Float[] near = new Float[0]
	FormList[] lists = new FormList[15]
	lists[0] = FireAnchors
	lists[1] = FireLights
	lists[2] = CounterAnchors
	lists[3] = RailAnchors
	lists[4] = WorkAnchors
	lists[5] = BenchAnchors
	lists[6] = RadioAnchors
	lists[7] = TableAnchors
	lists[8] = CampfireAnchors
	lists[9] = CropAnchors
	lists[10] = HedgeAnchors
	lists[11] = PoolAnchors
	lists[12] = TvAnchors
	lists[13] = GateAnchors
	lists[14] = CrateAnchors
	Int[] kinds = new Int[15]
	kinds[0] = K_FIRE
	kinds[1] = K_FIRE
	kinds[2] = K_COUNTER
	kinds[3] = K_RAIL
	kinds[4] = K_WORK
	kinds[5] = K_BENCH
	kinds[6] = K_RADIO
	kinds[7] = K_TABLE
	kinds[8] = K_CAMP
	kinds[9] = K_CROP
	kinds[10] = K_HEDGE
	kinds[11] = K_POOL
	kinds[12] = K_TV
	kinds[13] = K_GATE
	kinds[14] = K_CRATE
	Int crates = 0
	Int p = 0
	While p < akPeople.Length && p < 12
		Int l = 0
		While l < lists.Length
			ObjectReference[] found = akPeople[p].FindAllReferencesOfType(lists[l], PeopleReach)
			Int f = 0
			While f < found.Length
				ObjectReference r = found[f]
				If Usable(r)
					Int at = cand.Find(r)
					If at >= 0
						near[at] = near[at] + 1.0
					ElseIf cand.Length < 120 && (kinds[l] != K_CRATE || crates < MaxCrateCandidates)
						cand.Add(r)
						kind.Add(kinds[l])
						near.Add(1.0)
						If kinds[l] == K_CRATE
							crates += 1
						EndIf
					EndIf
				EndIf
				f += 1
			EndWhile
			l += 1
		EndWhile
		p += 1
	EndWhile
	If cand.Length == 0
		Return
	EndIf

	Float[] weight = KindWeights(akPlayer)
	Int[] drawn = new Int[KIND_COUNT]
	Float[] crowd = new Float[0]
	Int i = 0
	While i < cand.Length
		crowd.Add(Jitter(cand[i]))
		i += 1
	EndWhile
	; What is already dressed crowds its surroundings and counts towards its kind.
	i = 0
	While i < _anchors.Length
		If _anchors[i]
			drawn[_anchorKind[i]] = drawn[_anchorKind[i]] + 1
			Crowd(cand, crowd, _anchors[i])
			SpaceOut(cand, kind, crowd, _anchors[i], _anchorKind[i])
		EndIf
		i += 1
	EndWhile

	While _spots.Length < _budget && _spots.Length < MaxSpots - 4
		Int best = -1
		Float bestScore = 0.0
		i = 0
		While i < cand.Length
			If cand[i]
				Int k = kind[i]
				Float people = Math.Sqrt(near[i])
				If people > 2.0
					people = 2.0
				EndIf
				Float sc = weight[k] * people * Math.Pow(KindDecay, drawn[k] as Float) * crowd[i]
				If drawn[k] >= KindCap()
					sc = 0.0
				EndIf
				If sc > bestScore
					bestScore = sc
					best = i
				EndIf
			EndIf
			i += 1
		EndWhile
		If best < 0
			Return
		EndIf
		ObjectReference pick = cand[best]
		Int pk = kind[best]
		cand[best] = None
		Bool isLight = FireLights.HasForm(pick.GetBaseObject())
		Int lightKind = LIGHT_FIRE
		If pk == K_FIRE && isLight
			lightKind = LightKind(pick)
		EndIf
		If pk == K_FIRE && isLight && NearKind(pick, K_FIRE, SameFire)
			; the flame of a fire already dressed
		ElseIf pk == K_FIRE && lightKind == LIGHT_NONE
			; room light: nothing burns under it (1.2.0, fR1eNd: hands warmed "out of nowhere" in the Dugout Inn)
		ElseIf pk == K_RADIO && !pick.IsRadioOn()
			; a radio that is off
		Else
			If pk == K_FIRE
				DressFire(pick, isLight, lightKind == LIGHT_LAMP)
			Else
				Dress(pick, pk)
			EndIf
			drawn[pk] = drawn[pk] + 1
			Crowd(cand, crowd, pick)
			SpaceOut(cand, kind, crowd, pick, pk)
		EndIf
	EndWhile
EndFunction

; No kind takes more than about a sixth of the budget's places (at least 2): 12 rails in one draw was the
; first measured overspam (log 2026-10-01).
Int Function KindCap()
	Int cap = _budget / 6
	If cap < 2
		cap = 2
	EndIf
	Return cap
EndFunction

; Same kind, too close: out of the draw (the per-kind spacing the pool lost; modular counters, long fences).
Function SpaceOut(ObjectReference[] akCand, Int[] akKind, Float[] akCrowd, ObjectReference akPlace, Int aiKind)
	Float spacing = 0.0
	If aiKind == K_RAIL
		spacing = 600.0
	ElseIf aiKind == K_CRATE
		spacing = 500.0
	ElseIf aiKind == K_COUNTER || aiKind == K_BENCH || aiKind == K_TABLE
		spacing = 300.0
	EndIf
	If spacing <= 0.0
		Return
	EndIf
	Int j = 0
	While j < akCand.Length
		If akCand[j] && akKind[j] == aiKind && akCand[j].GetDistance(akPlace) < spacing
			akCrowd[j] = 0.0
		EndIf
		j += 1
	EndWhile
EndFunction

Function Crowd(ObjectReference[] akCand, Float[] akCrowd, ObjectReference akPlace)
	Int j = 0
	While j < akCand.Length
		If akCand[j] && akCand[j].GetDistance(akPlace) < Crowding
			akCrowd[j] = akCrowd[j] * 0.3
		EndIf
		j += 1
	EndWhile
EndFunction

; 0.85-1.15 from the place and the in-game day: the same all day, different next week.
Float Function Jitter(ObjectReference akRef)
	Int v = Seed(akRef) % 9973 + Day() * 7919
	If v < 0
		v = -v
	EndIf
	Return 0.85 + (v % 31) / 100.0
EndFunction

; Base shares (fire 3, counter 2, bench 2, work 1.5, rail 1, radio 1), times the hour and the place.
Float[] Function KindWeights(Actor akPlayer)
	Float[] w = new Float[KIND_COUNT]
	w[K_FIRE] = 3.0
	w[K_COUNTER] = 2.0
	w[K_RAIL] = 1.0
	w[K_WORK] = 1.5
	w[K_BENCH] = 2.0
	w[K_RADIO] = 1.0
	w[K_TABLE] = 2.0
	w[K_CAMP] = 3.0
	w[K_CROP] = 1.5
	w[K_HEDGE] = 1.0
	w[K_POOL] = 1.5
	w[K_TV] = 1.0
	w[K_GATE] = 1.0
	w[K_CRATE] = 0.8
	If _robots == 0          ; the hedge trimming is for robots only (crops have people farming since wave 3)
		w[K_HEDGE] = 0.0
	EndIf
	GlobalVariable gameHour = Game.GetFormFromFile(GAME_HOUR, "Fallout4.esm") as GlobalVariable
	Float hour = 12.0
	If gameHour
		hour = gameHour.GetValue()
	EndIf
	If hour >= 20.0 || hour < 5.0          ; night: around fires and radios, fewer at counters
		w[K_FIRE] = w[K_FIRE] * 2.0
		w[K_RADIO] = w[K_RADIO] * 2.0
		w[K_COUNTER] = w[K_COUNTER] * 0.7
	ElseIf hour < 11.0                     ; morning: coffee and work
		w[K_COUNTER] = w[K_COUNTER] * 1.5
		w[K_WORK] = w[K_WORK] * 1.5
	Else                                   ; day: work
		w[K_WORK] = w[K_WORK] * 1.5
	EndIf
	Location here = akPlayer.GetCurrentLocation()
	If here
		If here.HasKeyword(Game.GetFormFromFile(LOC_WORKSHOP, "Fallout4.esm") as Keyword)
			w[K_WORK] = w[K_WORK] * 2.0
			w[K_FIRE] = w[K_FIRE] * 1.5
		EndIf
		If here.HasKeyword(Game.GetFormFromFile(LOC_TOWN, "Fallout4.esm") as Keyword)
			w[K_COUNTER] = w[K_COUNTER] * 1.5
			w[K_BENCH] = w[K_BENCH] * 1.5
			w[K_TABLE] = w[K_TABLE] * 1.5
		EndIf
		If here.HasKeyword(Game.GetFormFromFile(LOC_RAIDERS, "Fallout4.esm") as Keyword)
			w[K_FIRE] = w[K_FIRE] * 2.0
			w[K_RADIO] = w[K_RADIO] * 2.0
			w[K_WORK] = 0.0
			w[K_COUNTER] = w[K_COUNTER] * 0.5
		EndIf
		If here.HasKeyword(Game.GetFormFromFile(LOC_BAR, "Fallout4.esm") as Keyword)
			w[K_COUNTER] = w[K_COUNTER] * 1.5
			w[K_RADIO] = w[K_RADIO] * 1.5
		EndIf
	EndIf
	; Wave 2 kinds by hour and place.
	If hour >= 20.0 || hour < 5.0
		w[K_CAMP] = w[K_CAMP] * 2.0
	EndIf
	If here
		If here.HasKeyword(Game.GetFormFromFile(LOC_TOWN, "Fallout4.esm") as Keyword)
			w[K_POOL] = w[K_POOL] * 1.5
			w[K_GATE] = w[K_GATE] * 1.5
		EndIf
		If here.HasKeyword(Game.GetFormFromFile(LOC_WORKSHOP, "Fallout4.esm") as Keyword)
			w[K_GATE] = w[K_GATE] * 1.5
			w[K_CROP] = w[K_CROP] * 1.5
			w[K_CRATE] = w[K_CRATE] * 1.5
		EndIf
		If here.HasKeyword(Game.GetFormFromFile(LOC_TOWN, "Fallout4.esm") as Keyword)
			w[K_CRATE] = w[K_CRATE] * 1.5
		EndIf
		If here.HasKeyword(Game.GetFormFromFile(LOC_RAIDERS, "Fallout4.esm") as Keyword)
			w[K_CAMP] = w[K_CAMP] * 1.5
		EndIf
		If here.HasKeyword(Game.GetFormFromFile(LOC_BAR, "Fallout4.esm") as Keyword)
			w[K_POOL] = w[K_POOL] * 2.0
			w[K_TV] = w[K_TV] * 1.5
		EndIf
	EndIf
	Int k = 0
	While k < w.Length && k < KindOn.Length
		If KindOn[k] && KindOn[k].GetValueInt() == 0
			w[k] = 0.0
		EndIf
		k += 1
	EndWhile
	Return w
EndFunction

; Budget left and nothing to anchor it: spots next to the people themselves, 150-300 out, one per
; person who has no dressed place near -- a smoke, a newspaper, a sit on the ground, a coffee.
Function PeopleSpots(Actor akPlayer, Actor[] akPeople)
	If !KindIsOn(K_PEOPLE)
		Return
	EndIf
	Int made = 0
	Int day = Day()
	Int i = 0
	While i < akPeople.Length && made < MaxPeopleSpots && _spots.Length < _budget
		Actor person = akPeople[i]
		If !NearAnyPlace(person, 400.0)
			Int seed = (Seed(person) % 9973) + day * 31
			Float angle = (seed % 360) as Float
			Float r = 150.0 + ((seed / 7) % 151) as Float
			Form kind = PersonSpot(seed)
			If person.HasKeyword(Game.GetFormFromFile(KW_CHILD, "Fallout4.esm") as Keyword)
				kind = KidSit      ; wave 3: the children get their own sit on the ground
			EndIf
			ObjectReference spot = person.PlaceAtMe(kind, 1, False, True, True)
			If spot
				spot.SetPosition(person.GetPositionX() + r * Math.Sin(angle), person.GetPositionY() + r * Math.Cos(angle), person.GetPositionZ())
				spot.SetAngle(0.0, 0.0, (seed % 360) as Float)
				spot.Enable(False)
				spot.MoveToNearestNavmeshLocation()
				If !Buried(spot)
					_spots.Add(spot)
					_spotFire.Add(spot)      ; its own place: kept while the player is near it
					AddAnchorRef(spot, K_PEOPLE)
					Placed(spot, person)
					made += 1
				EndIf
			EndIf
		EndIf
		i += 1
	EndWhile
	If made > 0
		Debug.Trace("Idle Life: " + made + " spots next to people where nothing else was", 0)
	EndIf
EndFunction

; Chat pairs (1.2.0; Nexus user fR1eNd's idea, the owner's "human - basically any creature, even robot"): two
; spots facing each other ChatGap apart, by a person standing where nothing else is dressed, never two chats close.
; At most one pair is a person and a creature (a dog barking yes and no, a Mr Handy scanning), by one standing about.
Function ChatSpots(Actor akPlayer, Actor[] akPeople)
	If !KindIsOn(K_CHAT)
		Return
	EndIf
	Int want = akPeople.Length / PeoplePerChat
	If want > MaxChatPairs
		want = MaxChatPairs
	EndIf
	Int day = Day()
	Int i = 0
	While i < akPeople.Length && CountKind(K_CHAT) / 2 < want && _spots.Length + 2 <= _budget
		Actor person = akPeople[i]
		If !person.HasKeyword(Game.GetFormFromFile(KW_CHILD, "Fallout4.esm") as Keyword) && !NearAnyPlace(person, 400.0) && !NearKind(person, K_CHAT, 700.0)
			Int seed = (Seed(person) % 9973) + day * 31
			Float a = (seed % 360) as Float
			Float r = 180.0 + ((seed / 7) % 121) as Float
			Float cx = person.GetPositionX() + r * Math.Sin(a)
			Float cy = person.GetPositionY() + r * Math.Cos(a)
			ChatPair(person, Chat, cx, cy, person.GetPositionZ(), ((seed / 13) % 360) as Float)
		EndIf
		i += 1
	EndWhile
	If !_mixedChat || _spots.Find(_mixedChat) < 0
		MixedChat(akPlayer)
	EndIf
EndFunction

; Two spots facing each other across the centre, along heading afAlong; the first takes akFirst (a creature's half
; or a person's), the second a person's. Either one inside a pillar: neither (a lone half gestures at nobody).
ObjectReference Function ChatPair(ObjectReference akNear, Form akFirst, Float afX, Float afY, Float afZ, Float afAlong)
	Float half = ChatGap / 2.0
	ObjectReference one = ChatSpot(akNear, akFirst, afX - half * Math.Sin(afAlong), afY - half * Math.Cos(afAlong), afZ, afAlong)
	If !one
		Return None
	EndIf
	ObjectReference two = ChatSpot(akNear, Chat, afX + half * Math.Sin(afAlong), afY + half * Math.Cos(afAlong), afZ, afAlong + 180.0)
	If !two
		DropSpot(one)
		Return None
	EndIf
	Return one
EndFunction

ObjectReference Function ChatSpot(ObjectReference akNear, Form akKind, Float afX, Float afY, Float afZ, Float afFacing)
	ObjectReference spot = akNear.PlaceAtMe(akKind, 1, False, True, True)
	If !spot
		Return None
	EndIf
	spot.SetPosition(afX, afY, afZ)
	spot.SetAngle(0.0, 0.0, afFacing)
	spot.Enable(False)
	spot.MoveToNearestNavmeshLocation()
	If Buried(spot)
		Return None
	EndIf
	spot.SetAngle(0.0, 0.0, afFacing)
	_spots.Add(spot)
	_spotFire.Add(spot)      ; its own place: kept while the player is near it
	AddAnchorRef(spot, K_CHAT)
	Placed(spot, akNear)
	Return spot
EndFunction

; A spot placed a moment ago, taken back (its pair failed).
Function DropSpot(ObjectReference akSpot)
	Int i = _spots.Find(akSpot)
	If i >= 0
		_spots.Remove(i, 1)
		_spotFire.Remove(i, 1)
	EndIf
	Int a = _anchors.Find(akSpot)
	If a >= 0
		_anchors.Remove(a, 1)
		_anchorKind.Remove(a, 1)
	EndIf
	akSpot.Disable(False)
	akSpot.Delete()
EndFunction

Bool Function NearAnyPlace(ObjectReference akRef, Float afDistance)
	Int i = 0
	While i < _anchors.Length
		If _anchors[i] && _anchors[i].GetDistance(akRef) < afDistance
			Return True
		EndIf
		i += 1
	EndWhile
	Return False
EndFunction

Bool Function NearKind(ObjectReference akRef, Int aiKind, Float afDistance)
	Int i = 0
	While i < _anchors.Length
		If _anchorKind[i] == aiKind && _anchors[i] && _anchors[i].GetDistance(akRef) < afDistance
			Return True
		EndIf
		i += 1
	EndWhile
	Return False
EndFunction

Int Function CountKind(Int aiKind)
	Int n = 0
	Int i = 0
	While i < _anchorKind.Length
		If _anchorKind[i] == aiKind
			n += 1
		EndIf
		i += 1
	EndWhile
	Return n
EndFunction

String Function KindCounts()
	Return CountKind(K_FIRE) + " fires, " + CountKind(K_COUNTER) + " counters, " + CountKind(K_RAIL) + " rails, " + CountKind(K_WORK) + " workbenches, " + CountKind(K_BENCH) + " benches, " + CountKind(K_RADIO) + " radios, " + CountKind(K_TABLE) + " tables, " + CountKind(K_CAMP) + " campfires, " + CountKind(K_CROP) + " crops, " + CountKind(K_HEDGE) + " hedges, " + CountKind(K_POOL) + " pool tables, " + CountKind(K_TV) + " TVs, " + CountKind(K_GATE) + " gates, " + CountKind(K_CRATE) + " crates, " + CountKind(K_CHAT) + " chatting, " + CountKind(K_PEOPLE) + " by people, " + CountKind(K_DOG) + " by dogs, " + CountKind(K_WALL) + " by walls, " + CountKind(K_OPEN) + " in the open; " + _spots.Length + " of " + _budget + " spots"
EndFunction

Int Function Seed(ObjectReference akRef)
	Int seed = akRef.GetFormID()
	If seed < 0
		seed = -seed
	EndIf
	Return seed
EndFunction

; ---- the rules -----------------------------------------------------------------------------------

; Fires: 1 to 3 hand-warming spots around the fire (vanilla: 1-3, never 5), unevenly spaced as vanilla's
; are, each facing it; mostly standing, now and then one kneeling; sometimes a smoker a little off.
Function DressFire(ObjectReference akFire, Bool abLight, Bool abLamp = False)
	Int seed = Seed(akFire)
	Float z = akFire.GetPositionZ()
	If abLight
		z -= LightDrop
	EndIf
	Int count = 1 + seed % 3
	If abLamp
		count = 1   ; a lamp warms one pair of hands, standing
	EndIf
	Float start = (seed % 360) as Float
	Float step = 360.0 / count
	Int k = 0
	While k < count
		Float angle = start + step * k + ((seed / (k + 3)) % 51 - 25) as Float   ; +-25 degrees off even
		Form kind = WarmStanding
		If !abLamp && (seed / (k + 7)) % 5 == 0
			kind = WarmKneeling
		EndIf
		PlaceWorld(akFire, kind, akFire.GetPositionX() + Ring * Math.Sin(angle), akFire.GetPositionY() + Ring * Math.Cos(angle), z, angle + 180.0)
		k += 1
	EndWhile
	If !abLamp && (seed / 11) % 3 == 0
		Float away = start + step / 2.0
		PlaceWorld(akFire, Smoke, akFire.GetPositionX() + SmokeRing * Math.Sin(away), akFire.GetPositionY() + SmokeRing * Math.Cos(away), z, (seed % 360) as Float)
		count += 1
	EndIf
	AddAnchorRef(akFire, K_FIRE)
	Debug.Trace("Idle Life: fire " + akFire + " (" + akFire.GetBaseObject() + ") gets " + count + " spots", 0)
EndFunction

Int Property LIGHT_NONE = 0 AutoReadOnly
Int Property LIGHT_FIRE = 1 AutoReadOnly
Int Property LIGHT_LAMP = 2 AutoReadOnly

; What a fire light lights: a fire (a barrel or a flame within FireSourceRadius), an oil lamp, or just the room.
Int Function LightKind(ObjectReference akLight)
	If Game.FindClosestReferenceOfAnyTypeInListFromRef(FireAnchors, akLight, FireSourceRadius) || Game.FindClosestReferenceOfAnyTypeInListFromRef(FireSources, akLight, FireSourceRadius)
		Return LIGHT_FIRE
	ElseIf Game.FindClosestReferenceOfAnyTypeInListFromRef(LampSources, akLight, LampRadius)
		Return LIGHT_LAMP
	EndIf
	Return LIGHT_NONE
EndFunction

; Everything else works in the object's own frame: local +Y is its forward, +X its right; its bounds come
; from the arrays baked from the catalog (a box can sit off-centre on its origin).
Function Dress(ObjectReference akRef, Int aiKind)
	Int seed = Seed(akRef)
	If aiKind == K_RADIO
		DressRadio(akRef, seed)
		Return
	EndIf
	If (aiKind >= K_CAMP && aiKind <= K_GATE) || aiKind == K_CRATE
		DressRing(akRef, aiKind, seed)
		Return
	EndIf
	Int g = GeoBases.Find(akRef.GetBaseObject())
	If g < 0
		Return
	EndIf
	Float s = akRef.GetScale()
	Float x1 = GeoX1[g] * s
	Float y1 = GeoY1[g] * s
	Float x2 = GeoX2[g] * s
	Float y2 = GeoY2[g] * s
	Bool alongX = (x2 - x1) >= (y2 - y1)      ; the long axis
	Bool plus = seed % 2 == 0                ; which long side
	Int count = 0
	If aiKind == K_COUNTER
		; Customers at a stall: 1 or 2 standing with a coffee or a bowl, facing the counter.
		Int n = 1 + (seed / 3) % 2
		Int k = 0
		While k < n
			Float t = 0.5
			If n == 2
				t = 0.3 + 0.4 * k
			EndIf
			Form kind = Coffee
			If (seed / (k + 5)) % 2 == 0
				kind = Noodles
			EndIf
			AlongSide(akRef, kind, x1, y1, x2, y2, alongX, plus, t, CounterOut, True)
			k += 1
			count += 1
		EndWhile
	ElseIf aiKind == K_TABLE
		; Standing at a table with a coffee or a bowl: the market stalls.
		Int tn = 1 + (seed / 3) % 2
		Int tk = 0
		While tk < tn
			Float tt = 0.5
			If tn == 2
				tt = 0.3 + 0.4 * tk
			EndIf
			Form tkind = Noodles
			If (seed / (tk + 5)) % 2 == 0
				tkind = Coffee
			EndIf
			Float tout = CounterOut
			If (seed / (tk + 13)) % 4 == 0
				; Wave 3: bent over the table as over a map, vanilla's 20 off its edge.
				tkind = MapLean
				tout = MapLeanOut
			EndIf
			AlongSide(akRef, tkind, x1, y1, x2, y2, alongX, plus, tt, tout, True)
			tk += 1
			count += 1
		EndWhile
	ElseIf aiKind == K_RAIL
		; Someone leaning back against it, somewhere along it -- or (wave 3) on one of vanilla's four hand-rail
		; poses: A/B with their back to it, C/D facing it with their hands on it.
		Float t = 0.2 + ((seed / 7) % 61) / 100.0
		Int pose = (seed / 11) % 6
		If pose == 2
			AlongSide(akRef, HandRailA, x1, y1, x2, y2, alongX, plus, t, RailBackOut, False)
		ElseIf pose == 3
			AlongSide(akRef, HandRailB, x1, y1, x2, y2, alongX, plus, t, RailBackOut, False)
		ElseIf pose == 4
			AlongSide(akRef, HandRailC, x1, y1, x2, y2, alongX, plus, t, RailFaceOut, True)
		ElseIf pose == 5
			AlongSide(akRef, HandRailD, x1, y1, x2, y2, alongX, plus, t, RailFaceOut, True)
		Else
			AlongSide(akRef, Lean, x1, y1, x2, y2, alongX, plus, t, RailOut, False)
		EndIf
		count = 1
	ElseIf aiKind == K_WORK
		; Someone at one end, working with a hammer or a wrench, facing the bench.
		Form base = akRef.GetBaseObject()
		Form kind = Tools[(seed / 3) % Tools.Length]
		If base == Game.GetFormFromFile(PA_STATION, "Fallout4.esm") || base == Game.GetFormFromFile(PA_SMALL, "Fallout4.esm")
			; A power armor station: someone in armor looking it over (power armor only), and a clipboard.
			AtEnd(akRef, PAExamine, x1, y1, x2, y2, alongX, plus, WorkOut)
			AtEnd(akRef, Clipboard, x1, y1, x2, y2, alongX, !plus, WorkOut)
			count = 2
		Else
			If base == Game.GetFormFromFile(CHEM_A, "Fallout4.esm") || base == Game.GetFormFromFile(CHEM_B, "Fallout4.esm")
				; A chem station: Jet among raiders, a needle being prepped or a clipboard elsewhere.
				If Raiders()
					kind = UseJet
				ElseIf (seed / 5) % 2 == 0
					kind = NeedlePrep
				Else
					kind = Clipboard
				EndIf
			ElseIf (seed / 5) % 6 == 0
				kind = Clipboard
			ElseIf (seed / 5) % 6 == 1
				kind = Search
			ElseIf (seed / 5) % 6 == 2
				kind = ClipboardPen      ; wave 3: writing it down
			ElseIf (seed / 5) % 6 == 3
				kind = WeldMed           ; wave 3: welding at the bench
			EndIf
			AtEnd(akRef, kind, x1, y1, x2, y2, alongX, plus, WorkOut)
			count = 1
		EndIf
	ElseIf aiKind == K_BENCH
		; Two standing about in front of it, facing each other; now and then a smoker at the far end.
		Form a = Coffee
		Form b = Smoke
		If (seed / 5) % 3 == 1
			a = Newspaper
		ElseIf (seed / 5) % 3 == 2
			b = Coffee
		EndIf
		PairInFront(akRef, a, b, x1, y1, x2, y2, alongX, plus, BenchOut, PairGap)
		count = 2
	EndIf
	AddAnchorRef(akRef, aiKind)
	Debug.Trace("Idle Life: " + KindName(aiKind) + " " + akRef + " (" + akRef.GetBaseObject() + ") gets " + count + " spots", 0)
EndFunction

; A playing radio: 2 to 4 dancers around it, 150-220 out, facing it.
Function DressRadio(ObjectReference akRadio, Int aiSeed)
	Int count = 2 + aiSeed % 3
	Float start = (aiSeed % 360) as Float
	Int k = 0
	While k < count
		Float angle = start + (360.0 / count) * k
		Float r = 150.0 + ((aiSeed / (k + 3)) % 71) as Float
		PlaceWorld(akRadio, Dance, akRadio.GetPositionX() + r * Math.Sin(angle), akRadio.GetPositionY() + r * Math.Cos(angle), akRadio.GetPositionZ(), angle + 180.0)
		k += 1
	EndWhile
	AddAnchorRef(akRadio, K_RADIO)
	Debug.Trace("Idle Life: radio " + akRadio + " (" + akRadio.GetBaseObject() + ") gets " + count + " dancers", 0)
EndFunction

String Function KindName(Int aiKind)
	If aiKind == K_COUNTER
		Return "counter"
	ElseIf aiKind == K_TABLE
		Return "table"
	ElseIf aiKind == K_CAMP
		Return "campfire"
	ElseIf aiKind == K_CROP
		Return "crop"
	ElseIf aiKind == K_HEDGE
		Return "hedge"
	ElseIf aiKind == K_POOL
		Return "pool table"
	ElseIf aiKind == K_TV
		Return "TV"
	ElseIf aiKind == K_GATE
		Return "gate"
	ElseIf aiKind == K_WALL
		Return "wall"
	ElseIf aiKind == K_OPEN
		Return "open ground"
	ElseIf aiKind == K_CRATE
		Return "crate"
	ElseIf aiKind == K_RAIL
		Return "rail"
	ElseIf aiKind == K_WORK
		Return "workbench"
	ElseIf aiKind == K_BENCH
		Return "bench"
	ElseIf aiKind == K_RADIO
		Return "radio"
	EndIf
	Return "fire"
EndFunction

; A spot on one long side, afT of the way along it, afOut beyond the face; facing into the object
; (abFaceIn) or away from it (back against it).
Function AlongSide(ObjectReference akRef, Form akKind, Float x1, Float y1, Float x2, Float y2, Bool abAlongX, Bool abPlus, Float afT, Float afOut, Bool abFaceIn)
	Float lx
	Float ly
	Float out    ; local heading pointing away from the object
	If abAlongX
		lx = x1 + afT * (x2 - x1)
		If abPlus
			ly = y2 + afOut
			out = 0.0
		Else
			ly = y1 - afOut
			out = 180.0
		EndIf
	Else
		ly = y1 + afT * (y2 - y1)
		If abPlus
			lx = x2 + afOut
			out = 90.0
		Else
			lx = x1 - afOut
			out = 270.0
		EndIf
	EndIf
	Float facing = out
	If abFaceIn
		facing = out + 180.0
	EndIf
	PlaceLocal(akRef, akKind, lx, ly, facing)
EndFunction

; A spot beyond one end of the long axis, centred on the short axis, facing the object.
Function AtEnd(ObjectReference akRef, Form akKind, Float x1, Float y1, Float x2, Float y2, Bool abAlongX, Bool abPlus, Float afOut)
	If abAlongX
		If abPlus
			PlaceLocal(akRef, akKind, x2 + afOut, (y1 + y2) / 2.0, 270.0)
		Else
			PlaceLocal(akRef, akKind, x1 - afOut, (y1 + y2) / 2.0, 90.0)
		EndIf
	Else
		If abPlus
			PlaceLocal(akRef, akKind, (x1 + x2) / 2.0, y2 + afOut, 180.0)
		Else
			PlaceLocal(akRef, akKind, (x1 + x2) / 2.0, y1 - afOut, 0.0)
		EndIf
	EndIf
EndFunction

; Two spots afOut in front of one long side, afGap apart along it, facing each other.
Function PairInFront(ObjectReference akRef, Form akA, Form akB, Float x1, Float y1, Float x2, Float y2, Bool abAlongX, Bool abPlus, Float afOut, Float afGap)
	If abAlongX
		Float cx = (x1 + x2) / 2.0
		Float ly = y1 - afOut
		If abPlus
			ly = y2 + afOut
		EndIf
		PlaceLocal(akRef, akA, cx - afGap / 2.0, ly, 90.0)
		PlaceLocal(akRef, akB, cx + afGap / 2.0, ly, 270.0)
	Else
		Float cy = (y1 + y2) / 2.0
		Float lx = x1 - afOut
		If abPlus
			lx = x2 + afOut
		EndIf
		PlaceLocal(akRef, akA, lx, cy - afGap / 2.0, 0.0)
		PlaceLocal(akRef, akB, lx, cy + afGap / 2.0, 180.0)
	EndIf
EndFunction

; Local (x right, y forward, heading relative to the object's) to world: FO4 heading is clockwise from
; north, so forward is (sin h, cos h) and right is (cos h, -sin h).
Function PlaceLocal(ObjectReference akRef, Form akKind, Float afX, Float afY, Float afFacing)
	Float h = akRef.GetAngleZ()
	Float wx = akRef.GetPositionX() + afX * Math.Cos(h) + afY * Math.Sin(h)
	Float wy = akRef.GetPositionY() - afX * Math.Sin(h) + afY * Math.Cos(h)
	PlaceWorld(akRef, akKind, wx, wy, akRef.GetPositionZ(), h + afFacing)
EndFunction

; The spot, then onto the nearest walkable floor: a radio on a table, a fire light's height, a point the
; maths put inside a wall -- the navmesh settles all three.
Function PlaceWorld(ObjectReference akAnchor, Form akKind, Float afX, Float afY, Float afZ, Float afFacing)
	ObjectReference spot = akAnchor.PlaceAtMe(akKind, 1, False, True, True)
	If spot
		spot.SetPosition(afX, afY, afZ)
		spot.SetAngle(0.0, 0.0, afFacing)
		spot.Enable(False)
		spot.MoveToNearestNavmeshLocation()
		If Buried(spot)
			Return
		EndIf
		spot.SetAngle(0.0, 0.0, afFacing)
		_spots.Add(spot)
		_spotFire.Add(akAnchor)
		Placed(spot, akAnchor)
	EndIf
EndFunction

; A spot that landed inside a pillar, a post or a machine is taken away again: the navmesh runs under them, so
; the snap to it does not keep a pose out (1.2.0, Nexus user fR1eNd: "they go inside pillars and do things").
Bool Function Buried(ObjectReference akSpot)
	If !_solid || !akSpot
		Return False
	EndIf
	ObjectReference holder = IdleLife:Navmesh.Inside(akSpot)
	If !holder
		Return False
	EndIf
	If DetailedLog.GetValueInt() == 1
		Debug.Trace("Idle Life: " + akSpot.GetBaseObject() + " fell inside " + holder + " (" + holder.GetBaseObject() + ") - not placed", 0)
	EndIf
	akSpot.Disable()
	akSpot.Delete()
	Return True
EndFunction

; The detailed log: one line per spot placed -- which pose, for which place, where.
Function Placed(ObjectReference akSpot, ObjectReference akPlace)
	If DetailedLog.GetValueInt() == 1
		String place = "itself"
		If akPlace && akPlace != akSpot
			place = akPlace + " (" + akPlace.GetBaseObject() + ")"
		EndIf
		Debug.Trace("Idle Life: placed " + akSpot.GetBaseObject() + " " + akSpot + " for " + place + " at " + (akSpot.GetPositionX() as Int) + ", " + (akSpot.GetPositionY() as Int) + ", " + (akSpot.GetPositionZ() as Int) + " facing " + (akSpot.GetAngleZ() as Int), 0)
	EndIf
EndFunction

Function AddAnchorRef(ObjectReference akRef, Int aiKind)
	_anchors.Add(akRef)
	_anchorKind.Add(aiKind)
EndFunction

; Spots whose place is gone, disabled, far behind the player (or in another cell where either is an
; interior: a distance across walls means nothing), or a radio that went quiet, are deleted; abAll takes
; every one.
Function Prune(Actor akPlayer, Bool abAll)
	Cell here = akPlayer.GetParentCell()
	Int i = _spots.Length - 1
	While i >= 0
		ObjectReference spot = _spots[i]
		ObjectReference place = _spotFire[i]
		Bool keep = !abAll && spot && place && !place.IsDisabled() && place.GetDistance(akPlayer) <= Radius * 1.5
		If keep
			Cell there = place.GetParentCell()
			If there != here && (!here || !there || here.IsInterior() || there.IsInterior())
				keep = False
			EndIf
		EndIf
		If keep
			Int at = _anchors.Find(place)
			If at >= 0 && !KindIsOn(_anchorKind[at])
				keep = False
			EndIf
		EndIf
		If keep && spot.GetBaseObject() == Dance && !place.IsRadioOn()
			keep = False
		EndIf
		If !keep
			If spot
				spot.Disable(False)
				spot.Delete()
			EndIf
			_spots.Remove(i, 1)
			_spotFire.Remove(i, 1)
			Int a = _anchors.Find(place)
			If a >= 0
				_anchors.Remove(a, 1)
				_anchorKind.Remove(a, 1)
			EndIf
		EndIf
		i -= 1
	EndWhile
EndFunction

; ---- the MCM Testing page (buttons that play out in the world wait until the menu closes) --------

; Testing page: a chat between the two standing nearest each other near the player, right away.
Function DebugPlaceChat()
	If _chA
		EndChat()
	EndIf
	_chNext = 0.0
	StartChat(Game.GetPlayer(), True)
EndFunction

; A person and a creature: a creature's chat spot where a dog or a robot stands about, a person's facing it
; (owner 10-06: "human - basically any creature, even robot, it would be hilarious"). One at a time.
String Function MixedChat(Actor akPlayer)
	If !KindIsOn(K_CHAT) || _spots.Length + 2 > MaxSpots
		Return ""
	EndIf
	ObjectReference[] dogs = akPlayer.FindAllReferencesWithKeyword(Game.GetFormFromFile(KW_DOG, "Fallout4.esm"), Radius)
	ObjectReference[] bots = akPlayer.FindAllReferencesWithKeyword(Game.GetFormFromFile(KW_ROBOT, "Fallout4.esm"), Radius)
	Actor who = None
	Form half = None
	Int i = 0
	While !who && i < dogs.Length
		Actor d = dogs[i] as Actor
		If d && d.Is3DLoaded() && !d.IsDead() && !d.IsInCombat() && !d.IsHostileToActor(akPlayer) && !NearKind(d, K_CHAT, 400.0)
			who = d
			half = ChatDog
		EndIf
		i += 1
	EndWhile
	i = 0
	While !who && i < bots.Length
		Actor r = bots[i] as Actor
		If r && r.Is3DLoaded() && !r.IsDead() && !r.IsInCombat() && !r.IsHostileToActor(akPlayer) && !NearKind(r, K_CHAT, 400.0)
			who = r
			half = ChatHandy
		EndIf
		i += 1
	EndWhile
	If !who
		Return ""
	EndIf
	Float h = (Seed(who) % 360) as Float
	; the creature's half where it stands, the person's ChatGap away
	ObjectReference first = ChatPair(who, half, who.GetPositionX() + (ChatGap / 2.0) * Math.Sin(h), who.GetPositionY() + (ChatGap / 2.0) * Math.Cos(h), who.GetPositionZ(), h)
	If !first
		Return ""
	EndIf
	_mixedChat = first
	Debug.Trace("Idle Life: a mixed chat by " + who + " (" + who.GetBaseObject() + ")", 0)
	Return ", and a mixed one by a " + who.GetDisplayName()
EndFunction

Function DebugSpawnTesters()
	StartTimer(0.5, DEBUG_SPAWN_TIMER)
	Debug.Notification("Idle Life: " + TesterCount + " test settlers when you close the menu.")
EndFunction

Function DebugRemoveTesters()
	Int removed = 0
	Int i = Testers.GetCount() - 1
	While i >= 0
		ObjectReference t = Testers.GetAt(i)
		Testers.RemoveRef(t)
		If t
			t.Disable(False)
			t.Delete()
			removed += 1
		EndIf
		i -= 1
	EndWhile
	Debug.Notification("Idle Life: " + removed + " test settlers removed.")
	Debug.Trace("Idle Life: " + removed + " test settlers removed", 0)
EndFunction

Function DebugStatus()
	StartTimer(0.5, DEBUG_STATUS_TIMER)
EndFunction

; Around the player, a few steps out: settlers who sandbox right there (their alias package), so they
; wander, sit, and take whatever spots are near.
Function SpawnTesters()
	If !TestQuest.IsRunning()
		TestQuest.Start()
	EndIf
	Actor player = Game.GetPlayer()
	Int made = 0
	Int k = 0
	While k < TesterCount
		Float angle = k * (360.0 / TesterCount) + 45.0
		Actor t = player.PlaceAtMe(TestNpc, 1, False, True, True) as Actor
		If t
			t.SetPosition(player.GetPositionX() + 250.0 * Math.Sin(angle), player.GetPositionY() + 250.0 * Math.Cos(angle), player.GetPositionZ())
			t.Enable(False)
			Testers.AddRef(t)
			t.EvaluatePackage(False)
			made += 1
		EndIf
		k += 1
	EndWhile
	_drawCell = None   ; more people here now: draw again on the next scan, so they get their spots
	Debug.Notification("Idle Life: " + made + " test settlers - watch the spots near you.")
	Debug.Trace("Idle Life: " + made + " test settlers placed around the player (collection " + Testers.GetCount() + ")", 0)
EndFunction

; Furniture spots only: the engine does not say who stands at an idle marker (smoke, dance).
Int Function InUse()
	Int used = 0
	Int i = 0
	While i < _spots.Length
		ObjectReference spot = _spots[i]
		If spot && (spot.GetBaseObject() as Furniture) && spot.IsFurnitureInUse(False)
			used += 1
		EndIf
		i += 1
	EndWhile
	Return used
EndFunction

Int Function FurnitureSpots()
	Int n = 0
	Int i = 0
	While i < _spots.Length
		ObjectReference spot = _spots[i]
		If spot && (spot.GetBaseObject() as Furniture)
			n += 1
		EndIf
		i += 1
	EndWhile
	Return n
EndFunction

String Function StatusText()
	Return "Idle Life\n\n" + KindCounts() + ".\n" + InUse() + " of " + FurnitureSpots() + " furniture spots are in use right now (smoke and dance spots cannot be counted).\n" + Testers.GetCount() + " test settlers."
EndFunction

Function Report()
	Int used = InUse()
	Debug.Trace("Idle Life: " + KindCounts() + ", " + used + " of " + FurnitureSpots() + " furniture spots in use", 0)
	TrackUsers()
	TrackChats()
	If used > 0 && !_toldInUse
		_toldInUse = True
		Debug.Notification("Idle Life: someone is using one of the new spots.")
	EndIf
EndFunction

; Who is on each furniture spot now, and how long the same one has been on it: the log answers "do they
; swap, or does someone camp on one spot?" (owner 2026-10-01). Nothing is changed here -- only measured.
Function TrackUsers()
	Actor[] people = People(Game.GetPlayer())
	ObjectReference[] nowSpot = new ObjectReference[0]
	Actor[] nowUser = new Actor[0]
	Float[] nowSince = new Float[0]
	Float now = Utility.GetCurrentRealTime()
	Int i = 0
	While i < people.Length
		ObjectReference f = people[i].GetFurnitureReference()
		If f && _spots.Find(f) >= 0 && nowSpot.Find(f) < 0
			Int prev = _dwSpot.Find(f)
			Float since = now
			If prev >= 0 && _dwUser[prev] == people[i]
				since = _dwSince[prev]
			ElseIf prev >= 0
				Debug.Trace("Idle Life: spot " + f + " changed hands: " + _dwUser[prev] + " -> " + people[i], 0)
			Else
				Debug.Trace("Idle Life: " + people[i] + " took spot " + f + " (" + f.GetBaseObject() + ")", 0)
			EndIf
			If now - since >= 300.0
				Debug.Trace("Idle Life: " + people[i] + " has been on spot " + f + " for " + ((now - since) as Int) + " s", 0)
			EndIf
			nowSpot.Add(f)
			nowUser.Add(people[i])
			nowSince.Add(since)
		EndIf
		i += 1
	EndWhile
	i = 0
	While i < _dwSpot.Length
		If nowSpot.Find(_dwSpot[i]) < 0
			Debug.Trace("Idle Life: " + _dwUser[i] + " left spot " + _dwSpot[i] + " after about " + ((now - _dwSince[i]) as Int) + " s", 0)
		EndIf
		i += 1
	EndWhile
	_dwSpot = nowSpot
	_dwUser = nowUser
	_dwSince = nowSince
EndFunction

; Who stands at the chat spots (1.2.0): idle markers have no "in use" the engine reports, so by position -- the
; actor closest to the spot, within ChatAtRange. Logs each arrival, and a pair with both halves taken as a chat on
; (owner 10-06: "do they take these spots?" -- the furniture log could not say).
Float Property ChatAtRange = 45.0 Auto Const
ObjectReference[] _chatAt     ; chat spots taken at the last report
Actor[] _chatWho

Function TrackChats()
	ObjectReference[] nowAt = new ObjectReference[0]
	Actor[] nowWho = new Actor[0]
	Int i = 0
	While i < _spots.Length
		ObjectReference spot = _spots[i]
		If spot
			Form b = spot.GetBaseObject()
			; every idle-marker spot, not only chats: whether the locals use runtime-placed idle markers at all
			; (examine, shopping, military, clipboard, smoke, dance) was never measured -- furniture spots only
			If !(b as Furniture)
				Actor who = Game.FindClosestActorFromRef(spot, ChatAtRange)
				If who && who != Game.GetPlayer()
					nowAt.Add(spot)
					nowWho.Add(who)
					Int prev = -1
					If _chatAt
						prev = _chatAt.Find(spot)
					EndIf
					If prev < 0 || _chatWho[prev] != who
						Debug.Trace("Idle Life: " + who + " (" + who.GetBaseObject() + ") is at idle spot " + spot + " (" + b + ")", 0)
					EndIf
				EndIf
			EndIf
		EndIf
		i += 1
	EndWhile
	; both halves of a pair taken: they face each other ChatGap apart
	i = 0
	While i < nowAt.Length
		Int j = i + 1
		While j < nowAt.Length
			If nowAt[i].GetDistance(nowAt[j]) < ChatGap + 30.0 && nowWho[i] != nowWho[j]
				Bool was = _chatAt && _chatAt.Find(nowAt[i]) >= 0 && _chatAt.Find(nowAt[j]) >= 0
				If !was
					Debug.Trace("Idle Life: a chat is on - " + nowWho[i] + " (" + nowWho[i].GetBaseObject() + ") and " + nowWho[j] + " (" + nowWho[j].GetBaseObject() + ")", 0)
				EndIf
			EndIf
			j += 1
		EndWhile
		i += 1
	EndWhile
	_chatAt = nowAt
	_chatWho = nowWho
EndFunction

; ---- the chat director (1.2.0) ---------------------------------------------------------------------------
;
; Chats are not spots. Nexus user fR1eNd asked for people talking with their hands, no words; the owner added
; "human - basically any creature, even robot". Chat MARKERS were placed first (IL_ChatMarker and its dog/Handy
; halves) and in the owner's Diamond City tests (10-06, three sessions) no local ever stopped at one: they walked
; past, whatever the marker carried. So the director picks two who are already standing about near each other,
; turns them face to face, and plays the gestures on them in turns. Only idles with no conditions: the dialogue
; talk/listen idles need a real conversation (TalkMTRoot) and do not play.
Int Property IDLE_YES = 0x038C7B AutoReadOnly       ; HeadShakeYes
Int Property IDLE_NO = 0x038C7A AutoReadOnly        ; HeadShakeNo
Int Property IDLE_SHRUG = 0x038C7C AutoReadOnly     ; Shrug
Int Property IDLE_POINT_F = 0x1793E3 AutoReadOnly   ; PointForward
Int Property IDLE_POINT_L = 0x1793E4 AutoReadOnly   ; PointLeft
Int Property IDLE_POINT_R = 0x1793E5 AutoReadOnly   ; PointRight
Int Property IDLE_LAUGH = 0x118013 AutoReadOnly     ; ActionCustomLaughingStandingA
Int Property IDLE_DOG_YES = 0x02B99E AutoReadOnly   ; Dogmeat_Neutral_TalkYes1
Int Property IDLE_DOG_NO = 0x02B9A0 AutoReadOnly    ; Dogmeat_Neutral_TalkNo1
Int Property IDLE_DOG_PLAY = 0x02B9A1 AutoReadOnly  ; Dogmeat_Playful_TalkYes1
Int Property IDLE_STOP = 0x029380 AutoReadOnly      ; LooseIdleStop: back to standing, before the hold is let go
Float Property ChatNear = 70.0 Auto Const
Float Property ChatFar = 400.0 Auto Const
{How far apart two may stand and still fall into a chat: one walks over (owner 10-06, option 2).}
Float Property ChatTalk = 110.0 Auto Const
{The distance they talk at: one walks up to this far from the other (vanilla's conversation distance).}
Float Property ChatWalkFrom = 150.0 Auto Const
{Further apart than this, the first walks up to the second before the chat.}
Float Property ChatBeat = 2.8 Auto Const
{Seconds between two gestures.}
Float Property ChatCooldown = 120.0 Auto Const
{Seconds between the end of one chat and the start of the next: a couple of minutes (owner 10-06).}

Actor _chA            ; the two in the chat now (None: no chat)
Actor _chB
Bool _chDog           ; _chB is a dog
Int _chStep
Int _chSteps
Float _chAX
Float _chAY
Float _chBX
Float _chBY
Float _chNext         ; real time the next chat may start
Float _chSince        ; real time this chat was picked
Bool _chBegun         ; the gestures have started (False: someone is still walking over)
Int _chId             ; this chat's number: a walk that ends late must not touch a newer chat (or none)
Float Property ChatWalkSeconds = 8.0 Auto Const
{How long the walk-over may take: then the chat starts where they are if near enough, else it is called off.}
Float Property ChatTalkMax = 260.0 Auto Const
{The furthest apart two may still chat once the walk is over.}
Actor[] _stillWho     ; where everyone stood at the last look: who stands still is free for a chat
Float[] _stillX
Float[] _stillY

; Free for a chat: here, standing still since the last look, on no furniture, in no scene or combat, no child,
; not the player's companion (they follow the player).
Bool Function FreeToChat(Actor akWho, Actor[] akWho0, Float[] afX0, Float[] afY0)
	If !akWho || !akWho.Is3DLoaded() || akWho.IsDead() || akWho.IsInCombat() || akWho.IsInScene() || akWho.GetDialogueTarget() || akWho.GetFurnitureReference() || akWho.IsPlayerTeammate()
		Return False
	EndIf
	If akWho.HasKeyword(Game.GetFormFromFile(KW_CHILD, "Fallout4.esm") as Keyword)
		Return False
	EndIf
	Int at = -1
	If akWho0
		at = akWho0.Find(akWho)
	EndIf
	If at < 0
		Return False
	EndIf
	Float dx = akWho.GetPositionX() - afX0[at]
	Float dy = akWho.GetPositionY() - afY0[at]
	Return dx * dx + dy * dy < 30.0 * 30.0
EndFunction

Function StartChat(Actor akPlayer, Bool abNow)
	If !abNow && Utility.GetCurrentRealTime() < _chNext
		RememberStill(akPlayer)
		Return
	EndIf
	Actor[] people = People(akPlayer)
	Actor[] w0 = _stillWho
	Float[] x0 = _stillX
	Float[] y0 = _stillY
	RememberStill(akPlayer)
	If abNow && !w0
		w0 = _stillWho     ; the test button: no earlier look -- take everyone where they stand now
		x0 = _stillX
		y0 = _stillY
	EndIf
	Actor best1 = None
	Actor best2 = None
	Float bestD = 999999.0
	Int i = 0
	While i < people.Length
		If FreeToChat(people[i], w0, x0, y0)
			Int j = i + 1
			While j < people.Length
				Float d = people[i].GetDistance(people[j])
				If d > ChatNear && d < ChatFar && d < bestD && FreeToChat(people[j], w0, x0, y0)
					bestD = d
					best1 = people[i]
					best2 = people[j]
				EndIf
				j += 1
			EndWhile
		EndIf
		i += 1
	EndWhile
	Bool dog = False
	; now and then a person and a dog standing about (the owner's "any creature")
	If (!best1 || Utility.RandomInt(0, 3) == 0)
		ObjectReference[] dogs = akPlayer.FindAllReferencesWithKeyword(Game.GetFormFromFile(KW_DOG, "Fallout4.esm"), Radius)
		Int k = 0
		While k < dogs.Length
			Actor d = dogs[k] as Actor
			If d && !d.IsDead() && !d.IsInCombat() && !d.IsHostileToActor(akPlayer) && !d.IsPlayerTeammate() && d.Is3DLoaded()
				Int m = 0
				While m < people.Length
					Float dd = people[m].GetDistance(d)
					If dd > ChatNear && dd < ChatFar && FreeToChat(people[m], w0, x0, y0)
						best1 = people[m]
						best2 = d
						dog = True
						m = people.Length
						k = dogs.Length
					EndIf
					m += 1
				EndWhile
			EndIf
			k += 1
		EndWhile
	EndIf
	If !best1
		If abNow
			Debug.Notification("Idle Life: nobody standing about near each other right now.")
		EndIf
		Return
	EndIf
	_chA = best1
	_chB = best2
	_chDog = dog
	_chStep = 0
	_chSteps = Utility.RandomInt(8, 14)
	_chSince = Utility.GetCurrentRealTime()
	_chBegun = False
	_chId += 1
	If !ChatQuest.IsRunning()
		ChatQuest.Start()
	EndIf
	; the second is held where it stands; the first comes over if they are too far apart to talk
	Chatters.AddRef(best2)
	best2.EvaluatePackage()
	Float apart = best1.GetDistance(best2)
	If apart > ChatWalkFrom
		Float k = ChatTalk / apart
		Float tx = best2.GetPositionX() + (best1.GetPositionX() - best2.GetPositionX()) * k
		Float ty = best2.GetPositionY() + (best1.GetPositionY() - best2.GetPositionY()) * k
		ObjectReference goal = best2.PlaceAtMe(Game.GetFormFromFile(0x00003B, "Fallout4.esm"), 1, False, True, True)   ; XMarker
		goal.SetPosition(tx, ty, best2.GetPositionZ())
		Debug.Trace("Idle Life: a chat - " + best1 + " (" + best1.GetBaseObject() + ") walks over to " + best2 + " (" + best2.GetBaseObject() + "), " + (apart as Int) + " apart", 0)
		Var[] args = new Var[2]
		args[0] = goal
		args[1] = _chId
		CallFunctionNoWait("WalkUp", args)       ; PathToReference is latent: never inside the scan's timer
	Else
		BeginChat(_chId)
	EndIf
EndFunction

; The first walks up to the second (its own stack: the walk takes seconds). There: the chat begins; lost on
; the way, or the chat called off meanwhile: everyone is let go.
Function WalkUp(ObjectReference akGoal, Int aiChat)
	Actor walker = _chA
	Float t0 = Utility.GetCurrentRealTime()
	Bool there = walker && walker.Is3DLoaded() && walker.PathToReference(akGoal, 0.0)
	String where = ""
	If walker && _chB
		where = "; walker " + (walker.GetDistance(akGoal) as Int) + " from the meeting point, " + (walker.GetDistance(_chB) as Int) + " from " + _chB + "; the meeting point " + (akGoal.GetDistance(_chB) as Int) + " from them"
	EndIf
	akGoal.Disable()
	akGoal.Delete()
	Debug.Trace("Idle Life: the walk-over " + aiChat + " ended after " + ((Utility.GetCurrentRealTime() - t0) as Int) + " s, arrived " + there + where, 0)
	If aiChat != _chId || _chBegun || !_chA
		Return      ; the chat already began (the walk ran long) or was called off
	EndIf
	; near enough to talk, whatever the walk said (DC test: "arrived" after 15 s, still 378 apart -- a patrolling
	; guard as the other one)
	If _chB && _chA.GetDistance(_chB) <= ChatTalkMax
		BeginChat(aiChat)
	Else
		Debug.Trace("Idle Life: a chat called off - " + walker + " did not get near", 0)
		EndChat()
	EndIf
EndFunction

; Both held, face to face, looking at each other; the gestures start.
Function BeginChat(Int aiChat)
	If aiChat != _chId || _chBegun
		Return
	EndIf
	If !_chA || !_chB || !_chA.Is3DLoaded() || !_chB.Is3DLoaded()
		EndChat()
		Return
	EndIf
	_chBegun = True     ; at once: the calls below can let another thread in
	Chatters.AddRef(_chA)
	_chA.EvaluatePackage()
	_chAX = _chA.GetPositionX()
	_chAY = _chA.GetPositionY()
	_chBX = _chB.GetPositionX()
	_chBY = _chB.GetPositionY()
	_chA.SetAngle(0.0, 0.0, _chA.GetAngleZ() + _chA.GetHeadingAngle(_chB))
	_chB.SetAngle(0.0, 0.0, _chB.GetAngleZ() + _chB.GetHeadingAngle(_chA))
	_chA.SetLookAt(_chB, False)
	_chB.SetLookAt(_chA, False)
	If aiChat != _chId || !_chA || !_chB
		Return      ; called off while turning them
	EndIf
	Debug.Trace("Idle Life: a chat starts - " + _chA + " (" + _chA.GetBaseObject() + ") and " + _chB + " (" + _chB.GetBaseObject() + "), " + (_chA.GetDistance(_chB) as Int) + " apart, " + _chSteps + " gestures", 0)
	StartTimer(0.6, CHAT_TIMER)
EndFunction

; Everyone held for a chat goes back to their own package (also after a save made mid-chat).
Function LetGo()
	Int i = Chatters.GetCount() - 1
	While i >= 0
		Actor a = Chatters.GetAt(i) as Actor
		Chatters.RemoveRef(Chatters.GetAt(i))
		If a
			a.EvaluatePackage()
		EndIf
		i -= 1
	EndWhile
EndFunction

Function RememberStill(Actor akPlayer)
	Actor[] people = People(akPlayer)
	Actor[] w = new Actor[0]
	Float[] x = new Float[0]
	Float[] y = new Float[0]
	Int i = 0
	While i < people.Length
		w.Add(people[i])
		x.Add(people[i].GetPositionX())
		y.Add(people[i].GetPositionY())
		i += 1
	EndWhile
	_stillWho = w
	_stillX = x
	_stillY = y
EndFunction

; One gesture: the two take turns. Over when either has walked off or got busy, or the gestures are spent.
Function ChatStep()
	If !_chA || !_chB
		Return
	EndIf
	Bool over = _chStep >= _chSteps || _chA.IsDead() || _chB.IsDead() || _chA.IsInCombat() || _chB.IsInCombat() || _chA.IsInScene() || _chB.IsInScene() || !_chA.Is3DLoaded() || !_chB.Is3DLoaded()
	If !over
		Float ax = _chA.GetPositionX() - _chAX
		Float ay = _chA.GetPositionY() - _chAY
		Float bx = _chB.GetPositionX() - _chBX
		Float by = _chB.GetPositionY() - _chBY
		over = ax * ax + ay * ay > 60.0 * 60.0 || bx * bx + by * by > 60.0 * 60.0
	EndIf
	If over
		EndChat()
		Return
	EndIf
	Actor speaker = _chA
	Bool dogTurn = False
	If _chStep % 2 == 1
		speaker = _chB
		dogTurn = _chDog
	EndIf
	Idle gesture = None
	Int r = Utility.RandomInt(0, 9)
	If dogTurn
		If r < 4
			gesture = Game.GetFormFromFile(IDLE_DOG_YES, "Fallout4.esm") as Idle
		ElseIf r < 7
			gesture = Game.GetFormFromFile(IDLE_DOG_PLAY, "Fallout4.esm") as Idle
		Else
			gesture = Game.GetFormFromFile(IDLE_DOG_NO, "Fallout4.esm") as Idle
		EndIf
	ElseIf r < 3
		gesture = Game.GetFormFromFile(IDLE_YES, "Fallout4.esm") as Idle
	ElseIf r < 4
		gesture = Game.GetFormFromFile(IDLE_NO, "Fallout4.esm") as Idle
	ElseIf r < 6
		; not the shrug: its event is dlg_question and it never played outside dialogue (3 of 3 failed, owner's DC
		; test 10-06, Cathy and John); a laugh in its place
		gesture = Game.GetFormFromFile(IDLE_LAUGH, "Fallout4.esm") as Idle
	ElseIf r < 7
		gesture = Game.GetFormFromFile(IDLE_POINT_F, "Fallout4.esm") as Idle
	ElseIf r < 8
		gesture = Game.GetFormFromFile(IDLE_POINT_L, "Fallout4.esm") as Idle
	ElseIf r < 9
		gesture = Game.GetFormFromFile(IDLE_POINT_R, "Fallout4.esm") as Idle
	Else
		gesture = Game.GetFormFromFile(IDLE_LAUGH, "Fallout4.esm") as Idle
	EndIf
	Bool played = speaker.PlayIdle(gesture)
	If DetailedLog.GetValueInt() == 1
		Debug.Trace("Idle Life: chat gesture " + _chStep + " - " + speaker + " " + gesture + (played as String), 0)
	EndIf
	_chStep += 1
	StartTimer(ChatBeat, CHAT_TIMER)
EndFunction

Function EndChat()
	Idle stop = Game.GetFormFromFile(IDLE_STOP, "Fallout4.esm") as Idle
	If _chA && _chA.Is3DLoaded()
		_chA.PlayIdle(stop)
		_chA.ClearLookAt()
	EndIf
	If _chB && _chB.Is3DLoaded()
		_chB.PlayIdle(stop)
		_chB.ClearLookAt()
	EndIf
	LetGo()
	Debug.Trace("Idle Life: the chat ends after " + _chStep + " gestures - " + _chA + " and " + _chB, 0)
	_chA = None
	_chB = None
	_chBegun = False
	_chId += 1
	_chNext = Utility.GetCurrentRealTime() + ChatCooldown
EndFunction

; ---- wave 2 ----------------------------------------------------------------------------------------------

; A town or a workshop settlement: where sweeping, painting and welding belong (wave 3).
Bool Function Settlement()
	Location here = Game.GetPlayer().GetCurrentLocation()
	Return here && (here.HasKeyword(Game.GetFormFromFile(LOC_TOWN, "Fallout4.esm") as Keyword) || here.HasKeyword(Game.GetFormFromFile(LOC_WORKSHOP, "Fallout4.esm") as Keyword))
EndFunction

Bool Function Raiders()
	Location here = Game.GetPlayer().GetCurrentLocation()
	Return here && here.HasKeyword(Game.GetFormFromFile(LOC_RAIDERS, "Fallout4.esm") as Keyword)
EndFunction

Int Function CountRobots(Actor akPlayer)
	ObjectReference[] refs = akPlayer.FindAllReferencesWithKeyword(Game.GetFormFromFile(KW_ROBOT, "Fallout4.esm"), Radius)
	Int n = 0
	Int i = 0
	While i < refs.Length
		Actor a = refs[i] as Actor
		If a && a.Is3DLoaded() && !a.IsDead() && !a.IsInCombat() && !a.IsHostileToActor(akPlayer)
			n += 1
		EndIf
		i += 1
	EndWhile
	Return n
EndFunction

; What a spot next to a person is, by the kind of place: raiders smoke, use Jet, play with knives and
; chug (Nuka-World); settlers work; townsfolk read, shop and check their Pip-Boys.
Form Function PersonSpot(Int aiSeed)
	Form[] pool = new Form[8]
	Location here = Game.GetPlayer().GetCurrentLocation()
	If here && here.HasKeyword(Game.GetFormFromFile(LOC_RAIDERS, "Fallout4.esm") as Keyword)
		pool[0] = Smoke
		pool[1] = UseJet
		pool[2] = GroundSit
		pool[3] = OrElse(Game.GetFormFromFile(DLC04_KNIFE_PLAY, "DLCNukaWorld.esm"), Smoke)
		pool[4] = OrElse(Game.GetFormFromFile(DLC04_BOTTLE, "DLCNukaWorld.esm"), SadSit)
		pool[5] = OrElse(Game.GetFormFromFile(DLC04_KNIFE_CLEAN, "DLCNukaWorld.esm"), KneelSit)
		pool[6] = Patrol
		pool[7] = PushUps
	ElseIf here && here.HasKeyword(Game.GetFormFromFile(LOC_WORKSHOP, "Fallout4.esm") as Keyword)
		pool[0] = Coffee
		pool[1] = Clipboard
		pool[2] = Search
		pool[3] = KneelSit
		pool[4] = GroundSit
		pool[5] = Smoke
		pool[6] = ClipboardPen
		pool[7] = BroomConst
	ElseIf here && here.HasKeyword(Game.GetFormFromFile(LOC_TOWN, "Fallout4.esm") as Keyword)
		pool[0] = Smoke
		pool[1] = Newspaper
		pool[2] = Coffee
		pool[3] = Examine
		pool[4] = PipBoy
		pool[5] = Shopping
		pool[6] = Broom
		pool[7] = GroundSit
	Else
		pool[0] = Smoke
		pool[1] = Newspaper
		pool[2] = GroundSit
		pool[3] = Coffee
		pool[4] = Examine
		pool[5] = SadSit
		pool[6] = Pray
		pool[7] = PushUps
	EndIf
	Return pool[(aiSeed / 3) % pool.Length]
EndFunction

Form Function OrElse(Form akForm, Form akFallback)
	If akForm
		Return akForm
	EndIf
	Return akFallback
EndFunction

; Ring and in-front kinds, no bounds needed.
Function DressRing(ObjectReference akRef, Int aiKind, Int aiSeed)
	Float x = akRef.GetPositionX()
	Float y = akRef.GetPositionY()
	Float z = akRef.GetPositionZ()
	Float start = (aiSeed % 360) as Float
	Int count = 0
	If aiKind == K_CAMP
		; Sitting round the campfire: vanilla's sitters are a median 131 out, 73% within 30 degrees of
		; facing it (research/anc2); now and then one kneels or sits slumped; among raiders, one with Jet.
		Int n = 2 + aiSeed % 3
		Int k = 0
		While k < n
			Float ca = start + (360.0 / n) * k + ((aiSeed / (k + 3)) % 41 - 20) as Float
			Float cr = 131.0 + ((aiSeed / (k + 5)) % 31 - 15) as Float
			Form ck = GroundSit
			Int roll = (aiSeed / (k + 7)) % 8
			If roll == 0
				ck = KneelSit
			ElseIf roll == 1
				ck = SadSit
			EndIf
			PlaceWorld(akRef, ck, x + cr * Math.Sin(ca), y + cr * Math.Cos(ca), z, ca + 180.0 + ((aiSeed / (k + 11)) % 31 - 15) as Float)
			k += 1
			count += 1
		EndWhile
		If Raiders()
			Float ja = start + 180.0 / n
			PlaceWorld(akRef, UseJet, x + 200.0 * Math.Sin(ja), y + 200.0 * Math.Cos(ja), z, ja + 180.0)
			count += 1
		EndIf
	ElseIf aiKind == K_POOL
		; Two standing at the table, either end, looking it over.
		Int pk = 0
		While pk < 2
			Float pa = start + 180.0 * pk
			Form pkind = Examine
			If (aiSeed / (pk + 3)) % 2 == 0
				pkind = Shopping
			EndIf
			PlaceWorld(akRef, pkind, x + 150.0 * Math.Sin(pa), y + 150.0 * Math.Cos(pa), z, pa + 180.0)
			pk += 1
			count += 1
		EndWhile
	ElseIf aiKind == K_TV
		; Watching from the floor in front (local +Y taken as the screen side).
		Int tn = 1 + aiSeed % 2
		Int tk = 0
		While tk < tn
			Form tkind = GroundSit
			If (aiSeed / (tk + 3)) % 3 == 0
				tkind = KneelSit
			EndIf
			PlaceLocal(akRef, tkind, (tk * 80 - 40 * (tn - 1)) as Float, 130.0, 180.0)
			tk += 1
			count += 1
		EndWhile
	ElseIf aiKind == K_GATE
		; Someone posing on guard beside it, facing out -- or (wave 3) on vanilla's guard post, watching the gate
		; from 157 off (its 4 spots by a gate all face it).
		If (aiSeed / 7) % 2 == 0
			PlaceWorld(akRef, GuardPost, x + 157.0 * Math.Sin(start), y + 157.0 * Math.Cos(start), z, start + 180.0)
		Else
			PlaceWorld(akRef, Military, x + 160.0 * Math.Sin(start), y + 160.0 * Math.Cos(start), z, start)
		EndIf
		count = 1
	ElseIf aiKind == K_CROP
		; A Mr Handy tending it (robots only), or (wave 3) someone hoeing or weeding it: vanilla's farmers
		; stand 64-79 off a crop facing it (research/wave3, n=33).
		If _robots > 0 && (aiSeed / 3) % 2 == 0
			PlaceWorld(akRef, HandyGarden, x + 90.0 * Math.Sin(start), y + 90.0 * Math.Cos(start), z, start + 180.0)
		Else
			Form farm = Hoe
			Float fr = 79.0
			If (aiSeed / 5) % 3 == 1
				farm = WeedA
				fr = 64.0
			ElseIf (aiSeed / 5) % 3 == 2
				farm = WeedB
				fr = 70.0
			EndIf
			PlaceWorld(akRef, farm, x + fr * Math.Sin(start), y + fr * Math.Cos(start), z, start + 180.0)
		EndIf
		count = 1
	ElseIf aiKind == K_CRATE
		; Rummaging through it (wave 3): vanilla's box search stands 18 off the box's EDGE, facing it; 50 from
		; the centre is that for a typical box (~30 half-size). The navmesh puts the spot on the floor when the
		; box sits on a shelf.
		PlaceWorld(akRef, BoxSearch, x + 50.0 * Math.Sin(start), y + 50.0 * Math.Cos(start), z, start + 180.0)
		count = 1
	ElseIf aiKind == K_HEDGE
		; A Mr Handy trimming it (robots only).
		PlaceWorld(akRef, HandyTrim, x + 140.0 * Math.Sin(start), y + 140.0 * Math.Cos(start), z, start + 180.0)
		count = 1
	EndIf
	AddAnchorRef(akRef, aiKind)
	Debug.Trace("Idle Life: " + KindName(aiKind) + " " + akRef + " (" + akRef.GetBaseObject() + ") gets " + count + " spots", 0)
EndFunction

; Dogs near, calm: a spot to sniff and scratch at a little way off (dogs only), at most two.
Function DogSpots(Actor akPlayer)
	If !KindIsOn(K_DOG)
		Return
	EndIf
	ObjectReference[] refs = akPlayer.FindAllReferencesWithKeyword(Game.GetFormFromFile(KW_DOG, "Fallout4.esm"), Radius)
	Int made = 0
	Int i = 0
	; At most 2 dog spots in all, not per draw (they piled up as a dog followed the player, 2026-10-01).
	While i < refs.Length && CountKind(K_DOG) < 2 && _spots.Length < MaxSpots - 4
		Actor d = refs[i] as Actor
		If d && d.Is3DLoaded() && !d.IsDead() && !d.IsInCombat() && !d.IsHostileToActor(akPlayer) && !NearKind(d, K_DOG, 400.0)
			Int seed = Seed(d) % 9973
			Float da = (seed % 360) as Float
			ObjectReference spot = d.PlaceAtMe(DogSniff, 1, False, True, True)
			If spot
				spot.SetPosition(d.GetPositionX() + 120.0 * Math.Sin(da), d.GetPositionY() + 120.0 * Math.Cos(da), d.GetPositionZ())
				spot.SetAngle(0.0, 0.0, da)
				spot.Enable(False)
				spot.MoveToNearestNavmeshLocation()
				If !Buried(spot)
					_spots.Add(spot)
					_spotFire.Add(spot)
					AddAnchorRef(spot, K_DOG)
					Placed(spot, d)
					made += 1
				EndIf
			EndIf
		EndIf
		i += 1
	EndWhile
	If made > 0
		Debug.Trace("Idle Life: " + made + " sniffing spots for dogs", 0)
	EndIf
EndFunction

; ---- settings ------------------------------------------------------------------------------------------

Bool Function KindIsOn(Int aiKind)
	Return aiKind < 0 || aiKind >= KindOn.Length || !KindOn[aiKind] || KindOn[aiKind].GetValueInt() != 0
EndFunction

; The in-game day, when the daily reshuffle is on; 0 when off (a place always looks the same).
Int Function Day()
	If DailyReshuffle.GetValueInt() == 1
		Return Utility.GetCurrentGameTime() as Int
	EndIf
	Return 0
EndFunction

; MCM Testing page: draw again now (after changing settings).
Function DebugRedraw()
	; Every spot goes first: kept, a full set left nothing to draw (owner's test 10-06: "0 new", 40 of 40), so a
	; save from before a new kind never got any of it.
	Prune(Game.GetPlayer(), True)
	_drawCell = None
	Debug.Notification("Idle Life: spots drawn again when you close the menu.")
EndFunction

; ---- phase 4: walls and open ground (IdleLife.dll) ----------------------------------------------------------

; Along real walls near the people: someone leaning back on it, now and then reading a paper; on flat
; open ground away from every edge: a sitting circle. Only with the plugin loaded.
Function WallAndOpen(Actor akPlayer, Actor[] akPeople)
	If !_native || akPeople.Length == 0
		Return
	EndIf
	ObjectReference[] near = new ObjectReference[0]
	Int i = 0
	While i < akPeople.Length && i < 20
		near.Add(akPeople[i])
		i += 1
	EndWhile
	Int made = 0
	Int room = KindCap() - CountKind(K_WALL)
	Int share = _budget / 4
	If room > share
		room = share
	EndIf
	If KindIsOn(K_WALL) && room > 0
		Float[] w = IdleLife:Navmesh.WallSpots(akPlayer, near, Radius, 250.0, room)
		i = 0
		While i + 3 < w.Length && _spots.Length < _budget
			If !NearPoint(w[i], w[i + 1], w[i + 2], 150.0)
				Int roll = Math.Floor(Math.Abs(w[i] + w[i + 1])) % 5
				Form kind = Lean
				Float face = w[i + 3]
				Float wx = w[i]
				Float wy = w[i + 1]
				If roll == 1
					kind = NewsLeanRight
				ElseIf roll == 2
					kind = NewsLeanLeft
				ElseIf roll >= 3 && Settlement()
					; Wave 3, in settlements: painting the wall or welding it, facing it, an arm's length off.
					kind = PaintWall
					If roll == 4
						kind = WeldHigh
					EndIf
					wx += 30.0 * Math.Sin(face)
					wy += 30.0 * Math.Cos(face)
					face += 180.0
				EndIf
				PlaceSelf(akPlayer, kind, wx, wy, w[i + 2], face, K_WALL)
				made += 1
			EndIf
			i += 4
		EndWhile
	EndIf
	If KindIsOn(K_OPEN) && CountKind(K_OPEN) < 5 && _spots.Length < _budget - 2
		Float[] o = IdleLife:Navmesh.OpenSpots(akPlayer, near, Radius, 250.0, 2)
		Int at = 0
		If CountKind(K_OPEN) < 3 && o.Length >= 4 && !NearPoint(o[0], o[1], o[2], 300.0)
			at = 4
			Int seed = Math.Floor(Math.Abs(o[0] * 3.0 + o[1])) as Int
			Float start = (seed % 360) as Float
			Int k = 0
			While k < 3
				Float a = start + 120.0 * k
				Form sit = GroundSit
				If (seed / (k + 3)) % 4 == 0
					sit = KneelSit
				EndIf
				PlaceSelf(akPlayer, sit, o[0] + 90.0 * Math.Sin(a), o[1] + 90.0 * Math.Cos(a), o[2], a + 180.0, K_OPEN)
				k += 1
				made += 1
			EndWhile
		EndIf
		; Wave 3: someone alone on open ground -- sweeping in towns and settlements, push-ups, a prayer, a
		; raider on the lookout.
		If at == 0 && o.Length >= 8 && NearPoint(o[0], o[1], o[2], 300.0)
			at = 4
		EndIf
		If at + 3 < o.Length && CountKind(K_OPEN) < 5 && _spots.Length < _budget && !NearPoint(o[at], o[at + 1], o[at + 2], 300.0)
			Int oseed = Math.Floor(Math.Abs(o[at] * 7.0 + o[at + 1])) as Int
			Form solo = Pray
			If Raiders()
				solo = Patrol
				If oseed % 3 == 0
					solo = PushUps
				EndIf
			ElseIf Settlement()
				solo = BroomConst
				If oseed % 4 == 0
					solo = PushUps
				ElseIf oseed % 4 == 1
					solo = Broom
				EndIf
			ElseIf oseed % 3 == 0
				solo = PushUps
			ElseIf oseed % 3 == 1
				solo = Patrol
			EndIf
			PlaceSelf(akPlayer, solo, o[at], o[at + 1], o[at + 2], (oseed % 360) as Float, K_OPEN)
			made += 1
		EndIf
	EndIf
	If made > 0
		Debug.Trace("Idle Life: " + made + " spots by walls and in the open (navmesh)", 0)
	EndIf
EndFunction

; A spot at a point, its own place (kept while the player is near it).
Function PlaceSelf(ObjectReference akNear, Form akKind, Float afX, Float afY, Float afZ, Float afFacing, Int aiKind)
	ObjectReference spot = akNear.PlaceAtMe(akKind, 1, False, True, True)
	If spot
		spot.SetPosition(afX, afY, afZ)
		spot.SetAngle(0.0, 0.0, afFacing)
		spot.Enable(False)
		_spots.Add(spot)
		_spotFire.Add(spot)
		AddAnchorRef(spot, aiKind)
		Placed(spot, None)
	EndIf
EndFunction

; Any place already dressed within afDistance of this point (a redraw must not double the wall spots).
Bool Function NearPoint(Float afX, Float afY, Float afZ, Float afDistance)
	Int i = 0
	While i < _anchors.Length
		ObjectReference a = _anchors[i]
		If a
			Float dx = a.GetPositionX() - afX
			Float dy = a.GetPositionY() - afY
			Float dz = a.GetPositionZ() - afZ
			If dx * dx + dy * dy + dz * dz < afDistance * afDistance
				Return True
			EndIf
		EndIf
		i += 1
	EndWhile
	Return False
EndFunction

; ---- what the installer cannot see (nexus-tools FOMOD-STANDARD rule 3), said once per save ----------------

Bool _toldF4SE = False
Bool _toldNavmesh = False
Bool _toldMCM = False

Function CheckSetup()
	_native = False
	If F4SE.GetVersionRelease() <= 0
		Debug.Trace("Idle Life: F4SE is not running - spots by walls and in the open are off", 0)
		If !_toldF4SE
			_toldF4SE = True
			Debug.MessageBox("Idle Life needs F4SE (f4se.silverlock.org) for its spots along walls and in the open. Every other kind of spot works.")
		EndIf
		Return
	EndIf
	If F4SE.GetPluginVersion("IdleLife") > 0
		_native = IdleLife:Navmesh.Ready()
		_solid = _native && IdleLife:Navmesh.Version() >= 300
		If !_native
			Debug.Trace("Idle Life: the navmesh plugin is loaded but cannot read the navmesh (Runtime Database?) - walls and the open are off", 0)
			If !_toldNavmesh
				_toldNavmesh = True
				Debug.MessageBox("Idle Life cannot read the navmesh on this game version: Runtime Database (Nexus 108394) is missing or does not know it. Spots along walls and in the open are off; every other kind works.")
			EndIf
		EndIf
	Else
		Debug.Trace("Idle Life: the navmesh plugin (IdleLife.dll) is not loaded - walls and the open are off", 0)
	EndIf
	If F4SE.GetPluginVersion("F4MCM") <= 0 && !_toldMCM
		_toldMCM = True
		Debug.Trace("Idle Life: MCM is not installed - the settings keep their defaults", 0)
		Debug.MessageBox("Idle Life: Mod Configuration Menu (MCM, Nexus 21497) is not installed, so its settings keep their defaults. Everything works.")
	EndIf
	Debug.Trace("Idle Life: navmesh plugin " + _native, 0)
EndFunction
