Scriptname B612_Announcement extends SKI_WidgetBase

String Function GetWidgetSource()
    Return "B612_Announcement.swf"
EndFunction

; returns the name of this very script file
String Function GetWidgetType()
    Return "B612_Announcement"
EndFunction

; Widget start. Is also called when save is loaded
Event OnWidgetReset()
    Parent.OnWidgetReset()
EndEvent

Function Show(String asText, String asImagePath, Float aiDelay = 2.0, String asKnot = "")
    If (Ready)
        int iCB = UiCallback.Create(HUD_MENU, WidgetRoot + ".announce")
        If iCB
            UiCallback.PushString(iCB, asText)
            UiCallback.PushString(iCB, asImagePath)
            UiCallback.PushFloat(iCB, aiDelay)
            UiCallback.PushString(iCB, asKnot)
            UiCallback.Send(iCB)
        EndIf
    EndIf
EndFunction