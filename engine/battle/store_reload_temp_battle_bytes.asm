;to save the additional player pokemon bytes from battle
StoreExtraPlayerMonBytesFromBattle:
	ld a,[wWhichPokemon]
	push af	;backup which pokemon
	ld a,[wPlayerMonNumber]
	ld [wWhichPokemon],a
	ld a,[H_WHOSETURN]
	push af	;backup the value of whose turn
	xor a
	ld [H_WHOSETURN],a	;set whose turn to 'player'
	call IsPokemonFainted
	jr nz,.notFainted	;skip down to not fainted if so
	call ClearAdditionalMonBytes
	call ClearBattleBytes
	jr .finish
.notFainted
	call SaveAdditionalMonBytes
	call StoreBattleBytes
.finish
	pop af
	ld [H_WHOSETURN],a	;restore whose_turn to original value
	pop af
	ld [wWhichPokemon],a	;restore which pokemon
	ret
	
;to save the additional enemy pokemon bytes from battle
StoreExtraEnemyMonBytesFromBattle:
	ld a,[wWhichPokemon]
	push af	;backup which pokemon
	ld a,[wEnemyMonPartyPos]
	ld [wWhichPokemon],a
	ld a,[H_WHOSETURN]
	push af	;backup the value of whose turn
	ld a,1
	ld [H_WHOSETURN],a	;set whose turn to 'enemy'
	call IsPokemonFainted
	jr nz,.notFainted	;skip down to not fainted if so
	call ClearAdditionalMonBytes
	call ClearBattleBytes
	jr .finish
.notFainted
	call SaveAdditionalMonBytes
	call StoreBattleBytes
.finish
	pop af
	ld [H_WHOSETURN],a	;restore whose_turn to original value
	pop af
	ld [wWhichPokemon],a	;restore which pokemon
	ret
	
;to clear the additional mon bytes for the current pokemon
ClearAdditionalMonBytes:
	ld hl,wPartyMon1SecondaryStatus	;secondary status pointer
	ld a, [H_WHOSETURN]
	and a
	jr z, .saveAdditionalBytes	;don't load enemy data if its the players turn
	ld hl,wEnemyMon1SecondaryStatus	;secondary status pointer
.saveAdditionalBytes
	ld a,[wWhichPokemon]	;get the index of the pokemon we are copying from
	call SkipFixedLengthTextEntries	;go to the data of the corresponding pokemon
	ld [hl],0	;set to 0
	ret

;to clear the stored battles bytes for the current pokemon
ClearBattleBytes:
	;load the stat modifiers
	ld hl,wPlayerPartyMon1AttackMod	;start of stored attack mods
	ld a, [H_WHOSETURN]
	and a
	jr z, .loadToxicPointers	;don't load enemy data if its the players turn
	ld hl,wEnemyPartyMon1AttackMod	;start of stored attack mods
.loadToxicPointers
	push hl
	ld hl,wPlayerPartyMon1ToxicCounter	;start of stored toxic counter
	jr z, .loadDisabledPointers	;don't load enemy data if its the players turn
	ld hl,wEnemyPartyMon1ToxicCounter	;start of stored toxic counter
.loadDisabledPointers
	push hl
	ld hl,wPlayerPartyMon1DisabledMove	;start of stored disabled byte
	jr z, .loadCursedFear	;don't load enemy data if its the players turn
	ld hl,wEnemyPartyMon1DisabledMove	;start of stored disabled byte
.loadCursedFear
	push hl
	ld hl,wPlayerPartyMon1CursedFearCounter	;start of stored cursed/fear counter
	jr z, .loadConfused	;don't load enemy data if its the players turn
	ld hl,wEnemyPartyMon1CursedFearCounter	;start of stored cursed/fear counter
.loadConfused
	push hl
	ld hl,wPlayerPartyMon1ConfusedCounter	;start of stored confused counter
	jr z, .beginLoading	;don't load enemy data if its the players turn
	ld hl,wEnemyPartyMon1ConfusedCounter	;start of stored confused counter
.beginLoading
	call .goToPokemonIndex	;go to corresponding pokemon in list
	ld [hl],0	;reset the confused byte
	pop hl
	call .goToPokemonIndex	;go to corresponding pokemon in list
	ld [hl],0	;reset the cursed/fear byte
	pop hl
	call .goToPokemonIndex	;go to corresponding pokemon in list
	ld [hl],0	;reset the disabled byte
	pop hl
	call .goToPokemonIndex	;go to corresponding pokemon in list
	ld [hl],0	;reset the toxic byte
	pop hl
	ld a,[wWhichPokemon]
	push af
	srl a	;divide by two, since they are grouped together by 2
	ld bc,wEnemyPartyMon3AttackMod - wEnemyPartyMon1AttackMod		;distance between each set of data
