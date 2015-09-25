MainMenu: ; 5af2 (1:5af2)
; Check save file
	call InitOptions
	xor a
	ld [wOptionsInitialized],a
	inc a
	ld [wSaveFileStatus],a

.mainMenuLoop
	ld c,20
	call DelayFrames
	xor a ; LINK_STATE_NONE
	ld [wLinkState],a
	ld hl,wPartyAndBillsPCSavedMenuItem
	ld [hli],a
	ld [hli],a
	ld [hli],a
	ld [hl],a
	ld [wDefaultMap],a
	ld hl,wd72e
	res 6,[hl]
	call ClearScreen
	call RunDefaultPaletteCommand
	call LoadTextBoxTilePatterns
	call LoadFontTilePatterns
	ld hl,wd730
	set 6,[hl]
	coord hl, 0, 0
	ld b,6
	ld c,13
	call TextBoxBorder
	coord hl, 2, 2
	ld de,ContinueText
	call PlaceString
	ld hl,wd730
	res 6,[hl]
	call UpdateSprites
	xor a
	ld [wCurrentMenuItem],a
	ld [wLastMenuItem],a
	ld [wMenuJoypadPollCount],a
	inc a
	ld [wTopMenuItemX],a
	inc a
	ld [wTopMenuItemY],a
	ld a,A_BUTTON | B_BUTTON | START
	ld [wMenuWatchedKeys],a
	ld a,2
	ld [wMaxMenuItem],a
	call HandleMenuInput
	bit 1,a ; pressed B?
	jp nz,DisplayTitleScreen ; if so, go back to the title screen
	ld c,20
	call DelayFrames
	ld a,[wCurrentMenuItem]
	and a
	jr z,.hard_mode ; if press_A on Hard Mode
	cp a,1
	jp z,.next4 ; if press_A on Normal Mode
	call DisplayOptionsFromMainMenu ; if press_a on Options
	ld a,1
	ld [wOptionsInitialized],a
	jp .mainMenuLoop
.hard_mode
	;turn off hard mode flag
	ld hl,wOptions
	set 4,[hl]
	jr .tryLoad
.next4
	;turn off hard mode flag
	ld hl,wOptions
	res 4,[hl]
.tryLoad
	predef LoadSAV	;try to load the data
	
	ld a,[wSaveFileStatus]	;did it load data?
	cp a,$1	;1 means it did not load data
	jp z,NewGame	;then run new game
	
	call ContinueGame
	ld hl,wd126
	set 5,[hl]
.inputLoop
	xor a
	ld [hJoyPressed],a
	ld [hJoyReleased],a
	ld [hJoyHeld],a
	call Joypad
	ld a,[hJoyHeld]
	bit 0,a
	jr nz,.pressedA
	bit 1,a
	jp nz,NewGame	;instead of going back, run a new game
	jr .inputLoop
.pressedA
	call GBPalWhiteOutWithDelay3
	call ClearScreen
	ld a,PLAYER_DIR_DOWN
	ld [wPlayerDirection],a
	ld c,10
	call DelayFrames
	ld a,[wNumHoFTeams]
	and a
	jp z,SpecialEnterMap
	ld a,[wCurMap] ; map ID
	cp a,HALL_OF_FAME
	jp nz,SpecialEnterMap
	xor a
	ld [wDestinationMap],a
	ld hl,wd732
	set 2,[hl] ; fly warp or dungeon warp
	call SpecialWarpIn
	jp SpecialEnterMap
InitOptions: ; 5bff (1:5bff)
	ld a,3
	ld [wOptions],a
SetDefaultSkipOptions:
	ld a,1
	ld [wLetterPrintingDelayFlags],a
	ret

