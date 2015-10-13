_DrawPlayerHUDAndHPBar: ; 3cd60 (f:4d60)
	xor a
	ld [H_AUTOBGTRANSFERENABLED], a
	coord hl, 9, 7
	ld bc, $50b
	call ClearScreenArea
	callab PlacePlayerHUDTiles
	coord hl, 18, 9
	ld [hl], $73
	ld de, wBattleMonNick
	coord hl, 10, 7
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
	coord hl, 14, 8
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
	coord hl, 10, 9
	predef DrawHP
	ld a, $1
	ld [H_AUTOBGTRANSFERENABLED], a
	ld hl, wPlayerHPBarColor
	callab GetBattleHealthBarColor2
	ld hl, wBattleMonHP
	ld a, [hli]
	or [hl]
	jr z, .asm_3cdd9
	ld a, [wLowHealthAlarmDisabled]
	and a
	ret nz
	ld a, [wPlayerHPBarColor]
	cp HP_BAR_RED
	jr z, .asm_3cde6
.asm_3cdd9
	ld hl, wLowHealthAlarm
	bit 7, [hl] ;low health alarm enabled?
	ld [hl], $0
	ret z
	xor a
	ld [wChannelSoundIDs + CH4], a
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
	coord hl, 1, 0
	call CenterMonName
	call PlaceString
	coord hl, 4, 1
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
	coord hl, 2, 2
	call DrawHPBar
	ld a, $1
	ld [H_AUTOBGTRANSFERENABLED], a
	ld hl, wEnemyHPBarColor
		
GetBattleHealthBarColor2: ; 3ce90 (f:4e90)
	ld b, [hl]
	call GetHealthBarColor
	ld a, [hl]
	cp b
	ret z
	ld b, $1
	jp RunPaletteCommand


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
	cp "@"
	jr z, .done
	inc de
	ld a, [de]
	cp "@"
	jr z, .done
	dec hl
	dec b
	jr nz, .loop
.done
	pop de
	ret
	
_DrawHUDsAndHPBars::
	call _DrawPlayerHUDAndHPBar
	jp _DrawEnemyHUDAndHPBar
	
_DisplayBattleMenu: ; 3ceb3 (f:4eb3)
	call LoadScreenTilesFromBuffer1 ; restore saved screen
	ld a, [wBattleType]
	and a
	jr nz, .nonstandardbattle
	call _DrawHUDsAndHPBars
	call PrintEmptyString2
	call SaveScreenTilesToBuffer1
.nonstandardbattle
	ld a, [wBattleType]
	cp $2 ; safari
	ld a, BATTLE_MENU_TEMPLATE
	jr nz, .menuselected
	ld a, SAFARI_BATTLE_MENU_TEMPLATE
.menuselected
	ld [wTextBoxID], a
	call DisplayTextBoxID
	ld a, [wBattleType]
	dec a
	jp nz, .handleBattleMenuInput ; handle menu input if it's not the old man tutorial
; the following happens for the old man tutorial
	ld hl, wPlayerName
	ld de, wGrassRate
	ld bc, $b
	call CopyData  ; temporarily save the player name in unused space,
	               ; which is supposed to get overwritten when entering a
	               ; map with wild Pokémon. Due to an oversight, the data
	               ; may not get overwritten (cinnabar) and the infamous
	               ; Missingno. glitch can show up.
	ld hl, .oldManName
	ld de, wPlayerName
	ld bc, $b
	call CopyData
; the following simulates the keystrokes by drawing menus on screen
	coord hl, 9, 14
	ld [hl], "▶"
	ld c, $50
	call DelayFrames
	ld [hl], $7f
	coord hl, 9, 16
	ld [hl], "▶"
	ld c, $32
	call DelayFrames
	ld [hl], $ec
	ld a, $2 ; select the "ITEM" menu
	jp .upperLeftMenuItemWasNotSelected
.oldManName
	db "OLD MAN@"
.handleBattleMenuInput
	ld a, [wBattleAndStartSavedMenuItem]
	ld [wCurrentMenuItem], a
	ld [wLastMenuItem], a
	sub 2 ; check if the cursor is in the left column
	jr c, .leftColumn
; cursor is in the right column
	ld [wCurrentMenuItem], a
	ld [wLastMenuItem], a
	jr .rightColumn
.leftColumn ; put cursor in left column of menu
	ld a, [wBattleType]
	cp $2
	ld a, " "
	jr z, .safariLeftColumn