.findStoredStatsLoop
	and a
	jr z,.loadStats
	add hl,bc
	dec a
	jr .findStoredStatsLoop
.loadStats
	pop af	;restore wWhichPokemon
	bit 0,a	;is it odd numbers? (if so, we will swap the bits)
	push af	;store the flag
	ld b,7	;number of stats to save
.loadStatsLoop
	pop af	;restore the 'is odd?' flag
	push af	;save again
	ld a,[hl]	;load stored stat
	jr z,.dontSwap	;don't swap if its an even number pokemon index
	and a,$0F	;only keep the low nibble of the stored byte
	jr .finishedSwapping
.dontSwap
	and a,$F0	;only keep the high nibble of the stored bytes
.finishedSwapping
	ld [hli],a	;store to the 'saved data' bytes
	dec b
	jr nz,.loadStatsLoop	;if haven't done this for all 7 stats, then loop
	;finish
	pop af
	ret
;to just go to the pokemon index in the list
.goToPokemonIndex
	ld a,[wWhichPokemon]	;which pokemon to load
	ld c,a
	ld b,00
	add hl,bc	;hl points to the corresponding pokemon
	ret
	
;to save addition mon bytes from the battle to the pokemon
SaveAdditionalMonBytes:
	ld hl,wPartyMon1SecondaryStatus	;secondary status pointer
	ld de,wPlayerBattleStatus1	;temporary battle bits
	ld a, [H_WHOSETURN]
	and a
	jr z, .saveAdditionalBytes	;don't load enemy data if its the players turn
	ld hl,wEnemyMon1SecondaryStatus	;secondary status pointer
	ld de,wEnemyBattleStatus1	;temporary battle bits
.saveAdditionalBytes
	ld a,[wWhichPokemon]	;get the index of the pokemon we are copying from
	call SkipFixedLengthTextEntries	;go to the data of the corresponding pokemon
	
	ld [hl],0	;initialize to 0
	ld a,[de]	;load the status bit into a
	
	bit 7,a		;confused bit set?
	jr z,.skipConfused
	set Confused2,[hl]		;otherwise, set the bit
.skipConfused
	inc de
	inc de
	ld a,[de]
	bit 0,a		;toxic bit set?
	jr z,.skipToxic
	set Toxic2,[hl]		;set toxic bit
.skipToxic
	bit 4,a		;fear bit set?
	jr z,.skipFear
	set Fear2,[hl]		;set fear bit
.skipFear
	bit 5,a		;delayed damage bit set?
	jr z,.skipDelayedDamage
	set DelayedDamage2,[hl]		;set delayed damage bit
.skipDelayedDamage
	bit 6,a		;cursed bit set?
	jr z,.skipCursed
	set Cursed2,[hl]		;set cursed bit
.skipCursed
	ld bc,wPartyMon1HeldItem-wPartyMon1SecondaryStatus
	add hl,bc		;hl now points to Held Item
	ld de,wBattleMonHeldItem
	ld a, [H_WHOSETURN]
	and a
	jr z, .skipEnemyHeldItem	;don't load enemy data if its the players turn
	ld de,wEnemyMonHeldItem
.skipEnemyHeldItem
	ld a,[de]
	ld [hl],a		;store the held item
	ld bc,wPartyMon1Morale-wPartyMon1HeldItem
	add hl,bc		;hl now points to morale
	ld a, [H_WHOSETURN]
	and a
	jr nz,.skipMorale	;skip morale if its the enemys turn
	ld a,[wBattleMonMorale]
	ld [hl],a
.skipMorale
	ld bc,wPartyMon1DelayedDamage-wPartyMon1Morale
	add hl,bc		;hl now points to delayed damage
	ld de,wBattleMonDelayedDamage
	ld a, [H_WHOSETURN]
	and a
	jr z,.dontLoadEnemyDelayedDamage	;dont load the enemy bytes if its players turn
	ld de,wEnemyMonDelayedDamage
.dontLoadEnemyDelayedDamage
	ld a,[de]
	inc de
	ld [hli],a
	ld a,[de]
	inc de
	ld [hli],a	
	ld a,[de]
	ld [hl],a		;store delayed damage and counter
	ret
	