LinkMenu: ; 5c0a (1:5c0a)
	xor a
	ld [wLetterPrintingDelayFlags], a
	ld hl, wd72e
	set 6, [hl]
	ld hl, TextTerminator_6b20
	call PrintText
	call SaveScreenTilesToBuffer1
	ld hl, WhereWouldYouLikeText
	call PrintText
	coord hl, 5, 5
	ld b, $6
	ld c, $d
	call TextBoxBorder
	call UpdateSprites
	coord hl, 7, 7
	ld de, CableClubOptionsText
	call PlaceString
	xor a
	ld [wUnusedCD37], a
	ld [wd72d], a
	ld hl, wTopMenuItemY
	ld a, $7
	ld [hli], a
	ld a, $6
	ld [hli], a
	xor a
	ld [hli], a
	inc hl
	ld a, $2
	ld [hli], a
	inc a
	; ld a, A_BUTTON | B_BUTTON
	ld [hli], a ; wMenuWatchedKeys
	xor a
	ld [hl], a
.waitForInputLoop
	call HandleMenuInput
	and A_BUTTON | B_BUTTON
	add a
	add a
	ld b, a
	ld a, [wCurrentMenuItem]
	add b
	add $d0
	ld [wLinkMenuSelectionSendBuffer], a
	ld [wLinkMenuSelectionSendBuffer + 1], a
.exchangeMenuSelectionLoop
	call Serial_ExchangeLinkMenuSelection
	ld a, [wLinkMenuSelectionReceiveBuffer]
	ld b, a
	and $f0
	cp $d0
	jr z, .asm_5c7d
	ld a, [wLinkMenuSelectionReceiveBuffer + 1]
	ld b, a
	and $f0
	cp $d0
	jr nz, .exchangeMenuSelectionLoop
.asm_5c7d
	ld a, b
	and $c ; did the enemy press A or B?
	jr nz, .enemyPressedAOrB
; the enemy didn't press A or B
	ld a, [wLinkMenuSelectionSendBuffer]
	and $c ; did the player press A or B?
	jr z, .waitForInputLoop ; if neither the player nor the enemy pressed A or B, try again
	jr .doneChoosingMenuSelection ; if the player pressed A or B but the enemy didn't, use the player's selection
.enemyPressedAOrB
	ld a, [wLinkMenuSelectionSendBuffer]
	and $c ; did the player press A or B?
	jr z, .useEnemyMenuSelection ; if the enemy pressed A or B but the player didn't, use the enemy's selection
; the enemy and the player both pressed A or B
; The gameboy that is clocking the connection wins.
	ld a, [hSerialConnectionStatus]
	cp USING_INTERNAL_CLOCK
	jr z, .doneChoosingMenuSelection
.useEnemyMenuSelection
	ld a, b
	ld [wLinkMenuSelectionSendBuffer], a
	and $3
	ld [wCurrentMenuItem], a
.doneChoosingMenuSelection
	ld a, [hSerialConnectionStatus]
	cp USING_INTERNAL_CLOCK
	jr nz, .skipStartingTransfer
	call DelayFrame
	call DelayFrame
	ld a, START_TRANSFER_INTERNAL_CLOCK
	ld [rSC], a
.skipStartingTransfer
	ld b, $7f
	ld c, $7f
	ld d, $ec
	ld a, [wLinkMenuSelectionSendBuffer]
	and (B_BUTTON << 2) ; was B button pressed?
	jr nz, .updateCursorPosition
; A button was pressed
	ld a, [wCurrentMenuItem]
	cp $2
	jr z, .updateCursorPosition
	ld c, d
	ld d, b
	dec a
	jr z, .updateCursorPosition
	ld b, c
	ld c, d
.updateCursorPosition
	ld a, b
	Coorda 6, 7
	ld a, c
	Coorda 6, 9
	ld a, d
	Coorda 6, 11
	ld c, 40
	call DelayFrames
	call LoadScreenTilesFromBuffer1
	ld a, [wLinkMenuSelectionSendBuffer]
	and (B_BUTTON << 2) ; was B button pressed?
	jr nz, .choseCancel ; cancel if B pressed
	ld a, [wCurrentMenuItem]
	cp $2
	jr z, .choseCancel
	xor a
	ld [wWalkBikeSurfState], a ; start walking
	ld a, [wCurrentMenuItem]
	and a
	ld a, COLOSSEUM
	jr nz, .next
	ld a, TRADE_CENTER
