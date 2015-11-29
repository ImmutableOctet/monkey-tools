Strict

Public

' Imports:
Import brl.filestream
Import brl.filesystem
Import brl.filepath
Import brl.process

' Functions:
Function Main:Int()
	Local Arguments:= AppArgs() ' ["reserved", "data", "directory.txt"]
	Local Master:= New Folder(Arguments[1])
	
	For Local Entry:= Eachin LoadDir(Master.Name, True)
		Local RealPath:= (Master.Name + "/" + Entry)
		
		Local Parent:= GetFolderFromPath(Master, RealPath)
		
		Select FileType(RealPath)
			Case FILETYPE_FILE
				Parent.Files.PushLast(StripDir(Entry))
			Case FILETYPE_DIR
				Parent.SubFolders.PushLast(New Folder(StripDir(Entry)))
		End Select
	Next
	
	Local F:= FileStream.Open(Arguments[2], "w")
	
	WriteFileSystem(F, Master)
	
	F.Close()
	
	Return 0
End

Function WriteFileSystem:Void(S:Stream, F:Folder, Offset:Int=1)
	Local Base:String
	
	For Local I:= 1 Until Offset
		Base += "~t"
	Next
	
	If (Base.Length > 0) Then
		S.WriteString(Base)
	Endif
	
	S.WriteLine(F.Name)
	
	S.WriteString(Base)
	S.WriteLine("{")
	
	Local Tabs:= Base+"~t"
	
	Local Files:= F.Files
	
	If (Not Files.IsEmpty) Then
		S.WriteString(Tabs)
		S.WriteString("!")
		
		For Local I:= 0 Until (Files.Length - 1)
			S.WriteString(Files.Get(I))
			S.WriteString(",")
		Next
		
		S.WriteLine(Files.Get(Files.Length-1))
	Endif
	
	Local Folders:= F.SubFolders

	For Local F:= Eachin Folders
		WriteFileSystem(S, F, Offset+1)
	Next
	
	S.WriteString(Base)
	S.WriteLine("}")
	
	Return
End

Function GetFolderByName:Folder(Master:Folder, FolderName:String)
	For Local F:= Eachin Master.SubFolders
		If (F.Name = FolderName) Then
			Return F
		Endif
	Next
	
	Return Null
End

Function GetFolderFromPath:Folder(Master:Folder, Path:String)
	If (Not Path.Contains("/")) Then
		Return Master
	Endif
	
	Local Folders:= Path.Split("/")
	
	Local F:Folder = Master
	
	For Local I:= 0 Until (Folders.Length - 1)
		Local NextFolder:= GetFolderByName(F, Folders[I])
		
		If (NextFolder <> Null) Then
			F = NextFolder
		Endif
	Next
	
	Return F
End

' Classes:
Class Folder
	' Constructor(s):
	Method New(Name:String)
		Self.Name = Name
	End
	
	' Fields:
	Field Name:String
	Field SubFolders:= New Deque<Folder>()
	Field Files:= New Deque<String>()
End