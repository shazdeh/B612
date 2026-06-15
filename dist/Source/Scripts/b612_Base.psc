Scriptname b612_Base extends Quest

Import B612_Utils

Function OpenMenu(String asMenuName)
    B612_Utils.OpenMenu(asMenuName)
EndFunction

Function CloseMenu(String asMenuName)
    B612_Utils.CloseMenu(asMenuName)
EndFunction

; for @asSWFFile arg, always use lowercase lettering
Function InjectMenu(String asMenuName, String asSWFFile)
    string[] args = new string[2]
    args[0] = asSWFFile
    args[1] = Utility.RandomInt(1000, 10000)
    UI.InvokeStringA( asMenuName, "_root.createEmptyMovieClip", args)
    UI.InvokeString( asMenuName, "_root." + asSWFFile + ".loadMovie", asSWFFile + ".swf")
EndFunction

Function LockWait(String asMenuName)
    While UI.IsMenuOpen(asMenuName)
        Utility.Wait(0.1)
    EndWhile
EndFunction

Function LockWaitMenuMode(String asMenuName)
    While UI.IsMenuOpen(asMenuName)
        Utility.WaitMenuMode(0.1)
    EndWhile
EndFunction