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
	Local FileSuffix:String
	
	If (Arguments.Length >= 2) Then
		TargetPath = Arguments[1]
		
		If (Arguments.Length >= 3) Then
			FileSuffix = Arguments[2]
			
			If (Arguments.Length >= 4) Then
				Recursive = Bool(Int(Arguments[3]))
			Endif
		Endif
	Endif
	
	ChangeDir(TargetPath)
	
	Local TotalLines:Int = 0
	Local EntriesLoaded:Int = 0
	
	For Local Path:= Eachin LoadDir(TargetPath, Recursive)
		If (Path.EndsWith(FileSuffix)) Then
			Local S:= FileStream.Open(Path, "r")
			
			If (S <> Null And Not S.Eof()) Then ' Eof
				Local Content:= S.ReadString()
				
				S.Close()
				
				Local LineCount:= CountLines(Content)
				
				EntriesLoaded += 1
				
				Print("[" + EntriesLoaded + "] ~q" + Path + "~q : " + LineCount)
				
				TotalLines += LineCount
			Endif
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