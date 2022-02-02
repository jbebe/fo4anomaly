;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
Scriptname Fragments:Quests:QF_aotc_quest_sidorovich_tra_01003E08 Extends Quest Hidden Const

;BEGIN FRAGMENT Fragment_Stage_0010_Item_00
Function Fragment_Stage_0010_Item_00()
;BEGIN CODE
; close and lock sid's lobby door
Alias_BunkerInnerDoor.GetRef().SetOpen(false)
Alias_BunkerInnerDoor.GetRef().BlockActivation(abBlocked = true, abHideActivateText = true)
; close the exterior bunker door
Alias_BunkerExtDoor.GetRef().SetOpen(false)
Alias_BunkerExtDoor.GetRef().BlockActivation(abBlocked = true, abHideActivateText = true)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Stage_0020_Item_00
Function Fragment_Stage_0020_Item_00()
;BEGIN CODE
Actor PlayerRef = Alias_PlayerRef.GetActorRef()
Actor Monster = Alias_AmbushMonster.GetActorRef()

; Make monster invincible
Monster.SetGhost(true)
; Make player invincible for the scene
PlayerRef.SetEssential(true)
; Wait a little and kock-back player to further help with that deadly hit
Utility.Wait(2.0)
PlayerRef.PushActorAway(PlayerRef, 0.0)

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
KillSounds[0].Play(PlayerRef)
Utility.Wait(1.0)
KillSounds[1].Play(PlayerRef)
Utility.Wait(0.5)
KillSounds[2].Play(PlayerRef)
Utility.Wait(4.0)
; Set player mortal
PlayerRef.SetEssential(false)
; Move player to Sidorovich's basement
PlayerRef.MoveTo(teleportMarker)
PlayerRef.SetAngle(14.31, 0.0, 265.12)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Stage_0030_Item_00
Function Fragment_Stage_0030_Item_00()
;BEGIN CODE
SetObjectiveDisplayed(10)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Stage_0040_Item_00
Function Fragment_Stage_0040_Item_00()
;BEGIN CODE
Alias_BunkerInnerDoor.GetRef().BlockActivation(abBlocked = false, abHideActivateText = false)
Alias_BunkerExtDoor.GetRef().BlockActivation(abBlocked = false, abHideActivateText = false)
SetObjectiveCompleted(10)
SetStage(1000)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Stage_0050_Item_00
Function Fragment_Stage_0050_Item_00()
;BEGIN CODE
Alias_BunkerInnerDoor.GetRef().BlockActivation(abBlocked = false, abHideActivateText = false)
Alias_BunkerExtDoor.GetRef().BlockActivation(abBlocked = false, abHideActivateText = false)
SetObjectiveCompleted(10)
SetStage(60)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Stage_0060_Item_00
Function Fragment_Stage_0060_Item_00()
;BEGIN CODE
SetObjectiveDisplayed(20)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

ReferenceAlias Property Alias_BunkerInnerDoor Auto Const Mandatory

ReferenceAlias Property Alias_BunkerExtDoor Auto Const Mandatory

ReferenceAlias Property Alias_PlayerRef Auto Const Mandatory

ReferenceAlias Property Alias_AmbushMonster Auto Const Mandatory

Sound[] Property KillSounds Auto Const Mandatory

ObjectReference Property TeleportMarker Auto Const Mandatory
