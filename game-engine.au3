#Region		includes
#include <GUIConstantsEx.au3>
#include <MsgBoxConstants.au3>
#include <WindowsConstants.au3>
#include <StructureConstants.au3>
#include <AutoItConstants.au3>
#include <GUIConstantsEx.au3>
#include <GuiMenu.au3>
#include <EditConstants.au3>
#include <WinAPIFiles.au3>
#include <FileConstants.au3>
#include <Misc.au3>
#include <StaticConstants.au3>
#include <SendMessage.au3>
#include <WinAPI.au3>
#include <ButtonConstants.au3>
#include <File.au3>
#include <WinAPIDlg.au3>
#include <Array.au3>
#include <String.au3>
#include <StringConstants.au3>

Opt("GUIOnEventMode", 1)
AutoItSetOption("PixelCoordMode", 0)
AutoItSetOption("MouseCoordMode", 0)
   global $idgame = GUICreate("game engine", 300, 300, -1, -1)

   global $idshow = GUICtrlCreatePic("", 0,0,300,200)

   global $idhead = GUICtrlCreatePic("", 0,125,75,75)

   GUICtrlcreateGraphic(0,200,300,100,$SS_WHITERECT)

   global $idspeaker = GUICtrlCreateLabel("", 10, 205, 100, 20)
   guictrlsetdata(-1, "Name")

   global $idspeech = GUICtrlCreateLabel("", 10, 225, 280, 65)
   guictrlsetdata(-1, "Text they are saying goes here. Text they are saying goes here. Text they are saying goes here. Text they are saying goes here. ")

GUISetOnEvent($GUI_EVENT_CLOSE, "X")
GUISetState()

Func X()
  Exit
EndFunc


 #endregion


global $script = FileReadToArray("script.txt")
_arrayinsert($script, 0, ubound($script))
global $sp = ""		;params as string
global $ap[1]		;params as array
global $pause = false
global $echo = false
global $line = 1
global $s = ''
global $a[1000]

global $o_chatspeed = 20



parse()

func parse()
   while $line <= $script[0]
   ;get current $line in [$s]tring and [$a]rray format
	  $s = string($script[$line])
	  $a = StringSplit($s, ' ')

   ;preprocessor
	  expandmacro()
	  expandvars()
	  expandmath()
	  setparams()

   ;engine variables
	  title()
	  echo()

   ;game variables
	  setmacro()
	  setvar()
	  sethead()

   ;flow
	  if()
   	  ;end()
	  goto()
	  wait()
	  ;rem()

   ;engine behavior
	  show()
	  say()

	  $line+=1

   WEnd

EndFunc

func setmacro(); [@w] [say] [wizard]
   if StringLeft($a[1], 1) = '@' then ;define a new macro if line starts with @
	  local $value = _arraytostring($a, ' ', 2)	;	say w
	  local $name = StringTrimLeft($a[1], 1)	;	w
	  assign('m_' & $name, $value, 2)			;	$m_w = say w

	  if $echo then msgbox(0,'setmacro - ' & $s, $name & ': ' & eval('m_' & $name))

   EndIf

EndFunc


func expandmacro();		macro expansion
   if eval('m_' & $a[1]) then ;check if a[1] is a macro. if $a[1] is a macro then expand the macro to its value and replace/update $s and $a
	  $a[1] = eval('m_' & $a[1])

	  _ArrayDelete($a, 0)
	  $s = _ArrayToString($a, ' ')
	  $a = StringSplit($s, ' ')



	  if $echo then msgbox(0,'expand macro', $a[1] & @CRLF & $s)	;w

   EndIf

EndFunc



func expandvars();	variable substitution
   local $regex[100]
   while 1	;regex for chars contained in []

	  $regex = StringRegExp($s, '(\[.*\])', $STR_REGEXPARRAYMATCH)		;return [gold]
	  if not @error then	;regex[0] = [gold]
		 local $name = stringtrimright(StringTrimLeft($regex[0], 1), 1)	;return	gold
		 local $value = eval('s_' & $name)								;return	25

		 $s = StringReplace($s, $regex[0], $value, 1, 0)
		 $a = Stringsplit($s, ' ')

		 if $echo then msgbox(0, 'expand vars - ', $name &': '& $value & @CRLF & $s)

	  Else
		 ExitLoop

	  EndIf

   WEnd

EndFunc



func expandmath();		evaluate math expressions
   local $regex[5]
   while 1	;do regex and look for chars contained in { }		'(\(.*\))'	original, doesnt work		'(\([^()[:alpha:]]*\))'		revised, works
	  local $regex = StringRegExp($s, '(\([^()[:alpha:]]*\))', $STR_REGEXPARRAYMATCH)	;return {5 + 5}
	  if not @error Then ;need to get (1) from (1)text(2)


		 _arraydisplay($regex)

		 ;local $name = stringtrimright(StringTrimLeft($regex[0], 1), 1)	;	return	5 + 5
		 local $name = $regex[0]
		 local $value = execute($name)							;			return	10

		 $s = StringReplace($s, $regex[0], $value, 1, 0)
		 $a = Stringsplit($s, ' ')

		 if $echo then msgbox(0, 'expand math - ', $name &': '& $value & @CRLF & $s)

	  Else
		 ExitLoop

	  EndIf

   WEnd

