visual novel scripting engine/language


Planned or implemented features:
- scripting language
- one command per line followed by parameters (bash/batch style)
- no quoted text with " or '
- case-insensitive
- all keywords able to be redefined
- goto example label (goto the first line containing exactly 'example label') 
- goto line X (goto the line number X of the script)
- many conditional prefixes to determine whether a line is run
- command macro expansion
- variable expansion using [ ], can be nested
- math evaluation using ( ), can be nested


Inspiration:
AutoIt, BASIC : command names
Ring, RenPy : [var] in a string expands to that var's value
Batch : syntax


Commands:
- [title] value		(rename the program's title)
- [set] var value		(create a variable [var] set to [value])
- [keyword] default replacement		(rename any default [keyword] to [replacement], even 'keyword' can be renamed)
- [macro] name value		(create macro of [name] set to [value])
- [show] picture.bmp		(change the background to display [picture.bmp])
- [head] name picture.bmp		([name]'s portait, [picture.bmp], will display from now on whenever [name] says something)
- [say] name text ...	([name] will say [text] [...])
- 		(empty lines are skipped)
-		[command] ...		(indented tabs are stripped away before running [command])
- ???????		(comment. if the first word of a line isn't a recognized keyword, the line is ignored)

- [goto line] number		(jump to the [number] line of the script)
- [goto] text ...	(jump to the first line found that consists entirely of [any other text])
- [wait] value			(pause script for [value] seconds)

- [ran/random] var min max		(set [var] to randomly generated integer between [min]...[max])
- [add/sum] var value ...		(set [var] to the sum of [value] and [...]) 
- [sub]	var value ...				(set [var] to the difference of [value] and [...]) 
- [mul/multiply/pro/product] var value ...	(set [var] to the product of [value] and [...])
- [div/divide]	var value ...		(set [var] to the quotient and/or remainder of [value] and [...])
- [ceil] var value			(
- [floor] var value			(
- [abs] var value
- [cos] var value
- [sin] var value
- [tan] var value
- [acos] var value
- [asin] var value
- [atan] var value
- [log]	var value
- [alog] var value
- [deg] var radians		(set [var] to [radians] converted to degrees)
- [rad] var degrees		(set [var] to [degrees[ converted to radians)
- not finished

- [is] value operator value		(if [value] [operator] [value], assign is-flag to 'yes')
CONDITIONAL IS-PREFIXES:	yes, no, maybe, always
- [command] ... 	(normal commands will not run because is-flag is set)
- yes [command] ...		(only runs if is-flag is 'yes')
- no [command] ...		(only runs if is-flag is 'no')
- maybe [command] ...	(50% chance of running regardless)
- always [command] ...	(will always run as long as is-flag is set to either 'yes' or 'no')
- [is end]		(resets the is-flag)

- [only] value	(sets only-flag to [value])
CONDITIONAL ONLY-PREFIXES:	any (when only-flag is set)
- [command] ... 	(normal commands will not run because only-flag is set)
- value [command] ...	(if only-flag equals [value], it runs)
- notvalue [command] ...	(if only-flag is set to [notvalue], it runs)
- [only end]	(resets the only-flag)


