Scriptname b612_Keybinds extends b612_Base

String sRoot = "_root.Menu_mc"

Function Show(String asFilename)
    UI.OpenCustomMenu("b612_keybinds_menu")
    Utility.WaitMenuMode(0.5)
    UI.InvokeString("CustomMenu", sRoot + ".setConfig", asFilename)
EndFunction