.next
	ld [wd72d], a
	ld hl, PleaseWaitText
	call PrintText
	ld c, 50
	call DelayFrames
	ld hl, wd732
	res 1, [hl]
	ld a, [wDefaultMap]
	ld [wDestinationMap], a
	call SpecialWarpIn
	ld c, 20
	call DelayFrames
	xor a
	ld [wMenuJoypadPollCount], a
	ld [wSerialExchangeNybbleSendData], a
	inc a ; LINK_STATE_IN_CABLE_CLUB
	ld [wLinkState], a
	ld [wEnteringCableClub], a
	jr SpecialEnterMap
.choseCancel
	xor a
	ld [wMenuJoypadPollCount], a
	call Delay3
	call CloseLinkConnection
	ld hl, LinkCanceledText
	call PrintText
	ld hl, wd72e
	res 6, [hl]
	ret

WhereWouldYouLikeText: ; 5d43 (1:5d43)
	TX_FAR _WhereWouldYouLikeText
	db "@"

PleaseWaitText: ; 5d48 (1:5d48)
	TX_FAR _PleaseWaitText
	db "@"

LinkCanceledText: ; 5d4d (1:5d4d)
	TX_FAR _LinkCanceledText
	db "@"

;to start a new game:
NewGame: ; 5d52 (1:5d52)
	ld hl, wd732
	res 1, [hl]
	call OakSpeech
	ld c, 20
	call DelayFrames

; enter map after using a special warp or loading the game from the main menu
SpecialEnterMap: ; 5d5f (1:5d5f)
	xor a
	ld [hJoyPressed], a
	ld [hJoyHeld], a
	ld [hJoy5], a
	ld [wd72d], a
	ld hl, wd732
	set 0, [hl] ; count play time
	call ResetPlayerSpriteData
	ld c, 20
	call DelayFrames
	ld a, [wEnteringCableClub]
	and a
	ret nz
	jp EnterMap

ContinueText: ; 5d7e (1:5d7e)
	db "HARD GAME", $4e

NewGameText: ; 5d87 (1:5d87)
	db "NORMAL GAME", $4e
	db "OPTION@"

CableClubOptionsText: ; 5d97 (1:5d97)
	db "TRADE CENTER", $4e
	db "COLOSSEUM",    $4e
	db "CANCEL@"

ContinueGame: ; 5db5 (1:5db5)
	xor a
	ld [H_AUTOBGTRANSFERENABLED], a
	coord hl, 4, 7
	ld b, 8
	ld c, 14
	call TextBoxBorder
	coord hl, 5, 9
	ld de, SaveScreenInfoText
	call PlaceString
	coord hl, 12, 9
	ld de, wPlayerName
	call PlaceString
	coord hl, 17, 11
	call PrintNumBadges
	coord hl, 16, 13
	call PrintNumOwnedMons
	coord hl, 13, 15
	call PrintPlayTime
	ld a, 1
	ld [H_AUTOBGTRANSFERENABLED], a
	ld c, 30
	jp DelayFrames

PrintSaveScreenText: ; 5def (1:5def)
	xor a
	ld [H_AUTOBGTRANSFERENABLED], a
	coord hl, 4, 0
	ld b, $8
	ld c, $e
	call TextBoxBorder
	call LoadTextBoxTilePatterns
	call UpdateSprites
	coord hl, 5, 2
	ld de, SaveScreenInfoText
	call PlaceString
	coord hl, 12, 2
	ld de, wPlayerName
	call PlaceString
	coord hl, 17, 4
	call PrintNumBadges
	coord hl, 16, 6
	call PrintNumOwnedMons
	coord hl, 13, 8
	call PrintPlayTime
	ld a, $1
	ld [H_AUTOBGTRANSFERENABLED], a
	ld c, 30
	jp DelayFrames

PrintNumBadges: ; 5e2f (1:5e2f)
	push hl
	ld hl, wObtainedBadges
	ld b, $1
	call CountSetBits
	pop hl
	ld de, wNumSetBits
	lb bc, 1, 2
	jp PrintNumber

PrintNumOwnedMons: ; 5e42 (1:5e42)
	push hl
	ld hl, wPokedexOwned ; wPokedexOwned
	ld b, 23
	call CountSetBits
	pop hl
	ld de, wNumSetBits
	lb bc, 1, 3
	jp PrintNumber

