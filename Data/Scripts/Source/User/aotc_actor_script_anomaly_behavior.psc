Scriptname aotc_actor_script_anomaly_behavior Extends Actor

Function _debug(string dbgMessage)
    ;Debug.Trace(dbgMessage)
EndFunction

Function TryDelete(ObjectReference refObj)
    If refObj != None
        refObj.Delete()
    EndIf
EndFunction

Explosion Property AttackExplosion Auto Const
Explosion Property Reaction Auto Const
Sound Property PreAttackSound Auto Const
ImpactDataSet Property BlackPitImpactSet Auto Const
Keyword Property ActorNpcsKeyword Auto Const
Light Property EffectLight Auto Const

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
ObjectReference LightRef = None
bool KillActionTimerRunning = False
bool GravityActionTimerRunning = False
bool PollingTimerRunning = False

Function CleanUpSoft()
    _debug("[aotc][gravity] CleanUpSoft called")
    If KillActionTimerRunning
        KillActionTimerRunning = false
        CancelTimer(KillActionTimerId)
    EndIf
    If GravityActionTimerRunning
        GravityActionTimerRunning = false
        CancelTimer(GravityActionTimerId)
    EndIf
    If ClosestNpc != None
        ClosestNpc.StopTranslation()
        ClosestNpc = None
    EndIf
EndFunction

Function CleanUpCell()
    _debug("[aotc][gravity] CleanUpCell called")
    If ClosestNpc != None && self != None
        UnRegisterForDistanceEvents(ClosestNpc, self)
    EndIf
    TryDelete(LightRef)
    CleanUpSoft()
EndFunction

Event OnLoad()
    _debug("[aotc][gravity] OnLoad called")
    If !self.Is3DLoaded()
        Return
    EndIf
    
    PlaceImpact()
    LightRef = self.PlaceAtMe(EffectLight)
    LightRef.SetPosition(self.GetPositionX(), self.GetPositionY(), self.GetPositionZ())
    
    ; Start polling for NPCs
    PollingTimerRunning = true
    StartTimer(0.0, PollingTimerId)
EndEvent

Event OnUnload()
    _debug("[aotc][gravity] OnUnload called")
	CleanUpCell()
EndEvent

Event OnTimer(int timerId)
    _debug("[aotc][gravity] OnTimer called")
    If !self.Is3DLoaded()
        Return
    EndIf
    
    If timerId == PollingTimerId
        DoPolling()
        StartTimer(PollingIntervalSec, PollingTimerId)
        Return
    EndIf

    If ClosestNpc == None
        Return
    EndIf
    float distance = self.GetDistance(ClosestNpc)
    float killDistance = KillDistancePct * BehaviorDistance
    If timerId == KillActionTimerId
        If distance < killDistance
            ;_debug("[aotc][behavior] Npc is too close, do kill " + ClosestNpc)
            DoKillBehavior()
        Else
            KillActionTimerRunning = true
            StartTimer(KillTimerSec, KillActionTimerId)
        EndIf
    ElseIf timerId == GravityActionTimerId
        float gravityDistance = GravityDistancePct * BehaviorDistance
        bool inGravityPullRange = distance > killDistance && distance < gravityDistance
        If inGravityPullRange
            ;_debug("[aotc][behavior] Npc is close, do gravity " + ClosestNpc)
            DoGravityBehavior()
        EndIf
        GravityActionTimerRunning = true
        StartTimer(GravityTimerSec, GravityActionTimerId)
    EndIf
EndEvent

Function DoPolling()
    Actor npcRef = FindClosestActor(self, BehaviorDistance)
    If npcRef == None
        CleanUpSoft()
        Return
    EndIf
    bool differentFromLastPoll = ClosestNpc != npcRef
    If differentFromLastPoll
        ClosestNpc = npcRef
        StartTimer(0.0, KillActionTimerId)
        StartTimer(0.0, GravityActionTimerId)
    EndIf
EndFunction

Actor Function FindClosestActor(Actor center, float radius)
    ObjectReference[] refs = center.FindAllReferencesWithKeyword(ActorNpcsKeyword, radius)
    _debug("[aotc][gravity] FindClosestActor length: " + refs.Length)
    Actor closestRef = None
    float closestDistance = 999999.0
    int i = 0
    While i < refs.Length
        ObjectReference ref = refs[i]
        If ref is Actor && ref != center && !(ref as Actor).IsEssential()
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
    ;_debug("[aotc][behavior] Kill explosion")
    PreAttackSound.Play(self)
    ; Looks nicer but gibs are not in place when explosion happens
    ;ClosestNpc.PushActorAway(ClosestNpc, 0.0)

    If ClosestNpc == Game.GetPlayer()
        InputEnableLayer myLayer = InputEnableLayer.Create()
        myLayer.DisablePlayerControls()
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
        ;ClosestNpc.PushActorAway(ClosestNpc, 0.0)
        i += 1
    endwhile
    
    ; Move to the center
    CustomSplineTo(0, 0, tangentMagnitude, 0)
    Utility.Wait(0.2)
    If ClosestNpc == None
        Return
    EndIf
    ;ClosestNpc.PushActorAway(ClosestNpc, 0.0)
    ClosestNpc.StopTranslation()

    ; Start explosion, disintegrate player, kill him
    self.PlaceAtMe(AttackExplosion)
    self.PlaceAtMe(Reaction)
    ClosestNpc.Dismember("Torso", true, true, true)
    ClosestNpc.Kill(self)
EndFunction

Function CustomSplineTo(float offsetX, float offsetY, float magnitude, float rotZ)
    If ClosestNpc == None
        Return
    EndIf
    float selfCenterOffset = 100.0
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
