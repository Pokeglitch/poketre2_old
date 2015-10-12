OaksLabScript: ; 1cb0e (7:4b0e)
	CheckEvent EVENT_PALLET_AFTER_GETTING_POKEBALLS_2
	call nz, OaksLabScript_1d076
	xor a
	ld [wAutoTextBoxDrawingControl], a
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld hl, OaksLabScriptPointers
	ld a, [wOaksLabCurScript]
	jp CallFunctionInTable

OaksLabScriptPointers: ; 1cb28 (7:4b28)
	dw OaksLabScript0
	dw OaksLabScript1
	dw OaksLabScript2
	dw OaksLabScript3
	dw OaksLabScript4
	dw OaksLabScript5
	dw OaksLabScript6
	dw OaksLabScript7
	dw OaksLabScript8
	dw OaksLabScript9
	dw OaksLabScript10
	dw OaksLabScript11
	dw OaksLabScript12
	dw OaksLabScript13
	dw OaksLabScript14
	dw OaksLabScript15
	dw OaksLabScript16
	dw OaksLabScript17
	dw OaksLabScript18

OaksLabScript0: ; 1cb4e (7:4b4e)
	CheckEvent EVENT_OAK_APPEARED_IN_PALLET
	ret z
	ld a, [wNPCMovementScriptFunctionNum]
	and a
	ret nz
	ld a, HS_OAKS_LAB_OAK_2
	ld [wMissableObjectIndex], a
	predef ShowObject
	ld hl, wd72e
	res 4, [hl]

	ld a, $1
	ld [wOaksLabCurScript], a
	ret

OaksLabScript1: ; 1cb6e (7:4b6e)
	ld a, $8
	ld [H_SPRITEINDEX], a
	ld de, OakEntryMovement
	call MoveSprite

	ld a, $2
	ld [wOaksLabCurScript], a
	ret

OakEntryMovement: ; 1cb7e (7:4b7e)
	db NPC_MOVEMENT_UP
	db NPC_MOVEMENT_UP
	db NPC_MOVEMENT_UP
	db $FF

OaksLabScript2: ; 1cb82 (7:4b82)
	ld a, [wd730]
	bit 0, a
	ret nz
	ld a, HS_OAKS_LAB_OAK_2
	ld [wMissableObjectIndex], a
	predef HideObject
	ld a, HS_OAKS_LAB_OAK_1
	ld [wMissableObjectIndex], a
	predef ShowObject

	ld a, $3
	ld [wOaksLabCurScript], a
	ret

OaksLabScript3: ; 1cba2 (7:4ba2)
	call Delay3
	ld hl, wSimulatedJoypadStatesEnd
	ld de, PlayerEntryMovementRLE
	call DecodeRLEList
	dec a
	ld [wSimulatedJoypadStatesIndex], a
	call StartSimulatingJoypadStates
	ld a, $1
	ld [H_SPRITEINDEX], a
	xor a
	ld [hSpriteFacingDirection], a
	call SetSpriteFacingDirectionAndDelay
	ld a, $5
	ld [H_SPRITEINDEX], a
	xor a
	ld [hSpriteFacingDirection], a
	call SetSpriteFacingDirectionAndDelay

	ld a, $4
	ld [wOaksLabCurScript], a
	ret

PlayerEntryMovementRLE: ; 1cbcf (7:4bcf)
	db D_UP,$8
	db $ff

OaksLabScript4: ; 1cbd2 (7:4bd2)
	ld a, [wSimulatedJoypadStatesIndex]
	and a
	ret nz
	SetEvent EVENT_FOLLOWED_OAK_INTO_LAB
	SetEvent EVENT_FOLLOWED_OAK_INTO_LAB_2
	ld a, $1
	ld [H_SPRITEINDEX], a
	ld a, SPRITE_FACING_UP
	ld [hSpriteFacingDirection], a
	call SetSpriteFacingDirectionAndDelay
	call UpdateSprites
	ld hl, wFlags_D733
	res 1, [hl]
	call PlayDefaultMusic

	ld a, $5
	ld [wOaksLabCurScript], a
	ret

OaksLabScript5: ; 1cbfd (7:4bfd)
	ld a, $fc
	ld [wJoyIgnore], a
	ld a, $11
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
	call Delay3
	ld a, $12
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
	call Delay3
	ld a, $13
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
	call Delay3
	ld a, $14
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
	SetEvent EVENT_OAK_ASKED_TO_CHOOSE_MON
	xor a
	ld [wJoyIgnore], a

	ld a, $6
	ld [wOaksLabCurScript], a
	ret

