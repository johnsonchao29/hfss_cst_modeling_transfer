Dim oHfssApp
Dim oDesktop
Dim oProject
Dim oDesign
Dim oEditor
Dim oModule

Set oHfssApp  = CreateObject("AnsoftHfss.HfssScriptInterface")
Set oDesktop = oHfssApp.GetAppDesktop()
oDesktop.RestoreWindow
oDesktop.NewProject
Set oProject = oDesktop.GetActiveProject

oProject.InsertDesign "HFSS", "transfertype", "DrivenModal", ""
Set oDesign = oProject.SetActiveDesign("transfertype")
Set oEditor = oDesign.SetActiveEditor("3D Modeler")

oEditor.CreateBox _
Array("NAME:BoxParameters", _
"XPosition:=", "-4.800000mm", _
"YPosition:=", "-1.000000mm", _
"ZPosition:=", "0.000000mm", _
"XSize:=", "9.600000mm", _
"YSize:=", "2.000000mm", _
"ZSize:=", "4.800000mm"), _
Array("NAME:Attributes", _
"Name:=", "1", _
"Flags:=", "", _
"Color:=", "(132 132 193)", _
"Transparency:=", 0.75, _
"PartCoordinateSystem:=", "Global", _
"MaterialName:=", "vacuum", _
"SolveInside:=", true)

oEditor.CreateBox _
Array("NAME:BoxParameters", _
"XPosition:=", "7.800000mm", _
"YPosition:=", "-0.500000mm", _
"ZPosition:=", "1.400000mm", _
"XSize:=", "2.200000mm", _
"YSize:=", "1.000000mm", _
"ZSize:=", "2.000000mm"), _
Array("NAME:Attributes", _
"Name:=", "2", _
"Flags:=", "", _
"Color:=", "(132 132 193)", _
"Transparency:=", 0.75, _
"PartCoordinateSystem:=", "Global", _
"MaterialName:=", "vacuum", _
"SolveInside:=", true)

oEditor.CreateRectangle _
Array("NAME:RectangleParameters", _
"IsCovered:=", true, _
"XStart:=", "4.800000mm", _
"YStart:=", "-1.000000mm", _
"ZStart:=", "0.000000mm", _
"Width:=", "2.000000mm", _
"Height:=", "4.800000mm", _
"WhichAxis:=", "X"), _
Array("NAME:Attributes", _
"Name:=", "3", _
"Flags:=", "", _
"Color:=", "(132 132 193)", _
"Transparency:=", 7.500000e-01, _
"PartCoordinateSystem:=", "Global", _
"MaterialName:=", "vacuum", _
"SolveInside:=", true)

oEditor.CreateRectangle _
Array("NAME:RectangleParameters", _
"IsCovered:=", true, _
"XStart:=", "7.800000mm", _
"YStart:=", "-0.500000mm", _
"ZStart:=", "1.400000mm", _
"Width:=", "1.000000mm", _
"Height:=", "2.000000mm", _
"WhichAxis:=", "X"), _
Array("NAME:Attributes", _
"Name:=", "temp2", _
"Flags:=", "", _
"Color:=", "(132 132 193)", _
"Transparency:=", 7.500000e-01, _
"PartCoordinateSystem:=", "Global", _
"MaterialName:=", "vacuum", _
"SolveInside:=", true)

oEditor.Connect _
Array("NAME:Selections", _
"Selections:=", _
"3,temp2")

oEditor.CreateBox _
Array("NAME:BoxParameters", _
"XPosition:=", "-2.000000mm", _
"YPosition:=", "-1.000000mm", _
"ZPosition:=", "4.800000mm", _
"XSize:=", "2.000000mm", _
"YSize:=", "2.000000mm", _
"ZSize:=", "2.000000mm"), _
Array("NAME:Attributes", _
"Name:=", "4", _
"Flags:=", "", _
"Color:=", "(132 132 193)", _
"Transparency:=", 0.75, _
"PartCoordinateSystem:=", "Global", _
"MaterialName:=", "vacuum", _
"SolveInside:=", true)
