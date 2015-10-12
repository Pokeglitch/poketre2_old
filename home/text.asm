; Note:
; When placing string from Inline ASM, it always assumes the next character is breaking
; To resolve: Always include the full words/punctuation inside the text

ResetNextChar:
	xor a
	ld [wNextChar],a
	ret
	
	
PlaceStringFromASM_HL::
	push hl
	pop de
	;fall through
	
PlaceStringFromASM_DE::
	call ResetNextChar			;clear the next char byte, not possible to determine
	call RecoverStringLocation	;recover the location to place the string
	call InitAndPlaceInlineString
	call ResetNextChar		;clear the next char byte, not possible to determine
	call AfterPlaceInlineString
	;fall through
	
StoreStringLocation:
	ld a,l			;store hl
	ld [wStringLocation],a
	ld a,h
	ld [wStringLocation+1],a
	ret

RecoverStringLocation:
	ld a,[wStringLocation]
	ld l,a
	ld a,[wStringLocation+1]
	ld h,a		;get the new string pointer location
	ret

	
TextScriptEnd:: ; 24d7 (0:24d7)
	pop de		;the return pointer = next character, so store that into de
	call RecoverStringLocation
	jp FinishDTECommon
	
TextBoxBorder::
; Draw a cxb text box at hl.

	; top row
	push hl
	ld a, TextBoxTopLeft
	ld [hli], a
	inc a
	call NPlaceChar
	inc a
	ld [hl], a
	pop hl

	ld de, 20
	add hl, de

	; middle rows
.next
	push hl
	ld a,TextBoxLeft
	ld [hli],a
	inc a
	call NPlaceChar
	inc a
	ld [hl], a
	pop hl

	ld de, 20
	add hl, de
	dec b
	jr nz, .next

	; bottom row
	inc a
	ld [hli], a
	inc a
	call NPlaceChar
	inc a
	ld [hl], a
	ret

GetFollowingCharacter:
	ld a,[de]		;get the character into DE again
	push hl
	push de
	ld hl,SizeOfSpecialChars
	ld de,2
	call IsInArray		;if its in the array, then get the size
	pop de
	push de
	jr nc,.dontAdjust
	inc hl
	ld l,[hl]
	ld h,0
	add hl,de
	ld a,[hl]	;get the character after
	jr .finish
.dontAdjust
	inc de
	ld a,[de]
.finish
	ld [wNextChar],a		;store the next character
	pop de
	pop hl
	ret
	
;how many bytes these special characters use
SizeOfSpecialChars:
	db $44, 4
	db $45, 4
	db $46, 4
	db $47, 3
	db $FF
	
NPlaceChar::
; Place char a c times.
	ld d, c
.loop
	ld [hli], a
	dec d
	jr nz, .loop
	ret
	
Char4E::
	pop hl		;recover the destination pointer
	ld bc,$0028
	ld a,[hFlags_0xFFF6]
	bit 2,a
	jr z,.next2
	ld bc,SCREEN_WIDTH
.next2
	pop hl
	add hl,bc
	;fall through
	
Shared4e4f:
	push hl
	inc de
	
	call ResetCharCount_LineBreak
	jr z,.finish		;if we aren't counting, then jump down
	
	push de		;otherwise, push the pointer
	
.finish
	jp PlaceNextChar

Char4F::
	pop hl		;recover the destination pointer
	
	pop hl
	coord hl, 1, 16
	jr Shared4e4f		;finish
		
Char52:: ; 0x19f9 player’s name
	pop hl		;recover the destination pointer
	push de
	ld de,wPlayerName
	jr FinishDTE

Char53:: ; 19ff (0:19ff) ; rival’s name
	pop hl		;recover the destination pointer
	push de
	ld de,wRivalName
	jr FinishDTE

Char5D:: ; 1a05 (0:1a05) ; TRAINER
	pop hl		;recover the destination pointer
	push de
	ld de,Char5DText
	jr FinishDTE

Char5C:: ; 1a0b (0:1a0b) ; TM
	pop hl		;recover the destination pointer
	push de
	ld de,Char5CText
	jr FinishDTE