OaksLabScript6: ; 1cc36 (7:4c36)
	ld a, [wYCoord]
	cp $6
	ret nz
	ld a, $5
	ld [H_SPRITEINDEX], a
	xor a ; SPRITE_FACING_DOWN
	ld [hSpriteFacingDirection], a
	call SetSpriteFacingDirectionAndDelay
	ld a, $1
	ld [H_SPRITEINDEX], a
	xor a
	ld [hSpriteFacingDirection], a
	call SetSpriteFacingDirectionAndDelay
	call UpdateSprites
	ld a, $c
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
	ld a, $1
	ld [wSimulatedJoypadStatesIndex], a
	ld a, D_UP
	ld [wSimulatedJoypadStatesEnd], a
	call StartSimulatingJoypadStates
	ld a, PLAYER_DIR_UP
	ld [wPlayerMovingDirection], a

	ld a, $7
	ld [wOaksLabCurScript], a
	ret

OaksLabScript7: ; 1cc72 (7:4c72)
	ld a, [wSimulatedJoypadStatesIndex]
	and a
	ret nz
	call Delay3

	ld a, $6
	ld [wOaksLabCurScript], a
	ret

OaksLabScript8: ; 1cc80 (7:4c80)
	ld a, [wPlayerStarter]
	cp STARTER1
	jr z, .Charmander
	cp STARTER2
	jr z, .Squirtle
	jr .Bulbasaur
.Charmander
	ld de, .MiddleBallMovement1
	ld a, [wYCoord]
	cp $4 ; is the player standing below the table?
	jr z, .asm_1ccf3
	ld de, .MiddleBallMovement2
	jr .asm_1ccf3

.MiddleBallMovement1
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_RIGHT
	db NPC_MOVEMENT_RIGHT
	db NPC_MOVEMENT_RIGHT
	db NPC_MOVEMENT_UP
	db $FF

.MiddleBallMovement2
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_RIGHT
	db NPC_MOVEMENT_RIGHT
	db NPC_MOVEMENT_RIGHT
	db $FF

.Squirtle
	ld de, .RightBallMovement1
	ld a, [wYCoord]
	cp $4 ; is the player standing below the table?
	jr z, .asm_1ccf3
	ld de, .RightBallMovement2
	jr .asm_1ccf3

.RightBallMovement1
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_RIGHT
	db NPC_MOVEMENT_RIGHT
	db NPC_MOVEMENT_RIGHT
	db NPC_MOVEMENT_RIGHT
	db NPC_MOVEMENT_UP
	db $FF

.RightBallMovement2
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_RIGHT
	db NPC_MOVEMENT_RIGHT
	db NPC_MOVEMENT_RIGHT
	db NPC_MOVEMENT_RIGHT
	db $FF

.Bulbasaur
	ld de, .LeftBallMovement1
	ld a, [wXCoord]
	cp $9 ; is the player standing to the right of the table?
	jr nz, .asm_1ccf3
	push hl
	ld a, $1
	ld [H_SPRITEINDEX], a
	ld a, $4
	ld [H_SPRITEDATAOFFSET], a
	call GetPointerWithinSpriteStateData1
	push hl
	ld [hl], $4c
	inc hl
	inc hl
	ld [hl], $0
	pop hl
	inc h
	ld [hl], $8
	inc hl
	ld [hl], $9
	ld de, .LeftBallMovement2 ; the rival is not currently onscreen, so account for that
	pop hl
	jr .asm_1ccf3

.LeftBallMovement1
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_RIGHT ; not yet terminated!
.LeftBallMovement2
	db NPC_MOVEMENT_RIGHT
	db $FF

.asm_1ccf3
	ld a, $1
	ld [H_SPRITEINDEX], a
	call MoveSprite

	ld a, $9
	ld [wOaksLabCurScript], a
	ret

OaksLabScript9: ; 1cd00 (7:4d00)
	ld a, [wd730]
	bit 0, a
	ret nz
	ld a, $fc
	ld [wJoyIgnore], a
	ld a, $1
	ld [H_SPRITEINDEX], a
	ld a, SPRITE_FACING_UP
	ld [hSpriteFacingDirection], a
	call SetSpriteFacingDirectionAndDelay
	ld a, $d
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
	ld a, [wRivalStarterBallSpriteIndex]
	cp $2
	jr nz, .asm_1cd28
	ld a, HS_STARTER_BALL_1
	jr .asm_1cd32
.asm_1cd28
	cp $3
	jr nz, .asm_1cd30
	ld a, HS_STARTER_BALL_2
	jr .asm_1cd32
.asm_1cd30
	ld a, HS_STARTER_BALL_3
