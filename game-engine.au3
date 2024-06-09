#Region		boilerplate
#include <Date.au3>
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
   global $idgame = GUICreate("Game Engine", 300, 300, -1, -1)

   global $idshow = GUICtrlCreatePic("", 0,0,300,200)

   global $idhead = GUICtrlCreatePic("", 0,125,75,75)

   GUICtrlcreateGraphic(0,200,300,100,$SS_WHITERECT)

   global $idspeaker = GUICtrlCreateLabel("", 10, 205, 280, 20)
   guictrlsetdata(-1, "Speaker name")

   global $idspeech = GUICtrlCreateLabel("", 10, 225, 280, 65)
   guictrlsetdata(-1, "Text they are saying goes here.")

GUISetOnEvent($GUI_EVENT_CLOSE, "X")
GUISetState()
Func X()
Exit
EndFunc



global const			 $s_pi = 3.14159265358979323846
global const			$s_tau = $s_pi*2
global const		 $s_golden = 1.61803398874989484820
global Const		  $s_euler = 2.71828182845904523536

global $script = FileReadToArray("script.txt")
_arrayinsert($script, 0, ubound($script))
global $sp = ""		;params as string
global $ap[1]		;params as array
global $pause = false
global $echo = false
global $line = 1
global $difference = 0
global $s = ''
global $a[1000]
global $s_time = 'time'

global $choice[1]
global $s_choice = ''
global $history[1]
	   $history[0] = 'history'
global $o_chatspeed = 20
global $o_title = 'Game Engine'

#EndRegion


script()

func script()
   while $line <= $script[0]
	  $s = string($script[$line])		;set (s)tring as current line of script
	  $s = StringReplace($s,@TAB,"")	;remove tabs from (s)
	  $a = StringSplit($s, ' ')			;set (a)rray to (s) delimited by spaces
	  $s_time = _NowTime()

	  if $a[1] then	;skips empty lines
		 if ubound($history) = 0 then _arrayadd($history, 'history')
		 if $echo then _arraydisplay($history)
		 if $echo then msgbox(0,'current line:' & $line, $s)

		 ;BEFORE
		 prefixcheck()
		 expandmacro()
		 expandvars()
		 expandmath()
		 setparams()

		 ;MAIN ROUTINE
		 master()

	  EndIf

	  $line+=1		;advance line down by 1

   WEnd

EndFunc



func master()
   if $echo then msgbox(0,'master', 'a[1] is ' & $a[1])
   local $prefix = stringleft($history[number(ubound($history, 1)-1)], 2)

   ;NEGATIVE FLAG ROUTINES
   if $prefix = 'in' or $prefix = 'x' or $prefix = 'wn' Then
	  switch $a[1]
		 case 'if', 'case'
			iftrue()

		 case 'end', 'else'
			end()

		 case 'while'
			loopwhile()

		 case 'choice'
			choice()

		 ;case 'case' ;do i need to add in cases?
			;kase()

	  EndSwitch

   ;CHOICE FLAG ROUTINES
   elseif $prefix = 'ch' Then
	  choicebuild()
	  end()
	  _arraydisplay($choice)

   ;NORMAL ROUTINES
   else
	  switch $a[1]
		 ;CONFIG
		 case 'title'
			title()
		 case 'debug'
			debug()


		 ;OUTPUT
		 case 'show'
			show()

		 case 'say'
			say()


		 ;INPUT
		 case '@'
			setmacro()

		 case 'math'
			;nothing

		 case 'set'
			setvar()

		 case 'head'
			sethead()


		 ;MISC
		 case 'if', 'case'
			iftrue()

		 case 'end', 'else'
			end()

		 case 'wait'
			wait()

		 case 'rem'
			rem()

		 case 'exit'
			endscript()

		 case 'choice'
			choice()


		 ;JUMPS
		 case 'while'
			loopwhile()

		 case 'call', 'return'
			subroutine()

		 case 'goto'
			goto()

	  EndSwitch

   EndIf
EndFunc



func choice()
   local $speaker = _ArrayToString($a, ' ', 2)	;convert array to string
   msgbox(0, 'TEST', $speaker)
   _ArrayAdd($history, 'ch' & $speaker)

EndFunc


