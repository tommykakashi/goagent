Sub WriteIniVisible(isVisible)
    Set objFSO   = CreateObject("Scripting.FileSystemObject")

    Set objReadFile = objFSO.OpenTextFile("proxy.ini", 1)
    strContents = objReadFile.ReadAll()
    objReadFile.Close()

    Set regEx = New RegExp
    regEx.Pattern = "(visible\s*=[^\r]*)"
    regEx.IgnoreCase = True
    regEx.Global = True
    regEx.MultiLine = True
    strNewContents = regEx.Replace(strContents, "visible = " & isVisible)

    Set objWriteFile = objFSO.OpenTextFile("proxy.ini", 2)
    objWriteFile.Write(strNewContents)
    objWriteFile.Close()
End Sub

Sub CreateShortcut(strTargetPath)
    Set WshShell = WScript.CreateObject("WScript.Shell")
    Set oShellLink = WshShell.CreateShortcut(WshShell.SpecialFolders("Startup") & "\goagent.lnk")
    oShellLink.TargetPath = strTargetPath
    oShellLink.Arguments = """" & WshShell.CurrentDirectory & "\proxy.py"""
    oShellLink.WindowStyle = 7
    oShellLink.Description = "GoAgent"
    oShellLink.WorkingDirectory = WshShell.CurrentDirectory
    oShellLink.Save
End Sub

Sub Main()
    Set WshShell = WScript.CreateObject("WScript.Shell")
    Set fso = CreateObject("Scripting.FileSystemObject")

    ' If fso.FileExists(WshShell.SpecialFolders("Startup") & "\goagent.lnk") Then
    '     CreateShortcut("""" & WshShell.CurrentDirectory & "\goagent.exe""")
    '     If WshShell.Popup("goagent.exe已经加入到启动项，是否删除？(本对话框6秒后消失)", 6, "GoAgent 对话框", vbOKCancel+vbQuestion) = 1 Then
    '         fso.DeleteFile(WshShell.SpecialFolders("Startup") & "\goagent.lnk")
    '         WshShell.Popup "删除成功", 5, "GoAgent 对话框", vbInformation
    '     End If
    '     WScript.Quit
    ' End If

    If WshShell.Popup("是否将goagent.exe加入到启动项？(本对话框6秒后消失)", 6, "GoAgent 对话框", vbOKCancel+vbQuestion) = 1 Then
        If WshShell.Popup("是否显示托盘区图标？", 5, "GoAgent 对话框", vbOKCancel+vbQuestion) = 1 Then
            strTargetPath = """" & WshShell.CurrentDirectory & "\goagent.exe"""
        Else
            strTargetPath = """" & WshShell.CurrentDirectory & "\python27.exe"""
        End If

        CreateShortcut(strTargetPath)
        WriteIniVisible "0"

        WshShell.Popup "成功加入GoAgent到启动项", 5, "GoAgent 对话框", vbInformation
    End If
End Sub

Main