Char5B:: ; 1a11 (0:1a11) ; PC
	pop hl		;recover the destination pointer
	push de
	ld de,Char5BText
	jr FinishDTE

Char5E:: ; 1a17 (0:1a17) ; ROCKET
	pop hl		;recover the destination pointer
	push de
	ld de,Char5EText
	jr FinishDTE

Char54:: ; 1a1d (0:1a1d) ; POKé
	pop hl		;recover the destination pointer
	push de
	ld de,Char54Text
	jr FinishDTE

Char56:: ; 1a23 (0:1a23) ; ……
	pop hl		;recover the destination pointer
	push de
	ld de,Char56Text
	jr FinishDTE

Char4A:: ; 1a29 (0:1a29) ; PKMN
	pop hl		;recover the destination pointer
	push de
	ld de,Char4AText
	;fall through to FinishDTE
	
FinishDTE::
	call InitAndPlaceInlineString

	pop de
	inc de
	
FinishDTECommon:
	call AfterPlaceInlineString
	jr z,.finish		;if we aren't, then finish
	push de		;save the starting position
.finish
	jp PlaceNextChar
	
Char59:: ; 1a2f (0:1a2f)
; depending on whose turn it is, print
; enemy active monster’s name, prefixed with “Enemy ”
; or
; player active monster’s name
; (like Char5A but flipped)
	ld a,[H_WHOSETURN]
	xor 1
	jr MonsterNameCharsCommon

Char5A:: ; 1a35 (0:1a35)
; depending on whose turn it is, print
; player active monster’s name
; or
; enemy active monster’s name, prefixed with “Enemy ”
	ld a,[H_WHOSETURN]
MonsterNameCharsCommon:: ; 1a37 (0:1a37)
	pop hl		;recover the destination pointer
	push de
	and a
	jr nz,.Enemy
	ld de,wBattleMonNick ; player active monster name
	jr FinishDTE

.Enemy
	; print “Enemy ”
	ld a,[wEnemyMonSpecies2]
	cp HUMAN
	jr z,.lastStandName	;dont say "Enemy" and just use the trainer name if the pokemon is Human
	ld de,Char5AText
	call PlaceInlineString
	ld de,wEnemyMonNick ; enemy active monster name
	ld h,b
	ld l,c
	jr FinishDTE
.lastStandName
	ld de,wTrainerName
	ld a,[wEnemyTrainerFirstName + 1]
	cp "@"		;is the trainer first name empty?
	jr z,.finish		;then finish
	call PlaceInlineString
	ld h,b
	ld l,c
	ld de,wEnemyTrainerFirstName
.finish
	jr FinishDTE

;his/her when referring to rival
Char57:: ; 1aad (0:1aad)
	pop hl		;recover the destination pointer
	push de
	ld de,HerText	;text if totem is on
	ld bc,HisText	;text if totem is on
	
RoleReversalTextCommon:
	ld a,[wTotems]
	bit RoleReversalTotem,a		;did we switch characters
	jr z,.finish		;finish if not
	push bc
	pop de		;use the BC text instead
.finish
	jr FinishDTE
	
;read from RAM
Char47:
	pop hl		;recover the destination pointer
	inc de
	ld a,[de]
	ld c,a
	inc de
	ld a,[de]
	push de		;store the new source pointer
	ld d,a
	ld e,c		;set de to be the ram pointer
	jr FinishDTE
	
	
;trainers name
Char48::
	pop hl		;recover the destination pointer
	push de
	ld de,wTrainerName
	ld a,[wEnemyTrainerFirstName + 1]
	cp "@"		;is the trainer first name empty?
	jr z,.finish		;then finish
	call PlaceInlineString
	ld h,b
	ld l,c
	ld de,wEnemyTrainerFirstName
.finish
	jr FinishDTE
	
;boy/girl when referring to rival
Char40::
	pop hl		;recover the destination pointer
	push de
	ld de,GirlText	;text if totem is off
	ld bc,BoyText	;text if totem is on
	jr RoleReversalTextCommon
	
;boy/girl when referring to player
Char50::
	pop hl		;recover the destination pointer
	push de
	ld de,BoyText	;text if totem is off
	ld bc,GirlText	;text if totem is on
	jr RoleReversalTextCommon
	
