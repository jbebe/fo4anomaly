Scriptname aotc_sidorovichbunker_radio extends ObjectReference

Function _debug(string dbgMessage)
    ;Debug.Trace(dbgMessage)
EndFunction

; This script aids to muffle the radio when the door starts to close 
; and vica versa. With an Activator radio, we couldn't get the handle of the sound source
; but this way (sound property) we can.

ObjectReference Property MufflingDoor Auto Const
Sound Property RadioTrack Auto Const

float MuffledVol = 0.2 Const
float FullVol = 1.0 Const
float DoorVolumeDelay = 0.5 Const
int DoorClosed = 3 Const

int RadioTrackId = -1

Event OnLoad()
    _debug("[aotc][radio] OnLoad called")
    If !self.Is3DLoaded()
        Return
    EndIf
    RegisterForRemoteEvent(MufflingDoor, "OnActivate")
    RadioTrackId = RadioTrack.Play(self)
    SetRadioVolumeByDoorState()
EndEvent

Event OnUnLoad()
    _debug("[aotc][radio] OnUnLoad called")
    If RadioTrackId != -1
        Sound.StopInstance(RadioTrackId)
    EndIf
EndEvent

Event ObjectReference.OnActivate(ObjectReference akSender, ObjectReference akActionRef)
    _debug("[aotc][radio] ObjectReference.OnActivate called")
    If akSender != MufflingDoor
        Return
    EndIf
    Utility.Wait(DoorVolumeDelay)
    SetRadioVolumeByDoorState()
EndEvent

Function SetRadioVolumeByDoorState()
    ; TODO: fix muffling if player is inside but the door is closed
    SetRadioVolume(FullVol)
    ;/If MufflingDoor.GetOpenState() < DoorClosed
        SetRadioVolume(FullVol)
    ElseIf MufflingDoor.GetOpenState() >= DoorClosed
        SetRadioVolume(MuffledVol)
    EndIf/;
EndFunction

Function SetRadioVolume(float volume)
    If RadioTrackId != -1
        Sound.SetInstanceVolume(RadioTrackId, volume)
    EndIf
EndFunction