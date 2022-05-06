#SingleInstance,Force
#NoTrayIcon
Menu, Tray, Icon, C:\Windows\System32\shell32.dll, 287
CoordMode, ToolTip, Screen
SetTitleMatchMode, 3 
DetectHiddenWindows,On 


timerm := "00"
timers := "00"
stopped := "0"


Gui,+AlwaysOnTop +LastFound +E0x20
Gui, Font, s12 bold
Gui, Add, Text, x120 y65 w60 h20 vTText, %timerm%:%timers%
Gui, Font, s42 cpurple
Gui, Add, Button, x12 y9 w50 h50 grec, ●
Gui, Font
Gui, Font, s30 
Gui, Add, Button, x72 y9 w50 h50 gpause, ■
Gui, Font
Gui, Font, s9
Gui, Add, Button, x132 y9 w130 h50 gopen, Abrir as gravações
Gui, Show, w273 h90, Gravador de Tela
Gui, -MaximizeBox 
Gui, -MinimizeBox 
return

GuiClose:
Process, Close, ffmpeg.exe
ExitApp


Stopwatch:
timers += 1
if(timers > 59)
{
	timerm += 1
	timers := "0"
	GuiControl, , TText ,  %timerm%:%timers%
}
if(timers < 10)
{
	GuiControl, , TText ,  %timerm%:0%timers%
}
else
{
	GuiControl, , TText ,  %timerm%:%timers%
}
return

rec:

 
    SplashTextOn,300,100, Iniciar Gravação, `n* A Gravação irá iniciar em 3 segundos. * `n* Pressione CTRL+SHIFT+S para parar a gravação. * 
    Sleep 3000
    SplashTextOff 
        FileName:=A_Desktop . "\" . A_Now . ".mp4" 
    
    ; Change this parameters to meet your needs / hardware
    ff_params = -f gdigrab -video_size 1920x1080 -framerate 10 -i desktop  -pix_fmt yuv420p -f mp4 %FileName%
 
    ; Run ffmpeg and start recording
    Run ffmpeg %ff_params%,,hide UseErrorLevel ;run ffmpeg with command parameters
    Sleep 1000
    Settimer, Stopwatch, 1000
    if ErrorLevel = ERROR
        MsgBox 0x10, Software Failure, Press OK to continue. `n`nTry this to solve:`n1. Download ffmpeg.exe and place it next to this script.`n2. Edit ff_params to meet your needs / hardware.


Return

pause:

  ControlSend, , ^c, ahk_class ConsoleWindowClass  ; send ctrl-c to command window which stops the recording
 
    SplashTextOn,300,100, Gravação parada, `n* Verifique o arquivo em sua área de trabalho. *
    Sleep 3000
    SplashTextOff 
    if(stopped = 0)
{
	Settimer, Stopwatch, off
	stopped = 1
}
else
{
	Settimer, Stopwatch, 999
	stopped = 0
}
timerm := "00"
timers := "00"
GuiControl, , TText ,  %timerm%:%timers%
timerm := "00"
timers := "00"
GuiControl, , TText ,  %timerm%:%timers%
return


open:
Run, %A_Desktop%
return