;he/she when referring to rival
Char4D::
	pop hl		;recover the destination pointer
	push de
	ld de,SheText	;text if totem is off
	ld bc,HeText	;text if totem is on
	jr RoleReversalTextCommon
	
;capital he/she when referring to rival
Char42::
	pop hl		;recover the destination pointer
	push de
	ld de,CapitalSheText	;text if totem is off
	ld bc,CapitalHeText	;text if totem is on
	jr RoleReversalTextCommon
	
;his/hers when referring to rival
Char41::
	pop hl		;recover the destination pointer
	push de
	ld de,HersText	;text if totem is off
	ld bc,HisText	;text if totem is on
	jr RoleReversalTextCommon
	
;capital his/her when referring to rival
Char55::
	pop hl		;recover the destination pointer
	push de
	ld de,CapitalHerText	;text if totem is off
	ld bc,CapitalHisText	;text if totem is on
	jr RoleReversalTextCommon
	
AfterPlaceInlineString:
	push hl
	ld hl,wTextCharCount
	bit CheckWordWrap,[hl]	;are we checking for word wrap
	jr z,.finish		;if we aren't, then finish

	set CountingLetters,[hl]	;make sure we continue to count again
	call DecIfNextCharPunctuation
	xor a
	inc a		;unzero flag
.finish
	pop hl
	ret	
	
;the routine to init and place the inline string
InitAndPlaceInlineString:
	push hl
	ld hl, wTextCharCount
	call IncIfNextCharPunctuation
	pop hl
	call PlaceInlineString
	ld h,b
	ld l,c
	ret
	
PlaceInlineString:: ; 1a4b (0:1a4b)
	push hl
	ld hl,wTextCharCount
	bit CheckWordWrap,[hl]		;are we checking for word wrap
	jr z,.dontCount		;dont count if not
		
	set CountingLetters,[hl]	
.dontCount
	pop hl
	jp PlaceString
	
DecIfNextCharPunctuation:
	call IsNextCharacterPunctuation	;see if the next character is punctuation
	ret nc		;return if not
	dec [hl]
	ret
IncIfNextCharPunctuation:
	call IsNextCharacterPunctuation	;see if the next character is breaking
	ret nc		;return if not
	inc [hl]
	ret
	
IsNextCharacterPunctuation:
	push de
	push hl
	ld a,[wNextChar]
	ld hl,PunctuationChars
	ld de,1
	call IsInArray
	pop hl
	pop de
	ret
	
PunctuationChars:
	db "?!.,",$BD,$FF

;to set the counting character flag if we are in word wrap mode
SetCountCharIfWordWrap:
	ld hl,wTextCharCount
	bit CheckWordWrap,[hl]		;are we checking for word wrap
	ret z					;return if not
	set CountingLetters,[hl]	;set counting letters
	ret
	
;to run inline ASM commands
Char43:
	pop hl		;recover the 'print to' location
	call StoreStringLocation ;and save it
	inc de
	push de
	pop hl		;hl = next line of text
	jp [hl]
	
; process text commands in another ROM bank
; AAAA = address of text commands
; BB = bank
Char44:
	pop hl		;recover the destination pointer
	ld a,[H_LOADEDROMBANK]
	push af		;store the current bank
	
	call ExtractNumberData	;get pointer and bank
	
	ld [H_LOADEDROMBANK],a
	ld [MBC1RomBank],a		;set the current bank	
	
	push de		;store the current text pointer
	
	push bc
	pop de		;set de to be the new text pointer
	
	call InitAndPlaceInlineString		;place the new string
	
	pop de
	inc de		;move to next character
	
	pop af		;recover the previous bank
	ld [H_LOADEDROMBANK],a
	ld [MBC1RomBank],a		;set the current bank	
	
	jp FinishDTECommon
	
;to print a decimal number from a BCD decimal
; AAAA = address of BCD number
; BB
; bits 0-4 = length in bytes
; bits 5-7 = flags
Char45:
	call SetCountCharIfWordWrap
	pop hl		;hl = destination pointer
	push hl		;store it again
	
