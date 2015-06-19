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
	call ClearScreen
	call UpdateSprites
	
	ld a,[wWhichScreen]
	push af
	ld a,TextInputScreen
	ld [wWhichScreen],a
	call LoadFontTilePatterns
	call LoadTextBoxTilePatterns
	
	ld b, $8
	call GoPAL_SET
	call LoadHpBarAndStatusTilePatterns
	call LoadEDTile
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
	hlCoord 2,9
	ld bc,$50e
	call TextBoxBorder
	hlCoord 2,2
	ld bc,$50e
	call TextBoxBorder
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
	jp EraseMenuCursor

LoadEDTile: ; 675b (1:675b)
	ld de, ED_Tile
	ld hl, vFont + $700
	ld bc, $1
	jp CopyVideoDataDouble

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
	hlCoord 10, 2
	ld bc, $10a
	call ClearScreenArea
	hlCoord 10, 2
	ld de, wcf4b
	call PlaceString
	hlCoord 10, 3
	ld a, [wd07d]
	cp $2
	jr nc, .asm_6835
	ld b, $7
	jr .asm_6837
.asm_6835
	ld b, $a
.asm_6837
	ld a, $76
.asm_6839
	ld [hli], a
	dec b
	jr nz, .asm_6839
	ld a, [wd07d]
	cp $2
	ld a, [wHPBarMaxHP]
	jr nc, .asm_684b
	cp $7
	jr .asm_684d
.asm_684b
	cp $a
.asm_684d
	jr nz, .asm_6867
	call EraseMenuCursor
	ld a, $11
	ld [wTopMenuItemX], a
	ld a, $5
	ld [wCurrentMenuItem], a
	ld a, [wd07d]
	cp $2
	ld a, $9
	jr nc, .asm_6867
	ld a, $6
.asm_6867
	ld c, a
	ld b, $0
	hlCoord 10, 3
	add hl, bc
	ld [hl], $77
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

Dakutens: ; 6885 (1:6885)
	db "かが", "きぎ", "くぐ", "けげ", "こご"
	db "さざ", "しじ", "すず", "せぜ", "そぞ"
	db "ただ", "ちぢ", "つづ", "てで", "とど"
	db "はば", "ひび", "ふぶ", "へべ", "ほぼ"
	db "カガ", "キギ", "クグ", "ケゲ", "コゴ"
	db "サザ", "シジ", "スズ", "セゼ", "ソゾ"
	db "タダ", "チヂ", "ツヅ", "テデ", "トド"
	db "ハバ", "ヒビ", "フブ", "へべ", "ホボ"
	db $ff

Handakutens: ; 68d6 (1:68d6)
	db "はぱ", "ひぴ", "ふぷ", "へぺ", "ほぽ"
	db "ハパ", "ヒピ", "フプ", "へぺ", "ホポ"
	db $ff

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

PrintNamingText: ; 68f8 (1:68f8)
	hlCoord 0, 1
	ld a, [wd07d]
	ld de, YourTextString
	and a
	jr z, .notNickname
	ld de, RivalsTextString
	dec a
	jr z, .notNickname
	ld a, [wcf91]
	ld [wMonPartySpriteSpecies], a
	push af
	callba WriteMonPartySpriteOAMBySpecies
	pop af
	ld [wd11e], a
	call GetMonName
	hlCoord 4, 1
	call PlaceString
	ld hl, $1
	add hl, bc
	ld [hl], $c9
	hlCoord 1, 3
	ld de, NicknameTextString
	jr .placeString
.notNickname
	call PlaceString
	ld l, c
	ld h, b
	ld de, NameTextString
.placeString
	jp PlaceString

YourTextString: ; 693f (1:693f)
	db "YOUR @"

RivalsTextString: ; 6945 (1:6945)
	db "RIVAL's @"

NameTextString: ; 694d (1:694d)
	db "NAME?@"

NicknameTextString: ; 6953 (1:6953)
	db "NICKNAME?@"
