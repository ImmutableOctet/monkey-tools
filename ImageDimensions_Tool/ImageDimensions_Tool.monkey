Strict

Public

' Imports:
Import imagedimensions
'Import ioutil

Import brl.process

' Functions:
Function Main:Int()
	Local Args:= AppArgs()
	
	If (Args.Length <= 1) Then
		Print("Please supply at least one image path.")
	Elseif (Args.Length < 3) Then
		Local Path:= Args[1].Replace("~q", "")
		Local Size:= LoadImageDimensions(Path)
		
		Print("Image dimensions for ~q"+Path+"~q:")
		Print(String(Size[0]) + "x" + String(Size[1]))
	Else
		For Local I:= 1 Until Args.Length
			Local Size:= LoadImageDimensions(Args[I].Replace("~q", ""))
			
			Print("|"+I+"|: " + String(Size[0]) + "x" + String(Size[1]))
		Next
	Endif
	
	' Return the default response.
	Return 0
End