.asm_1cd32
	ld [wMissableObjectIndex], a
	predef HideObject
	call Delay3
	ld a, [wRivalStarterTemp]
	ld [wRivalStarter], a
	ld [wcf91], a
	ld [wd11e], a
	call GetMonName
	ld a, $1
	ld [H_SPRITEINDEX], a
	ld a, SPRITE_FACING_UP
	ld [hSpriteFacingDirection], a
	call SetSpriteFacingDirectionAndDelay
	ld a, $e
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
	SetEvent EVENT_GOT_STARTER
	xor a
	ld [wJoyIgnore], a

	ld a, $a
	ld [wOaksLabCurScript], a
	ret

OaksLabScript10: ; 1cd6d (7:4d6d)
	ld a, [wYCoord]
	cp $6
	ret nz
	ld a, $1
	ld [H_SPRITEINDEX], a
	xor a ; SPRITE_FACING_DOWN
	ld [hSpriteFacingDirection], a
	call SetSpriteFacingDirectionAndDelay
	ld a, PLAYER_DIR_UP
	ld [wPlayerMovingDirection], a
	ld c, BANK(Music_MeetRival)
	ld a, MUSIC_MEET_RIVAL
	call PlayMusic
	ld a, $f
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
	ld a, $1
	ld [hNPCPlayerRelativePosPerspective], a
	ld a, $1
	swap a
	ld [hNPCSpriteOffset], a
	predef CalcPositionOfPlayerRelativeToNPC
	ld a, [hNPCPlayerYDistance]
	dec a
	ld [hNPCPlayerYDistance], a
	predef FindPathToPlayer
	ld de, wNPCMovementDirections2
	ld a, $1
	ld [H_SPRITEINDEX], a
	call MoveSprite

	ld a, $b
	ld [wOaksLabCurScript], a
	ret

OaksLabScript11: ; 1cdb9 (7:4db9)
	ld a, [wd730]
	bit 0, a
	ret nz

	; define which team rival uses, and fight it
	ld a, OPP_SONY1
	ld [wCurOpponent], a
	ld a, [wRivalStarter]
	cp STARTER2
	jr nz, .NotSquirtle
	ld a, $1
	jr .done
.NotSquirtle
	cp STARTER3
	jr nz, .Charmander
	ld a, $2
	jr .done
.Charmander
	ld a, $3
.done
	ld [wTrainerNo], a
	ld a, $1
	ld [wSpriteIndex], a
	call GetSpritePosition1
	ld hl, OaksLabText_1d3be
	ld de, OaksLabText_1d3c3
	call SaveEndBattleTextPointers
	ld hl, wd72d
	set 6, [hl]
	set 7, [hl]
	xor a
	ld [wJoyIgnore], a
	ld a, PLAYER_DIR_UP
	ld [wPlayerMovingDirection], a
	ld a, $c
	ld [wOaksLabCurScript], a
	ret

OaksLabScript12: ; 1ce03 (7:4e03)
	ld a, $f0
	ld [wJoyIgnore], a
	ld a, PLAYER_DIR_UP
	ld [wPlayerMovingDirection], a
	call UpdateSprites
	ld a, $1
	ld [wSpriteIndex], a
	call SetSpritePosition1
	ld a, $1
	ld [H_SPRITEINDEX], a
	xor a ; SPRITE_FACING_DOWN
	ld [hSpriteFacingDirection], a
	call SetSpriteFacingDirectionAndDelay
	predef HealParty
	SetEvent EVENT_BATTLED_RIVAL_IN_OAKS_LAB

	ld a, $d
	ld [wOaksLabCurScript], a
	ret

OaksLabScript13: ; 1ce32 (7:4e32)
	ld c, 20
	call DelayFrames
	ld a, $10
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
	callba Music_RivalAlternateStart
	ld a, $1
	ld [H_SPRITEINDEX], a
	ld de, .RivalExitMovement
	call MoveSprite
	ld a, [wXCoord]
	cp $4
	; move left or right depending on where the player is standing
	jr nz, .moveLeft
	ld a, NPC_MOVEMENT_RIGHT
	jr .next
.moveLeft
	ld a, NPC_MOVEMENT_LEFT
.next
	ld [wNPCMovementDirections], a

	ld a, $e
	ld [wOaksLabCurScript], a
	ret

.RivalExitMovement
	db $E0 ; change sprite facing direction
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db $FF

OaksLabScript14: ; 1ce6d (7:4e6d)
	ld a, [wd730]
	bit 0, a
	jr nz, .asm_1ce8c
	ld a, HS_OAKS_LAB_RIVAL
	ld [wMissableObjectIndex], a
	predef HideObject
	xor a
	ld [wJoyIgnore], a
	call PlayDefaultMusic ; reset to map music
	ld a, $12
	ld [wOaksLabCurScript], a
	jr .done
