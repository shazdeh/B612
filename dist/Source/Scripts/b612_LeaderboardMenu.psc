Scriptname b612_LeaderboardMenu extends b612_Base

Bool Function Init()
    UI.OpenCustomMenu("b612_leaderboard_menu")
    While ! UI.GetBool("CustomMenu", "_root.isLoaded")
        Utility.WaitMenuMode(0.1)
    EndWhile
    Return True
EndFunction

; add single item to the leaderboard
Function AddItem(String astitle, String asScore)
    String[] args = new String[2]
    args[0] = astitle
    args[1] = asScore
    UI.InvokeStringA("CustomMenu", "_root.Menu_mc.addItem", args)
EndFunction

; bulk-add items that are in JSON format:
; [
;    {
;       "name" : "Name",
;       "score" : 1000
;    },
;    ...
; ]
Function LoadJSON(String asJSON)
    UI.InvokeString("CustomMenu", "_root.Menu_mc.loadJSON", asJSON)
EndFunction

; menu title
Function setHeader(String asTitle)
    UI.InvokeString("CustomMenu", "_root.Menu_mc.setHeader", asTitle)
EndFunction

Function Show()
    RegisterForModEvent("B612_Leaderboard_Close", "OnClose")
    UI.Invoke("CustomMenu", "_root.Menu_mc.render")

    LockWait("CustomMenu")
EndFunction

Event OnClose(string eventName, string strArg, float numArg, Form formArg)
    UI.CloseCustomMenu()
    UnregisterForModEvent("B612_Leaderboard_Close")
EndEvent