PrintPlayTime: ; 5e55 (1:5e55)
	ld de, wPlayTimeHours + 1
	lb bc, 1, 3
	call PrintNumber
	ld [hl], $6d
	inc hl
	ld de, wPlayTimeMinutes + 1
	lb bc, LEADING_ZEROES | 1, 2
	jp PrintNumber

SaveScreenInfoText: ; 5e6a (1:5e6a)
	db   "PLAYER"
	next "BADGES    "
	next "POKéDEX    "
	next "TIME@"

DisplayOptionsFromMainMenu:
	call ClearScreen
	ld c,20
	call DelayFrames
DisplayOptionMenu: ; 5e8a (1:5e8a)
	coord hl, 1, 1
	ld de,TextSpeedOptionText
	call PlaceString
	coord hl, 1, 5
	ld de,BattleAnimationOptionText
	call PlaceString
	coord hl, 1, 9
	ld de,BattleStyleOptionText
	call PlaceString
	coord hl, 1, 13
	ld de,BattleTextOptionText
	call PlaceString
	xor a
	ld [wCurrentMenuItem],a
	ld [wLastMenuItem],a
	inc a
	ld [wLetterPrintingDelayFlags],a
	ld [wUnusedCD40],a
	ld a,3 ; text speed cursor Y coordinate
	ld [wTopMenuItemY],a
	call SetCursorPositionsFromOptions
	ld [wTopMenuItemX],a
	ld a,$01
	ld [H_AUTOBGTRANSFERENABLED],a ; enable auto background transfer
	call Delay3
.loop
	call PlaceMenuCursor
.getJoypadStateLoop
	call JoypadLowSensitivity
	ld a,[hJoy5]
	ld b,a
	and a,A_BUTTON | B_BUTTON | START | D_RIGHT | D_LEFT | D_UP | D_DOWN ; any key besides select pressed?
	jr z,.getJoypadStateLoop
	bit 1,b ; B button pressed?
	jr nz,.exitMenu
	bit 3,b ; Start button pressed?
	jr z,.checkDirectionKeys
.exitMenu
	ld a,SFX_PRESS_AB
	call PlaySound
	ret
.eraseOldMenuCursor
	ld [wTopMenuItemX],a
	call EraseMenuCursor
	ld a,d
	ld [wOptions],a	;store d into wOptions
	jp .loop
.checkDirectionKeys
	ld a,[wOptions]
	ld d,a		;d stores wOptions
	ld a,[wTopMenuItemY]
	bit 7,b ; Down pressed?
	jr nz,.downPressed
	bit 6,b ; Up pressed?
	jr nz,.upPressed
	cp a,7 ; cursor in Battle Animation section?
	jr z,.cursorInBattleAnimation
	cp a,11 ; cursor in Battle Style section?
	jr z,.cursorInBattleStyle
	cp a,15 ; cursor on Battle Text?
	jr z,.cursorInBattleText
.cursorInTextSpeed
	bit 5,b ; Left pressed?
	jp nz,.pressedLeftInTextSpeed
	jp .pressedRightInTextSpeed
.downPressed
	cp a,15
	ld b,-12	;jump to the top if we are are the bottom
	jr z,.updateMenuVariables
	ld b,4		;otherwise, move 4 lines
	jr .updateMenuVariables
.upPressed
	cp a,3
	ld b,12	;jump to the bottom if we are at the top
	jr z,.updateMenuVariables
	ld b,-4	;otherwise move 4 lines
	;fall through
.updateMenuVariables
	add b
	ld [wTopMenuItemY],a
	call GetOptionsXCoord
	ld [wTopMenuItemX],a
	call PlaceUnfilledArrowMenuCursor
	jp .loop
.cursorInBattleAnimation
	ld a,d	;load the options byte into a
	xor a,$80	;toggle the bit
	ld d,a
	call BattleAnimationXCoord
	jp .eraseOldMenuCursor
.cursorInBattleStyle
	ld a,d	;load the options byte into a
	xor a,$40	;toggle the bit
	ld d,a
	call BattleStyleXCoord
	jp .eraseOldMenuCursor
