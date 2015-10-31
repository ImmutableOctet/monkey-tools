#Rem
	This tool takes the text (Map) output from "Sprite Sheet Packer",
	and re-encodes it into a slightly more optimal, binary format.
	
	The main purpose of this is to reduce parsing overhead
	and memory consumption as much as possible.
	
	The tool in question can be found here:
	https://spritesheetpacker.codeplex.com
#End

Strict

Public

' Imports:
Import regal.stringutil
Import regal.autostream
Import regal.ioelement

'Import regal.argumentloader

Import brl.process
Import brl.filepath

' Constant variable(s):
Const FORMAT_TYPE:= 0
Const FORMAT_EXTENSION:String = ".osf"
Const ENTRIES_PER_SPRITE:= 4

' Functions:
Function Main:Int()
	Local Arguments:= AppArgs()
	Local Arguments_Length:= Arguments.Length
	
	For Local I:= 1 Until Arguments_Length Step 2
		If (I+1 >= Arguments_Length) Then
			Local Path:= Arguments[I]
			
			Encode(Path, (StripExt(Path) + FORMAT_EXTENSION))
		Else
			Encode(Arguments[I], Arguments[I+1])
		Endif
	Next
	
	' Return the default response.
	Return 0
End

Function Encode:Void(Path:String, OutPath:String)
	Local In:= OpenAutoStream(Path, "r")
	Local Out:= OpenAutoStream(OutPath, "w")
	
	Encode(In, Out)
	
	CloseAutoStream(In)
	CloseAutoStream(Out)
	
	Return
End

Function Encode:Void(In:Stream, Out:Stream)
	Out.WriteByte(FORMAT_TYPE)
	
	Local Entries:Int = 0
	Local Count_Position:= Out.Position
	
	Out.WriteInt(Entries)
	
	#If CONFIG = "debug"
		DebugLog("Encoding file:")
	#End
	
	While (Not In.Eof())
		Local Line:= In.ReadLine()
		
		#If CONFIG = "debug"
			DebugLog(Line)
		#End
		
		Local Equals_Location:= Line.Find("= ")
		Local Parse_Location:= (Equals_Location+1)
		
		If (Equals_Location = STRING_INVALID_LOCATION Or Parse_Location >= Line.Length) Then
			Continue
		Endif
		
		Local Name:= Line[..(Equals_Location-1)]
		Local Data:= Line[(Parse_Location+1)..].Split(stringutil.Space)
		
		If (Data.Length < ENTRIES_PER_SPRITE) Then
			Continue
		Endif
		
		IOElement.WriteString(Out, Name)
		
		For Local I:= 0 Until ENTRIES_PER_SPRITE ' Data.Length
			Out.WriteShort(Int(Data[I]))
		Next
		
		Entries += 1
	Wend
	
	Local Position:= Out.Position
	
	Out.Seek(Count_Position)
	
	Out.WriteInt(Entries)
	
	Out.Seek(Position)
	
	Return
End