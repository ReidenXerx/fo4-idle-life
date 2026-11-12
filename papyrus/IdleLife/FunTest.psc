Scriptname IdleLife:FunTest Hidden
{FFS2 premise test (11-12): send an actor to sit on a Funtime For Settlers 2 marker with Idle Life's own package.
Console: cgf "IdleLife:FunTest.Send" <actor id> <marker id>   (decimal ids)
         cgf "IdleLife:FunTest.Release" <actor id>
Logs to the Papyrus log ("IdleLife FunTest:").}

RefCollectionAlias Function Sitters() Global
	Quest q = Game.GetFormFromFile(0x00082E, "IdleLife.esp") as Quest   ; IL_FunSitters (tools/formids.json FunQuest)
	If !q
		Debug.Trace("IdleLife FunTest: no IL_FunSitters quest", 0)
		Return None
	EndIf
	Return q.GetAlias(0) as RefCollectionAlias
EndFunction

Keyword Function LinkKeyword() Global
	Return Game.GetFormFromFile(0x05D5E6, "Fallout4.esm") as Keyword   ; LinkCustom01
EndFunction

Function Send(Int aiActor, Int aiMarker) Global
	Actor who = Game.GetForm(aiActor) as Actor
	ObjectReference marker = Game.GetForm(aiMarker) as ObjectReference
	RefCollectionAlias sitters = Sitters()
	If !who || !marker || !sitters
		Debug.Trace("IdleLife FunTest: Send needs an actor, a marker and the collection (" + who + ", " + marker + ", " + sitters + ")", 0)
		Return
	EndIf
	who.SetLinkedRef(marker, LinkKeyword())
	sitters.AddRef(who)
	who.EvaluatePackage()
	Debug.Trace("IdleLife FunTest: " + who + " sent to " + marker + ", package " + who.GetCurrentPackage(), 0)
	Debug.Notification("FunTest: sent")
EndFunction

; Round 4: hold the actor where they stand (the collection's HoldPosition) and play an FFS2 idle on them directly.
; aiIdle: the IDLE's id inside Funtime2.esm (decimal), e.g. 2703 = 0xA8F dcy_salsa, 2704 = 0xA90 dcy_salsaclap.
Function Play(Int aiActor, Int aiIdle) Global
	Actor who = Game.GetForm(aiActor) as Actor
	Idle dance = Game.GetFormFromFile(aiIdle, "Funtime2.esm") as Idle
	RefCollectionAlias sitters = Sitters()
	If !who || !dance || !sitters
		Debug.Trace("IdleLife FunTest: Play needs an actor, a Funtime2 idle and the collection (" + who + ", " + dance + ", " + sitters + ")", 0)
		Return
	EndIf
	sitters.AddRef(who)
	who.EvaluatePackage()
	Utility.Wait(0.5)
	Bool played = who.PlayIdle(dance)
	Debug.Trace("IdleLife FunTest: " + who + " plays " + dance + " -> " + played + ", package " + who.GetCurrentPackage(), 0)
	Debug.Notification("FunTest: play " + played)
EndFunction

Function Release(Int aiActor) Global
	Actor who = Game.GetForm(aiActor) as Actor
	RefCollectionAlias sitters = Sitters()
	If !who || !sitters
		Return
	EndIf
	who.PlayIdle(Game.GetFormFromFile(0x029380, "Fallout4.esm") as Idle)   ; LooseIdleStop
	sitters.RemoveRef(who)
	who.SetLinkedRef(None, LinkKeyword())
	who.EvaluatePackage()
	Debug.Trace("IdleLife FunTest: " + who + " released, sit state " + who.GetSitState(), 0)
EndFunction
