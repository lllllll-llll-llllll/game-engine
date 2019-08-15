visual novel game engine / scripting language

this is a visual novel engine built using autoit. au3 files are autoit scripts that can be interpreted directly using the latest version of autoit. they can also be compiled to an executable to run on systems that don't have autoit installed. game-engine.au3 will be referred to as the engine. create a textfile script.txt in the same folder as the engine to begin creating a visual novel. this textfile will be known as the script.



syntax
the script is composed of multiple lines of unindented text that start with a command word.
words are separated by spaces and aren't contained in " or '.



SAY
	say myname hello world.
	say is the command which will enable say() to run.
	myname is the $speaker.
	hello world. is considered the $speech.

if the command is SAY, then the function say() will run. it will use the word after SAY, which is MYNAME in this case. every word after the speaker is considered the $speech. the $speaker and $speech are used by dialogue() to output $speaker to $idspeaker and $speech to $idspeech. $speaker and $speech are global engine variables not directly accessible from the script. the $speaker's name appears topleft of the $speech textbox. the $speech appears in the textbox itself and wordwraps. if a head graphic for the $speaker is set using then myface.bmp will be displayed on $idhead when that speaker is talking. the speech output speed is determined by [chatspeed], higher values are slower. after the speech is finished displaying, continue() will run, which pauses the script until you press spacebar.



SET
    set myname michael
    set is the command which will enable setvar() to run.
    myname is the variable name to be assigned.
    michael is the variables assigned value.

if the command is , then the function set() will run. it will create and assign the variable to value at a global scope. the engine actually prefixes all script variables assigned using with "s_", so for this instance to access that variable using the autoit engine you would be using <$s_myname>. within the script however you can just use . variable substitution enables you to replace any word enclosed in brackets like [myname] and it will be replaced with "michael".



@ (MACROS)

    @s set
    @ is the command prefix which enables setmacro() to run.
    s is the assigned macro's name.
    set is the assigned macro's substitution value.

@macros function similarly to SET variables as both expand to their values, however macros are always the first word of a line. set variables also require being enclosed in brackets to expand. macros can contain bracketed variables to expand. macros are intended as custom command words, for instance instead of using @ to assign a macro you can do @# @ which will enable you to create macros using # instead of @, or @; @ to use ; as the macro prefix.



VARIABLE EXPANSION
there is an order to how expansion occurs:

    macro > variables > math

MACROS
macro prefixes expand if the first word is a valid macro's name.

VARIABLES
variables expand bracketed words into that variable's value.
"[name] and [enemy[number]]" will expand "name" first, then "number", then "enemy#".

MATH
math expressions expand parenthesized numbers and operators into a result.
is [day] was set to 16, then by before ([day] - 1) reaches the expandmath() will already have expanded the variable [day] into "16". it will look like this: (16 - 1)
if the parenthesized group doesn't contain other any parentheses or alphabetic characters, it will directly evaluate the expression. if it contains those characters, it skips that section.
