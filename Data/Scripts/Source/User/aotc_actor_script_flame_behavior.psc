Scriptname aotc_actor_script_flame_behavior extends Actor

Function _debug(string dbgMessage)
    Debug.Trace(dbgMessage)
EndFunction

MovableStatic Property ConstantSparks Auto Const
Light Property FlameLight Auto Const
STATIC Property FlameProjectile Auto Const
Keyword Property ActorNpcsKeyword Auto Const
Sound Property FireStart Auto Const
Sound Property FireLoop Auto Const
Hazard Property FireHazard Auto Const
ImpactDataSet Property BlackPitImpactSet Auto Const
MovableStatic Property Smokes Auto Const

float TargetRange = 300.0 Const
float PollingIntervalSec = 1.0 Const
int PollingTimerId = 386134 Const
int StartAttackTimerId = 386135 Const
int StopAttackTimerId = 386136 Const

ObjectReference ConstantSparksRef = None
ObjectReference FlameLightRef = None
ObjectReference Projectile1 = None
ObjectReference Projectile2 = None
ObjectReference Projectile3 = None
ObjectReference FireHazardRef = None
ObjectReference SmokesRef = None
ObjectReference[] ClosestActorRefs = None
int FireLoopRef = -1

Event OnLoad()
    If !self.Is3DLoaded()
        Return
    EndIf
    ConstantSparksRef = self.PlaceAtMe(ConstantSparks)
    FlameLightRef = self.PlaceAtMe(FlameLight)
    SmokesRef = self.PlaceAtMe(Smokes)
    PlaceImpact()
    ClosestActorRefs = new ObjectReference[0]
    
    StartTimer(0.0, PollingTimerId)
EndEvent

Event OnUnload()
	ConstantSparksRef.Delete()
	FlameLightRef.Delete()
    SmokesRef.Delete()
    StopFlames()
EndEvent

Event OnTimer(int timerId)
    If timerId == PollingTimerId
        DoPolling()
        StartTimer(PollingIntervalSec, PollingTimerId)
    ElseIf timerId == StartAttackTimerId
        ; Call once, don't loop
        StartFlames()
    ElseIf timerId == StopAttackTimerId
        ; Call once, don't loop
        StopFlames()
    EndIf
EndEvent

Function DoPolling()
    ObjectReference[] refs = self.FindAllReferencesWithKeyword(ActorNpcsKeyword, TargetRange)
    ObjectReference[] actorRefs = new ObjectReference[0]
    int i = 0
    While i < refs.Length
        ObjectReference ref = refs[i]
        If ref != self && ref is Actor
            actorRefs.Add(ref)
        EndIf
        i += 1
    EndWhile

    bool hadActors = ClosestActorRefs.Length > 0
    bool hasActors = actorRefs.Length > 0
    If !hadActors && hasActors
        _debug("[aotc][flame] Didnt have actors, but now we have, start fire!")
        StartTimer(0.0, StartAttackTimerId)
    ElseIf hadActors && !hasActors
        _debug("[aotc][flame] Had actors, but now we dont, stop fire!")
        StartTimer(0.0, StopAttackTimerId)
    EndIf
    ClosestActorRefs = actorRefs
EndFunction

Function StartFlames()
    PlaceProjectiles()
    FireStart.Play(self)
    FireLoopRef = FireLoop.Play(self)
    FireHazardRef = self.PlaceAtMe(FireHazard)
EndFunction

Function StopFlames()
    DeleteProjectiles()
    Sound.StopInstance(FireLoopRef)
    FireHazardRef.Delete()
EndFunction

Function PlaceProjectiles()
    float selfX = self.GetPositionX()
    float selfY = self.GetPositionY()
    float selfZ = self.GetPositionZ()

    Projectile1 = self.PlaceAtMe(FlameProjectile)
    Projectile2 = self.PlaceAtMe(FlameProjectile)
    Projectile3 = self.PlaceAtMe(FlameProjectile)

    float projectileRange = 0.2 * TargetRange
    float actorZOffset = -35.0
    Projectile1.SetPosition(selfX + 0, selfY + projectileRange, selfZ + actorZOffset)
    Projectile1.SetAngle(-90.0, 0, 0)
    Projectile2.SetPosition(selfX - (projectileRange * 0.86), selfY - (0.5 * projectileRange), selfZ + actorZOffset)
    Projectile2.SetAngle(-90.0, 0, 0)
    Projectile3.SetPosition(selfX + (projectileRange * 0.86), selfY - (0.5 * projectileRange), selfZ + actorZOffset)
    Projectile3.SetAngle(-90.0, 0, 0)
EndFunction

Function DeleteProjectiles()
    Projectile1.Delete()
    Projectile2.Delete()
    Projectile3.Delete()
EndFunction

Function PlaceImpact()
    float pickLength = 512
    PlayImpactEffect(BlackPitImpactSet, "", 0, 0, -1, pickLength, false, false)
EndFunction
