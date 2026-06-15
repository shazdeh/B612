Scriptname b612_SelectList extends b612_Base

Int iSelectedIndex

Int Function Show(String[] asItems)
    RegisterForModEvent("b612_SelectList_Select", "Onb612_SelectList_Select")
    UI.OpenCustomMenu("b612_SelectList")
    UI.InvokeString( "CustomMenu", "_root.MenuHolder.Menu_mc.setData", Serialize( asItems ) )

    LockWaitMenuMode("CustomMenu")

    Return iSelectedIndex
EndFunction

Event Onb612_SelectList_Select(string eventName, string strArg, float numArg, Form formArg)
    iSelectedIndex = numArg as Int
    UI.CloseCustomMenu()
    UnregisterForModEvent("b612_SelectList_Select")
EndEvent

String Function Serialize(String[] asItems)
	Int iIndex
	String sOutput = ""
	While iIndex < asItems.Length
		If StringUtil.GetLength(sOutput) != 0
			sOutput += "_|_"
		EndIf
		sOutput += iIndex + "_:_" + asItems[iIndex]
		iIndex += 1
	EndWhile

    Return sOutput
EndFunction
