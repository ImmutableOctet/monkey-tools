Strict

Public

' Imports:
Import brl.process ' os

' Functions:
Function Main:Int()
	Local Args:= AppArgs()
	
	Print("Arguments:")
	
	For Local I:= 1 Until Args.Length
		Print(Args[I])
	Next
	
	' Return the default response.
	Return 0
End