Scriptname aotc_actor_script_anomaly extends Actor Const

; Inputs
ImageSpaceModifier Property PlayerImod Auto Const

; Vars
int ActionTimerId = 1 Const
float triggerDistance = 150.0 Const

Event OnLoad()
    RegisterForDistanceLessThanEvent(Game.GetPlayer(), self, triggerDistance)
    RegisterForDistanceGreaterThanEvent(Game.GetPlayer(), self, triggerDistance)
EndEvent

Event OnUnload()
	UnRegisterForDistanceEvents(Game.GetPlayer(), self)
EndEvent

Event OnTimer(int timerId)
	float distance = Game.GetPlayer().GetDistance(self)
    float effectStrength = 1.0 - (distance/triggerDistance)
    Debug.Trace("effect strength: " + effectStrength)
endEvent

Event OnDistanceLessThan(ObjectReference _player, ObjectReference _anomaly, float afDistance)
    float intervalSec = 1.0
    StartTimer(intervalSec, ActionTimerId)
endEvent

Event OnDistanceGreaterThan(ObjectReference _player, ObjectReference _anomaly, float afDistance)
    CancelTimer(ActionTimerId)
    Debug.Trace("Distance too big, cancel action")
endEvent
