_DrawPlayerHUDAndHPBar: ; 3cd60 (f:4d60)
	xor a
	ld [H_AUTOBGTRANSFERENABLED], a
	hlCoord 9, 7
	ld bc, $50b
	call ClearScreenArea
	callab PlacePlayerHUDTiles
	hlCoord 18, 9
	ld [hl], $73
	ld de, wBattleMonNick
	hlCoord 10, 7
	call CenterMonName
	call PlaceString
	ld hl, wBattleMonSpecies
	ld de, wLoadedMon
	ld bc, $c
	call CopyData
	ld hl, wBattleMonLevel
	ld de, wLoadedMonLevel
	ld bc, $b
	call CopyData
	hlCoord 14, 8
	push hl
	inc hl
	ld de, wLoadedMonStatus
	call PrintStatusConditionNotFainted
	pop hl
	jr nz, .asm_3cdae
	call PrintLevel
.asm_3cdae
	ld a, [wLoadedMonSpecies]
	ld [wcf91], a
	hlCoord 10, 9
	predef DrawHP
	ld a, $1
	ld [H_AUTOBGTRANSFERENABLED], a
	ld hl, wcf1d
	callab GetBattleHealthBarColor2
	ld hl, wBattleMonHP
	ld a, [hli]
	or [hl]
	jr z, .asm_3cdd9
	ld a, [wccf6]
	and a
	ret nz
	ld a, [wcf1d]
	cp $2
	jr z, .asm_3cde6
.asm_3cdd9
	ld hl, wLowHealthAlarm
	bit 7, [hl] ;low health alarm enabled?
	ld [hl], $0
	ret z
	xor a
	ld [wc02a], a
	ret
.asm_3cde6
	ld hl, wLowHealthAlarm
	set 7, [hl] ;enable low health alarm
	ret

_DrawEnemyHUDAndHPBar: ; 3cdec (f:4dec)
	xor a
	ld [H_AUTOBGTRANSFERENABLED], a
	ld hl, wTileMap
	ld bc, $40c
	call ClearScreenArea
	callab PlaceEnemyHUDTiles
	ld de, wEnemyMonNick
	hlCoord 1, 0
	call CenterMonName
	call PlaceString
	hlCoord 4, 1
	push hl
	inc hl
	ld de, wEnemyMonStatus
	call PrintStatusConditionNotFainted
	pop hl
	jr nz, .skipPrintLevel ; if the mon has a status condition, skip printing the level
	ld a, [wEnemyMonLevel]
	ld [wLoadedMonLevel], a
	call PrintLevel
.skipPrintLevel
	ld hl, wEnemyMonHP
	ld a, [hli]
	ld [H_MULTIPLICAND + 1], a
	ld a, [hld]
	ld [H_MULTIPLICAND + 2], a
	or [hl] ; is current HP zero?
	jr nz, .hpNonzero
; current HP is 0
; set variables for DrawHPBar
	ld c, a
	ld e, a
	ld d, $6
	jp .drawHPBar
.hpNonzero
	xor a
	ld [H_MULTIPLICAND], a
	ld a, 48
	ld [H_MULTIPLIER], a
	call Multiply ; multiply current HP by 48
	ld hl, wEnemyMonMaxHP
	ld a, [hli]
	ld b, a
	ld a, [hl]
	ld [H_DIVISOR], a
	ld a, b
	and a ; is max HP > 255?
	jr z, .doDivide
; if max HP > 255, scale both (current HP * 48) and max HP by dividing by 4 so that max HP fits in one byte
; (it needs to be one byte so it can be used as the divisor for the Divide function)
	ld a, [H_DIVISOR]
	srl b
	rr a
	srl b
	rr a
	ld [H_DIVISOR], a
	ld a, [H_PRODUCT + 2]
	ld b, a
	srl b
	ld a, [H_PRODUCT + 3]
	rr a
	srl b
	rr a
	ld [H_PRODUCT + 3], a
	ld a, b
	ld [H_PRODUCT + 2], a
.doDivide
	ld a, [H_PRODUCT + 2]
	ld [H_DIVIDEND], a
	ld a, [H_PRODUCT + 3]
	ld [H_DIVIDEND + 1], a
	ld a, $2
	ld b, a
	call Divide ; divide (current HP * 48) by max HP
	ld a, [H_QUOTIENT + 3]
; set variables for DrawHPBar
	ld e, a
	ld a, $6
	ld d, a
	ld c, a
.drawHPBar
	xor a
	ld [wHPBarType], a
	hlCoord 2, 2
	call DrawHPBar
	ld a, $1
	ld [H_AUTOBGTRANSFERENABLED], a
	ld hl, wcf1e
		
GetBattleHealthBarColor2: ; 3ce90 (f:4e90)
	ld b, [hl]
	call GetHealthBarColor
	ld a, [hl]
	cp b
	ret z
	ld b, $1
	jp GoPAL_SET


; center's mon's name on the battle screen
; if the name is 1 or 2 letters long, it is printed 2 spaces more to the right than usual
; (i.e. for names longer than 4 letters)
; if the name is 3 or 4 letters long, it is printed 1 space more to the right than usual
; (i.e. for names longer than 4 letters)
CenterMonName: ; 3ce9c (f:4e9c)
	push de
	inc hl
	inc hl
	ld b, $2
.loop
	inc de
	ld a, [de]
	cp $50
	jr z, .done
	inc de
	ld a, [de]
	cp $50
	jr z, .done
	dec hl
	dec b
	jr nz, .loop
.done
	pop de
	ret