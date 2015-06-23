AskName: ; 64eb (1:64eb)
	call SaveScreenTilesToBuffer1
	call GetPredefRegisters
	push hl
	ld a, [W_ISINBATTLE]
	dec a
	ld hl, wTileMap
	ld b, $4
	ld c, $b
	call z, ClearScreenArea ; only if in wild batle
	ld a, [wcf91]
	ld [wd11e], a
	call GetMonName
	ld hl, DoYouWantToNicknameText
	call PrintText
	hlCoord 14, 7
	ld bc, $80f
	ld a, TWO_OPTION_MENU
	ld [wTextBoxID], a
	call DisplayTextBoxID
	pop hl
	ld a, [wCurrentMenuItem]
	and a
	jr nz, .asm_654c
	ld a, [wUpdateSpritesEnabled]
	push af
	xor a
	ld [wUpdateSpritesEnabled], a
	push hl
	ld a, $2
	ld [wd07d], a
	call DisplayNamingScreen
	ld a, [W_ISINBATTLE]
	and a
	jr nz, .asm_653e
	call ReloadMapSpriteTilePatterns
.asm_653e
	call LoadScreenTilesFromBuffer1
	pop hl
	pop af
	ld [wUpdateSpritesEnabled], a
	ld a, [wcf4b]
	cp $50
	ret nz
.asm_654c
	ld d, h
	ld e, l
	ld hl, wcd6d
	ld bc, $000b
	jp CopyData

DoYouWantToNicknameText: ; 0x6557
	TX_FAR _DoYouWantToNicknameText
	db "@"

Func_655c: ; 655c (1:655c)
	ld hl, wHPBarMaxHP
	xor a
	ld [wUpdateSpritesEnabled], a
	ld a, $2
	ld [wd07d], a
	call DisplayNamingScreen
	call GBPalWhiteOutWithDelay3
	call RestoreScreenTilesAndReloadTilePatterns
	call LoadGBPal
	ld a, [wcf4b]
	cp $50
	jr z, .asm_6594
	ld hl, wPartyMonNicks
	ld bc, $b
	ld a, [wWhichPokemon]
	call AddNTimes
	ld e, l
	ld d, h
	ld hl, wHPBarMaxHP
	ld bc, $b
	call CopyData
	and a
	ret
.asm_6594
	scf
	ret

DisplayNamingScreen: ; 6596 (1:6596)
	push hl
	ld hl, wd730
	set 6, [hl]
	call GBPalWhiteOutWithDelay3
	
	ld a,$DD
	call ClearScreenAltTile
	call UpdateSprites
	
	ld a,[wWhichScreen]
	push af
	ld a,TextInputScreen
	ld [wWhichScreen],a
	call LoadFontTilePatterns
	call LoadTextBoxTilePatterns
	call LoadSecondTextBoxBorderTiles
	ld b, $8
	call GoPAL_SET
	
	hlCoord 2,9
	ld bc,$50e
	call TextBoxBorder
	hlCoord 2,2
	ld bc,$50e
	call TextBoxBorderAndAdjust
	
	ld a, [wd07d]
	cp 2	;nickname screen?
	jr c,.afterClearingSpriteArea		;skip if not
	hlCoord 14,4
	ld a,$D9
	ld [hli],a
	inc a
	ld [hld],a
	ld de,20
	add hl,de
	inc a
	ld [hli],a
	inc a
	ld [hl],a
	
.afterClearingSpriteArea
	callba LoadMonPartySpriteGfx
	call PrintNamingText
	xor a
	ld [wTopMenuItemY], a
	ld [wTopMenuItemX], a
	ld [wLastMenuItem], a
	ld a,$E5		;unused tile at start
	ld [wCurrentMenuItem], a
	ld a, $ff
	ld [wMenuWatchedKeys], a
	ld a, $50
	ld [wcf4b], a
	xor a
	ld hl, wHPBarMaxHP + 1
	ld [hli], a
	ld [hli], a
	ld [wPartyMonAnimCounter], a
.asm_65ed
	call PrintAlphabet
	call GBPalNormal
.asm_65f3
	ld a, [wHPBarMaxHP + 1]
	and a
	jr nz, .asm_662d
	call Func_680e
.asm_65fc
	call PlaceKeyboardCursor
.asm_65ff
	ld a, [wCurrentMenuItem]
	push af
	callba AnimatePartyMon_ForceSpeed1
	pop af
	ld [wCurrentMenuItem], a
	call JoypadLowSensitivity
	ld a, [hJoyPressed]
	and a
	jr z, .asm_65ff
	ld hl, .unknownPointerTable_665e
