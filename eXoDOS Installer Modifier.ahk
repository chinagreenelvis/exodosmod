#NoEnv
#SingleInstance force
#Persistent
SetWorkingDir %A_ScriptDir%

;; Skip install prompts

Loop Files, eXoDOS\Games\!dos\*.bat, FR
{
	;MsgBox, %A_LoopFileName%
	If (A_LoopFileName = "install.bat")
	{
		FileRead, BatFile, %A_LoopFileFullPath%
		FileDelete,  %A_LoopFileFullPath%
		ReplacedStr := StrReplace(BatFile, "goto config", "goto end", , 1)
		FileAppend, %ReplacedStr%, %A_LoopFileFullPath%
	}
	Else
	{
		FileRead, BatFile, %A_LoopFileFullPath%
		FileDelete,  %A_LoopFileFullPath%
		ReplacedStr := StrReplace(BatFile, "echo Game has not been installed", "goto yes", , 1)
		FileAppend, %ReplacedStr%, %A_LoopFileFullPath%
	}
}

;; .conf file settings. Defaults are fullscreen=true, fullresolution=original, output=overlay, aspect=true, scaler=none

Loop Files, eXoDOS\Games\!dos\dosbox.conf, FR
{
	;MsgBox, %A_LoopFileFullPath%
	
	IniWrite, true, %A_LoopFileFullPath%, sdl, fullscreen
	IniWrite, original, %A_LoopFileFullPath%, sdl, fullresolution
	IniWrite, overlay, %A_LoopFileFullPath%, sdl, output
	IniWrite, true, %A_LoopFileFullPath%, render, aspect
	 
	;; SCALER OPTIONS: none, normal2x, normal3x, hq2x, hq3x, 2xsai, super2xsai, advmame2x, advmame3x, tv2x, normal2x
	IniWrite, none, %A_LoopFileFullPath%, render, scaler
}

;; Lowers MIDI music volume across the board, edit individual .conf files to adjust mixer fm value

Loop Files, eXoDOS\Games\!dos\dosbox.conf, FR
{
	;MsgBox, %A_LoopFileName%
	FileRead, ConfFile, %A_LoopFileFullPath%
	FileDelete,  %A_LoopFileFullPath%
	ReplacedStr := StrReplace(ConfFile, "[AutoExec]", "[AutoExec]`nmixer fm 20", , 1)
	FileAppend, %ReplacedStr%, %A_LoopFileFullPath%
}

MsgBox, Defaults set!

ExitApp