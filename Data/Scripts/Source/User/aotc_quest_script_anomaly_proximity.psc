Scriptname aotc_quest_script_anomaly_proximity extends Quest

Function _debug(string dbgMessage)
    Debug.Trace(dbgMessage)
EndFunction

Actor Property PlayerRef Auto Const
Sound Property BeepSlowest Auto Const
Sound Property BeepSlow Auto Const
Sound Property BeepMedium Auto Const
Sound Property BeepFast Auto Const
ImageSpaceModifier Property GravityAnomalyImod Auto Const
ImageSpaceModifier Property GravityAnomalyWeakImod Auto Const
ImageSpaceModifier Property ZeroEffect Auto Const
FormList Property AnomalyTypes Auto Const

int PollingTimerId = 386130 Const
float PollingIntervalSec = 1.0 Const
int BeepTimerId = 386129 Const
float TriggerDistance = 1400.0 Const
float PauseSlowestBeep = 1.7 Const
float DistanceSlowBeep = 800.0 Const
float PauseSlowBeep = 1.2 Const
float DistanceMediumBeep = 600.0 Const
float PauseMediumBeep = 0.882 Const
float DistanceFastBeep = 350.0 Const
float PauseFastBeep = 0.232 Const

ObjectReference ClosestAnomaly = None

Event OnQuestInit()
    StartTimer(0.0, PollingTimerId)
EndEvent

Event OnTimer(int timerId)
    ;_debug("[aotc][proximity] OnTimer happened")
    If timerId == PollingTimerId
        DoPolling()
    ElseIf timerId == BeepTimerId
        DoBeep()
    EndIf
EndEvent

; Poll for the closest anomaly in range {TriggerDistance} every {PollingIntervalSec} seconds
; If we found an anomaly, save it to a local variable so that {DoBeep} can access it to save computation
Function DoPolling()
    ; TODO:
    ; Since {PollingIntervalSec} is very slow, we need to find the closest anomaly 
    ; before {TriggerDistance} could be reached. That's why we use {PreTriggerDistance} which is bigger
    ObjectReference anomalyRef = Game.FindClosestReferenceOfAnyTypeInListFromRef(AnomalyTypes, PlayerRef, TriggerDistance)
    bool differentFromLastPoll = ClosestAnomaly != anomalyRef
    If differentFromLastPoll
        bool isAnomalyClose = anomalyRef != None
        If isAnomalyClose
            ;_debug("[aotc][proximity] Anomaly is close, start BeepTimer")
            ClosestAnomaly = anomalyRef
            StartTimer(0.0, BeepTimerId)
            ; GravityAnomalyWeakImod.ApplyCrossFade(1.0)
        Else
            ;_debug("[aotc][proximity] Anomaly is far, cancel BeepTimer")
            ZeroEffect.ApplyCrossFade(1.0)
            ClosestAnomaly = None
            CancelTimer(BeepTimerId)
        EndIf
    EndIf
    StartTimer(PollingIntervalSec, PollingTimerId)
EndFunction

Function DoBeep()
    If ClosestAnomaly == None
        Return
    EndIf
    float distance = PlayerRef.GetDistance(ClosestAnomaly)
    If distance > TriggerDistance || PlayerRef.IsDead()
        _debug("[aotc][proximity] Distance was too big, beep exited voluntarly")
        Return
    EndIf

    If distance > DistanceMediumBeep
        GravityAnomalyWeakImod.ApplyCrossFade(1.0)
    Else
        GravityAnomalyImod.ApplyCrossFade(0.5)
    EndIf

    If distance > DistanceSlowBeep
        BeepSlowest.Play(PlayerRef)
        StartTimer(PauseSlowestBeep, BeepTimerId)
    ElseIf distance > DistanceMediumBeep
        BeepSlow.Play(PlayerRef)
        StartTimer(PauseSlowBeep, BeepTimerId)
    ElseIf distance > DistanceFastBeep
        BeepMedium.Play(PlayerRef)
        StartTimer(PauseMediumBeep, BeepTimerId)
    Else
        BeepFast.Play(PlayerRef)
        StartTimer(PauseFastBeep, BeepTimerId)
    EndIf
EndFunction