.asm_661a
	sla a
	jr c, .asm_6624
	inc hl
	inc hl
	inc hl
	inc hl
	jr .asm_661a
.asm_6624
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	push de
	jp [hl]
.asm_662d
	call GBPalWhiteOutWithDelay3
	call ClearScreen
	call ClearSprites
	
	
	pop af
	ld [wWhichScreen],a		;restore the previous screen id
	call LoadFontTilePatterns ;and reload the correct font tiles
	call LoadTextBoxTilePatterns
	
	pop de
	ld hl, wcf4b
	ld bc, $b
	call CopyData
	
	call GoPAL_SET_CF1C
	call GBPalNormal
	xor a
	ld [W_SUBANIMTRANSFORM], a
	ld hl, wd730
	res 6, [hl]
	ld a, [W_ISINBATTLE]
	and a
	jp z, LoadTextBoxTilePatterns
	ld hl, LoadHudTilePatterns
	ld b, BANK(LoadHudTilePatterns)
	jp Bankswitch

.unknownPointerTable_665e: ; 665e (1:665e)
	dw .asm_65fc
	dw .asm_673e
	dw .asm_65fc
	dw .asm_672c
	dw .asm_65fc
	dw .asm_6718
	dw .asm_65fc
	dw .asm_6702
	dw .asm_65f3
	dw .asm_668c
	dw .asm_65ed
	dw .asm_6683
	dw .asm_65f3
	dw .deleteLetter
	dw .asm_65f3
	dw .asm_6692

.asm_667e
	pop de
	ld de, .asm_65ed ; $65ed
	push de
.asm_6683
	call AnimateCaps
	ld a, [wHPBarOldHP]
	xor $1
	ld [wHPBarOldHP], a
	ret
.asm_668c
	ld a, [wd07d]
	cp $2
	jr nc, .skipCheckingLength
	ld a, [wHPBarMaxHP]
	and a
	ret z		;return if players name is empty
.skipCheckingLength
	call AnimateEnter
	ld a, $1
	ld [wHPBarMaxHP + 1], a
	ret
.asm_6692		; a pressed
	ld a, [wCurrentMenuItem]
	cp $9A
	jr z,.deleteLetter		;delete letter
	cp $9B
	jr z,.deleteLetter		;delete letter
	cp $9C
	jr z, .asm_667e		;swap case
	cp $9D
	jr z, .asm_667e		;swap case
	cp $9E
	jr z, .asm_668c		;finish
	cp $9F
	jr z, .asm_668c		;finish
	ld [wHPBarNewHP], a
	call CalcStringLength
	ld a, [wHPBarMaxHP]
	cp 10 ; max length of pokemon nicknames
	ret nc
	ld a, [wHPBarNewHP]
	ld [hli], a
	ld [hl], $50
	call AnimateTilePress
	call PlayButtonPressSound
	ret
.deleteLetter
	ld a, [wHPBarMaxHP]
	and a
	ret z
	call AnimateBackspace
	call CalcStringLength
	dec hl
	ld [hl], $50
	ret
.asm_6702	;right pressed
	ld a, [wCurrentMenuItem]
	cp " "
	ret z		;dont move right if on spacebar
	cp $9A
	jr c,.noWrapRight
	cp $A0
	jr c,.wrapAroundRight		;if one of the function keys,then wrap around
.noWrapRight
	ld a,[wTopMenuItemX]
	cp 11		;at the end?
	jr z,.wrapAroundRight
	inc a
	jr .asm_6755
.wrapAroundRight
	ld a, 0
	jr .asm_6755
.asm_6718	;left pressed
	ld a, [wCurrentMenuItem]
	cp " "
	ret z		;dont move left if on spacebar
	cp $9B
	jr z,.jumpLeft
	cp $9D
	jr z,.jumpLeft
	cp $9F
	jr nz,.noJumpLeft		;if not right side of function, then dont jump
.jumpLeft
	ld a,[wTopMenuItemX]
	dec a
	dec a
	jr .asm_6755
.noJumpLeft
	ld a,[wTopMenuItemX]
	and a
	jr z,.wrapAroundLeft		;if at start, then wrap around
	dec a
	jr .asm_6755
.wrapAroundLeft
	ld a, 11
	jr .asm_6755
.asm_672c		;up pressed
	ld a,[wTopMenuItemY]
	and a
	jr z,.wrapAroundUp
	dec a
	jr .saveToY
