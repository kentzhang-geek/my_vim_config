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


; Hotkey: Win + G
#G::
{
    ClipSaved := A_Clipboard

    Link := ""
    IB := InputBox("Enter Codelink. Will Open in Visual Studio", "Codelinke", "w320 h120")
    if IB.Result != "Cancel" {
        Link := IB.Value
        match := []

        if RegExMatch(Link, "codelink://(.+):(\d+)", &match)
        {
            filePath := match[1]
            lineNumber := match[2]
            VST_Goto(filePath, lineNumber)
        }
        else
        {
            MsgBox("The input format is incorrect.")
        }
    }

    return
}