LoadMonBackPic: ; 3f103 (f:7103)
; Assumes the monster's attributes have
; been loaded with GetMonHeader.
	ld a, [wBattleMonSpecies2]
	cp HUMAN	;is it human?
	jp z,LoadPlayerBackPic	;then load the trainer back pic
	ld [wcf91], a
	coord hl, 1, 5
	ld b, $7
	ld c, $8
	call ClearScreenArea
	ld hl,  wMonHBackSprite - wMonHeader
	call UncompressMonSprite
	call Load6x6BackPic
	ld hl, vSprites
	ld de, vBackPic
	ld c, (2*SPRITEBUFFERSIZE)/16 ; count of 16-byte chunks to be copied
	ld a, [H_LOADEDROMBANK]
	ld b, a
	jp CopyVideoData
	


;to load a 6x6 player back pic
Load6x6BackPic:
	ld de,vBackPic
	ld a,$66
	push de
	jp FinishLoading6x6BackSprite
	
; loads either red back pic or old man back pic
; also writes OAM data and loads tile patterns for the Red or Old Man back sprite's head
; (for use when scrolling the player sprite and enemy's silhouettes on screen)
LoadPlayerBackPic: ; 3ec92 (f:6c92)
	ld a, [wTotems]
	bit RoleReversalTotem,a ; is the Role Reversal on?
	ld de, JamesPicBack
	jr z, .next
	ld de, JessiePicBack
.next
	ld a, BANK(JamesPicBack)
	call UncompressSpriteFromDE
	call Load6x6BackPic
	ld hl, wOAMBuffer
	xor a
	ld [$FF8B], a ; initial tile number
	ld b, $7 ; 7 columns
	ld e, $a0 ; X for the left-most column
.loop ; each loop iteration writes 3 OAM entries in a vertical column
	ld c, $3 ; 3 tiles per column
	ld d, $38 ; Y for the top of each column
.innerLoop ; each loop iteration writes 1 OAM entry in the column
	ld [hl], d ; OAM Y
	inc hl
	ld [hl], e ; OAM X
	ld a, $8 ; height of tile
	add d ; increase Y by height of tile
	ld d, a
	inc hl
	ld a, [$FF8B]
	ld [hli], a ; OAM tile number
	inc a ; increment tile number
	ld [$FF8B], a
	inc hl
	dec c
	jr nz, .innerLoop
	ld a, [$FF8B]
	add $4 ; increase tile number by 4
	ld [$FF8B], a
	ld a, $8 ; width of tile
	add e ; increase X by width of tile
	ld e, a
	dec b
	jr nz, .loop
	ld a, $a
	ld [$0], a
	xor a
	ld [$4000], a
	ld hl, vSprites
	ld de, sSpriteBuffer1
	ld a, [H_LOADEDROMBANK]
	ld b, a
	ld c, 7 * 7
	call CopyVideoData
	xor a
	ld [$0], a
	ld a, $31
	ld [hStartTileID], a
	coord hl, 1, 5
	predef_jump CopyUncompressedPicToTilemap

; does nothing since no stats are ever selected (barring glitches)
DoubleOrHalveSelectedStats: ; 3ed02 (f:6d02)
	callab DoubleSelectedStats
	ld hl, HalveSelectedStats
	ld b, BANK(HalveSelectedStats)
	jp Bankswitch
	
	
SlidePlayerAndEnemySilhouettesOnScreen: ; 3c04c (f:404c)
	call LoadPlayerBackPic
	ld a, MESSAGE_BOX ; the usual text box at the bottom of the screen
	ld [wTextBoxID], a
	call DisplayTextBoxID
	coord hl, 1, 5
	ld bc, $307
	call ClearScreenArea
	call DisableLCD
	call LoadFontTilePatterns
	callab LoadHudAndHpBarAndStatusTilePatterns
	ld hl, vBGMap0
	ld bc, $400
.clearBackgroundLoop
	ld a, $C4
	ld [hli], a
	dec bc
	ld a, b
	or c
	jr nz, .clearBackgroundLoop
; copy the work RAM tile map to VRAM
	ld hl, wTileMap
	ld de, vBGMap0
	ld b, 18 ; number of rows
.copyRowLoop
	ld c, 20 ; number of columns
.copyColumnLoop
	ld a, [hli]
	ld [de], a
	inc e
	dec c
	jr nz, .copyColumnLoop
	ld a, 12 ; number of off screen tiles to the right of screen in VRAM
	add e ; skip the off screen tiles
	ld e, a
	jr nc, .noCarry
	inc d
.noCarry
	dec b
	jr nz, .copyRowLoop
	call EnableLCD
	ld a, $90
	ld [hWY], a
	ld [rWY], a
	xor a
	ld [hTilesetType], a
	ld [hSCY], a
	dec a
	ld [wUpdateSpritesEnabled], a
	call Delay3
	xor a
	ld [H_AUTOBGTRANSFERENABLED], a
	ld b, $70
	ld c, $90
	ld a, c
	ld [hSCX], a
	call DelayFrame
	ld a, %11100100 ; inverted palette for silhouette effect
	ld [rBGP], a
	ld [rOBP0], a
	ld [rOBP1], a
.slideSilhouettesLoop ; slide silhouettes of the player's pic and the enemy's pic onto the screen
	ld h, b
	ld l, $40
	call SetScrollXForSlidingPlayerBodyLeft ; begin background scrolling on line $40
	inc b
	inc b
	ld h, $0
	ld l, $60
	call SetScrollXForSlidingPlayerBodyLeft ; end background scrolling on line $60
	call SlidePlayerHeadLeft
	ld a, c
	ld [hSCX], a
	dec c
	dec c
	jr nz, .slideSilhouettesLoop
	ld a, $1
	ld [H_AUTOBGTRANSFERENABLED], a
	ld a, $31
	ld [$ffe1], a
	coord hl, 1, 5
	predef CopyUncompressedPicToTilemap
	xor a
	ld [hWY], a
	ld [rWY], a
	inc a
	ld [H_AUTOBGTRANSFERENABLED], a
	call Delay3
	ld b, $1
	call RunPaletteCommand
	call HideSprites
	ld hl, PrintBeginningBattleText
	ld b, BANK(PrintBeginningBattleText)
	jp Bankswitch
	
; when a battle is starting, silhouettes of the player's pic and the enemy's pic are slid onto the screen
; the lower of the player's pic (his body) is part of the background, but his head is a sprite
; the reason for this is that it shares Y coordinates with the lower part of the enemy pic, so background scrolling wouldn't work for both pics
; instead, the enemy pic is part of the background and uses the scroll register, while the player's head is a sprite and is slid by changing its X coordinates in a loop
SlidePlayerHeadLeft: ; 3c0ff (f:40ff)
	push bc
	ld hl, wOAMBuffer + $01
	ld c, $15 ; number of OAM entries
	ld de, $4 ; size of OAM entry
.loop
	dec [hl] ; decrement X
	dec [hl] ; decrement X
	add hl, de ; next OAM entry
	dec c
	jr nz, .loop
	pop bc
	ret
	


SetScrollXForSlidingPlayerBodyLeft: ; 3c110 (f:4110)
	ld a, [rLY]
	cp l
	jr nz, SetScrollXForSlidingPlayerBodyLeft
	ld a, h
	ld [rSCX], a
.loop
	ld a, [rLY]
	cp h
	jr z, .loop
	ret
	
; show 2 stages of the player getting smaller before disappearing
AnimateRetreatingPlayerMon: ; 3ccfa (f:4cfa)
	coord hl, 1, 5
	lb bc, 7, 7
	call ClearScreenArea
	coord hl, 3, 7
	lb bc, 5, 5
	xor a
	ld [wDownscaledMonSize], a
	ld [hBaseTileID], a
	predef CopyDownscaledMonTiles
	ld c, 4
	call DelayFrames
	call .clearScreenArea
	coord hl, 4, 9
	ld bc, $303
	ld a, $1
	ld [wDownscaledMonSize], a
	xor a
	ld [hBaseTileID], a
	predef CopyDownscaledMonTiles
	call Delay3
	call .clearScreenArea
	ld a, $4c
	Coorda 5, 11
.clearScreenArea
	coord hl, 1, 5
	lb bc, 7, 7
	jp ClearScreenArea