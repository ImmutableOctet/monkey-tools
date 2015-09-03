#Rem
	ATTENTION:
		* This tool requires use of the GLFW target by default.
		To build with STDCPP / C++ Tool, disable 'MD5TOOL_NOTIFY'.
#End

Strict

Public

' Preprocessor related:
#If TARGET <> "stdcpp"
	#MD5TOOL_NOTIFY = True
#End

' Imports:
Import hash
Import stringutil

Import brl.process
Import brl.filestream
Import brl.requesters

' Functions:
Function Main:Int()
	' Constant variable(s):
	Const ERROR_CODE:Int = 1 ' -1
	
	' Local variable(s):
	Local Args:= AppArgs()
	Local Args_Length:= Args.Length
	
	If (Args_Length < 2) Then
		Return ERROR_CODE
	Endif
	
	#If MD5TOOL_NOTIFY
		Local ShouldNotify:Bool = True
		
		If (Args_Length > 2) Then
			ShouldNotify = StringToBool(Args[2])
		Endif
	#End
	
	Local F:= FileStream.Open(Args[1], "r")
	
	If (F = Null) Then
		Return ERROR_CODE
	Endif
	
	Local Hash:= MD5(F)
	
	F.Close()
	
	Print(Hash)
	
	#If MD5TOOL_NOTIFY
		If (ShouldNotify) Then
			Notify("MD5: ~q" + Args[1] + "~q", Hash, False)
		Endif
	#End
	
	' Return the default response.
	Return 0
End