Scriptname aotc_actor_script_anomaly Extends Actor Const

; Inputs
ImageSpaceModifier Property PlayerImod Auto Const
Explosion Property AttackExplosion Auto Const
Explosion Property Reaction Auto Const
Sound Property PreAttackSound Auto Const

; Vars
float TimerIntervalSec = 0.1 Const
int ActionTimerId = 386127 Const
float TriggerDistance = 200.0 Const

Event OnLoad()
    Debug.Trace("[aotc] Anomaly loaded")
    RegisterForDistanceLessThanEvent(Game.GetPlayer(), self, TriggerDistance)
    RegisterForDistanceGreaterThanEvent(Game.GetPlayer(), self, TriggerDistance)
    ; TODO: always face towards player, create new script so we dont clutter this file
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

    If effectStrength > 0.4
        ; if player jumps over the anomaly, let him go with damage
        ; but if player was walking, kill him
        If true ; Needs condition for player is airborne
            Debug.Trace("[aotc] Kill explosion")
            PreAttackSound.Play(self)
            InputEnableLayer myLayer = InputEnableLayer.Create()
            myLayer.DisablePlayerControls()

            int i = 0
            float rockingMagnitude = 50
            float tangentMagnitude = 100
            while (i < 3)
                CustomSplineTo(rockingMagnitude, 0, tangentMagnitude)
                Utility.Wait(0.3)
                CustomSplineTo(-rockingMagnitude, 0, -tangentMagnitude)
                Utility.Wait(0.3)
                rockingMagnitude = rockingMagnitude / 2
                i += 1
            endwhile
            
            CustomSplineTo(0, 0, tangentMagnitude)
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

Function CustomSplineTo(float offsetX, float offsetY, float magnitude)
    Actor player = Game.GetPlayer()
    float destinationX = self.GetPositionX()
    float destinationY = self.GetPositionY()
    float destinationZ = self.GetPositionZ() + 60
    float forceSpeed = 300.0
    float rotationalSpeed = 30.0

    ; player.MoveTo(self, 0, 0, 100)
    ; player.TranslateTo(destinationX, destinationY, destinationZ, 0, 90, 0, gravitySpeed, rotationalSpeed)
    player.SplineTranslateTo(destinationX + offsetX, destinationY + offsetY, destinationZ, 0, 90, 0, magnitude, forceSpeed, rotationalSpeed)
EndFunction
