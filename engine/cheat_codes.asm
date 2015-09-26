CheatCodeCheck:
	ld hl,CheatCodesTables1		;first cheat code table
	call CompareCheatCode
	ld hl,wActiveCheats
	jr z,.setCheatCode		;set the cheat code if there is a match (a is which bit to set)
	ld hl,CheatCodesTables2		;second cheat code table
	call CompareCheatCode
	ld hl,wActiveCheats2
	jr z,.setCheatCode		;set the cheat code if there is a match (a is which bit to set)
	xor a
	ret	;otherwise, exit without setting a carry flag
.setCheatCode
	ld b,9
	ld c,a
	inc c
	ld a,[hl]		;load the cheat code byte into a
.setBitLoop
	dec c
	jr z,.toggleBit
	dec b
	rrca
	jr .setBitLoop
.toggleBit
	bit 0,a
	jr z,.setBit		;set the bit if it isn't already set
	res 0,a
	jr .resetCheatCodeByteLoop
.setBit
	set 0,a
.resetCheatCodeByteLoop
	dec b
	jr z,.clearName
	rrca
	jr .resetCheatCodeByteLoop
.clearName
	ld [hl],a		;save the byte
	coord hl, 5, 7
	ld a, [wNamingScreenType]
	cp NAME_MON_SCREEN		;nickname screen?
	jr nc,.dontAdjust		;dont adjust the line if so
	ld de,-20
	add hl,de		;move up a line if not pokemon screen
.dontAdjust
	ld b,10
	ld a,$D4
.clearLoop
	ld [hli],a
	dec b
	jr nz,.clearLoop
	ld a,$50
	ld [wcf4b],a
	xor a
	ld hl, wHPBarMaxHP + 1
	ld [hli], a
	ld [hli], a
	ld a,SFX_INTRO_WHOOSH
	ld [wNewSoundID],a
	call PlaySound	;play sound
	call WaitForSoundToFinish	;wait for it to 
	scf
	ret
	
;to see if the text input name equals a cheat code
CompareCheatCode:
	ld de,wcf4b		;where the name is
	ld a,0		;which cheat code we are at
.outerLoop
	push af
	push de
.innerLoop
	ld a,[de]
	inc de
	swap a
	add $F1		;encode the value
	cp [hl]		;does it match the current cheat code?
	inc hl
	jr nz,.nextWord		;go to the next word if no match
	cp $F6		;did we reach the end of the word (encoded)?
	jr nz,.innerLoop		;loop if not
	pop de
	pop bc
	xor a
	ld a,b
	ret		;otherwise, return
.nextWord
	pop de
.goToNextRowLoop
	ld a,[hli]
	cp $F6
	jr nz,.goToNextRowLoop
	ld a,[hl]
	inc a		;did we reach the end of the table?
	jr nz,.incAndLoop
	pop af
	xor a
	inc a		;unset the zero flag
	ret
.incAndLoop
	pop af
	inc a
	jr .outerLoop
	
CheatCodesTables1:
	db $79, $c9, $4a, $39, $0a, $2a, $39, $0a, $F6
	db $69, $f9, $c9, $29, $3d, $29, $0a, $f9, $5a, $c9, $F6
	db $79, $5a, $69, $09, $7a, $29, $F6
	db $a9, $3a, $19, $99, $7a, $19, $69, $f9, $0a, $b9, $F6
	db $49, $0a, $39, $39, $3d, $e9, $19, $F6
	db $49, $79, $0a, $39, $1a, $f9, $a9, $39, $F6
	db $29, $39, $1a, $d9, $a9, $f9, $2a, $39, $F6
	db $1a, $b9, $f9, $a9, $a9, $49, $0a, $7a, $F6
	db $FF
	
CheatCodesTables2:
	db $09, $d9, $d9, $2a, $19, $f9, $b9, $e9, $F6
	db $1a, $f9, $c9, $2a, $f9, $1a, $1a, $f9, $19, $99, $F6
	db $f9, $59, $f9, $79, $c9, $1a, $2a, $3d, $b9, $39, $F6
	db $69, $39, $f9, $a9, $2a, $69, $3d, $c9, $3a, $2a, $F6
	db $0a, $39, $29, $3d, $09, $3a, $a9, $a9, $F6
	db $f9, $a9, $3d, $19, $f9, $e9, $d9, $c9, $39, $F6
	db $b9, $f9, $99, $39, $79, $2a, $0a, $f9, $79, $c9, $F6
	db $1a, $b9, $f9, $0a, $2a, $e9, $69, $d9, $c9, $39, $F6
	db $FF