#Rem
	ATTENTION:
		* This tool requires use of the GLFW target by default.
		To build with STDCPP / C++ Tool, disable 'CRCTOOL_NOTIFY'.
#End

Strict

Public

' Preprocessor related:
#HASH_EXPERIMENTAL = True

#If TARGET <> "stdcpp"
	#CRCTOOL_NOTIFY = True
#End

' Imports:
Import regal.hash
Import regal.time
Import regal.stringutil

Import brl.process
Import brl.filestream

#If CRCTOOL_NOTIFY
	Import brl.requesters
#End

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
	
	#If CRCTOOL_NOTIFY
		Local ShouldNotify:Bool = True
		
		If (Args_Length > 2) Then
			ShouldNotify = StringToBool(Args[2])
		Endif
	#End
	
	Local Hash:CRC32Hash
	Local BeginTime:Int, TimeTaken:Int
	
	Local F:= FileStream.Open(Args[1], "r")
	
	If (F = Null) Then
		Print("Unable to load file.")
		
		Return ERROR_CODE
	Else
		BeginTime = Millisecs()
		
		Local FileData:= F.ReadAll()
		
		Hash = CRC32InHex(FileData, FileData.Length)
		
		TimeTaken = (Millisecs()-BeginTime)
		
		F.Close()
	Endif
	
	Print("0x" + Hash)
	Print("That took " + TimeTaken + "ms.")
	
	#If CRCTOOL_NOTIFY
		If (ShouldNotify) Then
			Notify("CRC32: ~q" + Args[1] + "~q", "0x" + Hash + " (" + TimeTaken + "ms)", False)
		Endif
	#End
	
	' Return the default response.
	Return 0
End