Scriptname aotc_actor_script_anomaly_proximity extends Actor Const

Sound Property BeepSlowest Auto Const
Sound Property BeepSlow Auto Const
Sound Property BeepMedium Auto Const
Sound Property BeepFast Auto Const

int ActionTimerId = 386129 Const
float GlobalTriggerDistance = 1400.0 Const
float PauseSlowestBeep = 1.7 Const
float DistanceSlowBeep = 800.0 Const
float PauseSlowBeep = 1.2 Const
float DistanceMediumBeep = 600.0 Const
float PauseMediumBeep = 0.882 Const
float DistanceFastBeep = 350.0 Const
float PauseFastBeep = 0.232 Const

Event OnLoad()
    ;Debug.Trace("[aotc][proximity] onload happened")
    Actor player = Game.GetPlayer()
    RegisterForDistanceLessThanEvent(player, self, GlobalTriggerDistance)
    RegisterForDistanceGreaterThanEvent(player, self, GlobalTriggerDistance)
EndEvent

Event OnUnload()
	;Debug.Trace("[aotc][proximity] onunload happened")
    UnRegisterForDistanceEvents(Game.GetPlayer(), self)
    CancelTimer(ActionTimerId)
EndEvent

Event OnDistanceLessThan(ObjectReference _player, ObjectReference _self, float afDistance)
    ;Debug.MessageBox("[aotc][proximity] distance less (" + afDistance + "/" + GlobalTriggerDistance + "): start timer")
    RegisterForDistanceGreaterThanEvent(_player, _self, GlobalTriggerDistance)
    StartTimer(0.0, ActionTimerId)
EndEvent

Event OnDistanceGreaterThan(ObjectReference _player, ObjectReference _self, float afDistance)
    ;Debug.MessageBox("[aotc][proximity] distance greater (" + afDistance + "/" + GlobalTriggerDistance + "): cancel timer")
    RegisterForDistanceLessThanEvent(_player, _self, GlobalTriggerDistance)
    CancelTimer(ActionTimerId)
EndEvent

Event OnTimer(int timerId)
    ;Debug.Trace("[aotc][proximity] ontimer happened")
    Actor player = Game.GetPlayer()
    float distance = player.GetDistance(self)
    
    If distance > GlobalTriggerDistance || player.IsDead()
        Return
    ElseIf distance > DistanceSlowBeep
        BeepSlowest.Play(player)
        StartTimer(PauseSlowestBeep, ActionTimerId)
    ElseIf distance > DistanceMediumBeep
        BeepSlow.Play(player)
        StartTimer(PauseSlowBeep, ActionTimerId)
    ElseIf distance > DistanceFastBeep
        BeepMedium.Play(player)
        StartTimer(PauseMediumBeep, ActionTimerId)
    Else
        BeepFast.Play(player)
        StartTimer(PauseFastBeep, ActionTimerId)
    EndIf
EndEvent
