#Requires AutoHotkey >=2.0
#SingleInstance Force
#Warn All, Off

; Global variable to store password
global storedPassword := ""

; Password input hotkey: Ctrl + Alt + P
^!P::
{
    global storedPassword
    if (storedPassword = "") {
        ; If password is empty, prompt user to input
        inputPassword := InputBox("PasswordInput", "Input:", "Password")
        if (inputPassword.Result = "OK") {
            storedPassword := inputPassword.Value
            ToolTip("Password saved")
            SetTimer(() => ToolTip(), -2000)
        }
    } else {
        ; If password is not empty, directly input the password
        SendInput(storedPassword)
    }
}

; Clear password hotkey: Win + Shift + P
#+P::
{
    global storedPassword
    storedPassword := ""
    ToolTip("Password cleared")
    SetTimer(() => ToolTip(), -2000)
}

; Hotkey: Win + N
#N::
{
NewPID := 0
GNVIM := "goneovim"
Run GNVIM, , , &NewPID
WinWait "ahk_pid " NewPID
WinActivate "ahk_pid " NewPID
}

; Hotkey: Alt + PrintScreen => redirect to Win + Shift + R to record screen video
!PrintScreen::
{
Send "#+r"
}
