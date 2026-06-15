Scriptname b612 hidden

Form Function GetB612() Global
    Return Game.GetFormFromFile(0x800, "b612.esp")
EndFunction

b612_SelectList Function GetSelectList() Global
    Return GetB612() as b612_SelectList
EndFunction

b612_QuantitySlider Function GetQuantitySlider() Global
    Return GetB612() as b612_QuantitySlider
EndFunction

b612_ItemSelect Function GetItemSelect() Global
    Return GetB612() as b612_ItemSelect
EndFunction

b612_TrainingMenu Function GetTrainingMenu() Global
    Return GetB612() as b612_TrainingMenu
EndFunction

b612_Keybinds Function GetKeybindsMenu() Global
    Return GetB612() as b612_Keybinds
EndFunction

b612_SpellSelect Function GetSpellSelect() Global
    Return Game.GetFormFromFile(0x802, "b612.esp") as b612_SpellSelect
EndFunction

B612_Announcement Function GetAnnouncement() Global
    Return Game.GetFormFromFile(0xD66, "b612.esp") as B612_Announcement
EndFunction

b612_NotificationManager Function GetNotificationManager() Global
    Return GetB612() as b612_NotificationManager
EndFunction

b612_Spinicon Function GetSpinicon() Global
    Return GetB612() as b612_Spinicon
EndFunction

b612_TraitsMenu Function GetTraitsMenu() Global
    b612_TraitsMenu menuObject = Game.GetFormFromFile(0x803, "b612.esp") as b612_TraitsMenu
    menuObject.Init()
    Return menuObject
EndFunction

b612_AccordionSlider Function GetAccordionSlider() Global
    b612_AccordionSlider menu = GetB612() as b612_AccordionSlider
    menu.Init()
    Return menu
EndFunction

B612_Progressbar Function GetProgressbar() Global
    Return Game.GetFormFromFile(0x804, "b612.esp") as B612_Progressbar
EndFunction

B612_TextBox Function GetTextbox() Global
    Return Game.GetFormFromFile(0x805, "b612.esp") as B612_TextBox
EndFunction

b612_LeaderboardMenu Function GetLeaderboard() Global
    Return Game.GetFormFromFile(0xD73, "b612.esp") as b612_LeaderboardMenu
EndFunction