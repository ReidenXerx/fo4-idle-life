Scriptname IdleLife:Navmesh Native Hidden
{Idle Life's F4SE plugin (F4SE\Plugins\IdleLife.dll): walls and open ground read from the navmesh. Each
returns packed floats, x, y, z, heading per spot. Call only when F4SE.GetPluginVersion("IdleLife") > 0.}

; Spots right beside walls, facing away from them (for wall leans): nearest the given people first, at
; least afSpacing apart, at most aiMax.
Float[] Function WallSpots(ObjectReference akCentre, ObjectReference[] akNear, Float afRadius, Float afSpacing, Int aiMax) Global Native

; Flat open ground at least afClearance from any edge of the walkable area (the middle of a sitting
; circle): nearest the given people first, at most aiMax.
Float[] Function OpenSpots(ObjectReference akCentre, ObjectReference[] akNear, Float afRadius, Float afClearance, Int aiMax) Global Native

Int Function Version() Global Native
