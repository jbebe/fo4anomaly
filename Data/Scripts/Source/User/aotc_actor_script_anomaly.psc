Scriptname aotc_actor_script_anomaly Extends Actor Const

; Inputs
ImageSpaceModifier Property PlayerImod Auto Const
Explosion Property AttackExplosion Auto Const
Explosion Property Reaction Auto Const
Sound Property AttackSound Auto Const

; Vars
float TimerIntervalSec = 0.1 Const
int ActionTimerId = 386127 Const
float TriggerDistance = 200.0 Const

Event OnLoad()
    Debug.Trace("[aotc] Anomaly loaded")
    RegisterForDistanceLessThanEvent(Game.GetPlayer(), self, TriggerDistance)
    RegisterForDistanceGreaterThanEvent(Game.GetPlayer(), self, TriggerDistance)
    ; TODO: always face towards player, by updating its position every second
EndEvent

Event OnUnload()
	UnRegisterForDistanceEvents(Game.GetPlayer(), self)
    CancelTimer(ActionTimerId)
    Debug.Trace("[aotc] Anomaly unloaded")
EndEvent

Event OnTimer(int timerId)
    Actor player = Game.GetPlayer()
	float distance = player.GetDistance(self)
    float normalizedDistance = distance / triggerDistance
    float effectStrength = 1.0 - normalizedDistance
    PlayerImod.PopTo(PlayerImod, effectStrength)
    Debug.Trace("[aotc] Distance: " + distance + ", effect strength: " + effectStrength)

    If effectStrength > 0.5
        ; if player jumps over the anomaly, let him go with damage
        ; but if player was walking, kill him
        If true ; Needs condition for player is airborne
            Debug.Trace("[aotc] Kill explosion")
            InputEnableLayer myLayer = InputEnableLayer.Create()
            myLayer.DisablePlayerControls()
            Utility.Wait(0.2)

            float destinationX = self.GetPositionX()
            float destinationY = self.GetPositionY()
            float destinationZ = self.GetPositionZ() + 60
            float gravitySpeed = 60.0
            float rotationalSpeed = 10.0
            player.TranslateTo(destinationX, destinationY, destinationZ, 0, 0, 0, gravitySpeed, rotationalSpeed)

            ;player.MoveTo(self, 0, 0, 100)
            Utility.Wait(0.5)
            self.PlaceAtMe(AttackExplosion)
            self.PlaceAtMe(Reaction)
            player.Kill(self)
            
            Return
        Endif

        ; TDB
        Debug.Trace("[aotc] Soft explosion")
        self.PlaceAtMe(Reaction)
        Utility.Wait(1.0)
    Endif

    StartTimer(TimerIntervalSec, ActionTimerId)
endEvent

Event OnDistanceLessThan(ObjectReference _player, ObjectReference _self, float afDistance)
    StartTimer(TimerIntervalSec, ActionTimerId)
EndEvent

Event OnDistanceGreaterThan(ObjectReference _player, ObjectReference _self, float afDistance)
    CancelTimer(ActionTimerId)
    PlayerImod.Remove()
    Debug.Trace("[aotc] Distance over " + TriggerDistance)
EndEvent
