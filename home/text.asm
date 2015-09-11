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
	ld bc,$14
.next2
	pop hl
	add hl,bc
	push hl
	inc de
	
	ld a,[wTextCharCount]
	and a
	jr z,.finish		;if we aren't, then jump down
	
	ld a,%11100000		;reset the value
	ld [wTextCharCount],a		;make sure we continue to count again
	push de		;push the pointer
	
.finish
	jp PlaceNextChar

Char4F::
	pop hl		;recover the destination pointer
	
	pop hl
	hlCoord 1, 16
	push hl
	inc de
	ld a,[wTextCharCount]
	and a
	jr z,.finish		;if we aren't, then jump down
	
	ld a,%11100000		;reset the value
	ld [wTextCharCount],a		;make sure we continue to count again
	push de		;push the source pointer
	
.finish
	jp PlaceNextChar
		

Char00:: ; 19ec (0:19ec)
	pop hl		;recover the destination pointer
	ld b,h
	ld c,l
	pop hl
	ld de,Char00Text
	dec de
	ret

Char00Text:: ; 0x19f4 “%d ERROR.”
	TX_FAR _Char00Text
	db "@"

Char52:: ; 0x19f9 player’s name
	pop hl		;recover the destination pointer
	push de
	ld de,wPlayerName
	jp FinishDTE

Char53:: ; 19ff (0:19ff) ; rival’s name
	pop hl		;recover the destination pointer
	push de
	ld de,W_RIVALNAME
	jp FinishDTE

Char5D:: ; 1a05 (0:1a05) ; TRAINER
	pop hl		;recover the destination pointer
	push de
	ld de,Char5DText
	jp FinishDTE

Char5C:: ; 1a0b (0:1a0b) ; TM
	pop hl		;recover the destination pointer
	push de
	ld de,Char5CText
	jp FinishDTE

Char5B:: ; 1a11 (0:1a11) ; PC
	pop hl		;recover the destination pointer
	push de
	ld de,Char5BText
	jp FinishDTE

Char5E:: ; 1a17 (0:1a17) ; ROCKET
	pop hl		;recover the destination pointer
	push de
	ld de,Char5EText
	jp FinishDTE

Char54:: ; 1a1d (0:1a1d) ; POKé
	pop hl		;recover the destination pointer
	push de
	ld de,Char54Text
	jp FinishDTE

Char56:: ; 1a23 (0:1a23) ; ……
	pop hl		;recover the destination pointer
	push de
	ld de,Char56Text
	jp FinishDTE

Char4A:: ; 1a29 (0:1a29) ; PKMN
	pop hl		;recover the destination pointer
	push de
	ld de,Char4AText
	jp FinishDTE

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

.Enemy ; 1A40
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
	ld de,W_TRAINERNAME
	ld a,[wEnemyTrainerFirstName + 1]
	cp "@"		;is the trainer first name empty?
	jr z,.finish		;then finish
	call PlaceInlineString
	ld h,b
	ld l,c
	ld de,wEnemyTrainerFirstName
.finish
	jr FinishDTE

PlaceInlineString:: ; 1a4b (0:1a4b)
	ld a,[wTextCharCount]
	bit CheckWordWrap,a		;are we checking for word wrap
	jr z,.dontCount		;dont count if not
		
	set CountingLetters,a
	ld [wTextCharCount],a
	
.dontCount
	jp PlaceString
	
FinishDTE::
	call PlaceInlineString
	ld h,b
	ld l,c
	pop de
	inc de
	ld a,[wTextCharCount]
	and a
	jr z,.finish		;if we aren't, then finish
	
	set CountingLetters,a
	ld [wTextCharCount],a		;make sure we continue to count again
	push de		;save the starting position
	
.finish
	jp PlaceNextChar

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
	jp FinishDTE
	
	
;trainers name
Char48::
	pop hl		;recover the destination pointer
	push de
	ld de,W_TRAINERNAME
	ld a,[wEnemyTrainerFirstName + 1]
	cp "@"		;is the trainer first name empty?
	jr z,.finish		;then finish
	call PlaceInlineString
	ld h,b
	ld l,c
	ld de,wEnemyTrainerFirstName
.finish
	jp FinishDTE
	
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

Char55:: ; 1a7c (0:1a7c)
	pop hl		;recover the destination pointer
	push de
	ld b,h
	ld c,l
	ld hl,Char55Text
	call TextCommandProcessor
	ld h,b
	ld l,c
	pop de
	inc de
	jp PlaceNextChar