.PrintInsteadOfCountLoop
	push de		;store the source pointer
	call ExtractNumberData

	push bc
	pop de		;de = where the number is stored
	
	or a,%11000000	;make sure no leading zeros and left align
	ld c,a		;c = flags and length
	call PrintBCDNumber
	
	push hl		;store the 'print to' location
	call AfterPrintNumber
	pop hl ;recover the 'print to' location
	pop de		;recover the start point
	jr z,Char4546Finish		;finish if the zero flag is set
	jr c,.PrintInsteadOfCount	;if carry flag, then print instead of count
	
	;else, we moved pointer to second line
	pop hl
	coord hl, 1, 16		;store the new destination
	push hl
	jp Char45		;and count again
	
.PrintInsteadOfCount
	pop hl		;recover the print to location
	jr .PrintInsteadOfCountLoop		;and do it again, but print numbers this time
	
	
Char4546Finish:
	inc de
	inc de
	inc de
	jp PlaceNextChar_inc

ExtractNumberData:
	inc de
	ld a,[de]
	ld c,a
	inc de
	ld a,[de]
	ld b,a		;bc = address
	inc de
	ld a,[de]	;a = flags
	ret
	
AfterPrintNumber:	
	ld hl,wTextCharCount
	bit CheckWordWrap,[hl]		;are we checking for word wrap
	ret z		;return if not
	
	bit CountingLetters,[hl]	;were we counting letters?
	jr nz,.counting		;then handle if we were counting

	call DecIfNextCharPunctuation
	xor a		;set zero flag
	ret
	
.counting
	res CountingLetters,[hl]		;unset counting letters
	call IncIfNextCharPunctuation
	;see if we should word wrap
	call CheckForWordWrap
	ret c		;return if there is a carry

	call TryScrollText	;try to scroll the text
	xor a
	inc a		;unset the zero and carry flag
	ret
	
	
	
	
;to print a decimal number from a binary number
; AAAA = address of number
; BB
; bits 0-3 = how many digits to display
; bits 4-7 = how long the number is in bytes
Char46:
	call SetCountCharIfWordWrap	;if we are checking word wrap, then count characters
	pop hl		;hl = destination pointer
	push hl		;store it again

.PrintInsteadOfCountLoop
	push de		;store the source pointer
	call ExtractNumberData

	push bc
	pop de		;de = where the number is stored
	
	ld b,a
	and a,$0f	
	ld c,a		;c = number of digits to display
	ld a,b
	and a,$f0
	swap a
	set BIT_LEFT_ALIGN,a
	ld b,a		;b = size of number in bytes & left align string
	call PrintNumber
	
	push hl		;store the 'print to' location
	call AfterPrintNumber
	pop hl ;recover the 'print to' location
	pop de		;recover the start point
	jr z,Char4546Finish		;finish if the zero flag is set
	jr c,.PrintInsteadOfCount	;if carry flag, then print instead of count
	
	;else, we moved pointer to second line
	pop hl
	coord hl, 1, 16		;store the new destination
	push hl
	jp Char46		;and count again
	
.PrintInsteadOfCount
	pop hl		;recover the print to location
	jr .PrintInsteadOfCountLoop		;and do it again, but print numbers this time
		
	

	
Char5CText:: ; 1a55 (0:1a55)
	db "TM@"
Char5DText:: ; 1a58 (0:1a58)
	db "TRAINER@"
Char5BText:: ; 1a60 (0:1a60)
	db "PC@"
Char5EText:: ; 1a63 (0:1a63)
	db "ROCKET@"
Char54Text:: ; 1a6a (0:1a6a)
	db "POKéMON@"
Char56Text:: ; 1a6f (0:1a6f)
	db "……@"
Char5AText:: ; 1a72 (0:1a72)
	db "Enemy @"
Char4AText:: ; 1a79 (0:1a79)
	db $E1,$E2,"@" ; PKMN

Char5F:: ; 1a91 (0:1a91)
; ends a Pokédex entry
	pop hl		;recover the destination pointer
	ld [hl],"."
	pop hl
	ret

Char58:: ; 1a95 (0:1a95)
	pop hl		;recover the destination pointer
	ld a,[wLinkState]
	cp LINK_STATE_BATTLING
	jp z,Next1AA2
	ld a,$EE
	Coorda 18, 13
