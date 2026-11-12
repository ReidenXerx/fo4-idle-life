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

Function Release(Int aiActor) Global
	Actor who = Game.GetForm(aiActor) as Actor
	RefCollectionAlias sitters = Sitters()
	If !who || !sitters
		Return
	EndIf
	sitters.RemoveRef(who)
	who.SetLinkedRef(None, LinkKeyword())
	who.EvaluatePackage()
	Debug.Trace("IdleLife FunTest: " + who + " released, sit state " + who.GetSitState(), 0)
EndFunction
