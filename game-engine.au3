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
   global $idgame = GUICreate("Game Engine", 300, 300, -1, -1)

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


global const			 $pi = 3.14159265358979323846
global const			$tau = $pi*2
global const		 $golden = 1.61803398874989484820
global Const		  $euler = 2.71828182845904523536

global $script = FileReadToArray("script.txt")
_arrayinsert($script, 0, ubound($script))
global $sp = ""		;params as string
global $ap[1]		;params as array
global $pause = false
global $echo = false
global $line = 1
global $s = ''
global $a[1000]

global $history[] = []
global $o_chatspeed = 20
global $o_title = 'Game Engine'


;_ArrayAdd($history



script()

func script()
   while $line <= $script[0]
   ;get current $line in [$s]tring and [$a]rray format
	  $s = string($script[$line])
	  $s = StringReplace($s,@TAB,"")	;remove all tabs
	  $a = StringSplit($s, ' ')

   if $a[1] then
	  _arraydisplay($history)

	  ;preprocessor
		 prefixcheck()
		 expandmacro()
		 expandvars()
		 expandmath()
		 setparams()

	  ;config
		 title()
		 echo()

	  ;input
		 setmacro()
		 ;setmath()
		 setvar()
		 sethead()

	  ;flow
		 subroutine()
		 iftrue()
		 goto()
		 wait()
		 ;rem()

	  ;output
		 show()
		 say()
   EndIf

	  $line+=1

   WEnd

EndFunc

#cs

history = []









#ce

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


func setmath()		;	[math]	[var]	[value]	[value]	[...]
   local $math = $a[1]
   local $var = $a[2]
   local $x = $a
   _arraydelete($x,0)
   _arraydelete($x,0)
   local $return = 0




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

	  case 'E', 'EULER'		;euler's constant
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

	  case 'TAU'				;tau constant

   EndSwitch

   _arraydisplay($x)

   assign('s_' & $a[2], $return, 3)

   if $echo then msgbox(0, 'setmath here- ' & $math, $var & ': '& $return & @CRLF & $s)

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

#Region		OLD PREFIX CHECK
#cs
func prefixcheck()
   if $a[1] = 'yes' then		;if $is = yes, strip the YES prefix.
	  if $is = 'yes' then $a[0] = _arraydelete($a, 1)

	  if $echo then msgbox(0, 'prefix yes', $a[1] & ' - ' & $is)


   ElseIf $a[1] = 'no' then		;if $is = no, strip the NO prefix
	  if $is = 'no' then $a[0] = _arraydelete($a, 1)

	  if $echo then msgbox(0, 'prefixcheck yes', $a[1] & ' - ' & $is)


   Elseif $a[1] = 'is' and $a[2] = 'end' then		;reset $is = ''
	  $is = ''
		 if $echo then msgbox(0, 'is end', 'is flag is set to: ' & $is)

   EndIf

;if $a[1] then
   if $a[1] = $only then $a[0] = _arraydelete($a, 1)	;	strip a1
   if $a[1] = 'only' and $a[2] = 'end' then $only = ''	;	reset $only

;EndIf

EndFunc



func istrue()
   if $a[1] = 'is' then	;	[ if ]  [ X ]  [ oper ]  [ Y ]
	  if $echo then msgbox(0, 'istrue', $a[2])

	  if $a[2] = 'end' then
	  Else
		 if $echo then msgbox(0, 'istrue no end', $s)

		 local $statement = '(' & $a[2] & ') ' & $a[3] & ' (' & $a[4] & ')'
		 if execute($statement) = true Then
			$is = 'yes'
			if $echo then msgbox(0, 'istrue', $statement & ' is true')

		 Else
			$is = 'no'
			if $echo then msgbox(0, 'istrue', $statement & ' is false')

		 EndIf

	  EndIf

   EndIf

EndFunc



func isonly()
   if $a[1] = 'only' then	;	[ only ]  [ X ]

	  if $a[2] = 'end' then
	  Else
		 $only = $a[2]
		 if $echo then msgbox(0, 'only', 'only flag is set to: ' & $a[2])

	  EndIf

   EndIf

EndFunc


#ce
#EndRegion



func prefixcheck()
   if ubound($history,1) > 1 then
	  ;CASE STRIP
	  if $a[1] = $history[number(ubound($history,1) - 1)] then	;check if a[1] = rightmost $history element
		 $a[0] = _arraydelete($a, 1)	;	if true, strip a1 (the case #) so the line runs
		 if $echo then msgbox(0, 'prefixcheck - case', 'case flag removed')

	  EndIf

	  ;Y/N STRIP
	  if $a[1] = 'y' then		;if recent = ifyes, strip the YES prefix.
		 if $history[number(ubound($history,1) - 1)] = 'ifyes' then
			$a[0] = _arraydelete($a, 1)
			if $echo then msgbox(0, 'prefixcheck - y', 'ifyes found, y stripped')

		 EndIf

	  ElseIf $a[1] = 'n' then		;if recent = ifno, strip the NO prefix
		 if $history[number(ubound($history,1) - 1)]= 'ifno' then
			$a[0] = _arraydelete($a, 1)
			if $echo then msgbox(0, 'prefixcheck - n', 'ifno found, n stripped')

		 EndIf

	  EndIf

	  ;END, FLAG POP
	  if $a[1] = 'end'	then	;reset $is = ''
		 _arraydelete($history, number(ubound($history,1) - 1))
		 if $echo then msgbox(0, 'prefixcheck - end', 'history flag removed')

	  EndIf

   EndIf

EndFunc


#cs
lisp math expressions

set num 10
set x (ran 1 (num))

first search for ()										;regex for ()
   found: check if it contains spaces.					;finds (num)
	  yes:  get the first word as the math command.		;skip
			math command the other values.				;skip
	  no: check if it contains only A-Z					;contains only a-z
		 yes:  check if it's a set variable				;isdefined($s_num) = true?
			   expand to that variable's value.			;if so, replace the regex result of the array with the variable's eval() value
		 no:   it's just a regular number.				;skip

#ce


func iftrue()
   if $a[1] = 'if' then	;	[ if ]  [ X ]  [ oper ]  [ Y ]
	  _arraydisplay($a)

	  if execute('(' & $a[2] & ') ' & $a[3] & ' (' & $a[4] & ')') Then
		 ;IF-YES
		 _arrayadd($history, 'ifyes')
		 if $echo then msgbox(0, 'iftrue', 'ifyes flag set')

	  Else
		 ;IF-NO
		 _arrayadd($history, 'ifno')
		 if $echo then msgbox(0, 'iftrue', 'ifno flag set')

	  EndIf		;history flag is set either ifyes/ifno

   ;CASE STATEMENT
   elseif $a[1] = 'case' and ubound($a,1) = 3 then	;	1[ if ] 	2[ X ]
	  _arrayadd($history, $a[2])
	  if $echo then msgbox(0, 'iftrue', 'case flag set')

   EndIf

EndFunc


#Region
;	if a1 is 'do'
;	attempt to goto a2, if nothing is found just skip this
;	if the label is found, goto it
;	set a func-##
;
;
;
;
;
#EndRegion


func subroutine()	;	[ ]   [ do ]   [ label ]
   ;because of macros it might be impossible to find '(to) label' if they are using a macro that expands
   ;macro expansion will need to occur during each iteration of the search below
   ;we might need to rework the macro/variable expansions (math too?) so we can just input a line and have the result returned
   ;we can probably just add a parameter and at the beginning and use that are the input instead of taking script[line]
   ;for now the goal is to see if it can even work at all

   ;the line numbers might need ot be line+1 to proceed to the next thing? i forget how script() is incrementing.

   if $a[1] = 'do' and ubound($a,1) = 3 then 	;go to subroutine
	  local $count = 1
	  local $target = string('to ' & $a[2])

	  if $echo then msgbox(0, 'subroutine goto', $s &@CRLF& 'target: ' & $target)

	  While $count < $script[0]					;	iterate through script looking for 'to label'
		 if $target = $script[$count] Then		;	'to label' found
			_ArrayAdd($history, 'sub' & $line)	;	add flag
			$line = $count						;	set line to the found function
			exitloop

		 else
			$count+=1

		 EndIf

	  WEnd

   EndIf

   if $a[1] = 'return' then	;return from subroutine
	  if ubound($history,1) > 0 then
		 if $echo then msgbox(0, 'reaches return','')

			_arraydisplay($history)

		 local $target = $history[number(ubound($history,1) - 1)]	;target line = last element of history
		 if StringLeft($target, 3) = 'sub' then $target = StringTrimLeft($target,3)
		 $line = $target

		 if $echo then msgbox(0, 'subroutine return', 'line/target: ' & $line &@CRLF& 'history: ' & $history[number(ubound($history,1) - 1)])


		 _ArrayPop($history)

	  EndIf

   endif

EndFunc







func goto()
   if $a[1] = 'goto' then	;goto a label

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
   ;sleep(300)

EndFunc


func continue()		;pause until space is pressed after dialogue finishes displaying text
   If WinActive('[TITLE:' & $o_title & ']') Then
	  $pause = false
	  HotKeySet('{space}')
	  if $echo then msgbox(0, 'continue', 'space pressed - ' & $pause)

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
	  $o_title = $a[2]
	  WinSetTitle($idgame, "", $o_title)

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