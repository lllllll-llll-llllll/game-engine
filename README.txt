









CONTROL FLOW


LABEL
Any line that doesn't start with a valid command is ignored, but can serve as a jump point for GOTO.

GOTO
There are two implementations of GOTO.

	GOTO [matching text]
	This jumps to the first line found containing the matching text. The matching text can be anything.

	GOTO LINE [number]
	This jumps to that line number of the script.


CONDITIONAL
There are a few ways to run lines of code on a conditional basis.

	IF [value operator value]
		If the statement evaluates true only lines of code starting with [Y] will run, however if it evaluates false only lines of code starting with [N] will run. This continues until it reaches [END]. You can nest IF statements inside each other.

	CASE [value]
		This will only allow lines of code starting with [value] to run. [END] will stop the condition.

	WHILE [value operator value]

SUBROUTINE
You can use [TO/DO/RETURN] to construct functions.

	[DO name]
	[TO name]
	[code]
	[RETURN]
		[TO name] declares a subroutine containing code which ends with [RETURN]. The subroutine is called using [DO name].