; make the player keep facing the rival as he walks away
.asm_1ce8c
	ld a, [wNPCNumScriptedSteps]
	cp $5
	jr nz, .asm_1cea8
	ld a, [wXCoord]
	cp $4
	jr nz, .asm_1cea1
	ld a, SPRITE_FACING_RIGHT
	ld [wSpriteStateData1 + 9], a
	jr .done
.asm_1cea1
	ld a, SPRITE_FACING_LEFT
	ld [wSpriteStateData1 + 9], a
	jr .done
.asm_1cea8
	cp $4
	ret nz
	xor a ; ld a, SPRITE_FACING_DOWN
	ld [wSpriteStateData1 + 9], a
.done
	ret

OaksLabScript15: ; 1ceb0 (7:4eb0)
	xor a
	ld [hJoyHeld], a
	call EnableAutoTextBoxDrawing
	ld a, $ff
	ld [wNewSoundID], a
	call PlaySound
	callba Music_RivalAlternateStart
	ld a, $15
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
	call OaksLabScript_1d02b
	ld a, HS_OAKS_LAB_RIVAL
	ld [wMissableObjectIndex], a
	predef ShowObject
	ld a, [wNPCMovementDirections2Index]
	ld [wSavedNPCMovementDirections2Index], a
	ld b, 0
	ld c, a
	ld hl, wNPCMovementDirections2
	ld a, NPC_MOVEMENT_UP
	call FillMemory
	ld [hl], $ff
	ld a, $1
	ld [H_SPRITEINDEX], a
	ld de, wNPCMovementDirections2
	call MoveSprite

	ld a, $10
	ld [wOaksLabCurScript], a
	ret

OaksLabScript_1cefd: ; 1cefd (7:4efd)
	ld a, $1
	ld [H_SPRITEINDEX], a
	ld a, SPRITE_FACING_UP
	ld [hSpriteFacingDirection], a
	call SetSpriteFacingDirectionAndDelay
	ld a, $8
	ld [H_SPRITEINDEX], a
	xor a ; SPRITE_FACING_DOWN
	ld [hSpriteFacingDirection], a
	jp SetSpriteFacingDirectionAndDelay

OaksLabScript16: ; 1cf12 (7:4f12)
	ld a, [wd730]
	bit 0, a
	ret nz
	call EnableAutoTextBoxDrawing
	call PlayDefaultMusic
	ld a, $fc
	ld [wJoyIgnore], a
	call OaksLabScript_1cefd
	ld a, $16
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
	call DelayFrame
	call OaksLabScript_1cefd
	ld a, $17
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
	call DelayFrame
	call OaksLabScript_1cefd
	ld a, $18
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
	call DelayFrame
	ld a, $19
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
	call Delay3
	ld a, HS_POKEDEX_1
	ld [wMissableObjectIndex], a
	predef HideObject
	ld a, HS_POKEDEX_2
	ld [wMissableObjectIndex], a
	predef HideObject
	call OaksLabScript_1cefd
	ld a, $1a
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
	ld a, $1
	ld [H_SPRITEINDEX], a
	ld a, SPRITE_FACING_RIGHT
	ld [hSpriteFacingDirection], a
	call SetSpriteFacingDirectionAndDelay
	call Delay3
	ld a, $1b
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
	SetEvent EVENT_GOT_POKEDEX
	SetEvent EVENT_OAK_GOT_PARCEL
	ld a, HS_LYING_OLD_MAN
	ld [wMissableObjectIndex], a
	predef HideObject
	ld a, HS_OLD_MAN
	ld [wMissableObjectIndex], a
	predef ShowObject
	ld a, [wSavedNPCMovementDirections2Index]
	ld b, 0
	ld c, a
	ld hl, wNPCMovementDirections2
	xor a ; NPC_MOVEMENT_DOWN
	call FillMemory
	ld [hl], $ff
	ld a, $ff
	ld [wNewSoundID], a
	call PlaySound
	callba Music_RivalAlternateStart
	ld a, $1
	ld [H_SPRITEINDEX], a
	ld de, wNPCMovementDirections2
	call MoveSprite

	ld a, $11
	ld [wOaksLabCurScript], a
	ret

OaksLabScript17: ; 1cfd4 (7:4fd4)
	ld a, [wd730]
	bit 0, a
	ret nz
	call PlayDefaultMusic
	ld a, HS_OAKS_LAB_RIVAL
	ld [wMissableObjectIndex], a
	predef HideObject
	SetEvent EVENT_1ST_ROUTE22_RIVAL_BATTLE
	ResetEventReuseHL EVENT_2ND_ROUTE22_RIVAL_BATTLE
	SetEventReuseHL EVENT_ROUTE22_RIVAL_WANTS_BATTLE
	ld a, HS_ROUTE_22_RIVAL_1
	ld [wMissableObjectIndex], a
	predef ShowObject
	ld a, $5
	ld [wPalletTownCurScript], a
	xor a
	ld [wJoyIgnore], a

	ld a, $12
	ld [wOaksLabCurScript], a
	ret