func choicebuild()
   if $a[1] = 'end' Then return
   $choice[0] = $choice[0] & stringleft($a[1], 1)
   _ArrayAdd($choice, $s)

EndFunc


func choose()
   global $choicechars = $choice[0]
   _arraydelete($choice, 0)
   local $string = _arraytostring($choice, @CRLF)
   local $speaker = stringtrimleft($history[number(ubound($history, 1)-1)], 2)	;strip [ch] from flag to get the speaker

   dialogue($speaker, $string)

EndFunc


;BEFORE - ORDERING
;prefixcheck - [ ]might eventually remove this as we have block flags for conditions instead of prefixes
;expandmacro - [ ] might remove this just to keep things simple. in its place we can just implement keyword renaming
;expandvars  - [x] necessary.
;expandmath  - [x] necessary. this is what we will need to change if we want lisp-style (math x y) type stuff
;setparams   - [ ] is this necessary anymore?

func prefixcheck()
   if ubound($history,1) > 1 then
	  ;CASE STRIP
	  if $a[1] = string('ca' & $history[number(ubound($history,1) - 1)]) then	;check if a[1] = rightmost $history element
		 $a[0] = _arraydelete($a, 1)	;	if true, strip a1 (the case #) so the line runs
		 if $echo then msgbox(0, 'prefixcheck - case', 'case flag removed')

	  EndIf

   EndIf
EndFunc


func end()
   if $a[1] = 'end'	then
	  local $prefix = stringleft($history[number(ubound($history, 1)-1)], 2)

	  if stringleft($history[number(ubound($history, 1)-1)], 1) = 'w' then
		 local $jump = stringtrimleft($history[number(ubound($history, 1)-1)], 2)
		 if $prefix = 'wy' Then ;go back to $jump
			_arraypop($history)
			$line = number($jump - 1)
			if $echo then msgbox(0, 'end - wy', 'history removed, jumping to line:' & $jump)

		 elseif $prefix = 'wn' Then	;remove history and continue
			_arraypop($history)
			if $echo then msgbox(0, 'end - wn', 'history removed')

		 EndIf

	  Else
		 if $echo then msgbox(0,'end history check before delete', $history[number(ubound($history,1) - 1)])

		 if $prefix = 'ch' Then	;go to choose(), then dialogue().
			choose()
			_arraypop($history)
			if $echo then msgbox(0, 'end', 'choice history removed')

		 Else
			_arraypop($history)
			if $echo then msgbox(0, 'end', 'history removed')

			EndIf

	  EndIf

   elseif $a[1] = 'else' then
	  if $history[number(ubound($history,1) - 1)] = 'x' then

	  elseif $history[number(ubound($history,1) - 1)] = 'iy' then
		 _arraypop($history)
		 _arrayadd($history, 'in')

	  elseif $history[number(ubound($history,1) - 1)] = 'in' then
		 _arraypop($history)
		 _arrayadd($history, 'iy')

	  EndIf

   EndIf
EndFunc



func dialogue($speaker, $speech)
   if IsDeclared('h_' & $speaker) then
	  if $echo then msgbox(0,'head true', eval('h_' & $speaker), 100)
	  GUICtrlSetImage($idhead, eval('h_' & $speaker))

   EndIf

   GUICtrlSetData($idspeaker, $speaker)

   local $count = 1
   While $count <= stringlen($speech)	;	chat chunker
	  GUICtrlSetData($idspeech, StringLeft($speech, $count))
	  sleep($o_chatspeed)
	  $count = number($count + 1)

   WEnd

   local $prefix = stringleft($history[number(ubound($history, 1)-1)], 2)
   $pause = true

   if $prefix = 'ch' Then
	  local $string = $choicechars
	  local $length = StringLen($string)
	  local $count = 1

	  if $echo then msgbox(0, 'choose loop string', 'length:' & $length & '- string:' & $string)

	  while $count <= $length
		 local $char = StringMid($string, $count, 1)
		 if $echo then msgbox(0, 'choose loop char', 'char:' & $char)
		 HotKeySet($char, "continue")
		 $count+=1

	  WEnd

	  while $pause = true
		 sleep(50)

	  WEnd

   Else
	  while $pause = true
		 HotKeySet('{space}', "continue")

	  WEnd

   EndIf
EndFunc


func continue()		;pause until hotkey is pressed
   If WinActive('[TITLE:' & $o_title & ']') Then
	  $pause = false
	  HotKeySet(@hotkeypressed)
	  if $echo then msgbox(0, 'continue', @hotkeypressed & ':pressed - pause:' & $pause)
	  $s_choice = string(@hotkeypressed)

   EndIf
EndFunc



func iftrue()
   if $a[1] = 'if' then	;	[ if ]  [ true / false ]
	  if $echo then _arraydisplay($a)
	  local $prefix = $history[number(ubound($history,1) - 1)]
	  if $echo then msgbox(0, 'iftrue', 'prefix: ' & $prefix)

	  if $prefix = 'x' or $prefix = 'in' or $prefix = 'wn' then
		 _arrayadd($history, 'x')
		 if $echo then msgbox(0, 'iftrue', 'x flag set')

	  elseif $a[2] = 'true' then
		 ;IF-YES
		 _arrayadd($history, 'iy')
		 if $echo then msgbox(0, 'iftrue', 'ifyes flag set')

	  Else
		 ;IF-NO
		 _arrayadd($history, 'in')
		 if $echo then msgbox(0, 'iftrue', 'ifno flag set')

	  EndIf		;history flag is set either iy / in / x


   ;CASE STATEMENT
   if $echo then msgbox(0,'case', 'ubound($a,1)=' & ubound($a,1))
   elseif $a[1] = 'case' and ubound($a,1) = 3 then	;	1[ if ] 	2[ X ]
	  _arrayadd($history, 'ca' & $a[2])
	  if $echo then msgbox(0, 'iftrue', 'case flag set')

   EndIf
EndFunc


func setmacro(); 		[@w] [say] [wizard]
   if StringLeft($a[1], 1) = '@' then ;define a new macro if line starts with @
	  local $value = _arraytostring($a, ' ', 2)	;	say w
	  local $name = StringTrimLeft($a[1], 1)	;	w
	  assign('m_' & $name, $value, 2)			;	$m_w = say wizard

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



func expandvars();		variable substitution
   if $a[1] = 'rem' then
	  Return

   Else
	  local $regex[100]
	  while 1	;regex for chars contained in []

		 $regex = StringRegExp($s, '(\[[^\W]*\])', $STR_REGEXPARRAYMATCH)		;return [gold]
		 if not @error then	;regex[0] = [gold]
			local $name = stringtrimright(StringTrimLeft($regex[0], 1), 1)	;return	gold
			local $value = eval('s_' & $name)								;return	25

			if $echo then msgbox(0, 'expand vars test ', $name )

			$s = StringReplace($s, $regex[0], $value, 1, 0)
			$a = Stringsplit($s, ' ')

			if $echo then msgbox(0, 'expand vars - ', $name &': '& $value & @CRLF & $s)

		 Else
			ExitLoop

		 EndIf

	  WEnd

   EndIf
EndFunc



func expandmath();		evaluate math expressions
   If $a[1] = 'rem' then
	  Return

   Else
	 ;local $regex[5]
	  while 1	;do regex and look for chars contained in { }		'(\(.*\))'	original, doesnt work		'(\([^()[:alpha:]]*\))'		revised, works
		 local $regex = StringRegExp($s, '(\([^()[:alpha:]]*\))', $STR_REGEXPARRAYMATCH)	;return {5 + 5}
		 if not @error Then ;need to get (1) from (1)text(2)

			if $echo then _arraydisplay($regex)

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

   EndIf
EndFunc


func setparams()
   $ap = $a
   _arraydelete($ap,0) ;remove a[1]
   _arraydelete($ap,0) ;remove a[1]

   $sp = _ArrayToString($ap, ' ')

EndFunc


func setmath()		;	[math]	[var]	[value]	[value]	[...] ???????
   local $math = $a[1]
   local $var = $a[2]
   local $x = $a
   _arraydelete($x,0)
   _arraydelete($x,0)
   local $return = 0


   ;dont use any of this for now

   Switch $math
	  case 'ABS'          	;absolute
		 $return = abs($x[0])

	  case 'ACOS'				;arccosine
		 $return = acos($x[0])

	  case 'ALOG'				;antilogarithm
		 ;y = log(b) * x
		 ;x = log(b) ^-1 * (y) = b^y

	  case 'ASIN'				;arcsine
		 $return = asin($x[0])

	  case 'ATAN'				;arctangent
		 $return = atan($x[0])

	  case 'AVG', 'AVERAGE'   ;average
	  ;	$return = a

	  case 'ADD', 'SUM'   	;addition
		 local $count = 1
		 $return = $x[0]
		 while $count <= number( ubound($x, 1) - 1)
			$return+=$x[$count]
			$count+=1
		 WEnd

	  case 'CEL', 'RND', 'CEILING', 'ROUND'  	;round up
		 $return = ceiling($a[0])

	  case 'COS'          	;cosine
		 $return = cos($x[0])

	  case 'DEG'          	;rad to degrees
		 $return = $a[0]*180/$PI

	  case 'DIV'				;
		 local $count = 1
		 $return = $x[0]
		 while $count <= number( ubound($x, 1) - 1)
			$return /= $x[$count]
			$count+=1

		 WEnd

	  case 'E', 'EULER'		;euler's ??
		 $result = $euler

	  case 'EXP', 'EXPONENT'	;exponentiation
		 ;a = a×a×a
		 ;n times

	  case 'FAC', 'FACTORIAL'	;factorial
		 ;5! = 1*2*3*4*5 = 120

	  case 'FLOOR'        	;floor
		 $result = floor($a[0])

	  case 'GOLDEN'			;golden ratio
		 $result = $goldenratio

	  case 'HYPOT', 'HYPOTENUSE'	;hypotenuse
	  case 'LOG'				;logarithm
	  case 'MIN'				;lowest value
	  case 'MAX'				;highest value
	  case 'MOD'				;modulus
	  case 'PI'				;pi constant
		 $return = $pi

	  case 'POW'         	 	;power
		 $return = $a[0]^$a[1]

	  case 'PRO', 'PRODUCT'        		;multiplication
		 local $count = 1
		 $return = $x[0]
		 while $count <= number( ubound($x, 1) - 1)
			$return*=$x[$count]
			$count+=1

		 WEnd

	  case 'RAN'         		;random
		 $return = random($x[1], $x[2], 1)

	  case 'REM', 'REMAINDER'	;remainder
	  case 'USD', 'DOLLAR'	;currency to usd
	  case 'SIN'         		;SINE
		 $return = sin($x[0])

	  case 'SUB'				;subtraction
		 local $count = 1
		 $return = $x[0]
		 while $count <= number( ubound($x, 1) - 1)
			$return-=$x[$count]
			$count+=1
		 WEnd

	  case 'SQRT'         	;square root
	  case 'TAN'          	;tangent
		 $return = tan($x[0])

	  case 'TAU'				;tau???

   EndSwitch

   _arraydisplay($x)

   assign('s_' & $a[2], $return, 3)

   if $echo then msgbox(0, 'setmath here- ' & $math, $var & ': '& $return & @CRLF & $s)

EndFunc


func setvar()
   if $a[1] = 'set' then 	;set variable a[2] to a[3]+
	  local $array = $ap
	  local $name = $ap[0]
	  _arraydelete($ap,0) ;remove ap[1]
	  local $value = $ap
	  local $svalue = _ArrayToString($value, ' ')

	  assign('s_' & $name, $svalue, 3)

	  if $echo then msgbox(0, 'setvar - ' & $s, $name & ': '& $svalue)

   EndIf
EndFunc


func loopwhile()	;WHILE		[ ]		[ while ]		[ true / false ]
   if $echo then msgbox(0,'loop reached', $s)

   if $a[1] = 'while' then
	  local $prefix = stringleft($history[number(ubound($history, 1)-1)], 2)

	  if $prefix = 'wn' or $prefix = 'in' or $prefix = 'x' then
		 _ArrayAdd($history, 'wn' & $line)

	  elseif $a[2] = 'true' then
		 if $history[number(ubound($history, 1)-1)] = 'wy'&$line then
			;same loop and its still true
			if $echo then msgbox(0,'while else-true else-true', '')

		 Else
			;new or nested true loop
			if $echo then msgbox(0,'while else-true else-false', '')	;set a history flag
			_ArrayAdd($history, 'wy' & $line)

		 EndIf

	  elseif $a[2] = 'false' then
		 if $history[number(ubound($history, 1)-1)] = 'wy'&$line then
			;same loop but its false this time around
			if $echo then msgbox(0,'while else-false else-true', '')
			$history[number(ubound($history, 1)-1)] = 'wn'&$line

		 Else
			;new or nested false loop
			if $echo then msgbox(0,'while else-false else-false', '')	;skip to end
			_ArrayAdd($history, 'wn' & $line)

		 EndIf

	  EndIf

   EndIf
EndFunc


func subroutine()	;		[ ]   	[ do ]  	 [ label ]
   if $a[1] = 'func' and ubound($a,1) = 3 then 	;go to subroutine
	  local $count = 1
	  local $target = string('func ' & $a[2])
	  if $echo then msgbox(0, 'subroutine goto', $s &@CRLF& 'target: ' & $target)

	  While $count < $script[0]					;	iterate through script looking for 'to label'
		 if $target = $script[$count] Then		;	'to label' found
			_ArrayAdd($history, 'fn' & $line)	;	add flag
			$line = $count						;	set line to the found function
			exitloop

		 else
			$count+=1

		 EndIf

	  WEnd

   elseif $a[1] = 'return' then	;return from subroutine
	  if ubound($history,1) > 0 then
		 if $echo then msgbox(0, 'subroutine return','')

		 local $target = $history[number(ubound($history,1) - 1)]	;target line = last element of history
		 if StringLeft($target, 2) = 'fn' then $target = StringTrimLeft($target,2)
		 $line = $target

		 if $echo then msgbox(0, 'subroutine return', 'line/target: ' & $line &@CRLF& 'history: ' & $history[number(ubound($history,1) - 1)])
		 _ArrayPop($history)

	  EndIf

   EndIf
EndFunc



func goto()
   if $a[2] = 'line' then

	  if $a[2] >= ubound($a, 1) then
		 $line = number(ubound($a, 1) - 1)

	  Elseif $a[2] <= 0 then
		 $line = 0

	  Else
		 $line = $a[2]

	  EndIf

   else
	  local $count = 1
	  local $string = ''

	  while $count < $script[0]
		 $string = $script[$count]
		 ;msgbox(0, 'comparing', $a[2] & '/' & $string, 100)

		 if $string = $a[2] then
			if $echo then msgbox(0, $script[$line], 'going to line ' &@CRLF& $script[$count])
			$line =  $count
			ExitLoop		;CHANGED

		 Else
			;msgbox(0, 'false', 'checking line ' & $count, 100)
			$count+=1

		 EndIf

	  WEnd

   EndIf
EndFunc



#Region	simple commands
func say()	;say dialogue. a[2] is the name of the speaker, a[3]+ ($text) is the dialogue spoken
	  local $speaker = $a[2]
	  _arraydelete($ap, 0)
	  local $speech = _arraytostring($ap, ' ')
	  dialogue($speaker, $speech)

EndFunc



func sethead()	;0-# 	1-head 		2-w 	3-wizzar.jpg		set variable 'z' + a[2] to filename a[3]
   Assign('h_' & $a[2], $a[3], 2)

   if $echo then msgbox(0, 'sethead', $a[2] &': '& eval('h_' & $a[2]), 100)

EndFunc



func show()	;	[show]	[picture.jpg] change background to a[2]
	  GUICtrlSetImage($idshow, $a[2])
	  GUISetState()
	  if $echo then msgbox(0, "show", $a[2])

EndFunc



func wait()
   sleep(number($a[2] * 1000))

EndFunc


func endscript()
   exit
EndFunc


func rem()
EndFunc


func title()	;[title]	[name]
   $o_title = $a[2]
   WinSetTitle($idgame, "", $o_title)

EndFunc


func debug()
   if $a[2] = 'off' then
	  $echo = False

   Elseif $a[2] = 'on' then
	  $echo = True
	  if $echo then msgbox(0, 'echo', 'echo turned on', 100)

   EndIf

EndFunc




while 1
   sleep(1000)
WEnd
#EndRegion