;to save the temporary pokemon bytes to a stored location for ths specific pokemon
StoreBattleBytes:
	;load the stat modifiers
	ld hl,wPlayerPartyMon1AttackMod	;start of stored attack mods
	ld de,wPlayerMonStatMods		;where to read from
	ld a, [H_WHOSETURN]
	and a
	jr z, .loadToxicPointers	;don't load enemy data if its the players turn
	ld hl,wEnemyPartyMon1AttackMod	;start of stored attack mods
	ld de,wEnemyMonStatMods	;where to read from
.loadToxicPointers
	push de
	push hl
	ld hl,wPlayerPartyMon1ToxicCounter	;start of stored toxic counter
	ld de,wPlayerToxicCounter	;where to read from
	jr z, .loadDisabledPointers	;don't load enemy data if its the players turn
	ld hl,wEnemyPartyMon1ToxicCounter	;start of stored toxic counter
	ld de,wEnemyToxicCounter	;where to read from
.loadDisabledPointers
	push de
	push hl
	ld hl,wPlayerPartyMon1DisabledMove	;start of stored disabled byte
	ld de,wPlayerDisabledMove	;where to read from
	jr z, .loadCursedFear	;don't load enemy data if its the players turn
	ld hl,wEnemyPartyMon1DisabledMove	;start of stored disabled byte
	ld de,wEnemyDisabledMove	;where to read from
.loadCursedFear
	push de
	push hl
	ld hl,wPlayerPartyMon1CursedFearCounter	;start of stored cursed/fear counter
	ld de,wBattleMonCursedFearCounter	;where to read from
	jr z, .loadConfused	;don't load enemy data if its the players turn
	ld hl,wEnemyPartyMon1CursedFearCounter	;start of stored cursed/fear counter
	ld de,wEnemyMonCursedFearCounter	;where to read from
.loadConfused
	push de
	push hl
	ld hl,wPlayerPartyMon1ConfusedCounter	;start of stored confused counter
	ld de,wPlayerConfusedCounter	;where to read from
	jr z, .beginLoading	;don't load enemy data if its the players turn
	ld hl,wEnemyPartyMon1ConfusedCounter	;start of stored confused counter
	ld de,wEnemyConfusedCounter	;where to read from
.beginLoading
	call .goToPokemonIndex	;go to corresponding pokemon in list
	ld a,[de]
	ld [hl],a	;save the confused byte
	pop hl
	pop de
	call .goToPokemonIndex	;go to corresponding pokemon in list
	ld a,[de]
	ld [hl],a	;save the cursed/fear byte
	pop hl
	pop de
	call .goToPokemonIndex	;go to corresponding pokemon in list
	ld a,[de]
	ld [hl],a	;save the disabled byte
	pop hl
	pop de
	call .goToPokemonIndex	;go to corresponding pokemon in list
	ld a,[de]
	ld [hl],a	;save the toxic byte
	pop hl
	pop de
	ld a,[wWhichPokemon]
	push af
	srl a	;divide by two, since they are grouped together by 2
	ld bc,wEnemyPartyMon3AttackMod - wEnemyPartyMon1AttackMod		;distance between each set of data
.findStoredStatsLoop
	and a
	jr z,.loadStats
	add hl,bc
	dec a
	jr .findStoredStatsLoop
.loadStats
	pop af	;restore wWhichPokemon
	bit 0,a	;is it odd numbers? (if so, we will swap the bits)
	push af	;store the flag
	ld b,7	;number of stats to save
.loadStatsLoop
	pop af	;restore the 'is odd?' flag
	push af	;save again
	ld a,[de]	;load stat
	ld c,a	;store into c
	inc de
	ld a,[hl]	;load stored stat
	jr z,.dontSwap	;don't swap if its an even number pokemon index
	and a,$0F	;only keep the low nibble of the stored byte
	swap c
	jr .finishedSwapping
.dontSwap
	and a,$F0	;only keep the high nibble of the stored bytes
.finishedSwapping
	or a,c	;combine the bytes
	ld [hli],a	;store to the 'saved data' bytes
	dec b
	jr nz,.loadStatsLoop	;if haven't done this for all 7 stats, then loop
	;finish
	pop af
	ret
;to just go to the pokemon index in the list
.goToPokemonIndex
	ld a,[wWhichPokemon]	;which pokemon to load
	ld c,a
	ld b,00
	add hl,bc	;hl points to the corresponding pokemon
	ret
	

;to check to see if the pokemon is fainted
IsPokemonFainted:
	ld hl,wBattleMonHP	;player hp pointer
	ld a, [H_WHOSETURN]
	and a
	jr z, .saveAdditionalBytes	;don't load enemy data if its the players turn
	ld hl,wEnemyMonHP	;enemy hp pointer
.saveAdditionalBytes
	ld a,[hli]
	or [hl]	;check if there are any bits on in either HP bytes
	ret