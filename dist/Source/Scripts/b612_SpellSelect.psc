Scriptname b612_SpellSelect extends b612_Base

Import B612_Utils

String sParentMenu = "MagicMenu"
String sMenuRoot = "_root.b612_spellselect_inject.Menu_mc"
Spell SelectedForm

Bool Property bAutoClose Auto
{Weather the menu should be closed automatically after selecting an spell}
String[] Property IncludeKeywords Auto
{Spells matching any of the listed keywords are listed}
String[] Property ExcludeKeywords Auto
{Has priority over IncludeKeywords, will exclude spells that have any of the listed keywords}
Int[] Property CastingType Auto
{Filter by casting type:
0 : Constant Effect
1 : Fire And Forget
2 : Concentration
}
Int[] Property DeliveryType Auto
{Filter by delivery type:
0: Self
1: Contact
2: Aimed
3: Target Actor
4: Target Location
}
Int Property Magnitude Auto
{Filter spells by their magnitude value}
String Property MagnitudeCompare = "<" Auto
{Comparison logic for Magnitude, default is "<" to show only spells below the specified Magnitude}
Int Property Cost Auto
{Filter spells by their effective casting cost}
String Property CostCompare = "<" Auto
{Comparison logic for Cost, default is "<" to show only spells that their casting cost is below the specified threshold.}
Int Property Area Auto
{Filter spells by their Area of effect}
String Property AreaCompare = "<" Auto
{Comparison logic for Area, default is "<" to show only spells that their area is below the specified threshold.}
Int Property SkillLevel Auto
{Filter spells by SkillLevel, 0 is Novice, 100 is Master}
String Property SkillLevelCompare = "<" Auto
{Comparison logic for SkillLevel, default is "<" to show only spells that are below the specified threshold.}
Int[] Property Archetype Auto
{Filter by desired Archetype}
Int[] Property ActorValue Auto
{Filter by what ActorValue the spell applies}
Int[] Property School Auto
{Filter spells by their magic school, these are the corresponding ActorValues for each skill:
18 : Alteration
19 : Conjuration
20 : Destruction
21 : Illusion
22 : Restoration
}

Spell Function Show()
    SelectedForm = None
    RegisterForModEvent("b612_SelectSpell", "OnSelect")
    OpenMenu(sParentMenu)
    InjectMenu(sParentMenu, "b612_spellselect_inject")
    Utility.WaitMenuMode(0.1)
    If School.Length
        UI.InvokeIntA(sParentMenu, sMenuRoot + ".setSchool", School)
    EndIf
    If IncludeKeywords.Length
        UI.InvokeStringA(sParentMenu, sMenuRoot + ".setIncludeKeywords", IncludeKeywords)
    EndIf
    If ExcludeKeywords.Length
        UI.InvokeStringA(sParentMenu, sMenuRoot + ".setExcludeKeywords", ExcludeKeywords)
    EndIf
    If CastingType.Length
        UI.InvokeIntA(sParentMenu, sMenuRoot + ".setCastingType", CastingType)
    EndIf
    If DeliveryType.Length
        UI.InvokeIntA(sParentMenu, sMenuRoot + ".setDeliveryType", DeliveryType)
    EndIf
    If Archetype.Length
        UI.InvokeIntA(sParentMenu, sMenuRoot + ".setArchetype", Archetype)
    EndIf
    If Magnitude
        UI.InvokeInt(sParentMenu, sMenuRoot + ".setMagnitude", Magnitude)
        UI.InvokeString(sParentMenu, sMenuRoot + ".setMagnitudeCompare", MagnitudeCompare)
    EndIf
    If Cost
        UI.InvokeInt(sParentMenu, sMenuRoot + ".setCost", Cost)
        UI.InvokeString(sParentMenu, sMenuRoot + ".setCostCompare", CostCompare)
    EndIf
    If Area
        UI.InvokeInt(sParentMenu, sMenuRoot + ".setArea", Area)
        UI.InvokeString(sParentMenu, sMenuRoot + ".setAreaCompare", AreaCompare)
    EndIf
    If SkillLevel
        UI.InvokeInt(sParentMenu, sMenuRoot + ".setSkillLevel", SkillLevel)
        UI.InvokeString(sParentMenu, sMenuRoot + ".setSkillLevelCompare", SkillLevelCompare)
    EndIf
    If ActorValue
        UI.InvokeIntA(sParentMenu, sMenuRoot + ".setActorValue", ActorValue)
    EndIf

    UI.Invoke(sParentMenu, sMenuRoot + ".render")

    LockWait(sParentMenu)
    UnregisterForModEvent("b612_SelectSpell")

    Return SelectedForm
EndFunction

; @param strArg Spell's name
; @param numArg Index of spell inside MagicMenu
Event OnSelect(string eventName, string strArg, float numArg, Form formArg)
    SelectedForm = GetSpellByIndex(numArg as Int)
    If bAutoClose
        CloseMenu(sParentMenu)
    EndIf
EndEvent