Char55Text:: ; 1a8c (0:1a8c)
; equivalent to Char4B
	TX_FAR _Char55Text
	db "@"

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
	ld a,$C4
	Coorda 18, 13
	jr Char57Finish
	
Char57:: ; 1aad (0:1aad)
	pop hl
Char57Finish::
	pop de		;recover the starting position
	ld de,Char58Text
	dec de
	ret

Char58Text:: ; 1ab3 (0:1ab3)
	db "@"

	
Char51:: ; 1ab4 (0:1ab4)
	pop hl		;recover the destination pointer
	push de
	ld a,$EE
	Coorda 18, 13
	call ProtectedDelay3
	call ManualTextScroll
	hlCoord 1, 13
	ld bc,$0412
	call ClearScreenArea
	ld c,$14
	call DelayFrames
	pop de
	inc de
	hlCoord 1, 14
	ld a,[wTextCharCount]
	and a
	jr z,.finish		;if we aren't, then finish
	ld a,%11000000		;re-initialize the counter
	ld [wTextCharCount],a
	push de		;push de since we are counting again
.finish
	jp PlaceNextChar

Char49:: ; 1ad5 (0:1ad5)
	pop hl		;recover the destination pointer
	push de
	ld a,$EE
	Coorda 18, 13
	call ProtectedDelay3
	call ManualTextScroll
	hlCoord 1, 10
	ld bc,$0712
	call ClearScreenArea
	ld c,$14
	call DelayFrames
	pop de
	pop hl
	hlCoord 1, 11
	push hl
	jp Next19E8

Char4B:: ; 1af8 (0:1af8)
	pop hl		;recover the destination pointer
	ld a,$EE
	Coorda 18, 13
	call ProtectedDelay3
	push de
	call ManualTextScroll
	pop de
	ld a,$C4
	Coorda 18, 13
	push hl		;push hl again because 4c will pop it
	;fall through

Char4C:: ; 1b0a (0:1b0a)
	pop hl		;recover the destination pointer
	push de
	call Next1B18
	call Next1B18
	hlCoord 1, 16
	pop de
	inc de
	ld a,[wTextCharCount]
	and a
	jr z,.finish		;if we aren't, then finish
	ld a,%11000000		;re-initialize the counter
	ld [wTextCharCount],a
	pop de
	inc de
	push de		;push the source pointer
.finish
	jp PlaceNextChar

Next1B18:: ; 1b18 (0:1b18)
	hlCoord 0, 14
	deCoord 0, 13
	ld b,$3C
.next
	ld a,[hli]
	ld [de],a
	inc de
	dec b
	jr nz,.next
	hlCoord 1, 16
	ld a,$C4
	ld b,$12
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
	ld a,%11000000
	ld [wTextCharCount],a	;initialize wTextCharCount to indicate that we should check for word wrapping and counting letters
	pop hl
	call Func_3c59
	xor a
	ld [wTextCharCount],a		;reset wTextCharCount
	ret
	
Func_3c59:: ; 3c59 (0:3c59)
	bcCoord 1, 14
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
	
FinishCountingLetters:
	;if we were counting letters, then see if we need to add a line break
	ld a,%00011111
	and [hl]		;only keep the character count
	cp CharsPerRow + 1
	jr c,.noLineBreak		;if it is under 19, then we do not need to add a line break, so finish counting
	
	bit FirstLineBreak,[hl]		;have we already added the first line break
	jr z,.dontScrollText		;if not, then we don't scroll the text
	
	;scroll text
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
	
	
	call Next1B18
	call Next1B18
	pop de			;scroll the text
	pop hl
	;fall through
	
.dontScrollText
	ld [hl],%11100000		;reset the counter and but set all other flags

	;move pointer to second line
	pop hl		;recover the destination
	hlCoord 1, 16		;store the new destination
	pop de		;recover the starting position
	push de		;store the starting position again since we are still counting
	jr PlaceNextChar	;start over
	
.noLineBreak
	;if no line break, then turn off the counting letters bit
	res CountingLetters,[hl]
	pop hl		;recover the destination
	pop de		;recover the start of the word
	jr PlaceNextChar	;place the characters
	
	
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
	jp [hl]
	
.handleChar
	ld hl,wTextCharCount
	bit CountingLetters,[hl]
	jr z,.placeChar		;if are not counting characters, then place char
	
	inc [hl]		;increment the counter
	pop hl			;recover the destination, don't increment
	jr Next19E8
	
.placeChar
	pop hl			;recover the destination
	ld a,[de]
	ld [hli],a
	call PrintLetterDelay
	;fall through
	
Next19E8:
	inc de
	jp PlaceNextChar		