OaksLabScript18: ; 1d009 (7:5009)
	ret

OaksLabScript_RemoveParcel: ; 1d00a (7:500a)
	ld hl, wBagItems
	ld bc, $0000
.loop
	ld a, [hli]
	cp $ff
	ret z
	cp OAKS_PARCEL
	jr z, .foundParcel
	inc hl
	inc c
	jr .loop
.foundParcel
	ld hl, wNumBagItems
	ld a, c
	ld [wWhichPokemon], a
	ld a, $1
	ld [wItemQuantity], a
	jp RemoveItemFromInventory

OaksLabScript_1d02b: ; 1d02b (7:502b)
	ld a, $7c
	ld [$ffeb], a
	ld a, $8
	ld [$ffee], a
	ld a, [wYCoord]
	cp $3
	jr nz, .asm_1d045
	ld a, $4
	ld [wNPCMovementDirections2Index], a
	ld a, $30
	ld b, $b
	jr .asm_1d068
.asm_1d045
	cp $1
	jr nz, .asm_1d054
	ld a, $2
	ld [wNPCMovementDirections2Index], a
	ld a, $30
	ld b, $9
	jr .asm_1d068
.asm_1d054
	ld a, $3
	ld [wNPCMovementDirections2Index], a
	ld b, $a
	ld a, [wXCoord]
	cp $4
	jr nz, .asm_1d066
	ld a, $40
	jr .asm_1d068
.asm_1d066
	ld a, $20
.asm_1d068
	ld [$ffec], a
	ld a, b
	ld [$ffed], a
	ld a, $1
	ld [wSpriteIndex], a
	call SetSpritePosition1
	ret

OaksLabScript_1d076: ; 1d076 (7:5076)
	ld hl, OaksLabTextPointers + $36 ; starts at OaksLabText28
	ld a, l
	ld [wMapTextPtr], a
	ld a, h
	ld [wMapTextPtr+1], a
	ret

OaksLabTextPointers: ; 1d082 (7:5082)
	dw OaksLabText1
	dw OaksLabText2
	dw OaksLabText3
	dw OaksLabText4
	dw OaksLabText5
	dw OaksLabText6
	dw OaksLabText7
	dw OaksLabText8
	dw OaksLabText9
	dw OaksLabText10
	dw OaksLabText11
	dw OaksLabText12
	dw OaksLabText13
	dw OaksLabText14
	dw OaksLabText15
	dw OaksLabText16
	dw OaksLabText17
	dw OaksLabText18
	dw OaksLabText19
	dw OaksLabText20
	dw OaksLabText21
	dw OaksLabText22
	dw OaksLabText23
	dw OaksLabText24
	dw OaksLabText25
	dw OaksLabText26
	dw OaksLabText27
	dw OaksLabText28
	dw OaksLabText29
	dw OaksLabText30
	dw OaksLabText31
	dw OaksLabText32
	dw OaksLabText33
	dw OaksLabText34
	dw OaksLabText35
	dw OaksLabText36
	dw OaksLabText37
	dw OaksLabText38

OaksLabText28: ; 1d0ce (7:50ce)
OaksLabText1: ; 1d0ce (7:50ce)
	asm_text
	CheckEvent EVENT_FOLLOWED_OAK_INTO_LAB_2
	jr nz, .asm_1d0de
	ld hl, OaksLabGaryText1
	call PrintText
	jr .asm_1d0f0
.asm_1d0de
	bit 2, a
	jr nz, .asm_1d0ea
	ld hl, OaksLabText40
	call PrintText
	jr .asm_1d0f0
.asm_1d0ea
	ld hl, OaksLabText41
	call PrintText
.asm_1d0f0
	end_asm_text
	done

OaksLabGaryText1: ; 1d0f3 (7:50f3)
	far_text _OaksLabGaryText1
	done

OaksLabText40: ; 1d0f8 (7:50f8)
	far_text _OaksLabText40
	done

OaksLabText41: ; 1d0fd (7:50fd)
	far_text _OaksLabText41
	done

OaksLabText29: ; 1d102 (7:5102)
OaksLabText2: ; 1d102 (7:5102)
	asm_text
	ld a, STARTER2
	ld [wRivalStarterTemp], a
	ld a, $3
	ld [wRivalStarterBallSpriteIndex], a
	ld a, STARTER1
	ld b, $2
	jr OaksLabScript_1d133

