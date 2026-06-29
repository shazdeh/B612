Scriptname b612_ItemSelect2 extends b612_Base

Import B612_Utils

String sParentMenu = "InventoryMenu"
String sMenuRoot = "_root.b612_itemselect_inject.Menu_mc"
Form SelectedForm

Bool Property bAutoClose Auto
{Weather the menu should be closed automatically after selecting an item}
String[] Property IncludeKeywords Auto
{Spells matching any of the listed keywords are listed}
String[] Property ExcludeKeywords Auto
{Has priority over IncludeKeywords, will exclude spells that have any of the listed keywords}
Int[] Property FormTypes Auto
{List of FormType(s) allowed; check FormType.psc script in SKSE for valid values; example: 41 is Weapon, 46 is Potion.}
Int Property Count Auto
{Filter by how many of the item the player has}
String Property CountCompare = "=" Auto
{Comparison logic for Count, default is "="}
Int Property Damage Auto
{Applied to weapons only, filter by a weapon's damage value}
String Property DamageCompare = "=" Auto
{Comparison logic for Damage, default is "="}
Int Property ArmorRating Auto
{Applied to Armor only, filter by armor rating it provides}
String Property ArmorRatingCompare = "=" Auto
{Comparison logic for ArmorRating, default is "="}
; Int Property EquipState = -1 Auto
; {Filter by weather the item is equipped or not:
; -1 : default, shows both
; 0 : show only unequipped gear
; 1 : only display equipped gear
; 3 : ???
; }
Int Property IsEnchanted = -1 Auto
{Filter by weather the item is enchanted or not:
-1 : default, shows both
0 : show only unenchanted gear
1 : only display enchanted gear
}
Int Property IsStolen = -1 Auto
{Filter by weather the item is stolen or not:
-1 : default, shows both
0 : show only items not stolen
1 : only display stolen items
}

Form Function Show()
    SelectedForm = None
    RegisterForModEvent("b612_SelectItem", "OnSelect")
    OpenMenu(sParentMenu)
    InjectMenu(sParentMenu, "b612_itemselect_inject")
    Utility.WaitMenuMode(0.1)
    If IncludeKeywords.Length
        UI.InvokeStringA(sParentMenu, sMenuRoot + ".setIncludeKeywords", IncludeKeywords)
    EndIf
    If ExcludeKeywords.Length
        UI.InvokeStringA(sParentMenu, sMenuRoot + ".setExcludeKeywords", ExcludeKeywords)
    EndIf
    If FormTypes.Length
        UI.InvokeIntA(sParentMenu, sMenuRoot + ".setFormTypes", FormTypes)
    EndIf
    If Count
        UI.InvokeInt(sParentMenu, sMenuRoot + ".setCount", Count)
        UI.InvokeString(sParentMenu, sMenuRoot + ".setCountCompare", CountCompare)
    EndIf
    If Damage
        UI.InvokeInt(sParentMenu, sMenuRoot + ".setDamage", Damage)
        UI.InvokeString(sParentMenu, sMenuRoot + ".setDamageCompare", DamageCompare)
    EndIf
    If ArmorRating
        UI.InvokeInt(sParentMenu, sMenuRoot + ".setArmorRating", ArmorRating)
        UI.InvokeString(sParentMenu, sMenuRoot + ".setArmorRatingCompare", ArmorRatingCompare)
    EndIf
    ; If EquipState != -1
    ;     UI.InvokeInt(sParentMenu, sMenuRoot + ".setEquipState", EquipState)
    ; EndIf
    If IsEnchanted != -1
        UI.InvokeInt(sParentMenu, sMenuRoot + ".setIsEnchanted", IsEnchanted)
    EndIf
    If IsStolen != -1
        UI.InvokeInt(sParentMenu, sMenuRoot + ".setIsStolen", IsStolen)
    EndIf

    UI.Invoke(sParentMenu, sMenuRoot + ".render")

    LockWait(sParentMenu)
    UnregisterForModEvent("b612_SelectItem")

    Return SelectedForm
EndFunction

; @param strArg Item Name
; @param numArg Index of item inside InventoryMenu
Event OnSelect(string eventName, string strArg, float numArg, Form formArg)
    SelectedForm = GetEntryForm(numArg as Int)
    If bAutoClose
        CloseMenu(sParentMenu)
    EndIf
EndEvent

; Drops the currently highlighted item
Function DropItem(Int aiAmount = 1)
    UI.InvokeInt(sParentMenu, sMenuRoot + ".drop", aiAmount)
EndFunction

; Equip currently highlighted item
; Valid Hand Slot:
; 0 - Left
; 1 - Right
Function AttemptEquip(Int aiHandSlot = 1)
    UI.InvokeInt(sParentMenu, sMenuRoot + ".equip", aiHandSlot)
EndFunction