SpecialTextChars:
	db $00
	dw Char00
	db " "
	dw CharSpace
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
	db $4E
	dw Char4E
	db $4F
	dw Char4F
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
	ld a,[wd358]
	push af
	set 1,a
	ld e,a
	ld a,[$fff4]
	xor e
	ld [wd358],a
	ld a,c
	ld [wcc3a],a
	ld a,b
	ld [wcc3b],a

NextTextCommand:: ; 1b55 (0:1b55)
	ld a,[hli]
	cp a, "@" ; terminator
	jr nz,.doTextCommand
	pop af
	ld [wd358],a
	ret
.doTextCommand
	push hl
	cp a,$17
	jp z,TextCommand17	;text in another bank
	cp a,$0e
	jp nc,TextCommand0B			;play sounds
	; if a != 0x17 and a >= 0xE, go to command 0xB
; if a < 0xE, use a jump table
	ld hl,TextCommandJumpTable
	push bc
	add a
	ld b,$00
	ld c,a
	add hl,bc
	pop bc
	ld a,[hli]
	ld h,[hl]
	ld l,a
	jp [hl]

; draw box
; 04AAAABBCC
; AAAA = address of upper left corner
; BB = height
; CC = width
TextCommand04:: ; 1b78 (0:1b78)
	pop hl
	ld a,[hli]
	ld e,a
	ld a,[hli]
	ld d,a
	ld a,[hli]
	ld b,a
	ld a,[hli]
	ld c,a
	push hl
	ld h,d
	ld l,e
	call TextBoxBorder
	pop hl
	jr NextTextCommand

; place string inline
; 00{string}
TextCommand00:: ; 1b8a (0:1b8a)
	pop hl
	ld d,h
	ld e,l
	ld h,b
	ld l,c
	call PlaceString
	ld h,d
	ld l,e
	inc hl
	jr NextTextCommand

; place string from RAM
; 01AAAA
; AAAA = address of string
TextCommand01:: ; 1b97 (0:1b97)
	pop hl
	ld a,[hli]
	ld e,a
	ld a,[hli]
	ld d,a
	push hl
	ld h,b
	ld l,c
	call PlaceString
	pop hl
	jr NextTextCommand

; print BCD number
; 02AAAABB
; AAAA = address of BCD number
; BB
; bits 0-4 = length in bytes
; bits 5-7 = unknown flags
TextCommand02:: ; 1ba5 (0:1ba5)
	pop hl
	ld a,[hli]
	ld e,a
	ld a,[hli]
	ld d,a
	ld a,[hli]
	push hl
	ld h,b
	ld l,c
	ld c,a
	call PrintBCDNumber
	ld b,h
	ld c,l
	pop hl
	jr NextTextCommand

; repoint destination address
; 03AAAA
; AAAA = new destination address
TextCommand03:: ; 1bb7 (0:1bb7)
	pop hl
	ld a,[hli]
	ld [wcc3a],a
	ld c,a
	ld a,[hli]
	ld [wcc3b],a
	ld b,a
	jp NextTextCommand

; repoint destination to second line of dialogue text box
; 05
; (no arguments)
TextCommand05:: ; 1bc5 (0:1bc5)
	pop hl
	bcCoord 1, 16 ; address of second line of dialogue text box
	jp NextTextCommand

; blink arrow and wait for A or B to be pressed
; 06
; (no arguments)
TextCommand06:: ; 1bcc (0:1bcc)
	ld a,[wLinkState]
	cp a,LINK_STATE_BATTLING
	jp z,TextCommand0D
	ld a,$ee ; down arrow
	Coorda 18, 13 ; place down arrow in lower right corner of dialogue text box
	push bc
	call ManualTextScroll ; blink arrow and wait for A or B to be pressed
	pop bc
	ld a," "
	Coorda 18, 13 ; overwrite down arrow with blank space
	pop hl
	jp NextTextCommand

; scroll text up one line
; 07
; (no arguments)
TextCommand07:: ; 1be7 (0:1be7)
	ld a," "
	Coorda 18, 13 ; place blank space in lower right corner of dialogue text box
	call Next1B18 ; scroll up text
	call Next1B18
	pop hl
	bcCoord 1, 16 ; address of second line of dialogue text box
	jp NextTextCommand

; execute asm inline
; 08{code}
TextCommand08:: ; 1bf9 (0:1bf9)
	pop hl
	ld de,NextTextCommand
	push de ; return address
	jp [hl]

