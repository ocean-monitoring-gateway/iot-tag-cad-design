Dim WshShell
Set WshShell = WScript.CreateObject("WScript.Shell")

Dim swApp
Set swApp = CreateObject("SldWorks.Application")

set fso = CreateObject("Scripting.FileSystemObject")

strCurDir = WshShell.CurrentDirectory

Dim Message, Title, Default, StartValue, EndValue
Message = "Enter Start value"    ' Set prompt.
Title = "InputBox Demo"    ' Set title.
Default = "1"    ' Set default.
' Display message, title, and default value.
StartValue = InputBox(Message, Title, Default)
'------------------------------------------------
Message = "Enter End value"    ' Set prompt.
Title = "InputBox Demo"    ' Set title.
Default = "1"    ' Set default.
' Display message, title, and default value.
EndValue = InputBox(Message, Title, Default)

Dim fileBase
fileBase = BrowseForFile


For i=StartValue To EndValue Step 1
	Dim fileName
	fileName = Right(i + 100000,3)
	'----------------------------------------------------------
	fso.CopyFile fileBase , strCurDir & "\STL\" & fileName & ".SLDPRT"
	'----------------------------------------------------------
	Set swModel = swApp.OpenDoc(strCurDir & "\STL\" & fileName & ".SLDPRT",1)
	swModel.EditRebuild()
	Dim value
	value = swModel.SaveAs3(strCurDir & "\STL\" & fileName & ".stl", 0, 2)
	swApp.CloseDoc swModel.GetTitle()
	fso.DeleteFile strCurDir & "\STL\" & fileName & ".SLDPRT" 
Next



'-----------------------------------------------------------------------
Function SaveAsStl(fileName)
'@description: Save model from filePath to .stl file with  fileName.
If filePath = "" Then
  MsgBox "Operation canceled", vbcritical
Else
	Dim docSpec
	Set docSpec = swApp.GetOpenDocSpec(filePath)
	docSpec.ReadOnly = True
	docSpec.Silent = True
	Dim swModel
	Set swModel = swApp.OpenDoc7(docSpec)
	Dim value
	value = swModel.SaveAs3(fileName & ".stl", 0, 2)
	swApp.CloseDoc swModel.GetTitle()
End If
End Function
'--------------------------------------------------------------------------------------
Function BrowseForFile()
    With CreateObject("WScript.Shell")
        Dim fso : Set fso = CreateObject("Scripting.FileSystemObject")
        Dim tempFolder : Set tempFolder = fso.GetSpecialFolder(2)
        Dim tempName : tempName = fso.GetTempName() & ".hta"
        Dim path : path = "HKCU\Volatile Environment\MsgResp"
        With tempFolder.CreateTextFile(tempName)
            .Write "<input type=file name=f>" & _
            "<script>f.click();(new ActiveXObject('WScript.Shell'))" & _
            ".RegWrite('HKCU\\Volatile Environment\\MsgResp', f.value);" & _
            "close();</script>"
            .Close
        End With
        .Run tempFolder & "\" & tempName, 1, True
        BrowseForFile = .RegRead(path)
        .RegDelete path
        fso.DeleteFile tempFolder & "\" & tempName
    End With
End Function
'-----------------------------------------------------------------------
Sub Pause(NSeconds)
    Wscript.Sleep(NSeconds*1000)
End Sub