; put cursor in left column for normal battle menu (i.e. when it's not a Safari battle)
	Coorda 15, 14 ; clear upper cursor position in right column
	Coorda 15, 16 ; clear lower cursor position in right column
	ld b, $9 ; top menu item X
	jr .leftColumn_WaitForInput
.safariLeftColumn
	Coorda 13, 14
	Coorda 13, 16
	coord hl, 7, 14
	ld de, wNumSafariBalls
	ld bc, $102
	call PrintNumber
	ld b, $1 ; top menu item X
.leftColumn_WaitForInput
	ld hl, wTopMenuItemY
	ld a, $e
	ld [hli], a ; wTopMenuItemY
	ld a, b
	ld [hli], a ; wTopMenuItemX
	inc hl
	inc hl
	ld a, $1
	ld [hli], a ; wMaxMenuItem
	ld [hl], D_RIGHT | A_BUTTON ; wMenuWatchedKeys
	call HandleMenuInput
	bit 4, a ; check if right was pressed
	jr nz, .rightColumn
	jr .AButtonPressed ; the A button was pressed
.rightColumn ; put cursor in right column of menu
	ld a, [wBattleType]
	cp $2
	ld a, " "
	jr z, .safariRightColumn
; put cursor in right column for normal battle menu (i.e. when it's not a Safari battle)
	Coorda 9, 14 ; clear upper cursor position in left column
	Coorda 9, 16 ; clear lower cursor position in left column
	ld b, $f ; top menu item X
	jr .rightColumn_WaitForInput
.safariRightColumn
	Coorda 1, 14 ; clear upper cursor position in left column
	Coorda 1, 16 ; clear lower cursor position in left column
	coord hl, 7, 14
	ld de, wNumSafariBalls
	ld bc, $102
	call PrintNumber
	ld b, $d ; top menu item X
.rightColumn_WaitForInput
	ld hl, wTopMenuItemY
	ld a, $e
	ld [hli], a ; wTopMenuItemY
	ld a, b
	ld [hli], a ; wTopMenuItemX
	inc hl
	inc hl
	ld a, $1
	ld [hli], a ; wMaxMenuItem
	ld a, D_LEFT | A_BUTTON
	ld [hli], a ; wMenuWatchedKeys
	call HandleMenuInput
	bit 5, a ; check if left was pressed
	jr nz, .leftColumn ; if left was pressed, jump
	ld a, [wCurrentMenuItem]
	add $2 ; if we're in the right column, the actual id is +2
	ld [wCurrentMenuItem], a
.AButtonPressed
	call PlaceUnfilledArrowMenuCursor
	ld a, [wBattleType]
	cp $2 ; is it a Safari battle?
	ld a, [wCurrentMenuItem]
	ld [wBattleAndStartSavedMenuItem], a
	jr z, .handleMenuSelection
; not Safari battle
; swap the IDs of the item menu and party menu (this is probably because they swapped the positions
; of these menu items in first generation English versions)
	cp $1 ; was the item menu selected?
	jr nz, .notItemMenu
; item menu was selected
	inc a ; increment a to 2
	jr .handleMenuSelection
.notItemMenu
	cp $2 ; was the party menu selected?
	jr nz, .handleMenuSelection
; party menu selected
	dec a ; decrement a to 1
.handleMenuSelection
	and a
	jr nz, .upperLeftMenuItemWasNotSelected
; the upper left menu item was selected
	ld a, [wBattleType]
	cp $2
	jr z, .throwSafariBallWasSelected
; the "FIGHT" menu was selected
	xor a
	ld [wNumRunAttempts], a
	jp LoadScreenTilesFromBuffer1 ; restore saved screen and return
.throwSafariBallWasSelected
	ld a, SAFARI_BALL
	ld [wcf91], a
	jr UseBagItem

.upperLeftMenuItemWasNotSelected ; a menu item other than the upper left item was selected
	cp $2
	jp nz, PartyMenuOrRockOrRun

; either the bag (normal battle) or bait (safari battle) was selected
	ld a, [wLinkState]
	cp LINK_STATE_BATTLING
	jr nz, .notLinkBattle

; can't use items in link battles
	ld hl, ItemsCantBeUsedHereText
	call PrintText
	jp _DisplayBattleMenu

.notLinkBattle
	call SaveScreenTilesToBuffer2
	ld a, [wBattleType]
	cp $2 ; is it a safari battle?
	jr nz, BagWasSelected

; bait was selected
	ld a, SAFARI_BAIT
	ld [wcf91], a
	jr UseBagItem

BagWasSelected:
	call LoadScreenTilesFromBuffer1
	ld a, [wBattleType]
	and a ; is it a normal battle?
	jr nz, .next

; normal battle
	call _DrawHUDsAndHPBars
.next
	ld a, [wBattleType]
	dec a ; is it the old man tutorial?
	jr nz, DisplayPlayerBag ; no, it is a normal battle
	ld hl, OldManItemList
	ld a, l
	ld [wListPointer], a
	ld a, h
	ld [wListPointer + 1], a
	jr DisplayBagMenu

OldManItemList:
	db 1 ; # items
	db POKE_BALL, 50
	db -1

DisplayPlayerBag:
	; get the pointer to player's bag when in a normal battle
	ld hl, wNumBagItems
	ld a, l
	ld [wListPointer], a
	ld a, h
	ld [wListPointer + 1], a

DisplayBagMenu:
	xor a
	ld [wPrintItemPrices], a
	ld a, ITEMLISTMENU
	ld [wListMenuID], a
	ld a, [wBagSavedMenuItem]
	ld [wCurrentMenuItem], a
	call DisplayListMenuID
	ld a, [wCurrentMenuItem]
	ld [wBagSavedMenuItem], a
	ld a, $0
	ld [wMenuWatchMovingOutOfBounds], a
	ld [wMenuItemToSwap], a
	jp c, _DisplayBattleMenu ; go back to battle menu if an item was not selected

UseBagItem:
	; either use an item from the bag or use a safari zone item
	ld a, [wcf91]
	ld [wd11e], a
	call GetItemName
	call CopyStringToCF4B ; copy name
	xor a
	ld [wPseudoItemID], a
	call UseItem
	callab LoadHudTilePatterns
	call ClearSprites
	xor a
	ld [wCurrentMenuItem], a
	ld a, [wBattleType]
	cp $2 ; is it a safari battle?
	jr z, .checkIfMonCaptured

	ld a, [wActionResultOrTookBattleTurn]
	and a ; was the item used successfully?
	jp z, BagWasSelected ; if not, go back to the bag menu

	ld a, [wPlayerBattleStatus1]
	bit UsingTrappingMove, a ; is the player using a multi-turn move like wrap?
	jr z, .checkIfMonCaptured
	ld hl, wPlayerNumAttacksLeft
	dec [hl]
	jr nz, .checkIfMonCaptured
	ld hl, wPlayerBattleStatus1
	res UsingTrappingMove, [hl] ; not using multi-turn move any more

.checkIfMonCaptured
	ld a, [wCapturedMonSpecies]
	and a ; was the enemy mon captured with a ball?
	jr nz, .returnAfterCapturingMon

	ld a, [wBattleType]
	cp $2 ; is it a safari battle?
	jr z, .returnAfterUsingItem_NoCapture
; not a safari battle
	call LoadScreenTilesFromBuffer1
	call _DrawHUDsAndHPBars
	call Delay3
.returnAfterUsingItem_NoCapture

	call GBPalNormal
	and a ; reset carry
	ret

.returnAfterCapturingMon
	call GBPalNormal
	xor a
	ld [wCapturedMonSpecies], a
	ld a, $2
	ld [wBattleResult], a
	scf ; set carry
	ret

ItemsCantBeUsedHereText:
	TX_FAR _ItemsCantBeUsedHereText
	db "@"

PartyMenuOrRockOrRun:
	dec a ; was Run selected?
	jp nz, BattleMenu_RunWasSelected
; party menu or rock was selected
	call SaveScreenTilesToBuffer2
	ld a, [wBattleType]
	cp $2 ; is it a safari battle?
	jr nz, .partyMenuWasSelected
; safari battle
	ld a, SAFARI_ROCK
	ld [wcf91], a
	jp UseBagItem
.partyMenuWasSelected
	call LoadScreenTilesFromBuffer1
	xor a ; NORMAL_PARTY_MENU
	ld [wPartyMenuTypeOrMessageID], a
	ld [wMenuItemToSwap], a
	call DisplayPartyMenu
.checkIfPartyMonWasSelected
	jp nc, .partyMonWasSelected ; if a party mon was selected, jump, else we quit the party menu
.quitPartyMenu
	call ClearSprites
	call GBPalWhiteOut
	callab LoadHudTilePatterns
	call LoadScreenTilesFromBuffer2
	call RunDefaultPaletteCommand
	call GBPalNormal
	jp _DisplayBattleMenu
.partyMonDeselected
	coord hl, 11, 11
	ld bc, 6 * SCREEN_WIDTH + 9
	ld a, " "
	call FillMemory
	xor a ; NORMAL_PARTY_MENU
	ld [wPartyMenuTypeOrMessageID], a
	call GoBackToPartyMenu
	jr .checkIfPartyMonWasSelected
.partyMonWasSelected
	ld a, SWITCH_STATS_CANCEL_MENU_TEMPLATE
	ld [wTextBoxID], a
	call DisplayTextBoxID
	ld hl, wTopMenuItemY
	ld a, $c
	ld [hli], a ; wTopMenuItemY
	ld [hli], a ; wTopMenuItemX
	xor a
	ld [hli], a ; wCurrentMenuItem
	inc hl
	ld a, $2
	ld [hli], a ; wMaxMenuItem
	ld a, B_BUTTON | A_BUTTON
	ld [hli], a ; wMenuWatchedKeys
	xor a
	ld [hl], a ; wLastMenuItem
	call HandleMenuInput
	bit 1, a ; was A pressed?
	jr nz, .partyMonDeselected ; if B was pressed, jump
; A was pressed
	call PlaceUnfilledArrowMenuCursor
	ld a, [wCurrentMenuItem]
	cp $2 ; was Cancel selected?
	jr z, .quitPartyMenu ; if so, quit the party menu entirely
	and a ; was Switch selected?
	jr z, .switchMon ; if so, jump
; Stats was selected
	xor a
	ld [wMonDataLocation], a
	ld hl, wPartyMon1
	call ClearSprites
; display the two status screens
	predef StatusScreen
	predef StatusScreen2
; now we need to reload the enemy mon pic
	ld a, [wEnemyBattleStatus2]
	bit HasSubstituteUp, a ; does the enemy mon have a substitute?
	ld hl, AnimationSubstitute
	jr nz, .doEnemyMonAnimation
; enemy mon doesn't have substitute
	ld a, [wEnemyMonMinimized]
	and a ; has the enemy mon used Minimise?
	ld hl, AnimationMinimizeMon
	jr nz, .doEnemyMonAnimation
; enemy mon is not minimised
	ld a, [wEnemyMonSpecies]
	ld [wcf91], a
	ld [wd0b5], a
	call GetMonHeader
	ld de, vFrontPic
	call LoadMonFrontSprite
	jr .enemyMonPicReloaded
.doEnemyMonAnimation
	ld b, BANK(AnimationSubstitute) ; BANK(AnimationMinimizeMon)
	call Bankswitch
.enemyMonPicReloaded ; enemy mon pic has been reloaded, so return to the party menu
	jp .partyMenuWasSelected
.switchMon
	ld a, [wPlayerMonNumber]
	ld d, a
	ld a, [wWhichPokemon]
	cp d ; check if the mon to switch to is already out
	jr nz, .notAlreadyOut
; mon is already out
	ld hl, AlreadyOutText2
	call PrintText
	jp .partyMonDeselected
.notAlreadyOut
	call HasMonFainted2
	jp z, .partyMonDeselected ; can't switch to fainted mon
	ld a, $1
	ld [wActionResultOrTookBattleTurn], a
	call GBPalWhiteOut
	call ClearSprites
	callab LoadHudTilePatterns
	call LoadScreenTilesFromBuffer1
	call RunDefaultPaletteCommand
	call GBPalNormal
; fall through to SwitchPlayerMon
	callab SwitchPlayerMon
	ret
	
BattleMenu_RunWasSelected: ; 3d1fa (f:51fa)
	call LoadScreenTilesFromBuffer1
	ld a, $3
	ld [wCurrentMenuItem], a
	ld hl, wBattleMonSpeed
	ld de, wEnemyMonSpeed
	call TryRunningFromBattle
	ld a, $0
	ld [wForcePlayerToChooseMon], a
	ret c
	ld a, [wActionResultOrTookBattleTurn]
	and a
	ret nz
	jp _DisplayBattleMenu
	
TryRunningFromBattle2:
	ld hl, wPartyMon1Speed
	ld de, wEnemyMonSpeed
	;fall through

; try to run from battle (hl = player speed, de = enemy speed)
; stores whether the attempt was successful in carry flag
TryRunningFromBattle: ; 3cab9 (f:4ab9)
	callab IsGhostBattle
	jp z, .canEscape ; jump if it's a ghost battle
	ld a, [wBattleType]
	cp $2
	jp z, .canEscape ; jump if it's a safari battle
	ld a, [wLinkState]
	cp LINK_STATE_BATTLING
	jp z, .canEscape
	ld a, [wIsInBattle]
	dec a
	jr nz, .trainerBattle ; jump if it's a trainer battle
	ld a, [wNumRunAttempts]
	inc a
	ld [wNumRunAttempts], a
	ld a, [hli]
	ld [H_MULTIPLICAND + 1], a
	ld a, [hl]
	ld [H_MULTIPLICAND + 2], a
	ld a, [de]
	ld [$ff8d], a
	inc de
	ld a, [de]
	ld [$ff8e], a
	call LoadScreenTilesFromBuffer1
	ld de, H_MULTIPLICAND + 1
	ld hl, $ff8d
	ld c, $2
	call StringCmp
	jr nc, .canEscape ; jump if player speed greater than enemy speed
	xor a
	ld [H_MULTIPLICAND], a
	ld a, 32
	ld [H_MULTIPLIER], a
	call Multiply ; multiply player speed by 32
	ld a, [H_PRODUCT + 2]
	ld [H_DIVIDEND], a
	ld a, [H_PRODUCT + 3]
	ld [H_DIVIDEND + 1], a
	ld a, [$ff8d]
	ld b, a
	ld a, [$ff8e]
; divide enemy speed by 4
	srl b
	rr a
	srl b
	rr a
	and a
	jr z, .canEscape ; jump if enemy speed divided by 4, mod 256 is 0
	ld [H_DIVISOR], a ; ((enemy speed / 4) % 256)
	ld b, $2
	call Divide ; divide (player speed * 32) by ((enemy speed / 4) % 256)
	ld a, [H_QUOTIENT + 2]
	and a ; is the quotient greater than 256?
	jr nz, .canEscape ; if so, the player can escape
	ld a, [wNumRunAttempts]
	ld c, a
; add 30 to the quotient for each run attempt
.loop
	dec c
	jr z, .compareWithRandomValue
	ld b, 30
	ld a, [H_QUOTIENT + 3]
	add b
	ld [H_QUOTIENT + 3], a
	jr c, .canEscape
	jr .loop
.compareWithRandomValue
	call FarBattleRandom
	ld b, a
	ld a, [H_QUOTIENT + 3]
	cp b
	jr nc, .canEscape ; if the random value was less than or equal to the quotient 
	                  ; plus 30 times the number of attempts, the player can escape
; can't escape
	ld a, $1
	ld [wActionResultOrTookBattleTurn], a
	ld hl, CantEscapeText
	jr .printCantEscapeOrNoRunningText
.trainerBattle
	ld hl, NoRunningText
.printCantEscapeOrNoRunningText
	call PrintText
	ld a, $1
	ld [wForcePlayerToChooseMon], a
	call SaveScreenTilesToBuffer1
	and a ; reset carry
	ret
.canEscape
	ld a, [wLinkState]
	cp LINK_STATE_BATTLING
	ld a, $2
	jr nz, .playSound
; link battle
	call SaveScreenTilesToBuffer1
	xor a
	ld [wActionResultOrTookBattleTurn], a
	ld a, $f
	ld [wPlayerMoveListIndex], a
	call LinkBattleExchangeData
	call LoadScreenTilesFromBuffer1
	ld a, [wSerialExchangeNybbleReceiveData]
	cp $f
	ld a, $2
	jr z, .playSound
	dec a
.playSound
	ld [wBattleResult], a
	ld a, SFX_RUN
	call PlaySoundWaitForCurrent
	ld hl, GotAwayText
	call PrintText
	call WaitForSoundToFinish
	call SaveScreenTilesToBuffer1
	scf ; set carry
	ret

CantEscapeText: ; 3cb97 (f:4b97)
	TX_FAR _CantEscapeText
	db "@"

NoRunningText: ; 3cb9c (f:4b9c)
	TX_FAR _NoRunningText
	db "@"

GotAwayText: ; 3cba1 (f:4ba1)
	TX_FAR _GotAwayText
	db "@"

PrintEmptyString2: ; 3ee94 (f:6e94)
	ld hl, .emptyString
	jp PrintText
.emptyString
	db "@"
	

; tests if player mon has fainted
; stores whether mon has fainted in Z flag
HasMonFainted2: ; 3ca97 (f:4a97)
	ld a, [wWhichPokemon]
	ld hl, wPartyMon1HP
	ld bc, wPartyMon2 - wPartyMon1
	call AddNTimes
	ld a, [hli]
	or [hl]
	ret nz
	ld a, [wFirstMonsNotOutYet]
	and a
	jr nz, .done
	ld hl, NoWillText2
	call PrintText
.done
	xor a
	ret
	
	
NoWillText2: ; 3cab4 (f:4ab4)
	TX_FAR _NoWillText
	db "@"
	

AlreadyOutText2: ; 3d1f5 (f:51f5)
	TX_FAR _AlreadyOutText
	db "@"