.wrapAroundUp
	ld a,4
.saveToY
	ld [wTopMenuItemY], a
	ret
.asm_673e		;down pressed
	ld a, [wCurrentMenuItem]
	cp " "	;are we at space bar?
	jr z,.wrapAroundDown
	ld a,[wTopMenuItemY]
	inc a
	jr .saveToY
	
.wrapAroundDown
	ld a,0
	jr .saveToY

.asm_6755
	ld [wTopMenuItemX], a
	ret

ED_Tile: ; 6767 (1:6767)
	INCBIN "gfx/ED_tile.1bpp"

PrintAlphabet: ; 676f (1:676f)
	xor a
	ld [H_AUTOBGTRANSFERENABLED], a ; $ffba
	ld a, [wHPBarOldHP]
	and a
	ld de, LowerCaseAlphabet ; $679e
	jr nz, .asm_677e
	ld de, UpperCaseAlphabet ; $67d6
.asm_677e
	hlCoord 4, 10
	ld bc, $50c
.asm_6784
	push bc
.asm_6785
	ld a, [de]
	ld [hli], a
	inc de
	dec c
	jr nz, .asm_6785
	ld bc, 8
	add hl, bc
	pop bc
	dec b
	jr nz, .asm_6784
	call PlaceString
	ld a, $1
	ld [H_AUTOBGTRANSFERENABLED], a ; $ffba
	jp Delay3

LowerCaseAlphabet: ; 679e (1:679e)
	db "0123456789()qwertyuiop",$e1,$e2,"asdfghjkl'[]zxcvbnm.",$ee,$f5,":;   ",$ba,$bb,$bc,$bd,$be,$bf,"   @"

UpperCaseAlphabet: ; 67d6 (1:67d6)
	db "0123456789()QWERTYUIOP",$e1,$e2,"ASDFGHJKL'[]ZXCVBNM.",$ee,$f5,":;   ",$ba,$bb,$bc,$bd,$be,$bf,"   @"

PlaceKeyboardCursor:
	ld a,[wTopMenuItemX]
	ld b,0
	ld c,a
	ld a,[wTopMenuItemY]
	cp a,4		;space bar?
	jr nz,.notSpace
	ld a,[wCurrentMenuItem]
	cp a," "
	ret z		;return if we are already on the space bar
	call .unhighlight
	ld a," "
	ld [wCurrentMenuItem],a
	ld hl,vFont + $3C0	;middle of spacebar
	ld de,KeyboardHighlightFont + $3C0
	ld c,2
	jr .finish
	
.notSpace
	hlCoord 4, 10		;top left of keyboard
	ld de,20		;one line
.loop
	and a
	jr z,.exitLoop
	add hl,de
	dec a
	jr .loop
.exitLoop
	add hl,bc		;move the x direction
	ld a,[hl]		;get the ID of the key
	ld hl,wCurrentMenuItem
	cp [hl]
	ret z		;return if we didn't change keys
	push af
	call .unhighlight
	pop af
	ld [wCurrentMenuItem],a
	call GetOffsetInBCDE
	ld hl,vFont
	add hl,bc		;hl is where to copy to
	push hl
	ld hl,KeyboardHighlightFont
	add hl,de
	push hl
	pop de			;de is where to copy from
	pop hl			;restore hl
	call .getSizeToCopy
.finish
	ld b, BANK(KeyboardHighlightFont)
	jp CopyVideoData
.unhighlight
	ld a,[wCurrentMenuItem]
	cp " "
	jr nz,.notSpaceUnhighlight
	ld hl,vFont + $3C0	;middle of spacebar
	ld de,KeyboardFont + $3C0
	ld c,2
	jr .finishUnhighlight
	
.notSpaceUnhighlight
	call GetOffsetInBCDE
	ld hl,vFont
	add hl,bc		;hl is where to copy to
	push hl
	ld hl,KeyboardFont
	add hl,de
	push hl
	pop de			;de is where to copy from
	pop hl			;restore hl
	call .getSizeToCopy
.finishUnhighlight
	ld b, BANK(KeyboardFont)
	jp CopyVideoData		;unhighlight
.getSizeToCopy
	ld a,[wCurrentMenuItem]
	cp $9a
	jr z,.dontDec
	cp $9b
	jr z,.dec
	cp $9c
	jr z,.dontDec
	cp $9d
	jr z,.dec
	cp $9e
	jr z,.dontDec
	cp $9f
	jr nz,.notSpecial