; print decimal number (converted from binary number)
; 09AAAABB
; AAAA = address of number
; BB
; bits 0-3 = how many digits to display
; bits 4-7 = how long the number is in bytes
TextCommand09:: ; 1bff (0:1bff)
	pop hl
	ld a,[hli]
	ld e,a
	ld a,[hli]
	ld d,a
	ld a,[hli]
	push hl
	ld h,b
	ld l,c
	ld b,a
	and a,$0f
	ld c,a
	ld a,b
	and a,$f0
	swap a
	set 6,a
	ld b,a
	call PrintNumber
	ld b,h
	ld c,l
	pop hl
	jp NextTextCommand

; wait half a second if the user doesn't hold A or B
; 0A
; (no arguments)
TextCommand0A:: ; 1c1d (0:1c1d)
	push bc
	call Joypad
	ld a,[hJoyHeld]
	and a,%00000011 ; A and B buttons
	jr nz,.skipDelay
	ld c,30
	call DelayFrames
.skipDelay
	pop bc
	pop hl
	jp NextTextCommand

; plays sounds
; this actually handles various command ID's, not just 0B
; (no arguments)
TextCommand0B:: ; 1c31 (0:1c31)
	pop hl
	push bc
	dec hl
	ld a,[hli]
	ld b,a ; b = command number that got us here
	push hl
	ld hl,TextCommandSounds
.loop
	ld a,[hli]
	cp b
	jr z,.matchFound
	inc hl
	jr .loop
.matchFound
	cp a,$14
	jr z,.pokemonCry
	cp a,$15
	jr z,.pokemonCry
	cp a,$16
	jr z,.pokemonCry
	ld a,[hl]
	call PlaySound
	call WaitForSoundToFinish
	pop hl
	pop bc
	jp NextTextCommand
.pokemonCry
	push de
	ld a,[hl]
	call PlayCry
	pop de
	pop hl
	pop bc
	jp NextTextCommand

; format: text command ID, sound ID or cry ID
TextCommandSounds:: ; 1c64 (0:1c64)
	db $0B,(SFX_02_3a - SFX_Headers_02) / 3
	db $12,(SFX_08_46 - SFX_Headers_08) / 3
	db $0E,(SFX_02_41 - SFX_Headers_02) / 3
	db $0F,(SFX_02_3a - SFX_Headers_02) / 3
	db $10,(SFX_02_3b - SFX_Headers_02) / 3
	db $11,(SFX_02_42 - SFX_Headers_02) / 3
	db $13,(SFX_08_45 - SFX_Headers_08) / 3
	db $14,NIDORINA ; used in OakSpeech
	db $15,PIDGEOT  ; used in SaffronCityText12
	db $16,DEWGONG  ; unused?

; draw ellipses
; 0CAA
; AA = number of ellipses to draw
TextCommand0C:: ; 1c78 (0:1c78)
	pop hl
	ld a,[hli]
	ld d,a
	push hl
	ld h,b
	ld l,c
.loop
	ld a,$75 ; ellipsis
	ld [hli],a
	push de
	call Joypad
	pop de
	ld a,[hJoyHeld] ; joypad state
	and a,%00000011 ; is A or B button pressed?
	jr nz,.skipDelay ; if so, skip the delay
	ld c,10
	call DelayFrames
.skipDelay
	dec d
	jr nz,.loop
	ld b,h
	ld c,l
	pop hl
	jp NextTextCommand

; wait for A or B to be pressed
; 0D
; (no arguments)
TextCommand0D:: ; 1c9a (0:1c9a)
	push bc
	call ManualTextScroll ; wait for A or B to be pressed
	pop bc
	pop hl
	jp NextTextCommand

; process text commands in another ROM bank
; 17AAAABB
; AAAA = address of text commands
; BB = bank
TextCommand17:: ; 1ca3 (0:1ca3)
	pop hl
	ld a,[H_LOADEDROMBANK]
	push af
	ld a,[hli]
	ld e,a
	ld a,[hli]
	ld d,a
	ld a,[hli]
	ld [H_LOADEDROMBANK],a
	ld [$2000],a
	push hl
	ld l,e
	ld h,d
	call TextCommandProcessor
	pop hl
	pop af
	ld [H_LOADEDROMBANK],a
	ld [$2000],a
	jp NextTextCommand

TextCommandJumpTable:: ; 1cc1 (0:1cc1)
	dw TextCommand00
	dw TextCommand01
	dw TextCommand02
	dw TextCommand03
	dw TextCommand04
	dw TextCommand05
	dw TextCommand06
	dw TextCommand07
	dw TextCommand08
	dw TextCommand09
	dw TextCommand0A
	dw TextCommand0B
	dw TextCommand0C
	dw TextCommand0D