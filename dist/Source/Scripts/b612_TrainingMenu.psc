Scriptname b612_TrainingMenu extends b612_Base

String sRoot = "_root.TrainingMenu_mc"

Function Show()
    RegisterForModEvent("b612_TrainingMenu_Ready", "Onb612_TrainingMenu_Ready")
    RegisterForModEvent("b612_TrainingMenu_Train", "Onb612_TrainingMenu_Train")
    RegisterForModEvent("b612_TrainingMenu_Close", "Onb612_TrainingMenu_Close")
    UI.OpenCustomMenu("b612_trainingmenu")
EndFunction

Function UpdateUI()
    UI.InvokeString( "CustomMenu", sRoot + ".setSkillName", GetSkillName() )
    UI.InvokeString( "CustomMenu", sRoot + ".setTrainerSkill", GetTrainerSkill() )
    UI.InvokeString( "CustomMenu", sRoot + ".setTimesTrainedLabel", GetTimesTrainedLabel() )
    UI.InvokeString( "CustomMenu", sRoot + ".setTimesTrained", GetTimesTrained() + "/" + GetAvailableTraining() )
    UI.InvokeString( "CustomMenu", sRoot + ".setTrainCost", GetTrainCost() )
    UI.InvokeString( "CustomMenu", sRoot + ".setCurrentGold", GetCurrentGold() )
    UI.InvokeString( "CustomMenu", sRoot + ".setSkillMeterPercent", GetSkillMeterPercent() )
EndFunction

Event Onb612_TrainingMenu_Ready(string eventName, string strArg, float numArg, Form formArg)
    UpdateUI()
    UI.Invoke( "CustomMenu", sRoot + ".render" )
EndEvent

Event Onb612_TrainingMenu_Train(string eventName, string strArg, float numArg, Form formArg)
    If GetTimesTrained() >= GetAvailableTraining()
        Return
    EndIf
    If GetTrainCost() > GetCurrentGold()
        Return
    EndIf

    Train()
    UpdateUI()
EndEvent

Event Onb612_TrainingMenu_Close(string eventName, string strArg, float numArg, Form formArg)
    UnregisterForModEvent("b612_TrainingMenu_Ready")
    UnregisterForModEvent("b612_TrainingMenu_Train")
    UnregisterForModEvent("b612_TrainingMenu_Close")
    UI.CloseCustomMenu()
EndEvent

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Below methods are to be overrided
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; show the skill name being trained
String Function GetSkillName()
    Return ""
EndFunction

; shows trainer's skill level
String Function GetTrainerSkill()
    Return "$B612_TRAINADEPT"
EndFunction

String Function GetTimesTrainedLabel()
    Return "$B612_TIMEDTRAINED"
EndFunction

; how many times the player has trained this skill
Int Function GetTimesTrained()
    Return 0
EndFunction

; how many times the player can train this skill
Int Function GetAvailableTraining()
    Return 0
EndFunction

; how much training for the next skill up costs
Int Function GetTrainCost()
    Return 0
EndFunction

; how much money the player currently has
Int Function GetCurrentGold()
    Return 0
EndFunction

; skill's progress, number between 0 and 100
Int Function GetSkillMeterPercent()
    Return 0
EndFunction

; train the skill
Function Train()
EndFunction

