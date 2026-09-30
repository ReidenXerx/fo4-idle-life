Scriptname IdleLife:Spawner extends Quest
{Idle Life, phase 2: fires. Around every lit fire near the player it places a small ring of vanilla spots
-- warm your hands standing or kneeling, have a smoke -- facing the fire, so anyone sandboxing nearby can
walk over and use them. The spots exist only around the player: placed when a fire comes in range,
deleted when the player leaves. The same fire always gets the same ring (seeded from the fire itself).
Every 30 s the log says how many spots are taken: that is premise 0 (docs/DESIGN.md), measured.}

FormList Property FireAnchors Auto Const Mandatory
{Lit fire barrels and the workshop cooking fire (Fallout4.esm); DLC braziers and barrels join at run time.}
FormList Property FireLights Auto Const Mandatory
{Fire lights: most fires in the game are a plain barrel or a burn pile lit by one of these.}
Float Property LightDrop = 68.0 Auto Const
{How far below a fire flame the floor is: vanilla's hand-warming spots, median (research/calib).}
Float Property SameFire = 150.0 Auto Const
{A flame this close to a fire that already has spots is that fire's flame, not another fire.}
Form Property WarmStanding Auto Const Mandatory
Form Property WarmKneeling Auto Const Mandatory
Form Property Smoke Auto Const Mandatory
GlobalVariable Property Enabled Auto Const Mandatory
{IL_On: 0 takes every spot away again.}

Float Property ScanSeconds = 5.0 Auto Const
Float Property Radius = 3000.0 Auto Const
{About 43 m around the player.}
Float Property Ring = 70.0 Auto Const
{Units from the fire's centre to a hand-warming spot. Vanilla's 74: median 69, facing the fire (research).}
Float Property SmokeRing = 170.0 Auto Const
{A smoker stands a little off, facing anywhere (vanilla smoke markers have no fire convention).}
Int Property MaxAnchors = 20 Auto Const
{Fires dressed at once; at most 4 spots each, so 80 spots, inside Papyrus' 128-element arrays.}

Int Property SCAN_TIMER = 1 AutoReadOnly
Int Property REPORT_EVERY = 6 AutoReadOnly     ; scans between two "spots in use" lines
Int Property SPAWNER_QUEST = 0x000800 AutoReadOnly
; DLC fires, by form id: DLCRobot braziers, the Vault-Tec and Contraptions fire barrels.
Int Property DLC01_BRAZIER01 = 0x00A5DD AutoReadOnly
Int Property DLC01_BRAZIER02 = 0x00A5DE AutoReadOnly
Int Property DLC01_BRAZIER03 = 0x00A5DF AutoReadOnly
Int Property DLC05_FIRE_BARREL = 0x000918 AutoReadOnly   ; DLCworkshop01 workshopMetalFireBarrel (buildable)
Int Property DLC06_FIRE_BARREL = 0x0052E7 AutoReadOnly   ; DLCworkshop03 DLC06ScrapableMetalBarrel01Fire02_Static

ObjectReference[] _anchors     ; fires that have their ring
ObjectReference[] _spots       ; every spot placed
ObjectReference[] _spotFire    ; the fire each spot belongs to (same index as _spots)
Int _scans = 0
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
	AddAnchor(DLC01_BRAZIER01, "DLCRobot.esm")
	AddAnchor(DLC01_BRAZIER02, "DLCRobot.esm")
	AddAnchor(DLC01_BRAZIER03, "DLCRobot.esm")
	AddAnchor(DLC05_FIRE_BARREL, "DLCworkshop01.esm")
	AddAnchor(DLC06_FIRE_BARREL, "DLCworkshop03.esm")
	Debug.Trace("Idle Life: fires - " + FireAnchors.GetSize() + " kinds of fire, " + _anchors.Length + " dressed, " + _spots.Length + " spots", 0)
	StartTimer(ScanSeconds, SCAN_TIMER)
EndFunction

Function AddAnchor(Int aiFormID, String asPlugin)
	If Game.IsPluginInstalled(asPlugin)
		Form f = Game.GetFormFromFile(aiFormID, asPlugin)
		If f && !FireAnchors.HasForm(f)
			FireAnchors.AddForm(f)
		EndIf
	EndIf
EndFunction

Event OnTimer(Int aiTimerID)
	If !OnOwnRecord() || aiTimerID != SCAN_TIMER
		Return
	EndIf
	Actor player = Game.GetPlayer()
	Prune(player, Enabled.GetValueInt() == 0)
	If Enabled.GetValueInt() == 1 && !player.IsInCombat()
		ObjectReference[] fires = player.FindAllReferencesOfType(FireAnchors, Radius)
		ObjectReference[] lights = player.FindAllReferencesOfType(FireLights, Radius)
		; Not Is3DLoaded: a fire baked into precombined meshes reads unloaded while it is right there (AN76
		; Toilets' world toilets, 2026-09-29). Its cell being attached is what "near and real" means here.
		Int dressed = 0
		Int i = 0
		While i < fires.Length && _anchors.Length < MaxAnchors
			ObjectReference fire = fires[i]
			If fire && !fire.IsDisabled() && _anchors.Find(fire) < 0 && fire.GetParentCell() && fire.GetParentCell().IsAttached()
				Dress(fire)
				dressed += 1
			EndIf
			i += 1
		EndWhile
		i = 0
		While i < lights.Length && _anchors.Length < MaxAnchors
			ObjectReference flame = lights[i]
			If flame && !flame.IsDisabled() && _anchors.Find(flame) < 0 && flame.GetParentCell() && flame.GetParentCell().IsAttached() && !NearDressed(flame)
				Dress(flame)
				dressed += 1
			EndIf
			i += 1
		EndWhile
		Int seen = fires.Length + lights.Length
		If seen != _lastSeen
			_lastSeen = seen
			Debug.Trace("Idle Life: " + fires.Length + " fire models and " + lights.Length + " fire lights within " + (Radius as Int) + " units (" + dressed + " newly dressed, " + _anchors.Length + " dressed) in " + player.GetParentCell(), 0)
		EndIf
	EndIf
	_scans += 1
	If _scans % REPORT_EVERY == 0 && _spots.Length > 0
		Report()
	EndIf
	StartTimer(ScanSeconds, SCAN_TIMER)
EndEvent

; ---- the ring --------------------------------------------------------------------------------

; 1 to 3 hand-warming spots around the fire (vanilla: 1-3, never 5), unevenly spaced as vanilla's are,
; each facing it; mostly standing, now and then one kneeling; and sometimes a smoker a little off. All of it from the fire's own form id, so
; the same fire gets the same ring every time the player comes back.
Function Dress(ObjectReference akFire)
	Int seed = akFire.GetFormID()
	If seed < 0
		seed = -seed
	EndIf
	Int count = 1 + seed % 3
	Float start = (seed % 360) as Float
	Float step = 360.0 / count
	Int k = 0
	While k < count
		Float angle = start + step * k + ((seed / (k + 3)) % 51 - 25) as Float   ; +-25 degrees off even
		Form kind = WarmStanding
		If (seed / (k + 7)) % 5 == 0
			kind = WarmKneeling
		EndIf
		Place(akFire, kind, angle, Ring, angle + 180.0)   ; +Y turned by the angle, then back at the fire
		k += 1
	EndWhile
	If (seed / 11) % 3 == 0
		Float away = start + step / 2.0
		Place(akFire, Smoke, away, SmokeRing, (seed % 360) as Float)
		count += 1
	EndIf
	_anchors.Add(akFire)
	Debug.Trace("Idle Life: " + akFire + " (" + akFire.GetBaseObject() + ") gets " + count + " spots", 0)
EndFunction

; Already a dressed fire within SameFire: this flame is its flame.
Bool Function NearDressed(ObjectReference akLight)
	Int i = 0
	While i < _anchors.Length
		If _anchors[i] && _anchors[i].GetDistance(akLight) < SameFire
			Return True
		EndIf
		i += 1
	EndWhile
	Return False
EndFunction

Function Place(ObjectReference akFire, Form akKind, Float afAngle, Float afDistance, Float afFacing)
	ObjectReference spot = akFire.PlaceAtMe(akKind, 1, False, True, True)
	If spot
		Float z = akFire.GetPositionZ()
		If FireLights.HasForm(akFire.GetBaseObject())
			z -= LightDrop
		EndIf
		spot.SetPosition(akFire.GetPositionX() + afDistance * Math.Sin(afAngle), akFire.GetPositionY() + afDistance * Math.Cos(afAngle), z)
		spot.SetAngle(0.0, 0.0, afFacing)
		spot.Enable(False)
		_spots.Add(spot)
		_spotFire.Add(akFire)
	EndIf
EndFunction

; Spots whose fire is gone, disabled, or far behind the player (or in another cell where either is an
; interior: a distance across walls means nothing) are deleted; abAll takes every one.
Function Prune(Actor akPlayer, Bool abAll)
	Cell here = akPlayer.GetParentCell()
	Int i = _spots.Length - 1
	While i >= 0
		ObjectReference spot = _spots[i]
		ObjectReference fire = _spotFire[i]
		Bool keep = !abAll && spot && fire && !fire.IsDisabled() && fire.GetDistance(akPlayer) <= Radius * 1.5
		If keep
			Cell there = fire.GetParentCell()
			If there != here && (!here || !there || here.IsInterior() || there.IsInterior())
				keep = False
			EndIf
		EndIf
		If !keep
			If spot
				spot.Disable(False)
				spot.Delete()
			EndIf
			_spots.Remove(i, 1)
			_spotFire.Remove(i, 1)
			Int a = _anchors.Find(fire)
			If a >= 0
				_anchors.Remove(a, 1)
			EndIf
		EndIf
		i -= 1
	EndWhile
EndFunction

; How many of our spots someone is using right now (furniture spots only: the engine does not say who
; stands at an idle marker).
Function Report()
	Int warming = 0
	Int used = 0
	Int i = 0
	While i < _spots.Length
		ObjectReference spot = _spots[i]
		If spot && spot.GetBaseObject() != Smoke
			warming += 1
			If spot.IsFurnitureInUse(False)
				used += 1
			EndIf
		EndIf
		i += 1
	EndWhile
	Debug.Trace("Idle Life: " + _anchors.Length + " fires dressed, " + _spots.Length + " spots, " + used + " of " + warming + " hand-warming spots in use", 0)
	If used > 0 && !_toldInUse
		_toldInUse = True
		Debug.Notification("Idle Life: someone is warming their hands at one of the new spots.")
	EndIf
EndFunction