OaksLabText30: ; 1d113 (7:5113)
OaksLabText3: ; 1d113 (7:5113)
	asm_text
	ld a, STARTER3
	ld [wRivalStarterTemp], a
	ld a, $4
	ld [wRivalStarterBallSpriteIndex], a
	ld a, STARTER2
	ld b, $3
	jr OaksLabScript_1d133

OaksLabText31: ; 1d124 (7:5124)
OaksLabText4: ; 1d124 (7:5124)
	asm_text
	ld a, STARTER1
	ld [wRivalStarterTemp], a
	ld a, $2
	ld [wRivalStarterBallSpriteIndex], a
	ld a, STARTER3
	ld b, $4

OaksLabScript_1d133: ; 1d133 (7:5133)
	ld [wcf91], a
	ld [wd11e], a
	ld a, b
	ld [wSpriteIndex], a
	CheckEvent EVENT_GOT_STARTER
	jp nz, OaksLabScript_1d22d
	CheckEventReuseA EVENT_OAK_ASKED_TO_CHOOSE_MON
	jr nz, OaksLabScript_1d157
	ld hl, OaksLabText39
	call PrintText
	end_asm_text
	done

OaksLabText39: ; 1d152 (7:5152)
	far_text _OaksLabText39
	done

OaksLabScript_1d157: ; 1d157 (7:5157)
	ld a, $5
	ld [H_SPRITEINDEX], a
	ld a, $9
	ld [H_SPRITEDATAOFFSET], a
	call GetPointerWithinSpriteStateData1
	ld [hl], SPRITE_FACING_DOWN
	ld a, $1
	ld [H_SPRITEINDEX], a
	ld a, $9
	ld [H_SPRITEDATAOFFSET], a
	call GetPointerWithinSpriteStateData1
	ld [hl], SPRITE_FACING_RIGHT
	ld hl, wd730
	set 6, [hl]
	predef StarterDex
	ld hl, wd730
	res 6, [hl]
	call ReloadMapData
	ld c, 10
	call DelayFrames
	ld a, [wSpriteIndex]
	cp $2
	jr z, OaksLabLookAtCharmander
	cp $3
	jr z, OaksLabLookAtSquirtle
	jr OaksLabLookAtBulbasaur

OaksLabLookAtCharmander: ; 1d195 (7:5195)
	ld hl, OaksLabCharmanderText
	jr OaksLabMonChoiceMenu
OaksLabCharmanderText: ; 1d19a (7:519a)
	far_text _OaksLabCharmanderText
	done

OaksLabLookAtSquirtle: ; 1d19f (7:519f)
	ld hl, OaksLabSquirtleText
	jr OaksLabMonChoiceMenu
OaksLabSquirtleText: ; 1d1a4 (7:51a4)
	far_text _OaksLabSquirtleText
	done

OaksLabLookAtBulbasaur: ; 1d1a9 (7:51a9)
	ld hl, OaksLabBulbasaurText
	jr OaksLabMonChoiceMenu
OaksLabBulbasaurText: ; 1d1ae (7:51ae)
	far_text _OaksLabBulbasaurText
	done

OaksLabMonChoiceMenu: ; 1d1b3 (7:51b3)
	call PrintText
	ld a, $1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	call YesNoChoice ; yes/no menu
	ld a, [wCurrentMenuItem]
	and a
	jr nz, OaksLabMonChoiceEnd
	ld a, [wcf91]
	ld [wPlayerStarter], a
	ld [wd11e], a
	call GetMonName
	ld a, [wSpriteIndex]
	cp $2
	jr nz, .asm_1d1db
	ld a, HS_STARTER_BALL_1
	jr .asm_1d1e5
.asm_1d1db
	cp $3
	jr nz, .asm_1d1e3
	ld a, HS_STARTER_BALL_2
	jr .asm_1d1e5
.asm_1d1e3
	ld a, HS_STARTER_BALL_3
.asm_1d1e5
	ld [wMissableObjectIndex], a
	predef HideObject
	ld a, $1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld hl, OaksLabMonReceivedText
	call PrintText
	xor a ; PLAYER_PARTY_DATA
	ld [wMonDataLocation], a
	ld a, 5
	ld [wCurEnemyLVL], a
	ld a, [wcf91]
	ld [wd11e], a
	call AddPartyMon
	ld hl, wd72e
	set 3, [hl]
	ld a, $fc
	ld [wJoyIgnore], a
	ld a, $8
	ld [wOaksLabCurScript], a
OaksLabMonChoiceEnd: ; 1d21f (7:521f)
	end_asm_text
	done

