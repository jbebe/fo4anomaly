;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
Scriptname Fragments:Quests:QF_aotc_quest_anomaly_tutori_01003F0D Extends Quest Hidden Const

;BEGIN FRAGMENT Fragment_Stage_0020_Item_00
Function Fragment_Stage_0020_Item_00()
;BEGIN CODE
TutorialMessage.ShowAsHelpMessage("Anomalies01", 14, 0, 2)
PlayerRef.Say(ReactionTopic)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

Message Property TutorialMessage Auto Const

Topic Property ReactionTopic Auto Const

Actor Property PlayerRef Auto Const
