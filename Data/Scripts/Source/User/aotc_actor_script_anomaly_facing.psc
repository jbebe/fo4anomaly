Scriptname aotc_actor_script_anomaly_facing extends Actor Const

; Vars
float FarTimerIntervalSec = 2.0 Const
float MiddleTimerIntervalSec = 1.0 Const
float CloseTimerIntervalSec = 0.1 Const
int ActionTimerId = 386128 Const

Event OnLoad()
    StartTimer(FarTimerIntervalSec, ActionTimerId)
EndEvent

Event OnUnload()
	CancelTimer(ActionTimerId)
EndEvent

Event OnTimer(int timerId)
    Actor player = Game.GetPlayer()
    
    ; default facing vector of anomaly
    float selfX = self.GetPositionX()
    float selfY = self.GetPositionY()
    float selfZ = self.GetPositionZ()

    ; vector between anomaly and player
    float playerX = player.GetPositionX()
    float playerY = player.GetPositionY()
    float playerZ = player.GetPositionZ()

    float horizontalAngle = GetAngle(selfX, selfY, playerX, playerY)
    self.SetAngle(0, 0, horizontalAngle)

    float distance = player.GetDistance(self)
    If distance > 500
        StartTimer(FarTimerIntervalSec, ActionTimerId)
    ElseIf distance > 300
        StartTimer(MiddleTimerIntervalSec, ActionTimerId)
    Else
        StartTimer(CloseTimerIntervalSec, ActionTimerId)
    Endif
EndEvent

float Function GetAngle(float aX, float aY, float bX, float bY)
    return 90 - atan2(bY - aY, bX - aX)
EndFunction

float Function atan2(float aY, float aX)
    If (aX > 0.0)
        return Math.atan(aY / aX)
    Elseif (aX < 0.0)
        If (aY >= 0)
            return Math.atan(aY / aX) + 180.0
        Else
            return Math.atan(aY / aX) - 180.0
        Endif
    Elseif (aY > 0.0)
        return 90.0
    Elseif (aY < 0.0)
        return -90.0
    Endif
    Return 0.0
EndFunction