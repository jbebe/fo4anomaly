Scriptname aotc_trigger_ambush_fight extends ObjectReference

Function _debug(string dbgMessage)
    Debug.Trace(dbgMessage)
EndFunction

Actor Property PlayerRef Auto Const
Actor Property Monster Auto Const
Actor Property Sidorovich Auto Const
ImageSpaceModifier Property FadeOutImod Auto Const
Sound[] Property KillSounds Auto Const
ObjectReference Property TeleportMarker Auto Const

bool TriggerStarted = false

Event OnTriggerEnter(objectReference triggerRef)
    If TriggerStarted
        Return
    EndIf
    TriggerStarted = true
    DoSurprise()
    DoFadeScene()
EndEvent

Function DoSurprise()
    _debug("[aotc][ambush] do surprise")
    ; Make player invincible for the scene
    PlayerRef.SetEssential(true)
    ; Wait a little and kock-back player to further help with that deadly hit
    Utility.Wait(2.0)
    PlayerRef.PushActorAway(PlayerRef, 0.0)
EndFunction

Function DoFadeScene()
    _debug("[aotc][ambush] do fade scene")
    ; fade screen to black
    Game.FadeOutGame(true, true, 0.0, 1.0, true)
    Utility.Wait(1.0)
    ; Remove deathclaw
    Monster.Disable()
    ; disable inputs
    InputEnableLayer myLayer = InputEnableLayer.Create()
    myLayer.DisablePlayerControls()
    ; play *Sidorovich fighting for your life* sound
    ; WPNLauncherMissileFirePlayer ... FXExplosionMineFrag .. NPCDeathclawDeathGeneric
    KillSounds[0].Play(self)
    Utility.Wait(1.0)
    KillSounds[1].Play(self)
    Utility.Wait(0.5)
    KillSounds[2].Play(self)
    Utility.Wait(4.0)
    ; Remove trigger self so that it won't happen again
    self.Disable()
    ; Move player to Sidorovich's basement
    PlayerRef.SetEssential(false)
    PlayerRef.MoveTo(TeleportMarker)
    PlayerRef.SetAngle(14.31, 0.0, 265.12)
    ;Game.FadeOutGame(false, false, 0.0, 0.0, false)
EndFunction