EndFunc


func setparams()
   $ap = $a
   _arraydelete($ap,0) ;remove a[1]
   _arraydelete($ap,0) ;remove a[1]

   $sp = _ArrayToString($ap, ' ')

EndFunc


func setvar()

   if $a[1] = 'set' then 	;set variable a[2] to a[3]+
	  ;if $echo then msgbox(0,'setvar - ' & $s, $a[1] & @CRLF & $sp, 100)

	  local $array = $ap
	  local $name = $ap[0]
	  _arraydelete($ap,0) ;remove ap[1]
	  local $value = $ap
	  local $svalue = _ArrayToString($value, ' ')

	  assign('s_' & $name, $svalue, 3)

	  if $echo then msgbox(0, 'setvar - ' & $s, $name & ': '& $svalue)

   EndIf

EndFunc


func if()
   if $a[1] = 'goto' then	;


   EndIf
endif


func goto()
   if $a[1] = 'goto' then	;
	  local $count = 1
	  local $string = ''

	  while $count < $script[0]
		 $string = $script[$count]
		 ;msgbox(0, 'comparing', $a[2] & '/' & $string, 100)

		 if $string = $a[2] then
			if $echo then msgbox(0, $script[$line], 'going to line ' &@CRLF& $script[$count])
			$line =  number($count)
			Return

		 Else
			;msgbox(0, 'false', 'checking line ' & $count, 100)
			$count = number($count + 1)


		 EndIf

	  WEnd

   EndIf
EndFunc


func say()
   if $a[1] = 'say' then ;say dialogue. a[2] is the name of the speaker, a[3]+ ($text) is the dialogue spoken
	  local $speaker = $a[2]
	  _arraydelete($ap, 0)
	  local $speech = _arraytostring($ap, ' ')

	  dialogue($speaker, $speech)

   EndIf
EndFunc



func dialogue($speaker, $speech)
   if $echo then msgbox(0,'dialogue', $speaker & ': ' & $speech, 100)


   if IsDeclared('h_' & $speaker) then
	  if $echo then msgbox(0,'head true', eval('h_' & $speaker), 100)
	  GUICtrlSetImage($idhead, eval('h_' & $speaker))

   Else
	  if $echo then msgbox(0,'head false', eval('h_' & $speaker), 100)

   EndIf



   GUICtrlSetData($idspeaker, $speaker)

   local $count = 1
   While $count <= stringlen($speech)	;	chat chunker
	  GUICtrlSetData($idspeech, StringLeft($speech, $count))
	  sleep($o_chatspeed)

	  $count = number($count + 1)

   WEnd

   $pause = true
   while $pause = true
	  HotKeySet('{space}', "continue")

   WEnd
   sleep(300)

EndFunc


func continue()
   If WinActive("[TITLE:Game]") Then
	  $pause = false
	  HotKeySet('{space}')

   EndIf
EndFunc


func sethead()	;0-# 	1-head 		2-w 	3-wizzar.jpg
   if $a[1] = 'head' then ;set variable 'z' + a[2] to filename a[3]
	  Assign('h_' & $a[2], $a[3], 2)

	  if $echo then msgbox(0, 'sethead', $a[2] &': '& eval('h_' & $a[2]), 100)

   EndIf
EndFunc



func show()	;	[#]	[show]	[picture.jpg]
   if $a[1] = 'show' then ;change background to a[2]
	  GUICtrlSetImage($idshow, $a[2])
	  GUISetState()

	  if $echo then msgbox(0, "show", $a[2])

   EndIf
EndFunc



func wait()
   if $a[1] = 'wait' then ;pause for a[2] seconds
	  sleep(number($a[2] * 1000))

   EndIf
EndFunc



func end()
   if $a[1] = 'end' then ;exit program
	  exit

   EndIf
EndFunc



func rem()
   if $a[1] = 'rem' then ;line is remark/comment, do nothing

   EndIf
EndFunc

func title()
   if $a[1] = 'title' then ;turn [echo] [on/off]
	  local $newtitle = $a[2]
	  WinSetTitle($idgame, "", $newtitle)

   EndIf
EndFunc


func echo()
   if $a[1] = 'echo' then ;turn [echo] [on/off]

	  if $a[2] = 'off' then
		 $echo = False

	  Elseif $a[2] = 'on' then
		 $echo = True
		  if $echo then msgbox(0, 'echo', 'echo turned on', 100)

	  EndIf

   EndIf
EndFunc




while 1
   sleep(1000)
WEnd