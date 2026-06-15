Scriptname b612_TextBox extends b612_Base

String sValue

String Function Show(String asDefaultValue = "Input text here...", String asButtonLabel = "$B612_CONFIRM", Int aiWidth = 400, Int aiHeight = 150)
    UI.OpenCustomMenu("b612_textbox_menu")
    sValue = ""
    Utility.WaitMenuMode(0.1)
    String[] args = new String[4]
    args[0] = asDefaultValue
    args[1] = asButtonLabel
    args[2] = aiWidth
    args[3] = aiHeight
    UI.InvokeStringA("CustomMenu", "_root.Menu_mc.SetOptions", args)
    RegisterForModEvent("b612_Textbox_Close", "OnClose")

    LockWait("CustomMenu")
    Return sValue
EndFunction

Event OnClose(string eventName, string strArg, float numArg, Form formArg)
    sValue = strArg
    UI.CloseCustomMenu()
    UnregisterForModEvent("b612_Textbox_Close")
EndEvent