Scriptname aotc_actor_script_anomaly_behavior Extends Actor

Explosion Property AttackExplosion Auto Const
Explosion Property Reaction Auto Const
Sound Property PreAttackSound Auto Const
ImpactDataSet Property BlackPitImpactSet Auto Const
Keyword Property ActorNpcsKeyword Auto Const

int PollingTimerId = 386125 Const
float PollingIntervalSec = 1.0 Const
int GravityActionTimerId = 386126 Const
float GravityDistancePct = 1.0 Const
int KillActionTimerId = 386127 Const
float KillDistancePct = 0.4 Const
float KillTimerSec = 0.1 Const
float GravityTimerSec = 0.2 Const
float BehaviorDistance = 350.0 Const
float RockingSpeed = 300.0 Const

Actor ClosestNpc = None

Function CleanUpSoft()
    Debug.Trace("[aotc][behavior] cleanup soft happened")
    CancelTimer(KillActionTimerId)
    CancelTimer(GravityActionTimerId)
    If ClosestNpc != None
        ClosestNpc.StopTranslation()
        ClosestNpc = None
    EndIf
EndFunction

Function CleanUpCell()
    Debug.Trace("[aotc][behavior] cleanup cell happened")
    UnRegisterForDistanceEvents(ClosestNpc, self)
    CleanUpSoft()
EndFunction

Event OnLoad()
    ;Debug.Trace("[aotc][behavior] onload happened")
    PlaceImpact()
    
    ; Start polling for NPCs
    StartTimer(0.0, PollingTimerId)
EndEvent

Event OnUnload()
    ;Debug.Trace("[aotc][behavior] onunload happened")
	CleanUpCell()
EndEvent

Event OnTimer(int timerId)
    ;Debug.Trace("[aotc][behavior] ontimer happened")
    If timerId == PollingTimerId
        DoPolling()
        StartTimer(PollingIntervalSec, PollingTimerId)
        Return
    EndIf

    If ClosestNpc == None
        Return
    EndIf
    float distance = self.GetDistance(ClosestNpc)
    Debug.Trace("[aotc][behavior] Npc is present at distance " + distance)
    float killDistance = KillDistancePct * BehaviorDistance
    If timerId == KillActionTimerId
        If distance < killDistance
            Debug.Trace("[aotc][behavior] Npc is too close, do kill " + ClosestNpc)
            DoKillBehavior()
        Else
            StartTimer(KillTimerSec, KillActionTimerId)
        EndIf
    ElseIf timerId == GravityActionTimerId
        float gravityDistance = GravityDistancePct * BehaviorDistance
        bool inGravityPullRange = distance > killDistance && distance < gravityDistance
        If inGravityPullRange
            Debug.Trace("[aotc][behavior] Npc is close, do gravity " + ClosestNpc)
            DoGravityBehavior()
        EndIf
        StartTimer(GravityTimerSec, GravityActionTimerId)
    EndIf
EndEvent

Function DoPolling()
    Actor npcRef = FindClosestActor(self, BehaviorDistance)
    If npcRef == None
        If ClosestNpc == None
            Debug.Trace("[aotc][behavior] Npc is far, cancel Gravity/Kill timer")
        Else
            Debug.Trace("[aotc][behavior] Npc is far, cancel Gravity/Kill timer, previous distance: " + self.GetDistance(ClosestNpc))
        EndIf
        CleanUpSoft()
        Return
    EndIf
    Debug.Trace("[aotc][behavior] Found npc: " + npcRef)
    bool differentFromLastPoll = ClosestNpc != npcRef
    If differentFromLastPoll
        Debug.Trace("[aotc][behavior] New npc is close, start Gravity/Kill timer")
        ClosestNpc = npcRef
        StartTimer(0.0, KillActionTimerId)
        StartTimer(0.0, GravityActionTimerId)
    EndIf
EndFunction

Actor Function FindClosestActor(Actor center, float radius)
    ObjectReference[] refs = center.FindAllReferencesWithKeyword(ActorNpcsKeyword, radius)
    Debug.Trace("[aotc][behavior] Found objrefs: " + refs.Length)
    Actor closestRef = None
    float closestDistance = 999999.0
    int i = 0
    While i < refs.Length
        ObjectReference ref = refs[i]
        If ref is Actor && ref != center
            float dist = ref.GetDistance(center)
            If dist < closestDistance
                closestRef = ref as Actor
                closestDistance = dist
            EndIf
        EndIf
        i += 1
    EndWhile    
    Return closestRef
EndFunction

Function DoKillBehavior()
    Debug.Trace("[aotc][behavior] Kill explosion")
    PreAttackSound.Play(self)

    If ClosestNpc == Game.GetPlayer()
        InputEnableLayer myLayer = InputEnableLayer.Create()
        myLayer.DisablePlayerControls()
        Game.StartDialogueCameraOrCenterOnTarget(ClosestNpc)
    EndIf

    ; Spiral actor into the anomaly
    int i = 0
    float rockingMagnitude = 90
    float tangentMagnitude = 100
    while (i < 3)
        CustomSplineTo(rockingMagnitude, 0, tangentMagnitude, i * 90)
        Utility.Wait(0.2)
        CustomSplineTo(-rockingMagnitude, 0, -tangentMagnitude, i * 90 + 45)
        Utility.Wait(0.2)
        rockingMagnitude = rockingMagnitude / 1.2
        i += 1
    endwhile
    
    ; Move to the center
    CustomSplineTo(0, 0, tangentMagnitude, 0)
    Utility.Wait(0.2)
    If ClosestNpc == None
        Return
    EndIf
    ClosestNpc.StopTranslation()

    ; Start explosion, disintegrate player, kill him
    self.PlaceAtMe(AttackExplosion)
    self.PlaceAtMe(Reaction)
    If ClosestNpc == None
        Return
    EndIf
    ClosestNpc.Dismember("Torso", true, true, true)
    ClosestNpc.Kill(self)
    ClosestNpc.SetAlpha(0.0, true)
    Utility.wait(0.4)
    If ClosestNpc == None
        Return
    EndIf
    ClosestNpc.SetPosition(0, 0, -10000)

EndFunction

Function CustomSplineTo(float offsetX, float offsetY, float magnitude, float rotZ)
    If ClosestNpc == None
        Return
    EndIf
    float selfCenterOffset = 20.0
    float destinationX = self.GetPositionX()
    float destinationY = self.GetPositionY()
    float destinationZ = self.GetPositionZ() + selfCenterOffset
    float rotationalSpeed = 100.0
    ClosestNpc.SplineTranslateTo(destinationX + offsetX, destinationY + offsetY, destinationZ, 0, 0, rotZ, magnitude, RockingSpeed, rotationalSpeed)
EndFunction

; just toss the player a little closer to the anomaly
Function DoGravityBehavior(bool doGravity = true)
    ClosestNpc.TranslateToRef(self, 50)
    Utility.Wait(0.4)
    ClosestNpc.StopTranslation()
EndFunction

; Technically it will be a black crater but it's called an 'Impact'
Function PlaceImpact()
    float pickLength = 512
    PlayImpactEffect(BlackPitImpactSet, "", 0, 0, -1, pickLength, false, false)
EndFunction
