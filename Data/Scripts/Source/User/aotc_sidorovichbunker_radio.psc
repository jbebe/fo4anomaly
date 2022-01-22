Scriptname aotc_sidorovichbunker_radio extends ObjectReference

ObjectReference Property MufflingDoor Auto Const
Sound Property RadioTrack Auto Const

float MuffledVol = 0.1 Const
float FullVol = 1.0 Const
float DoorVolumeDelay = 0.5 Const
int DoorClosed = 3 Const

int RadioTrackId = -1

Event OnLoad()
    RegisterForRemoteEvent(MufflingDoor, "OnActivate")
    RadioTrackId = RadioTrack.Play(self)
    SetRadioVolumeByDoorState()
EndEvent

Event OnUnLoad()
    If RadioTrackId != -1
        Sound.StopInstance(RadioTrackId)
    EndIf
EndEvent

Event ObjectReference.OnActivate(ObjectReference akSender, ObjectReference akActionRef)
    If akSender != MufflingDoor
        Return
    EndIf
    Utility.Wait(DoorVolumeDelay)
    SetRadioVolumeByDoorState()
EndEvent

Function SetRadioVolumeByDoorState()
    If MufflingDoor.GetOpenState() < DoorClosed
        SetRadioVolume(FullVol)
    ElseIf MufflingDoor.GetOpenState() >= DoorClosed
        SetRadioVolume(MuffledVol)
    EndIf
EndFunction

Function SetRadioVolume(float volume)
    If RadioTrackId != -1
        Sound.SetInstanceVolume(RadioTrackId, volume)
    EndIf
EndFunction