Next1AA2:: ; 1aa2 (0:1aa2)
	call ProtectedDelay3
	call ManualTextScroll
	ld a," "
	Coorda 18, 13
	jr Char58Finish
	
Char00::
	pop hl
Char58Finish::
	ld de,Char58Text
	jp PlaceNextChar

Char58Text:: ; 1ab3 (0:1ab3)
	db "@"
	
HisText:
	text "his"
	done
	
HerText:
	text "her"
	done

HersText:	
	text "hers"
	done
	
CapitalHisText:
	text "His"
	done
	
CapitalHerText:
	text "Her"
	done
	
HeText:
	text "he"
	done
	
SheText:
	text "she"
	done
	
CapitalHeText:
	text "He"
	done
	
CapitalSheText:
	text "She"
	done
	
BoyText:
	text "boy"
	done
	
GirlText:
	text "girl"
	done
	
	
Char51:: ; 1ab4 (0:1ab4)
	pop hl		;recover the destination pointer
	push de
	ld a,$EE
	Coorda 18, 13
	call ProtectedDelay3
	call ManualTextScroll
	coord hl, 1, 13
	lb bc, 4, 18
	call ClearScreenArea
	ld c,20
	call DelayFrames
	pop de
	inc de
	coord hl, 1, 14
	call ResetCharCount_NoLineBreak
	jr z,.finish		;if we aren't counting, then finish
	push de		;other, push de since we are counting again
.finish
	jp PlaceNextChar

Char49:: ; 1ad5 (0:1ad5)
	pop hl		;recover the destination pointer
	push de
	ld a,$EE
	Coorda 18, 13
	call ProtectedDelay3
	call ManualTextScroll
	coord hl, 1, 10
	lb bc, 7, 18
	call ClearScreenArea
	ld c,20
	call DelayFrames
	pop de
	pop hl
	coord hl, 1, 11
	push hl
	jp PlaceNextChar_inc

Char4B:: ; 1af8 (0:1af8)
	pop hl		;recover the destination pointer
	ld a,$EE
	Coorda 18, 13
	call ProtectedDelay3
	push de
	call ManualTextScroll
	pop de
	ld a, " "
	Coorda 18, 13
	push hl		;push hl again because 4c will pop it
	;fall through

Char4C:: ; 1b0a (0:1b0a)
	pop hl		;recover the destination pointer
	push de
	call Scroll2Lines
	coord hl, 1, 16
	pop de
	inc de
	call ResetCharCount_LineBreak
	jr z,.finish		;if we not counting, then finish
	push de		;otherwise, push the source pointer
.finish
	jp PlaceNextChar

Scroll2Lines:
	call ScrollLine
	;fall through
	
ScrollLine:: ; 1b18 (0:1b18)
	coord hl, 0, 14
	coord de, 0, 13
	ld b,60
.next
	ld a,[hli]
	ld [de],a
	inc de
	dec b
	jr nz,.next
	coord hl, 1, 16
	ld a, " "
	ld b,SCREEN_WIDTH - 2
.next2
	ld [hli],a
	dec b
	jr nz,.next2

	; wait five frames
	ld b,5
.WaitFrame
	call DelayFrame
	dec b
	jr nz,.WaitFrame

	ret

ProtectedDelay3:: ; 1b3a (0:1b3a)
	push bc
	call Delay3
	pop bc
	ret
	

PrintText:: ; 3c49 (0:3c49)
; Print text hl at (1, 14).
	push hl
	ld a,MESSAGE_BOX
	ld [wTextBoxID],a
	call DisplayTextBoxID
	call UpdateSprites
	call Delay3
	pop hl
	
PrintText_NoCreatingTextBox_WordWrap:
	ld a,%11000000
	ld [wTextCharCount],a	;initialize wTextCharCount to indicate that we should check for word wrapping and counting letters
	call PrintText_NoCreatingTextBox
	call ResetNextChar
	ld [wTextCharCount],a		;reset wTextCharCount as well
	ret
	
PrintText_NoCreatingTextBox:: ; 3c59 (0:3c59)
	coord bc, 1, 14
	jp TextCommandProcessor
	

