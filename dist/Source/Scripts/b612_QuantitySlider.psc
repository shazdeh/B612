Scriptname b612_QuantitySlider extends b612_Base

Int iSelectedQuantity
String sConfirm = "$B612_CONFIRM"
String sCancel = "$B612_CANCEL"

Int Function Show(String asTitle, Int aiMinValue = 1, Int aiMaxValue = 100)
    RegisterForModEvent("b612_QuantitySlider_Select", "Onb612_QuantitySlider_Select")
    UI.OpenCustomMenu("b612_QuantitySlider")

    UI.InvokeString( "CustomMenu", "_root.Quantity_mc.setTitle", asTitle )
    UI.InvokeString( "CustomMenu", "_root.Quantity_mc.setConfirmText", sConfirm )
    UI.InvokeString( "CustomMenu", "_root.Quantity_mc.setCancelText", sCancel )
    UI.InvokeInt( "CustomMenu", "_root.Quantity_mc.setMinValue", aiMinValue )
    UI.InvokeInt( "CustomMenu", "_root.Quantity_mc.setMaxValue", aiMaxValue ) ; also opens the menu

    LockWaitMenuMode("CustomMenu")

    Return iSelectedQuantity
EndFunction

Event Onb612_QuantitySlider_Select(string eventName, string strArg, float numArg, Form formArg)
    iSelectedQuantity = numArg as Int
    UI.CloseCustomMenu()
    UnregisterForModEvent("b612_QuantitySlider_Select")
EndEvent