OaksLabMonReceivedText: ; 1d222 (7:5222)
	far_text _OaksLabMonReceivedText
	db $11
	done

OaksLabScript_1d22d: ; 1d22d (7:522d)
	ld a, $5
	ld [H_SPRITEINDEX], a
	ld a, $9
	ld [H_SPRITEDATAOFFSET], a
	call GetPointerWithinSpriteStateData1
	ld [hl], $0
	ld hl, OaksLabLastMonText
	call PrintText
	end_asm_text
	done

OaksLabLastMonText: ; 1d243 (7:5243)
	far_text _OaksLabLastMonText
	done

OaksLabText32: ; 1d248 (7:5248)
OaksLabText5: ; 1d248 (7:5248)
	asm_text
	CheckEvent EVENT_PALLET_AFTER_GETTING_POKEBALLS
	jr nz, .asm_1d266
	ld hl, wPokedexOwned
	ld b, wPokedexOwnedEnd - wPokedexOwned
	call CountSetBits
	ld a, [wNumSetBits]
	cp 2
	jr c, .asm_1d279
	CheckEvent EVENT_GOT_POKEDEX
	jr z, .asm_1d279
.asm_1d266
	ld hl, OaksLabText_1d31d
	call PrintText
	ld a, $1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	predef DisplayDexRating
	jp .asm_1d2ed
.asm_1d279
	ld b,POKE_BALL
	call IsItemInBag
	jr nz, .asm_1d2e7
	CheckEvent EVENT_BEAT_ROUTE22_RIVAL_1ST_BATTLE
	jr nz, .asm_1d2d0
	CheckEvent EVENT_GOT_POKEDEX
	jr nz, .asm_1d2c8
	CheckEventReuseA EVENT_BATTLED_RIVAL_IN_OAKS_LAB
	jr nz, .asm_1d2a9
	ld a, [wd72e]
	bit 3, a
	jr nz, .asm_1d2a1
	ld hl, OaksLabText_1d2f0
	call PrintText
	jr .asm_1d2ed
.asm_1d2a1
	ld hl, OaksLabText_1d2f5
	call PrintText
	jr .asm_1d2ed
.asm_1d2a9
	ld b, OAKS_PARCEL
	call IsItemInBag
	jr nz, .asm_1d2b8
	ld hl, OaksLabText_1d2fa
	call PrintText
	jr .asm_1d2ed
.asm_1d2b8
	ld hl, OaksLabDeliverParcelText
	call PrintText
	call OaksLabScript_RemoveParcel
	ld a, $f
	ld [wOaksLabCurScript], a
	jr .asm_1d2ed
.asm_1d2c8
	ld hl, OaksLabAroundWorldText
	call PrintText
	jr .asm_1d2ed
.asm_1d2d0
	CheckAndSetEvent EVENT_GOT_POKEBALLS_FROM_OAK
	jr nz, .asm_1d2e7
	lb bc, POKE_BALL, 5
	call GiveItem
	ld hl, OaksLabGivePokeballsText
	call PrintText
	jr .asm_1d2ed
.asm_1d2e7
	ld hl, OaksLabPleaseVisitText
	call PrintText
.asm_1d2ed
	end_asm_text
	done

OaksLabText_1d2f0: ; 1d2f0 (7:52f0)
	far_text _OaksLabText_1d2f0
	done

OaksLabText_1d2f5: ; 1d2f5 (7:52f5)
	far_text _OaksLabText_1d2f5
	done

OaksLabText_1d2fa: ; 1d2fa (7:52fa)
	far_text _OaksLabText_1d2fa
	done

OaksLabDeliverParcelText: ; 1d2ff (7:52ff)
	far_text _OaksLabDeliverParcelText1
	db $11
	far_text _OaksLabDeliverParcelText2
	done

OaksLabAroundWorldText: ; 1d309 (7:5309)
	far_text _OaksLabAroundWorldText
	done

OaksLabGivePokeballsText: ; 1d30e (7:530e)
	far_text _OaksLabGivePokeballsText1
	db $11
	far_text _OaksLabGivePokeballsText2
	done

OaksLabPleaseVisitText: ; 1d318 (7:5318)
	far_text _OaksLabPleaseVisitText
	done

OaksLabText_1d31d: ; 1d31d (7:531d)
	far_text _OaksLabText_1d31d
	done

OaksLabText34: ; 1d322 (7:5322)
OaksLabText33: ; 1d322 (7:5322)
OaksLabText7: ; 1d322 (7:5322)
OaksLabText6: ; 1d322 (7:5322)
	asm_text
	ld hl, OaksLabText_1d32c
	call PrintText
	end_asm_text
	done

