Scriptname b612_PlayerLoadGameScript extends ReferenceAlias

Event OnPlayerLoadGame()
    (GetOwningQuest() as b612_Spinicon).OnInit()
EndEvent