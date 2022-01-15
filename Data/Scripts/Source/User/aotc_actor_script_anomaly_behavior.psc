Scriptname aotc_actor_script_anomaly_behavior Extends Actor Const

Explosion Property AttackExplosion Auto Const
Explosion Property Reaction Auto Const
Sound Property PreAttackSound Auto Const
ImpactDataSet Property BlackPitImpactSet Auto Const
Actor Property PlayerRef Auto Const

int GravityActionTimerId = 386126 Const
int KillActionTimerId = 386127 Const
float KillDistancePct = 0.4 Const
float GravityDistancePct = 1.0 Const
float IdleTimerSec = 0.5 Const
float KillTimerSec = 0.1 Const
float GravityTimerSec = 0.2 Const
float BehaviorDistance = 350.0 Const
float RockingSpeed = 200.0 Const

Function CleanUpSoft()
    ;Debug.Trace("[aotc][behavior] cleanup soft happened")
    CancelTimer(KillActionTimerId)
    CancelTimer(GravityActionTimerId)
EndFunction

Function CleanUpCell()
    ;Debug.Trace("[aotc][behavior] cleanup cell happened")
    UnRegisterForDistanceEvents(PlayerRef, self)
    CleanUpSoft()
EndFunction

Event OnLoad()
    ;Debug.Trace("[aotc][behavior] onload happened")
    PlaceImpact()
    RegisterForDistanceLessThanEvent(PlayerRef, self, BehaviorDistance)
    RegisterForDistanceGreaterThanEvent(PlayerRef, self, BehaviorDistance)

    ; Actor player = PlayerRef
    ; float playerX = player.GetPositionX()
    ; float playerY = player.GetPositionY()
    ; float playerZ = player.GetPositionZ()
    ; MovableStatic barrier = Game.GetForm(0x000F676A) as MovableStatic
    ; ObjectReference ref = Game.FindClosestReferenceOfType(barrier, playerX, playerY, playerZ, 30000)
    ; Debug.Trace("[aotc][behavior] closest barrier: " + ref.GetPositionX() + ", " + ref.GetPositionY())
    
    ; MovableStatic barrier = Game.GetForm(0x000F676A) as MovableStatic
    ; ObjectReference[] refs = PlayerRef.FindAllReferencesOfType(barrier, 3000.0)
    ; Debug.Trace("[aotc][behavior] ref length: " + refs.Length)
    ; int i = 0
    ; While i < refs.Length
    ;     ObjectReference barrierObj = refs[i]
    ;     barrierObj.MoveTo(barrierObj, 0, 0, 200)
    ;     Debug.Trace("[aotc][behavior] barrier moved up")
    ;     i += 1
    ; EndWhile
EndEvent

Event OnUnload()
    ;Debug.Trace("[aotc][behavior] onunload happened")
	CleanUpCell()
EndEvent

Event OnDistanceLessThan(ObjectReference _player, ObjectReference _self, float afDistance)
    ;Debug.MessageBox("[aotc][behavior] distance less (" + afDistance + "/" + BehaviorDistance + "): start timer")
    RegisterForDistanceGreaterThanEvent(_player, _self, BehaviorDistance)
    StartTimer(0.0, KillActionTimerId)
    StartTimer(0.0, GravityActionTimerId)
EndEvent

Event OnDistanceGreaterThan(ObjectReference _player, ObjectReference _self, float afDistance)
    ;Debug.MessageBox("[aotc][behavior] distance greater (" + afDistance + "/" + BehaviorDistance + "): cancel timer")
    RegisterForDistanceLessThanEvent(_player, _self, BehaviorDistance)
    CleanUpSoft()
EndEvent

Event OnTimer(int timerId)
    ;Debug.Trace("[aotc][behavior] ontimer happened")
    float distance = PlayerRef.GetDistance(self)

    float killDistance = KillDistancePct * BehaviorDistance
    If timerId == KillActionTimerId
        If distance < killDistance
            DoKillBehavior(PlayerRef)
        Else
            StartTimer(KillTimerSec, KillActionTimerId)
        EndIf
    ElseIf timerId == GravityActionTimerId
        float gravityDistance = GravityDistancePct * BehaviorDistance
        bool inGravityPullRange = distance > killDistance && distance < gravityDistance
        If inGravityPullRange
            DoGravityBehavior(PlayerRef)
        EndIf
        StartTimer(GravityTimerSec, GravityActionTimerId)
    EndIf
EndEvent

Function DoKillBehavior(Actor PlayerRef)
    ; Debug.Trace("[aotc] Kill explosion")
    PreAttackSound.Play(self)
    InputEnableLayer myLayer = InputEnableLayer.Create()
    myLayer.DisablePlayerControls()
    Game.StartDialogueCameraOrCenterOnTarget(PlayerRef)

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
    PlayerRef.StopTranslation()

    ; Start explosion, disintegrate player, kill him
    self.PlaceAtMe(AttackExplosion)
    self.PlaceAtMe(Reaction)
    PlayerRef.Dismember("Torso", true, true, true)
    Utility.wait(0.2)
    PlayerRef.Kill(self)
    PlayerRef.SetAlpha(0.0, true)
EndFunction

Function CustomSplineTo(float offsetX, float offsetY, float magnitude, float rotZ)
    float selfCenterOffset = 60.0
    float destinationX = self.GetPositionX()
    float destinationY = self.GetPositionY()
    float destinationZ = self.GetPositionZ() + selfCenterOffset
    float rotationalSpeed = 100.0
    PlayerRef.SplineTranslateTo(destinationX + offsetX, destinationY + offsetY, destinationZ, 0, 0, rotZ, magnitude, RockingSpeed, rotationalSpeed)
EndFunction

; just toss the player a little closer to the anomaly
Function DoGravityBehavior(Actor player, bool doGravity = true)
    player.TranslateToRef(self, 60)
    Utility.Wait(0.4)
    player.StopTranslation()
EndFunction

; Technically it will be a black crater but it's called an 'Impact'
Function PlaceImpact()
    float pickLength = 512
    PlayImpactEffect(BlackPitImpactSet, "", 0, 0, -1, pickLength, false, false)
EndFunction
