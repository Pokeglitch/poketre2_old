HatchEggScreen:
	ld a,[wWhichPokemon]
	ld hl,wPartySpecies
	ld b,0
	ld c,a
	add hl,bc		;hl now points to the pokemon id
	ld a,[hl]
	ld [wEvoCrySpecies],a	;store the original pokemon
	ld a,$FF
	ld [wEvoOldSpecies],a		;store $FF (egg) as the original pokemon
	ld [wEvoNewSpecies],a	;store as the new pokemon
	
	show_overworld_text IsHatchingText
	
	ld a,[H_LOADEDROMBANK]
	push af
	callba DisplayTextIDInit
	
	call GBPalWhiteOutWithDelay3		;whiteout the palette
	call ClearScreen
	call UpdateSprites
	
	ld a,[hSCX]
	push af
	ld a,[hSCY]
	push af		;save the screen x, y positions
	
	xor a
	ld [hSCX],a
	ld [hSCY],a	;set the screen x, y position to 0
	
	call Delay3
	call GBPalNormal
	
	
	call Func_7bde9
	
	xor a
	ld [wUpdateSpritesEnabled],a
	
	ld a, [wWhichPokemon]
	ld hl, wPartyMonNicks
	
	call GetPartyMonName
	call CopyStringToCF4B
	ld hl,_HatchedIntoText
	call PrintText
	
	ld hl, wcd6d
	ld de, wcf4b
	ld bc, 11
	call CopyData
	
	
	ld a,[wcf91]	;store the previous value
	push af
	ld a,[wEvoCrySpecies]	;get the original pokemon
	ld [wcf91],a	;store the original pokemon
	
	
	ld a, [wWhichPokemon]
	ld hl, wPartyMonNicks
	call SkipFixedLengthTextEntries
	ld a, NAME_MON_SCREEN
	ld [wNamingScreenType], a
	predef AskName
	
	pop af
	ld [wcf91],a	;restore the previous value
.finish
	call GBPalWhiteOutWithDelay3		;whiteout the palette
	ld c,32
	call DelayFrames
	
	pop af
	ld [hSCY],a
	pop af
	ld [hSCX],a	;restore the X,Y positions
	
	
	ld a,1
	ld [wUpdateSpritesEnabled],a
	
	call ReloadMapData
	jp CloseTextDisplay

_HatchedIntoText:
	TX_FAR HatchedIntoText
	db "@"
_IsHatchingText:
	TX_FAR IsHatchingText
	db "@"

EvolveMon: ; 7bde9 (1e:7de9)
	push hl
	push de
	push bc
	ld a, [wcf91]
	push af
	ld a, [wd0b5]
	push af
	xor a
	ld [wLowHealthAlarm], a
	ld [wChannelSoundIDs + CH4], a
	dec a
	ld [wNewSoundID], a
	call PlaySound
	ld a, $1
	ld [H_AUTOBGTRANSFERENABLED], a
	ld a, SFX_TINK
	call PlaySound
	call Delay3
	xor a
	ld [H_AUTOBGTRANSFERENABLED], a
	ld [hTilesetType], a
	ld a, [wEvoOldSpecies]
	ld c, 0
	call EvolutionSetWholeScreenPalette
	ld a, [wEvoNewSpecies]
	ld [wcf91], a
	ld [wd0b5], a
	call LoadEvoSprite

	ld de, vFrontPic
	ld hl, vBackPic
	ld bc, 7 * 7
	call CopyVideoData
	ld a, [wEvoOldSpecies]
	push af
	ld [wcf91], a
	ld [wd0b5], a
	call LoadEvoSpriteEggFlipped
	ld a, $1
	ld [H_AUTOBGTRANSFERENABLED], a ; $ffba
	pop af
	cp $FF		;egg?
	jr z,.skipCry	;then dont play cry
	ld a, [wEvoCrySpecies]
	call PlayCry
	call WaitForSoundToFinish
.skipCry
	ld c, BANK(Music_SafariZone)
	ld a, MUSIC_SAFARI_ZONE
	call PlayMusic
	ld c, 80
	call DelayFrames
	ld c, 1 ; set PAL_BLACK instead of mon palette
	call EvolutionSetWholeScreenPalette
	lb bc, $1, $10
.animLoop
	push bc
	call Evolution_CheckForCancel
	jr c, .evolutionCancelled
	call Evolution_BackAndForthAnim
	pop bc
	inc b
	dec c
	dec c
	jr nz, .animLoop
	xor a
	ld [wEvoCancelled], a
	ld a, $31
	ld [wEvoMonTileOffset], a
	call Evolution_ChangeMonPic
	ld a, [wEvoNewSpecies]
.done
	cp $FF		;was it egg?
	call z,LoadFinalEggSprite	;then whiteout the screen
	ld [wEvoCrySpecies],a		;store into cf1d
	ld a, $ff
	ld [wNewSoundID], a
	call PlaySound
	ld a, [wEvoCrySpecies]
	call PlayCry
	ld c, 0
	call EvolutionSetWholeScreenPalette
	pop af
	ld [wd0b5], a
	pop af
	ld [wcf91], a
	pop bc
	pop de
	pop hl
	ld a, [wEvoCancelled]
	and a
	ret z
	scf
	ret
