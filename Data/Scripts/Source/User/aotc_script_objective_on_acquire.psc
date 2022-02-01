Scriptname aotc_script_objective_on_acquire extends ObjectReference Const

Actor Property PlayerRef Auto Const
Quest Property inQuest Auto Const
Int Property inObjective Auto Const
Int Property startObjective = -1 Auto Const

Event OnContainerChanged(ObjectReference newContainer, ObjectReference oldContainer)
    If (newContainer == PlayerRef)
        inQuest.SetObjectiveCompleted(inObjective)
        If startObjective != -1
            inQuest.SetObjectiveDisplayed(startObjective)
        EndIf
    EndIf
EndEvent
