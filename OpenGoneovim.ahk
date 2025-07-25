#Requires AutoHotkey >=2.0
#SingleInstance Force
#Warn All, Off

; Hotkey: Win + N
#N::
{
NewPID := 0
GNVIM := "goneovim"
Run GNVIM, , , &NewPID
WinWait "ahk_pid " NewPID
WinActivate "ahk_pid " NewPID
}
