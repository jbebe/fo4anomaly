Scriptname aotc_actor_script_electric_movement extends Actor

Function _debug(string dbgMessage)
    Debug.Trace(dbgMessage)
EndFunction

bool Function IsAnimatable()
    Return self.Is3DLoaded() && self.GetParentCell() != None
EndFunction

Struct Vec3
    float pX
    float pY
    float pZ
EndStruct

Light Property StrobeLight Auto Const

float Deviance = 20.0 Const
int TimerId = 386133 Const

Vec3 OriginalPosition = None
ObjectReference StrobeLightRef = None

Event OnLoad()
    _debug("[aotc][electric-movement] OnLoad called")
    If !IsAnimatable()
        Return
    EndIf
    
    OriginalPosition = new Vec3
    OriginalPosition.pX = self.GetPositionX()
    OriginalPosition.pY = self.GetPositionY()
    OriginalPosition.pZ = self.GetPositionZ()

    StrobeLightRef = self.PlaceAtMe(StrobeLight)
    ;StrobeLightRef.SetPosition(OriginalPosition.pX, OriginalPosition.pY, OriginalPosition.pZ)
    ;StrobeLightRef.AttachTo(self)
    StartTimer(0.0, TimerId)
EndEvent

Event OnUnload()
    _debug("[aotc][electric-movement] OnUnload called")
    StrobeLightRef.Delete()
	self.StopTranslation()
EndEvent

Event OnTimer(int _)
    _debug("[aotc][electric-movement] OnTimer called")
    If !IsAnimatable()
        Return
    EndIf
    
    self.StopTranslation()
    self.SetPosition(OriginalPosition.pX, OriginalPosition.pY, OriginalPosition.pZ)
    float newX = OriginalPosition.pX + Utility.randomfloat(-Deviance, Deviance)
    float newY = OriginalPosition.pY + Utility.randomfloat(-Deviance, Deviance)
    float newZ = OriginalPosition.pZ + Utility.randomfloat(-Deviance, Deviance)
    self.TranslateTo(newX, newY, newZ, 0, 0, 0, 200)

    StartTimer(0.1, TimerId)
EndEvent
