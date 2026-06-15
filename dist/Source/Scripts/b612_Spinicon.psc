Scriptname b612_Spinicon extends b612_Base

String sParentMenu = "HUD Menu"
String sMenuRoot = "_root.HUDMovieBaseInstance.b612_spinicon_.Spinicon_mc"

Event OnInit()
    If ! UI.GetBool(sParentMenu, "_root.HUDMovieBaseInstance.b612_spinicon_._visible")
        string[] args = new string[2]
        args[0] = "b612_spinicon_"
        args[1] = Utility.RandomInt(1000, 10000)
        UI.InvokeStringA( sParentMenu, "_root.HUDMovieBaseInstance.createEmptyMovieClip", args)
        UI.InvokeString( sParentMenu, "_root.HUDMovieBaseInstance.b612_spinicon_.loadMovie", "b612_spinicon_.swf")
    EndIf
EndEvent

Function Show(String aiText = "")
    UI.InvokeString(sParentMenu, sMenuRoot + ".Show", aiText)
EndFunction

Function Hide()
    UI.Invoke(sParentMenu, sMenuRoot + ".Hide")
EndFunction