.dec
	ld bc,-$10
	add hl,bc
	push hl
	
	push de
	pop hl
	add hl,bc
	push hl
	pop de
	
	pop hl
.dontDec
	ld c,2
	ret
.notSpecial
	ld c,1
	ret
	
;to draw the text box border, but then incrase the tile id's by $10
TextBoxBorderAndAdjust:
	push hl
	push bc
	call TextBoxBorder
	pop bc
	pop hl
	inc b
	inc b
	inc c
	inc c
.loop1
	push hl
	push bc
.loop2
	ld a,[hl]
	add a,$10
	ld [hli],a
	dec c
	jr nz,.loop2	
.continueLoop
	pop bc
	pop hl
	dec b
	ret z
	ld de,20
	add hl,de	;move to next row	
	jr .loop1
	
;to copy over the secondary text box border
LoadSecondTextBoxBorderTiles:
	ld de,PCTextBox2Graphics			;de is where to copy from
	ld hl,vFont + $500			;restore hl
	ld c,14
	ld b, BANK(PCTextBox2Graphics)
	jp CopyVideoData

	
AnimateTilePress:
	ld a,[wCurrentMenuItem]
	cp " "
	jr z,.animateSpace
	call GetOffsetInBCDE
	ld hl,vFont
	add hl,bc		;hl is where to copy to
	push hl
	ld hl,KeyboardPressFont
	add hl,de
	push hl
	pop de			;de is where to copy from
	pop hl			;restore hl
	ld c,1
	ld b, BANK(KeyboardPressFont)
	call CopyVideoData
	ld c,10
	call DelayFrames
	ld a,[wCurrentMenuItem]
	call GetOffsetInBCDE
	ld hl,vFont
	add hl,bc		;hl is where to copy to
	push hl
	ld hl,KeyboardHighlightFont
	add hl,de
	push hl
	pop de			;de is where to copy from
	pop hl			;restore hl
	ld c,1
	ld b, BANK(KeyboardFont)
	jp CopyVideoData
.animateSpace
	ld hl,vFont + $3A0	;start of spacebar
	ld de,KeyboardPressFont + $3A0
	ld c,6
	ld b, BANK(KeyboardPressFont)
	call CopyVideoData
	ld c,10
	call DelayFrames
	ld hl,vFont + $3A0	;start of spacebar
	ld de,KeyboardHighlightFont + $3A0
	ld c,6
	ld b, BANK(KeyboardHighlightFont)
	jp CopyVideoData
	
PlayButtonPressSound:
	ld a, (SFX_02_40 - SFX_Headers_02) / 3
	jp PlaySound
	
AnimateCaps:
	ld hl,vFont + $1C0	;start of caps
	ld de,KeyboardPressFont + $1C0
	ld c,2
	ld b, BANK(KeyboardPressFont)
	call CopyVideoData
	ld c,10
	call DelayFrames
	ld hl,vFont + $1C0	;start of caps
	ld a,[wCurrentMenuItem]
	cp a,$9C
	ld de,KeyboardHighlightFont + $1C0
	jr z,.skip
	cp a,$9D
	jr z,.skip
	ld de,KeyboardFont + $1C0
.skip
	ld c,2
	ld b, BANK(KeyboardHighlightFont)
	call CopyVideoData
	jp PlayButtonPressSound

AnimateBackspace:
	ld hl,vFont + $1A0	;start of backspace
	ld de,KeyboardPressFont + $1A0
	ld c,2
	ld b, BANK(KeyboardPressFont)
	call CopyVideoData
	ld c,10
	call DelayFrames
	ld hl,vFont + $1A0	;start of backspace
	ld a,[wCurrentMenuItem]
	cp a,$9A
	ld de,KeyboardHighlightFont + $1A0
	jr z,.skip
	cp a,$9B
	jr z,.skip
	ld de,KeyboardFont + $1A0
.skip
	ld c,2
	ld b, BANK(KeyboardHighlightFont)
	call CopyVideoData
	jp PlayButtonPressSound

AnimateEnter:
	ld hl,vFont + $1E0	;start of enter
	ld de,KeyboardPressFont + $1E0
	ld c,2
	ld b, BANK(KeyboardPressFont)
	call CopyVideoData
	ld c,10
	call DelayFrames
	ld hl,vFont + $1E0	;start of enter
	ld a,[wCurrentMenuItem]
	cp a,$9E
	ld de,KeyboardHighlightFont + $1E0
	jr z,.skip
	cp a,$9F
	jr z,.skip
	ld de,KeyboardFont + $1E0
