Scriptname b612_Utils Hidden

Function OpenMenu(String asMenuName) Global Native

Function CloseMenu(String asMenuName) Global Native

Function UpdateInventoryMenu() Global Native


;----------------------------------------------------------------------------------------------------------
; API to extract info and work with items inside menus
;----------------------------------------------------------------------------------------------------------

Spell Function GetSpellByIndex(Int aiIndex) Global Native

Form Function GetFormAtIndex(Int aiIndex) Global Native

Bool Function SetOwnerOfIndex(Int aiIndex, Form akOwner) Global Native

Form Function GetOwnerOfIndex(Int aiIndex) Global Native

Int Function GetItemCountAtIndex(Int aiIndex) Global Native

String Function GetFormEditorIDAtIndex(Int aiIndex) Global Native