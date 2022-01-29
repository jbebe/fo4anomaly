Scriptname aotc_actor_script_anomaly_facing extends Actor Const

int ActionTimerId = 386128 Const
float DistanceFar = 1000.0 Const
float TimerSecFar = 2.0 Const
float DistanceMiddle = 500.0 Const
float TimerSecMiddle = 1.0 Const
float TimerSecClose = 0.1 Const

Event OnLoad()
    If !self.Is3DLoaded()
        Return
    EndIf
    
    StartTimer(0.0, ActionTimerId)
EndEvent

Event OnUnload()
	CancelTimer(ActionTimerId)
EndEvent

Event OnTimer(int timerId)
    float selfX = self.GetPositionX()
    float selfY = self.GetPositionY()
    float selfZ = self.GetPositionZ()

    Actor player = Game.GetPlayer()
    float playerX = player.GetPositionX()
    float playerY = player.GetPositionY()
    float playerZ = player.GetPositionZ()

    float horizontalAngle = GetAngle(selfX, selfY, playerX, playerY)
    float verticalAngle = GetAngle(selfY, selfZ, playerY, playerZ)
    self.SetAngle(verticalAngle, 0.0, horizontalAngle)

    float distance = player.GetDistance(self)
    If distance > DistanceFar
        StartTimer(TimerSecFar, ActionTimerId)
    ElseIf distance > DistanceMiddle
        StartTimer(TimerSecMiddle, ActionTimerId)
    Else
        StartTimer(TimerSecClose, ActionTimerId)
    Endif
EndEvent

float Function GetAngle(float aX, float aY, float bX, float bY)
    return 90.0 - atan2(bY - aY, bX - aX)
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