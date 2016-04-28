Strict

Public

' Imports:
Import brl.filesystem
Import brl.process
Import brl.filestream

Import regal.stringutil

' Functions:
Function Main:Int()
	Local Arguments:= AppArgs() ' ["RESERVED", ""]
	
	Local Recursive:Bool = False ' True
	
	Local TargetPath:String
	
	If (Arguments.Length >= 2) Then
		TargetPath = Arguments[1]
		
		If (Arguments.Length >= 3) Then
			Recursive = Bool(Int(Arguments[2]))
		Endif
	Endif
	
	ChangeDir(TargetPath)
	
	Local TotalLines:Int = 0
	
	For Local Path:= Eachin LoadDir(TargetPath, Recursive)
		Local S:= FileStream.Open(Path, "r")
		
		If (S <> Null And Not S.Eof()) Then ' Eof
			Local Content:= S.ReadString()
			
			S.Close()
			
			Local LineCount:= CountLines(Content)
			
			Print("~q" + Path + "~q : " + LineCount)
			
			TotalLines += LineCount
		Endif
	Next
	
	Print("Total lines found: " + TotalLines)
	
	Return 0
End

Function CountLines:Int(content:String)
	Local Lines:Int = 0
	Local Position:Int = STRING_INVALID_LOCATION
	
	Repeat
		Position = content.Find("~n", (Position + 1))
		
		If (Position <> STRING_INVALID_LOCATION) Then
			Lines += 1
		Else
			Exit
		Endif
	Forever
	
	Return Lines
End