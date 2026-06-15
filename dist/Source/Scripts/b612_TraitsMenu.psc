Scriptname b612_TraitsMenu extends b612_Base

String sSelectedIndexes
Int iMinSelection

Bool Function Init()
    UI.OpenCustomMenu("b612_traitsmenut")
    While ! UI.GetBool("CustomMenu", "_root.isLoaded")
        Utility.WaitMenuMode(0.1)
    EndWhile
    Return True
EndFunction

Function AddItem(String astitle, String asDescription, String asImagePath)
    String[] args = new String[3]
    args[0] = astitle
    args[1] = asDescription
    args[2] = asImagePath
    UI.InvokeStringA("CustomMenu", "_root.Traits_mc.addItem", args)
EndFunction

String[] Function Show(Int aiMaxSelection = 1, Int aiMinSelection = 0)
    RegisterForModEvent("b612_TraitsMenu_Close", "Onb612_TraitsMenu_Close")
    UI.InvokeInt("CustomMenu", "_root.Traits_mc.setMaxSelection", aiMaxSelection)
    UI.InvokeInt("CustomMenu", "_root.Traits_mc.setMinSelection", aiMinSelection)
    iMinSelection = aiMinSelection
    UI.Invoke("CustomMenu", "_root.Traits_mc.render")

    LockWait("CustomMenu")
    String[] SelectedIndexes = StringUtil.Split(sSelectedIndexes, ",")

    Return SelectedIndexes
EndFunction

Event Onb612_TraitsMenu_Close(string eventName, string strArg, float numArg, Form formArg)
    sSelectedIndexes = strArg
    UI.CloseCustomMenu()
    UnregisterForModEvent("b612_TraitsMenu_Close")
EndEvent