.evolutionCancelled
	pop bc
	ld a, 1
	ld [wEvoCancelled], a
	ld a, [wEvoOldSpecies]
	jr .done

EvolutionSetWholeScreenPalette: ; 7beb4 (1e:7eb4)
	ld b, SET_PAL_POKEMON_WHOLE_SCREEN
	jp RunPaletteCommand

LoadFinalEggSprite:
	ld b,0
	ld c,5
.loop
	push bc
	dec c
	ld hl,.eggCrackTable
	add hl,bc
	add hl,bc
	ld a,[hli]
	ld h,[hl]
	ld l,a
	call LoadEggSprite
	pop bc
	dec c
	jr nz,.loop

	call GBPalWhiteOutWithDelay3
	ld a,[wEvoCrySpecies]
	ld [wcf91], a
	ld [wd0b5], a
	push af
	call LoadEvoSprite
	call Delay3
	call GBPalNormal
	pop af		;return the original pokemon id in a
	ret
	
.eggCrackTable:
	dw EggCrack5Sprite
	dw EggCrack4Sprite
	dw EggCrack3Sprite
	dw EggCrack2Sprite
	dw EggCrack1Sprite

EggCrack1Sprite: INCBIN "pic/other/egg_crack1.pic"
EggCrack2Sprite: INCBIN "pic/other/egg_crack2.pic"
EggCrack3Sprite: INCBIN "pic/other/egg_crack3.pic"
EggCrack4Sprite: INCBIN "pic/other/egg_crack4.pic"
EggCrack5Sprite: INCBIN "pic/other/egg_crack5.pic"
EggNormalSprite: INCBIN "pic/other/egg_normal.pic"
EggSprite: INCBIN "pic/other/egg.pic"
FlippedEggSprite: INCBIN "pic/other/flippedegg.pic"
	
LoadEvoSpriteEggFlipped:
	cp a,$FF		;egg?
	ld a, 1
	ld [wSpriteFlipped], a
	jr nz,LoadNotEggSprite
	ld hl, FlippedEggSprite
	call LoadEggSprite
	ret
	
	
LoadEvoSprite: ; 7beb9 (1e:7eb9)
	cp a,$FF		;egg?
	jr nz,LoadNotEggSprite
	ld a, 1
	ld [wSpriteFlipped], a
	ld hl, EggNormalSprite
	call LoadEggSprite
	ret
	
LoadEggSprite:
	ld a,l
	ld [wMonHFrontSprite],a
	ld a,h
	ld [wMonHFrontSprite+1],a
	ld a,BANK(EggSprite)
	ld [wMonHSpriteBank],a
	ld a,$77
	ld [wMonHSpriteDim],a
	ld de, vFrontPic
	call LoadMonFrontSprite
	callab DrawEvoEggSprite
	ret
	
LoadNotEggSprite:
	call GetMonHeader
	coord hl, 7, 2
	jp LoadFlippedFrontSpriteByMonIndex

Evolution_BackAndForthAnim: ; 7bec2 (1e:7ec2)
; show the mon change back and forth between the new and old species b times
	ld a, $31
	ld [wEvoMonTileOffset], a
	call Evolution_ChangeMonPic
	ld a, -$31
	ld [wEvoMonTileOffset], a
	call Evolution_ChangeMonPic
	dec b
	jr nz, Evolution_BackAndForthAnim
	ret

Evolution_ChangeMonPic: ; 7bed6 (1e:7ed6)
	push bc
	xor a
	ld [H_AUTOBGTRANSFERENABLED], a
	coord hl, 7, 2
	lb bc, 7, 7
	ld de, SCREEN_WIDTH - 7
.loop
	push bc
.innerLoop
	ld a, [wEvoMonTileOffset]
	add [hl]
	ld [hli], a
	dec c
	jr nz, .innerLoop
	pop bc
	add hl, de
	dec b
	jr nz, .loop
	ld a, 1
	ld [H_AUTOBGTRANSFERENABLED], a
	call Delay3
	pop bc
	ret

Evolution_CheckForCancel: ; 7befa (1e:7efa)
	call DelayFrame
	push bc
	call JoypadLowSensitivity
	ld a, [hJoy5]
	pop bc
	and B_BUTTON
	jr nz, .pressedB
.notAllowedToCancel
	dec c
	jr nz, Evolution_CheckForCancel
	and a
	ret
.pressedB
	ld a, [wForceEvolution]
	and a
	jr nz, .notAllowedToCancel
	ld a,[wEvoOldSpecies]
	cp a,$FF		;is it an egg?
	jr z, .notAllowedToCancel	;loop if so	(cant cancel)
	xor a		;set a to 0
	scf
	ret
