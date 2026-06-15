Scriptname b612_AccordionSlider extends b612_Base

Int iSelectedIndex

Bool Function Init()
    UI.OpenCustomMenu("b612_accordionslider")
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
    UI.InvokeStringA("CustomMenu", "_root.Menu_mc.addItem", args)
EndFunction

Function SetTitle(String astitle)
    UI.InvokeString("CustomMenu", "_root.Menu_mc.setTitle", astitle)
EndFunction

Int Function Show()
    RegisterForModEvent("b612_AccordionSlider_Close", "Onb612_AccordionSlider_Close")
    UI.Invoke("CustomMenu", "_root.Menu_mc.render")

    LockWait("CustomMenu")
    Return iSelectedIndex
EndFunction

Event Onb612_AccordionSlider_Close(string eventName, string strArg, float numArg, Form formArg)
    iSelectedIndex = strArg as Int
    UI.CloseCustomMenu()
    UnregisterForModEvent("b612_AccordionSlider_Close")
EndEvent