.skip
	ld c,2
	ld b, BANK(KeyboardHighlightFont)
	call CopyVideoData
	jp PlayButtonPressSound

GetOffsetInBCDE:
	sub a,$80
	ld c,a
	and $F0
	swap a
	ld b,a
	ld a,c
	and $0F
	swap a
	ld c,a		;bc is the offset of where to copy to
	push bc
	pop de
	ld a,d
	cp 4		;check to see if we went past the 4th row of tiles
	ret c		;return if we dont have to adjust
	ld hl,-$200
	add hl,de
	push hl
	pop de	
	ret
	
Func_680e: ; 680e (1:680e)
	call CalcStringLength
	ld a, c
	ld [wHPBarMaxHP], a
	hlCoord 5, 7
	ld a, [wd07d]
	cp 2	;nickname screen?
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

	ld a,10
	sub c
	push af
	
	ld hl,wcf4b
	ld de,$9600
	call CopyLetterTilesToVRAM
	
	pop af
	ld c,a
	ld b,0
	hlCoord 5, 7
	add hl,bc		;hl is where to copy to
	ld a, [wd07d]
	cp 2	;nickname screen?
	jr nc,.dontAdjust2		;dont adjust the line if so
	ld de,-20
	add hl,de		;move up a line if not pokemon screen
.dontAdjust2
	ld a,$60
	ld de,wcf4b
.loop2
	push af
	ld a,[de]
	cp $50
	jr z,.finish
	pop af
	ld [hli],a
	inc a
	inc de
	jr .loop2		;print the pokemon string
.finish
	pop af
	ret
	
	ret

Func_6871: ; 6871 (1:6871)
	push de
	call CalcStringLength
	dec hl
	ld a, [hl]
	pop hl
	ld de, $2
	call IsInArray
	ret nc
	inc hl
	ld a, [hl]
	ld [wHPBarNewHP], a
	ret

; calculates the length of the string at wcf4b and stores it in c
CalcStringLength: ; 68eb (1:68eb)
	ld hl, wcf4b
	ld c, $0
.asm_68f0
	ld a, [hl]
	cp $50
	ret z
	inc hl
	inc c
	jr .asm_68f0

;to copy over the black text tiles (text pointer in hl) for the corresponding letter into the vram at de
CopyLetterTilesToVRAM:
.loop
	ld a,[hli]
	cp "@"
	ret z		;return when we reach the end of the string
	push hl
	
	ld hl,WhiteOnBlackFont
	cp a,$E0		;are we in the second section of tiles?
	jr c,.dontAdjust		;skip down if not
	sub $20		;otherwise, subtract by $20 for the source
.dontAdjust
	sub $80		;reduce by the first tile name anyway
	swap a
	push af
	and $0F
	ld b,a
	pop af
	and $F0
	ld c,a
	add hl,bc	;hl is where to copy from
	
	push hl
	push de
	pop hl
	pop de		;de is where to copy from, hl is where to copy to
	
	ld c,1
	ld b,BANK(WhiteOnBlackFont)
	call CopyVideoData
	ld de,$10
	add hl,de
	push hl
	pop de
	
	pop hl
	jr .loop
	
PrintNamingText: ; 68f8 (1:68f8)
	ld hl,NameLabelString
	ld de,vFont + $490
	call CopyLetterTilesToVRAM
	
	hlCoord 3,5
	ld a, [wd07d]
	cp 2	;nickname screen?
	jr nc,.dontAdjust		;dont adjust the line if so
	ld de,-20
	add hl,de		;move up a line if not pokemon screen
.dontAdjust
	ld a,$C9
	ld b,5
.loop
	ld [hli],a
	inc a
	dec b
	jr nz,.loop		;print the Name: string
	
	ld a, [wd07d]
	cp 2	;nickname screen?
	ret c		;return if not
	ld a, [wcf91]
	ld [wMonPartySpriteSpecies], a
	push af
	callba WriteMonPartySpriteOAMBySpecies
	pop af
	ld [wd11e], a
	call GetMonName
	ld hl,wcd6d		;where the name was copied to
	ld de,$9700
	call CopyLetterTilesToVRAM
	
	ld a,$70
	hlCoord 3,4
	ld de,wcd6d
.loop2
	push af
	ld a,[de]
	cp $50
	jr z,.finish
	pop af
	ld [hli],a
	inc a
	inc de
	jr .loop2		;print the pokemon string
.finish
	pop af
	ret
	

NameLabelString:
	db "Name:@"