CharSpace:	
	ld hl,wTextCharCount
	bit CheckWordWrap,[hl]		;are we checking for word wrap
	jr nz,.wordWrap		;jump down if so
	pop hl		;otherwise, recover the destination and continue
	ld a," "
	ld [hli],a	;store the space
	inc de		;move to next character
	jr PlaceNextChar
	
.wordWrap
	set CountingLetters,[hl]		;set the bit so we will count letters for the next word
	ld a,%00011111
	and [hl]		;only keep the count
	cp CharsPerRow		;is it 18?
	jr z,.dontInc	;if it is 18 (the end of the line), then dont increment
	
	inc [hl]
	
.dontInc
	pop hl		;recover the destination
	jr z,.dontPrintSpace		;if the count is zero or 18, then don't print the space
	ld a," "
	ld [hli],a		;otherwise, place the space

.dontPrintSpace
	inc de		;move past the space
	push de		;save the letter starting position
	jr PlaceNextChar
	
CheckForWordWrap:
	;if we were counting letters, then see if we need to add a line break
	ld a,%00011111
	and [hl]		;only keep the character count
	cp CharsPerRow + 1
	ret
	
;to scroll the text
TryScrollText:
	bit FirstLineBreak,[hl]		;have we already added the first line break
	jr z,.finish		;if not, then we don't scroll the text
	
	push hl
	push de
	
	ld a,$EE		;place the cursor
	Coorda 18, 13
	call ProtectedDelay3
	push de
	call ManualTextScroll
	pop de
	ld a,$C4		;erase the cursor
	Coorda 18, 13
	
	
	call Scroll2Lines
	pop de			;scroll the text
	pop hl
	
.finish
	ld [hl],%11100000		;reset the counter and but set all other flags
	inc hl
	ld [hl],0		;reset the 'next character' byte
	ret
	
ResetCharCount_NoLineBreak:
	push hl
	ld a,%11000000
	jr ResetCharCountFinish
	
ResetCharCount_LineBreak:
	push hl
	ld a,%11100000
	
ResetCharCountFinish:
	ld hl, wTextCharCount
	bit CheckWordWrap,[hl]		;are we checking word wrap?
	jr z,.finish			;finish if not
	ld [hli],a		;store the flags
	ld [hl], 0		;zero the 'next character' byte
	
.finish
	pop hl
	ret
	
FinishCountingLetters:
	call CheckForWordWrap	;check if we should word wrap
	jr c,.noLineBreak		;if it is under 19, then we do not need to add a line break, so finish counting
	
	call TryScrollText
	
	;move pointer to second line
	pop hl		;recover the destination
	coord hl, 1, 16		;store the new destination
	pop de		;recover the starting position
	push de		;store the starting position again since we are still counting
	jr PlaceNextChar	;start over
	
.noLineBreak
	;if no line break, then turn off the counting letters bit
	res CountingLetters,[hl]
	pop hl		;recover the destination
	pop de		;recover the start of the word
	jr PlaceNextChar	;place the characters
	
	
;to place a into hl or increment the counter
PlaceCharOrCountChars:
	push hl
	ld hl,wTextCharCount
	bit CountingLetters,[hl]
	jr z,.placeChar
	inc [hl]		;increment the counter
	pop hl
	ret
.placeChar
	pop hl
	ld [hl],a
	ret
	
;to place a smart string, we have to first save the starting location
;this will cause an infinite loop if a word is >18 characters
PlaceString::
	push hl
	ld a,[wTextCharCount]
	and a
	jr z,PlaceNextChar		;if we are not counting characters, then don't push de
	push de		;save the destination
	;fall through
PlaceNextChar:: ; 1956 (0:1956)
	ld a,[de]
	cp "@"
	jr nz,.PlaceText

	ld a,[wTextCharCount]
	bit CheckWordWrap,a		;are we checking for word wrap
	jr z,.finish		;finish if not
		
	bit CountingLetters,a		;are we counting letters?
	jr z,.resetCountAndFinish			;finish if not
	
	push hl			;otherwise, push the destination
	ld hl,wTextCharCount
	jr FinishCountingLetters	;and run the routine to finish counting letters

.resetCountAndFinish
	ld a,[wTextCharCount]
	set CountingLetters,a	;turn on counting
	ld [wTextCharCount],a
	;fall through
