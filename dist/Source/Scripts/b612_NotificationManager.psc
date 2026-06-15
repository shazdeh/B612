Scriptname b612_NotificationManager extends b612_Base

String sParentMenu = "HUD Menu"
String sMenuPath = "_root.b612_NotificationManager.NotificationManager_mc"

Function Register(String asMessageText, String asEventName = "", String asBeforeText = "", String asAfterText = "")
    If ! UI.GetBool(sParentMenu, sMenuPath + "._visible")
        InjectMenu(sParentMenu, "b612_notificationmanager")
        Utility.WaitMenuMode(0.1)
    EndIf

    int iCB = UiCallback.Create(sParentMenu, sMenuPath + ".addItem")
    If iCB
        UiCallback.PushString(iCB, asMessageText)
        UiCallback.PushString(iCB, asEventName)
        UiCallback.PushString(iCB, asBeforeText)
        UiCallback.PushString(iCB, asAfterText)
        UiCallback.Send(iCB)
    EndIf
EndFunction

Function EnclosesWith(String asBeforeText = "", String asAfterText = "", String asEventName = "")
    Register("", asEventName, asBeforeText, asAfterText)
EndFunction

Function Unregister(String asMessageText)
    UI.InvokeString(sParentMenu, sMenuPath + ".removeItem", asMessageText)
EndFunction