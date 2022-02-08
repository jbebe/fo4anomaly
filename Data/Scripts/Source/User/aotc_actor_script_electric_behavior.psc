Scriptname aotc_actor_script_electric_behavior extends Actor

Function _debug(string dbgMessage)
    ;Debug.Trace(dbgMessage)
EndFunction

Static property XMarker Auto Const
SPELL Property TrapElectricArcSpell Auto Const
Keyword Property ActorNpcsKeyword Auto Const

String FireTrapAnim = "Trip" Const
float TargetDistance = 500.0 Const
int PollingTimerId = 386131 Const
int AttackTimerId = 386132 Const
float PollingIntervalSec = 1.0 Const

Actor ClosestNpc = None

Event OnLoad()
    _debug("[aotc][electric-behavior] OnLoad called")
    If !self.Is3DLoaded()
        Return
    EndIf
    
    ; Start polling for NPCs
    StartTimer(0.0, PollingTimerId)
EndEvent

Event OnTimer(int timerId)
    _debug("[aotc][electric-behavior] OnTimer called")
    If !self.Is3DLoaded()
        Return
    EndIf
    
    If timerId == PollingTimerId
        DoPolling()
        StartTimer(PollingIntervalSec, PollingTimerId)
    ElseIf timerId == AttackTimerId
        ; Call once, don't loop
        LocalFireTrap()
    EndIf
EndEvent

Function DoPolling()
    Actor npcRef = FindRandomActor(self, TargetDistance)
    If npcRef == None && ClosestNpc != None
        ;_debug("[aotc][electric] " + npcRef + " is too far, set to None")
        ClosestNpc = None
    ElseIf npcRef != None && ClosestNpc == None
        ;_debug("[aotc][electric] " + npcRef + " is close, start firing!")
        ClosestNpc = npcRef
        ; Start attack on a different thread
        StartTimer(0.0, AttackTimerId)
    Else
        ; Don't do anything if ClosestNpc is already under fire
    EndIf
EndFunction

Actor Function FindRandomActor(Actor center, float radius)
    ObjectReference[] refs = center.FindAllReferencesWithKeyword(ActorNpcsKeyword, radius)
    _debug("[aotc][electric-behavior] FindRandomActor length" + refs.Length)
    int i = 0
    While i < refs.Length
        ObjectReference ref = refs[i]
        If ref is Actor && ref != center && !(ref as Actor).IsEssential()
            Return ref as Actor
        EndIf
        i += 1
    EndWhile    
    Return None
EndFunction

;Put the local stuff in here
Function LocalFireTrap()
	ObjectReference akTarget = ClosestNpc as ObjectReference
    ObjectReference objSelf = self as ObjectReference
	ObjectReference myXmarker = objSelf.placeAtMe(XMarker)
	;PlayAnimation(FireTrapAnim)
	float currentTargetDistance = (TargetDistance * objSelf.GetScale())
	While ClosestNpc != None && is3dLoaded()
        _debug("[aotc][electric-behavior] LocalFireTrap loop")
		;akTarget.moveToNode( game.FindRandomActorFromRef(objSelf, TargetDistance), "Torso")
		; akTarget = game.FindRandomActorFromRef(akTargetRange, currentTargetDistance)
		;if we have a target and this is not a dummy fire, half the time fire at the dummy
		if akTarget && Utility.randomint(1, 100) <= 50 
			TrapElectricArcSpell.Cast(objSelf, akTarget)
		else
            float afXOffset = Utility.randomfloat(-200.0, 200.0)
            float afYOffset = Utility.randomfloat(-200.0, 200.0)
            float afZOffset = Utility.randomfloat(-200.0, 200.0)
			myXmarker.moveto(objSelf, afXOffset, afYOffset, afZOffset)
			TrapElectricArcSpell.Cast(objSelf, myXmarker)
		endif
		Utility.wait(Utility.randomfloat(0.05, 0.2))
	endWhile
    _debug("[aotc][electric-behavior] ClosestNpc is None, exit")
	akTarget = None
	myXmarker.delete()
EndFunction