.cursorInBattleText
	ld a,d	;load the options byte into a
	xor a,$20	;toggle the bit
	ld d,a
	call BattleTextXCoord
	jp .eraseOldMenuCursor
.pressedRightInTextSpeed
	ld a,d ; load options into a
	bit 1,a	; is it medium?
	jr nz,.updateMediumToSlow	;update medium
	bit 2,a	;is it slow?
	jr nz,.updateSlowToFast
	;otherwise, update from fast to medium
	set 1,a
	jr .updateTextSpeedXCoord
.updateMediumToSlow
	res 1,a
	set 2,a
	jr .updateTextSpeedXCoord
.updateSlowToFast
	res 2,a
	jr .updateTextSpeedXCoord
.pressedLeftInTextSpeed
	ld a,d ; load options into a
	bit 1,a	; is it medium?
	jr nz,.updateMediumToFast	;update medium
	bit 2,a	;is it slow?
	jr nz,.updateSlowToMedium
	;otherwise, update from fast to slow
	set 2,a
	jr .updateTextSpeedXCoord
.updateMediumToFast
	res 1,a
	jr .updateTextSpeedXCoord
.updateSlowToMedium
	res 2,a
	set 1,a
	;fall through
.updateTextSpeedXCoord
	ld d,a	;store back into d
	call BattleSpeedXCoord
	jp .eraseOldMenuCursor

;to get the option x coord based upon which row
GetOptionsXCoord:
	cp a,7 ; cursor in Battle Animation section?
	jr z,BattleAnimationXCoord
	cp a,11 ; cursor in Battle Style section?
	jr z,BattleStyleXCoord
	cp a,15 ; cursor on Battle Text?
	jr z,BattleTextXCoord
	;fall through
BattleSpeedXCoord:
	ld a,7	;medium position
	bit 1,d	; is it medium?
	ret nz
	ld a,14	;slow position
	bit 2,d	;is it slow?
	ret nz
	ld a,1	;load fast position
	ret
	
BattleAnimationXCoord:
	bit 7,d
	jr OptionCoordCommon

BattleStyleXCoord:
	bit 6,d
	jr OptionCoordCommon
	
BattleTextXCoord:
	bit 5,d
	;fall through

OptionCoordCommon
	ld a,1	;coord = 1
	ret z
	ld a,10
	ret
	
TextSpeedOptionText: ; 5fc0 (1:5fc0)
	db   "Text Speed:"
	next " Fast  Medium Slow@"

BattleAnimationOptionText: ; 5fde (1:5fde)
	db   "Battle Animation:"
	next " On       Off@"

BattleStyleOptionText: ; 5ffd (1:5ffd)
	db   "Battle Style:"
	next " Shift    Set@"
	
BattleTextOptionText: ; 5ffd (1:5ffd)
	db   "Battle Text:"
	next " Extended Reduced@"

; reads the options variable and places menu cursors in the correct positions within the options menu
SetCursorPositionsFromOptions: ; 604c (1:604c)
	ld a,[wOptions]
	ld d,a
	call BattleSpeedXCoord
	push af
	coord hl, 0, 3
	call .placeUnfilledRightArrow
	call BattleAnimationXCoord
	coord hl, 0, 7
	call .placeUnfilledRightArrow
	call BattleStyleXCoord
	coord hl, 0, 11
	call .placeUnfilledRightArrow
	call BattleTextXCoord
	coord hl, 0, 15
	call .placeUnfilledRightArrow
	pop af	;load the speed coord
	ret
.placeUnfilledRightArrow
	ld c,a
	ld b,0
	add hl,bc
	ld [hl],$ec ; unfilled right arrow menu cursor
	ret

; table that indicates how the 3 text speed options affect frame delays
; Format:
; 00: X coordinate of menu cursor
; 01: delay after printing a letter (in frames)
TextSpeedOptionData: ; 6096 (1:6096)
	db 14,5 ; Slow
	db  7,3 ; Medium
	db  1,1 ; Fast
	db 7 ; default X coordinate (Medium)
	db $ff ; terminator