.finish
	ld b,h
	ld c,l
	pop hl		;recover the destination
	ret

.PlaceText
	push hl
	push de
	ld hl,SpecialTextChars
	ld de,3
	call IsInArray
	pop de
	jr nc,.handleChar		;if the character isn't in the array, then handle the char
	;otherwise, run the function
	inc hl
	ld a,[hli]
	ld h,[hl]
	ld l,a

	ld a,[wTextCharCount]
	bit CheckWordWrap,a		;are we checking for word wrap
	jr z,.runCharFunction		;finish if not
		
	bit CountingLetters,a		;are we counting letters?
	jr z,.runCharFunction			;finish if not
	
	ld hl,wTextCharCount
	jp FinishCountingLetters	;and run the routine to finish counting letters

.runCharFunction
	call GetFollowingCharacter	;get the character after this special text
	jp [hl]
	
.handleChar
	ld hl,wTextCharCount
	bit CountingLetters,[hl]
	jr z,.placeChar		;if are not counting characters, then place char
	
	inc [hl]		;increment the counter
	pop hl			;recover the destination, don't increment
	jr PlaceNextChar_inc
	
.placeChar
	pop hl			;recover the destination
	ld a,[de]
	ld [hli],a
	call PrintLetterDelay
	;fall through
	
PlaceNextChar_inc:
	inc de
	jp PlaceNextChar		

SpecialTextChars:
	db " "
	dw CharSpace
	db $40
	dw Char40
	db $41
	dw Char41
	db $42
	dw Char42
	db $43
	dw Char43
	db $44
	dw Char44
	db $45
	dw Char45
	db $46
	dw Char46
	db $47
	dw Char47
	db $48
	dw Char48
	db $49
	dw Char49
	db $4A
	dw Char4A
	db $4B
	dw Char4B
	db $4C
	dw Char4C
	db $4D
	dw Char4D
	db $4E
	dw Char4E
	db $4F
	dw Char4F
	db $50
	dw Char50
	db $51
	dw Char51
	db $52
	dw Char52
	db $53
	dw Char53
	db $54
	dw Char54
	db $55
	dw Char55
	db $56
	dw Char56
	db $57
	dw Char57
	db $58
	dw Char58
	db $59
	dw Char59
	db $5A
	dw Char5A
	db $5B
	dw Char5B
	db $5C
	dw Char5C
	db $5D
	dw Char5D
	db $5E
	dw Char5E
	db $5F
	dw Char5F
	db $FF	

TextCommandProcessor:: ; 1b40 (0:1b40)
	ld a,[wLetterPrintingDelayFlags]
	push af
	set 1,a
	ld e,a
	ld a,[$fff4]
	xor e
	ld [wLetterPrintingDelayFlags],a
	push hl
	pop de
	push bc
	pop hl
	call PlaceString
	push de
	pop hl
	inc hl
	pop af
	ld [wLetterPrintingDelayFlags],a
	ret


; draw box
; 04AAAABBCC
; AAAA = address of upper left corner
; BB = height
; CC = width
TextCommand04:: ; 1b78 (0:1b78)
;	pop hl
;	ld a,[hli]
;	ld e,a
;	ld a,[hli]
;	ld d,a
;	ld a,[hli]
;	ld b,a
;	ld a,[hli]
;	ld c,a
;	push hl
;	ld h,d
;	ld l,e
;	call TextBoxBorder
;	pop hl
;	jr NextTextCommand


; repoint destination address
; 03AAAA
; AAAA = new destination address
TextCommand03:: ; 1bb7 (0:1bb7)
;	pop hl
;	ld a,[hli]
;	ld [wUnusedCC3A],a
;	ld c,a
;	ld a,[hli]
;	ld [wUnusedCC3B],a
;	ld b,a
;	jp NextTextCommand

; repoint destination to second line of dialogue text box
; 05
; (no arguments)
TextCommand05:: ; 1bc5 (0:1bc5)
;	pop hl
;	coord bc, 1, 16 ; address of second line of dialogue text box
;	jp NextTextCommand

