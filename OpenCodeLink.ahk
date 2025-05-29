#Requires AutoHotkey >=2.0
#SingleInstance Force
#Warn All, Off
if not A_IsAdmin
    Run '*RunAs "' A_AhkPath '" /restart "' A_ScriptFullPath '"'

; http://msdn.microsoft.com/en-us/library/envdte.textselection.aspx
; http://msdn.microsoft.com/en-us/library/envdte.textselection.movetodisplaycolumn.aspx
VST_Goto(Filename, Row:=1, Col:=1) {
    DTE := ComObjActive("VisualStudio.DTE")
    DTE.ExecuteCommand("File.OpenFile", Filename)
    DTE.ActiveDocument.Selection.MoveToDisplayColumn(Row, Col)
}

UND_Goto(Filename, Row:=1, Col:=1) {
    UND_PATH := "C:\Program Files\SciTools\bin\pc-win64\understand.exe -visit "
    Run UND_PATH Filename " " Row
}

BCOMP_Goto(Filename) {
    BC_PATH := "C:\Tools\bin\BComp.exe"
    Run BC_PATH " " Filename
}

BCOMP_Compare(Filename1, Filename2) {
    BC_PATH := "C:\Tools\bin\BComp.exe"
    Run BC_PATH " " Filename1 " " Filename2
}


MyGui := Gui()
MyGui.Add("Text", "Section", "CodeLink:")  ; Save this control's position and start a new section.
CLink := MyGui.Add("Edit", "w460 r1")  ; Add a fairly wide edit control at the top of the window.
MyGui.Add("Text", "Section", "BC pattern:")  ; Save this control's position and start a new section.
Replace_pattern := MyGui.Add("Edit", "w460 r1")  ; Add a fairly wide edit control at the top of the window.
MyGui.Add("Text", "Section", "BC target:")  ; Save this control's position and start a new section.
Replace_target := MyGui.Add("Edit", "w460 r1")  ; Add a fairly wide edit control at the top of the window.
Target := MyGui.AddComboBox("vTarget", ["VisualStudio", "Understand", "Beyond Compare"])
MyGui.Add("Button", "Default", "OK").OnEvent("Click", OK_Click)

OK_Click(*)
{
    Link := CLink.Value
    match := []

    if RegExMatch(Link, "codelink://(.+):(\d+)", &match)
    {
        filePath := match[1]
        lineNumber := match[2]
        if Target.Value == "1" {
            VST_Goto(filePath, lineNumber)
        } else if Target.Value == "2" {
            UND_Goto(filePath, lineNumber)
        } else if Target.Value == "3" {
            pattern := Replace_pattern.Value
            bctarget := Replace_target.Value
            if pattern != "" && target != "" {
                filePath2 := StrReplace(filePath, pattern, bctarget)
                BCOMP_Compare(filePath, filePath2)
            } else {
                BCOMP_Goto(filePath)
            }
        }
    }
    else
    {
        MsgBox("The input format is incorrect.")
    }
    MyGui.Hide()
}

; Hotkey: Win + G
#G::
{
    ClipSaved := A_Clipboard
    ; change \\ to /
    ClipSaved := StrReplace(ClipSaved, "\", "/")
    CLink.Value := ClipSaved
    MyGui.Show("w480 h200")

    return
}
