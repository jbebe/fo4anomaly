Scriptname aotc_actor_script_anomaly_behavior Extends Actor Const

ImageSpaceModifier Property PlayerImod Auto Const
Explosion Property AttackExplosion Auto Const
Explosion Property Reaction Auto Const
Sound Property PreAttackSound Auto Const

int GravityActionTimerId = 386126 Const
int KillActionTimerId = 386127 Const
float KillDistancePct = 0.4 Const
float GravityDistancePct = 1.0 Const
float IdleTimerSec = 0.5 Const
float KillTimerSec = 0.1 Const
float GravityTimerSec = 0.2 Const
float GlobalTriggerDistance = 1300.0 Const
float BehaviorDistance = 350.0 Const
float RockingSpeed = 200.0 Const

Function CleanUpSoft()
    ;Debug.Trace("[aotc][behavior] cleanup soft happened")
    CancelTimer(KillActionTimerId)
    CancelTimer(GravityActionTimerId)
    PlayerImod.Remove()
EndFunction

Function CleanUpCell()
    ;Debug.Trace("[aotc][behavior] cleanup cell happened")
    UnRegisterForDistanceEvents(Game.GetPlayer(), self)
    CleanUpSoft()
EndFunction

Event OnLoad()
    ;Debug.Trace("[aotc][behavior] onload happened")
    RegisterForDistanceLessThanEvent(Game.GetPlayer(), self, GlobalTriggerDistance)
    RegisterForDistanceGreaterThanEvent(Game.GetPlayer(), self, GlobalTriggerDistance)
EndEvent

Event OnUnload()
    ;Debug.Trace("[aotc][behavior] onunload happened")
	CleanUpCell()
EndEvent

Event OnDistanceLessThan(ObjectReference _player, ObjectReference _self, float afDistance)
    ;Debug.MessageBox("[aotc][behavior] distance less (" + afDistance + "/" + GlobalTriggerDistance + "): start timer")
    RegisterForDistanceGreaterThanEvent(_player, _self, GlobalTriggerDistance)
    StartTimer(0.0, KillActionTimerId)
    StartTimer(0.0, GravityActionTimerId)
EndEvent

Event OnDistanceGreaterThan(ObjectReference _player, ObjectReference _self, float afDistance)
    ;Debug.MessageBox("[aotc][behavior] distance greater (" + afDistance + "/" + GlobalTriggerDistance + "): cancel timer")
    RegisterForDistanceLessThanEvent(_player, _self, GlobalTriggerDistance)
    CleanUpSoft()
EndEvent

Event OnTimer(int timerId)
    ;Debug.Trace("[aotc][behavior] ontimer happened")
    Actor player = Game.GetPlayer()
    float distance = player.GetDistance(self)
    If distance > BehaviorDistance
        PlayerImod.Remove()
        StartTimer(IdleTimerSec, timerId)
        Return
    Endif

    If timerId == KillActionTimerId
        float effectStrength = GetAnomalyStrength(distance)
        PlayerImod.PopTo(PlayerImod, effectStrength)

        If distance < (KillDistancePct * BehaviorDistance)
            DoKillBehavior(player)
        Else
            StartTimer(KillTimerSec, KillActionTimerId)
        Endif
    ElseIf timerId == GravityActionTimerId
        If distance > (KillDistancePct * BehaviorDistance) && distance < (GravityDistancePct * BehaviorDistance)
            ; just toss the player a little closer to the anomaly
            DoGravityBehavior(player)
        EndIf
        StartTimer(GravityTimerSec, GravityActionTimerId)
    EndIf
EndEvent

float Function GetAnomalyStrength(float distance)
    float normalizedDistance = distance / BehaviorDistance
    float effectStrength = 1.0 - normalizedDistance
    return effectStrength
EndFunction

Function DoKillBehavior(Actor player)
    ; Debug.Trace("[aotc] Kill explosion")
    PreAttackSound.Play(self)
    InputEnableLayer myLayer = InputEnableLayer.Create()
    myLayer.DisablePlayerControls()

    ; Spiral player into the anomaly
    int i = 0
    float rockingMagnitude = 90
    float tangentMagnitude = 100
    while (i < 3)
        CustomSplineTo(rockingMagnitude, 0, tangentMagnitude, i * 90)
        Utility.Wait(0.3)
        CustomSplineTo(-rockingMagnitude, 0, -tangentMagnitude, i * 90 + 45)
        Utility.Wait(0.3)
        rockingMagnitude = rockingMagnitude / 1.2
        i += 1
    endwhile
    
    ; Move to the center
    CustomSplineTo(0, 0, tangentMagnitude, 0)
    Utility.Wait(0.3)
    player.StopTranslation()

    ; Start explosion, disintegrate player, kill him
    self.PlaceAtMe(AttackExplosion)
    self.PlaceAtMe(Reaction)
    player.Dismember("Torso", true, true, true)
    Utility.wait(0.2)
    player.Kill(self)
    player.SetAlpha(0.0, true)
EndFunction

Function CustomSplineTo(float offsetX, float offsetY, float magnitude, float rotZ)
    Actor player = Game.GetPlayer()
    float selfCenterOffset = 60.0
    float destinationX = self.GetPositionX()
    float destinationY = self.GetPositionY()
    float destinationZ = self.GetPositionZ() + selfCenterOffset
    float rotationalSpeed = 100.0
    player.SplineTranslateTo(destinationX + offsetX, destinationY + offsetY, destinationZ, 0, 0, rotZ, magnitude, RockingSpeed, rotationalSpeed)
EndFunction

Function DoGravityBehavior(Actor player)
    player.TranslateToRef(self, 60)
    Utility.Wait(0.3)
    player.StopTranslation()
EndFunction