; blink arrow and wait for A or B to be pressed
; 06
; (no arguments)
TextCommand06:: ; 1bcc (0:1bcc)
;	ld a,[wLinkState]
;	cp a,LINK_STATE_BATTLING
;	jp z,TextCommand0D
;	ld a,$ee ; down arrow
;	Coorda 18, 13 ; place down arrow in lower right corner of dialogue text box
;	push bc
;	call ManualTextScroll ; blink arrow and wait for A or B to be pressed
;	pop bc
;	ld a," "
;	Coorda 18, 13 ; overwrite down arrow with blank space
;	pop hl
;	jp NextTextCommand

; scroll text up one line
; 07
; (no arguments)
TextCommand07:: ; 1be7 (0:1be7)
;	ld a," "
;	Coorda 18, 13 ; place blank space in lower right corner of dialogue text box
;	call Scroll2Lines
;	pop hl
;	coord bc, 1, 16 ; address of second line of dialogue text box
;	jp NextTextCommand

; execute asm inline
; 08{code}
TextCommand08:: ; 1bf9 (0:1bf9)
;	pop hl
;	ld de,NextTextCommand
;	push de ; return address
;	jp [hl]

; wait half a second if the user doesn't hold A or B
; 0A
; (no arguments)
TextCommand0A:: ; 1c1d (0:1c1d)
;	push bc
;	call Joypad
;	ld a,[hJoyHeld]
;	and a,A_BUTTON | B_BUTTON
;	jr nz,.skipDelay
;	ld c,30
;	call DelayFrames
;.skipDelay
;	pop bc
;	pop hl
;	jp NextTextCommand

; plays sounds
; this actually handles various command ID's, not just 0B
; (no arguments)
TextCommand0B:: ; 1c31 (0:1c31)
;	pop hl
;	push bc
;	dec hl
;	ld a,[hli]
;	ld b,a ; b = command number that got us here
;	push hl
;	ld hl,TextCommandSounds
;.loop
;	ld a,[hli]
;	cp b
;	jr z,.matchFound
;	inc hl
;	jr .loop
;.matchFound
;	cp a,$14
;	jr z,.pokemonCry
;	cp a,$15
;	jr z,.pokemonCry
;	cp a,$16
;	jr z,.pokemonCry
;	ld a,[hl]
;	call PlaySound
;	call WaitForSoundToFinish
;	pop hl
;	pop bc
;	jp NextTextCommand
;.pokemonCry
;	push de
;	ld a,[hl]
;	call PlayCry
;	pop de
;	pop hl
;	pop bc
;	jp NextTextCommand

; format: text command ID, sound ID or cry ID
TextCommandSounds:: ; 1c64 (0:1c64)
;	db $0B,SFX_GET_ITEM_1
;	db $12,SFX_CAUGHT_MON
;	db $0E,SFX_POKEDEX_RATING
;	db $0F,SFX_GET_ITEM_1
;	db $10,SFX_GET_ITEM_2
;	db $11,SFX_GET_KEY_ITEM
;	db $13,SFX_DEX_PAGE_ADDED
;	db $14,NIDORINA ; used in OakSpeech
;	db $15,PIDGEOT  ; used in SaffronCityText12
;	db $16,DEWGONG  ; unused?

; draw ellipses
; 0CAA
; AA = number of ellipses to draw
TextCommand0C:: ; 1c78 (0:1c78)
;	pop hl
;	ld a,[hli]
;	ld d,a
;	push hl
;	ld h,b
;	ld l,c
;.loop
;	ld a,$75 ; ellipsis
;	ld [hli],a
;	push de
;	call Joypad
;	pop de
;	ld a,[hJoyHeld] ; joypad state
;	and a,A_BUTTON | B_BUTTON
;	jr nz,.skipDelay ; if so, skip the delay
;	ld c,10
;	call DelayFrames
;.skipDelay
;	dec d
;	jr nz,.loop
;	ld b,h
;	ld c,l
;	pop hl
;	jp NextTextCommand

; wait for A or B to be pressed
; 0D
; (no arguments)
TextCommand0D:: ; 1c9a (0:1c9a)
;	push bc
;	call ManualTextScroll ; wait for A or B to be pressed
;	pop bc
;	pop hl
;	jp NextTextCommand