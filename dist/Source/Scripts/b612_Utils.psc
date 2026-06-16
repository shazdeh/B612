Scriptname b612_Utils Hidden

Function OpenMenu(String asMenuName) Global Native

Function CloseMenu(String asMenuName) Global Native

Function UpdateInventoryMenu() Global
    _UpdateInventoryMenu()
    ; InvalidateData does get called with SendInventoryUpdateMessage() but it doesn't re-render
    ; need to figure this out at some point, but this works
    UI.Invoke("InventoryMenu", "_root.Menu_mc.inventoryLists.itemList.InvalidateData")
EndFunction


;----------------------------------------------------------------------------------------------------------
; API to extract info and work with items inside menus
;----------------------------------------------------------------------------------------------------------

Spell Function GetSpellByIndex(Int aiIndex) Global Native

Form Function GetEntryForm(Int aiIndex) Global Native

Form Function GetEntryOwner(Int aiIndex) Global Native

Bool Function SetEntryOwner(Int aiIndex, Form akOwner) Global Native

; number of items stacked together
Int Function GetEntryCount(Int aiIndex) Global Native

; how many items in a stack are stolen
Int Function GetEntryStolenCount(Int aiIndex) Global Native

String Function GetEntryEditorID(Int aiIndex) Global Native

String Function GetEntryName(Int aiIndex) Global Native

Enchantment Function GetEntryEnchantment(Int aiIndex) Global Native

Bool Function IsEntryEnchanted(Int aiIndex) Global
    Return GetEntryEnchantment(aiIndex) != None
EndFunction

; returns percentage (0-100) of how much charge the item has
Int Function GetEntryCharge(Int aiIndex) Global Native

Potion Function GetEntryAppliedPoison(Int aiIndex) Global Native

Bool Function IsEntryPoisoned(Int aiIndex) Global
    Return GetEntryAppliedPoison(aiIndex) != None
EndFunction

Int Function GetEntryPoisonCount(Int aiIndex) Global Native

; returns:
;   0 if item is not a weapon/armor,
;   1 if item is not tempered at all,
;   or the tempering value
Float Function GetEntryHealth(Int aiIndex) Global Native

;  Function SetEntryHealth(Int aiIndex, Float afValue) Global Native

Bool Function IsEntryEquipped(Int aiIndex) Global Native

Bool Function IsEntryFavorited(Int aiIndex) Global Native

Bool Function IsEntryQuestObject(Int aiIndex) Global Native


;----------------------------------------------------------------------------------------------------------
; Private
;----------------------------------------------------------------------------------------------------------

Function _UpdateInventoryMenu() Global Native