OaksLabText_1d32c: ; 1d32c (7:532c)
	far_text _OaksLabText_1d32c
	done

OaksLabText35: ; 1d331 (7:5331)
OaksLabText8: ; 1d331 (7:5331)
	far_text _OaksLabText8
	done

OaksLabText36: ; 1d336 (7:5336)
OaksLabText9: ; 1d336 (7:5336)
	asm_text
	ld hl, OaksLabText_1d340
	call PrintText
	end_asm_text
	done

OaksLabText_1d340: ; 1d340 (7:5340)
	far_text _OaksLabText_1d340
	done

OaksLabText17: ; 1d345 (7:5345)
	asm_text
	ld hl, OaksLabRivalWaitingText
	call PrintText
	end_asm_text
	done

OaksLabRivalWaitingText: ; 1d34f (7:534f)
	far_text _OaksLabRivalWaitingText
	done

OaksLabText18: ; 1d354 (7:5354)
	asm_text
	ld hl, OaksLabChooseMonText
	call PrintText
	end_asm_text
	done

OaksLabChooseMonText: ; 1d35e (7:535e)
	far_text _OaksLabChooseMonText
	done

OaksLabText19: ; 1d363 (7:5363)
	asm_text
	ld hl, OaksLabRivalInterjectionText
	call PrintText
	end_asm_text
	done

OaksLabRivalInterjectionText: ; 1d36d (7:536d)
	far_text _OaksLabRivalInterjectionText
	done

OaksLabText20: ; 1d372 (7:5372)
	asm_text
	ld hl, OaksLabBePatientText
	call PrintText
	end_asm_text
	done

OaksLabBePatientText: ; 1d37c (7:537c)
	far_text _OaksLabBePatientText
	done

OaksLabText12: ; 1d381 (7:5381)
	asm_text
	ld hl, OaksLabLeavingText
	call PrintText
	end_asm_text
	done

OaksLabLeavingText: ; 1d38b (7:538b)
	far_text _OaksLabLeavingText
	done

OaksLabText13: ; 1d390 (7:5390)
	asm_text
	ld hl, OaksLabRivalPickingMonText
	call PrintText
	end_asm_text
	done

OaksLabRivalPickingMonText: ; 1d39a (7:539a)
	far_text _OaksLabRivalPickingMonText
	done

OaksLabText14: ; 1d39f (7:539f)
	asm_text
	ld hl, OaksLabRivalReceivedMonText
	call PrintText
	end_asm_text
	done

OaksLabRivalReceivedMonText: ; 1d3a9 (7:53a9)
	far_text _OaksLabRivalReceivedMonText
	done

OaksLabText15: ; 1d3af (7:53af)
	asm_text
	ld hl, OaksLabRivalChallengeText
	call PrintText
	end_asm_text
	done

OaksLabRivalChallengeText: ; 1d3b9 (7:53b9)
	far_text _OaksLabRivalChallengeText
	done

OaksLabText_1d3be: ; 1d3be (7:53be)
	far_text _OaksLabText_1d3be
	done

OaksLabText_1d3c3: ; 1d3c3 (7:53c3)
	far_text _OaksLabText_1d3c3
	done

OaksLabText16: ; 1d3c8 (7:53c8)
	asm_text
	ld hl, OaksLabRivalToughenUpText
	call PrintText
	end_asm_text
	done

OaksLabRivalToughenUpText: ; 1d3d2 (7:53d2)
	far_text _OaksLabRivalToughenUpText
	done

OaksLabText21: ; 1d3d7 (7:53d7)
	far_text _OaksLabText21
	done

OaksLabText22: ; 1d3dc (7:53dc)
	far_text _OaksLabText22
	done

OaksLabText23: ; 1d3e1 (7:53e1)
	far_text _OaksLabText23
	done

OaksLabText24: ; 1d3e6 (7:53e6)
	far_text _OaksLabText24
	done

OaksLabText25: ; 1d3eb (7:53eb)
	far_text _OaksLabText25
	db $11
	done

OaksLabText26: ; 1d3f1 (7:53f1)
	far_text _OaksLabText26
	done

OaksLabText27: ; 1d3f6 (7:53f6)
	far_text _OaksLabText27
	done

OaksLabText38: ; 1d3fb (7:53fb)
OaksLabText37: ; 1d3fb (7:53fb)
OaksLabText11: ; 1d3fb (7:53fb)
OaksLabText10: ; 1d3fb (7:53fb)
	asm_text
	ld hl, OaksLabText_1d405
	call PrintText
	end_asm_text
	done

OaksLabText_1d405: ; 1d405 (7:5405)
	far_text _OaksLabText_1d405
	done
