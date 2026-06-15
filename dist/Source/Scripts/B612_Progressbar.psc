Scriptname B612_Progressbar extends b612_Base

String sMenuName = "CustomMenu"
String sMenuRoot = "_root.Menu_mc"

Function Show(Bool bCanClose = False)
    UI.OpenCustomMenu("b612_progressmenu")
    If bCanClose
        int iCB = UiCallback.Create(sMenuName, sMenuRoot + ".setCloseButtonData")
        If iCB
            UiCallback.PushString(iCB, "$B612_CLOSE")
            UiCallback.PushInt(iCB, Input.GetMappedKey("Tween Menu"))
            UiCallback.Send(iCB)
        EndIf
    EndIf
    UI.InvokeBool(sMenuName, sMenuRoot + ".setCanClose", bCanClose)
EndFunction

Function Update(Int iPercent, String sHeading = "")
    int iCB = UiCallback.Create(sMenuName, sMenuRoot + ".update")
    If iCB
        UiCallback.PushInt(iCB, iPercent)
        UiCallback.PushString(iCB, sHeading)
        UiCallback.Send(iCB)
    EndIf
EndFunction

Function Close()
    UI.CloseCustomMenu()
EndFunction