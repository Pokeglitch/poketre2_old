;to load the additional player pokemon bytes into battle
LoadExtraPlayerMonBytesIntoBattle:
	ld a,[H_WHOSETURN]
	push af	;backup the value of whose turn
	xor a
	ld [H_WHOSETURN],a	;set whose turn to 'player'
	call LoadAdditionalMonBytes
	call LoadStoredBattleBytes
	pop af
	ld [H_WHOSETURN],a	;restore whose_turn to original value
	ret
	
;to load the additional enemy pokemon bytes into battle
LoadExtraEnemyMonBytesIntoBattle:
	ld a,[H_WHOSETURN]
	push af	;backup the value of whose turn
	ld a,1
	ld [H_WHOSETURN],a	;set whose turn to 'enemy'
	call LoadAdditionalMonBytes
	call LoadStoredBattleBytes
	pop af
	ld [H_WHOSETURN],a	;restore whose_turn to original value
	ret
	
;to load addition mon bytes from the pokemon into battle:
LoadAdditionalMonBytes:
	ld a, [H_WHOSETURN]
	and a
	jr z, .skipBaseSpDef	;don't load base special defense data if its the players pokemon
	ld a,[W_MONHBASESPECIALD]	;load the pokemons base special defense into a
	ld [wEnemyMonBaseSpDef],a		;store into base special defense byte
.skipBaseSpDef
	ld hl,wPartyMon1HPSpDefDV	;special defense EV pointer
	ld de,wPlayerMonUnmodifiedSpecialDefense	;where to save to
	ld a, [H_WHOSETURN]
	and a
	jr z, .saveSpDef	;don't load enemy data if its the players turn
	ld hl,wEnemyMon1HPSpDefDV	;special defense EV pointer
	ld de,wEnemyMonUnmodifiedSpecialDefense	;where to save to
.saveSpDef
	ld a,[wWhichPokemon]	;get the index of the pokemon we are copying from
	ld bc,wPartyMon2 - wPartyMon1	;the difference between each pokemon
	call AddNTimes	;hl now points to the specific pokemons special def/hp DV
	
	ld bc,wBattleMonHPSpDefDV
	ld a, [H_WHOSETURN]
	and a
	jr z, .notEnemyDV	;don't load enemy iv's if players turn
	ld bc,wEnemyMonHPSpDefDV
.notEnemyDV
	ld a,[hl]
	ld [bc],a	;store the special defense DV
.copySpDef
	ld bc,wPartyMon1SpDefense - wPartyMon1HPSpDefDV
	add hl,bc		;hl now points to the special defense
	ld a,[hli]
	ld [de],a
	inc de
	ld a,[hl]
	ld [de],a	;store the special defense into the in-battle unmodified special defense
	
	;now load the other additional bytes
	ld bc,W_PLAYERBATTSTATUS1	;temporary battle bits
	push bc
	ld de,wPartyMon1SecondaryStatus - wPartyMon1Abilities	;what we add to get to secondary status
	push de
	ld hl,wPartyMon1Abilities	;start of additional bytes pointer
	ld de,wBattleMonAbility	;where to save to
	ld bc,7						;we only copy 7 bytes for the player
	ld a, [H_WHOSETURN]
	and a
	jr z, .saveAdditionalBytes	;don't load enemy data if its the players turn
	pop de
	pop bc
	ld bc,W_ENEMYBATTSTATUS1	;temporary battle bits
	push bc
	ld de,wEnemyMon1SecondaryStatus - wEnemyMon1SpDefenseEV	;what we add to get to secondary status
	push de
	ld hl,wEnemyMon1SpDefenseEV	;start of additional bytes pointer
	ld de,wEnemyMonSpDefenseEV	;where to save to
	ld bc,10		;copy 10 bytes for enemy
	ld a, [W_ENEMYBATTSTATUS3]
	bit Transformed, a ; is enemy mon transformed?
	jr z,.saveAdditionalBytes	;if not, then copy over the OT bytes
	ld a,[wWhichPokemon]	;get the index of the pokemon we are copying from
	call SkipFixedLengthTextEntries	;go to the data of the corresponding pokemon
	push hl
	ld a,[hli]
	ld [de],a
	inc de
	ld a,[hli]
	ld [de],a	;copy the sp def EVs
	inc de
	inc hl
	inc de		;skip secondary status
	ld a,[hli]
	ld [de],a
	inc de
	ld a,[hli]
	ld [de],a	;copy the abilities
	inc de
	inc hl
	inc de
	inc hl
	inc de
	inc hl
	inc de	;skip the delayed damages
	ld a,[hli]
	ld [de],a
	inc de
	ld a,[hli]
	ld [de],a
	inc de
	ld a,[hli]
	ld [de],a	;finish copying the data	
	jr .afterTransform
.saveAdditionalBytes
	push bc
	ld a,[wWhichPokemon]	;get the index of the pokemon we are copying from
	call SkipFixedLengthTextEntries	;go to the data of the corresponding pokemon
	pop bc	;recover the size of the data to copy
	push hl
	call CopyData	;copy the data from hl to de
.afterTransform		;if we transform, then we dont copy data
	pop hl
	pop de
	add hl,de	;hl now points to the secondary status
	pop bc
	
	xor a	;initialize to 0
	;copy over the secondary status bits to the corresponding in-battle status bits
	bit 3,[hl]		;confused bit set?
	jr z,.skipConfused
	set 7,a		;otherwise, set the bit
.skipConfused
	ld [bc],a
	inc bc
	xor a	;initialize to 0
	ld [bc],a
	inc bc	;move to the third temp status byte (a is already 0)
	bit 0,[hl]	;toxic bit set?
	jr z,.skipToxic
	set 0,a		;set toxic bit
.skipToxic
	bit 4,[hl]	;fear bit set?
	jr z,.skipFear
	set 4,a		;set fear bit
.skipFear
	bit 1,[hl]	;delayed damage bit set?
	jr z,.skipDelayedDamage
	set 5,a		;set delayed damage bit
.skipDelayedDamage
	bit 2,[hl]	;cursed bit set?
	jr z,.skipCursed
	set 6,a		;set cursed bit
.skipCursed
	ld [bc],a	;save the temp status byte
	ret
	
;to load the stored battle bytes for this specific pokemon into battle:
LoadStoredBattleBytes:
	;load the stat modifiers
	ld hl,wPlayerPartyMon1AttackMod	;start of stored attack mods
	ld de,wPlayerMonStatMods		;where to save to
	ld a, [H_WHOSETURN]
	and a
	jr z, .loadToxicPointers	;don't load enemy data if its the players turn
	ld hl,wEnemyPartyMon1AttackMod	;start of stored attack mods
	ld de,wEnemyMonStatMods	;where to save to
.loadToxicPointers
	push de
	push hl
	ld hl,wPlayerPartyMon1ToxicCounter	;start of stored toxic counter
	ld de,W_PLAYERTOXICCOUNTER	;where to save to
	jr z, .loadDisabledPointers	;don't load enemy data if its the players turn
	ld hl,wEnemyPartyMon1ToxicCounter	;start of stored toxic counter
	ld de,W_ENEMYTOXICCOUNTER	;where to save to
.loadDisabledPointers
	push de
	push hl
	ld hl,wBattleMonMoves	;player mon move list
	push hl
	ld hl,wPlayerPartyMon1DisabledMove	;start of stored disabled byte
	ld de,W_PLAYERDISABLEDMOVE	;where to save to
	ld bc,wPlayerDisabledMoveNumber	;attack ID
	jr z, .loadCursedFear	;don't load enemy data if its the players turn
	pop hl
	ld hl,wEnemyMonMoves	;enemy mon  move list
	push hl
	ld hl,wEnemyPartyMon1DisabledMove	;start of stored disabled byte
	ld de,W_ENEMYDISABLEDMOVE	;where to save to
	ld bc,wEnemyDisabledMoveNumber	;attack ID
.loadCursedFear
	push bc
	push de
	push hl
	ld hl,wPlayerPartyMon1CursedFearCounter	;start of stored cursed/fear counter
	ld de,wBattleMonCursedFearCounter	;where to save cursed/fear to
	jr z, .loadConfused	;don't load enemy data if its the players turn
	ld hl,wEnemyPartyMon1CursedFearCounter	;start of stored cursed/fear counter
	ld de,wEnemyMonCursedFearCounter	;where to save cursed/fear to
.loadConfused
	push de
	push hl
	ld hl,wPlayerPartyMon1ConfusedCounter	;start of stored confused counter
	ld de,W_PLAYERCONFUSEDCOUNTER	;where to save confused to
	jr z, .beginLoading	;don't load enemy data if its the players turn
	ld hl,wEnemyPartyMon1ConfusedCounter	;start of stored confused counter
	ld de,W_ENEMYCONFUSEDCOUNTER	;where to save confused to
.beginLoading
	call .goToPokemonIndex	;go to corresponding pokemon in list
	ld a,[hl]
	ld [de],a	;restore the confused byte
	pop hl
	pop de
	call .goToPokemonIndex	;go to corresponding pokemon in list
	ld a,[hl]
	ld [de],a	;restore the cursed/fear byte
	pop hl
	pop de
	call .goToPokemonIndex	;go to corresponding pokemon in list
	ld a,[hl]
	ld [de],a	;restore the disabled byte
	pop bc	;pointer for disabled move index
	pop hl	;pointer to pokemon move list
	and a	;is the disabled by 0?
	jr z,.dontLoadDisabledMoveIndex ;then set the index to 0
	and a,$F0
	swap a		;a = the move index in the pokemon move list
	dec a		;starts at 1
	ld d,0
	ld e,a
	add hl,de	;hl = pointer to correct move
	ld a,[hl]	;load the move ID	
.dontLoadDisabledMoveIndex
	ld [bc],a
	pop hl
	pop de
	call .goToPokemonIndex	;go to corresponding pokemon in list
	ld a,[hl]
	ld [de],a	;restore the toxic byte
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
	ld b,7	;number of stats to restore
.loadStatsLoop
	pop af	;restore the 'is odd?' flag
	push af	;save again
	ld a,[hli]	;load stat
	jr z,.dontSwap	;don't swap if its an even number pokemon index
	swap a
.dontSwap
	and a,$0F	;only keep the lower 4 bits
	jr nz,.notZero	;if not zero, then skip
	ld a,7	;otherwise, set to the default (7)
.notZero
	ld [de],a	;store to the in battle bytes
	inc de
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
	ld de,W_PLAYERBATTSTATUS1	;temporary battle bits
	ld a, [H_WHOSETURN]
	and a
	jr z, .saveAdditionalBytes	;don't load enemy data if its the players turn
	ld hl,wEnemyMon1SecondaryStatus	;secondary status pointer
	ld de,W_ENEMYBATTSTATUS1	;temporary battle bits
.saveAdditionalBytes
	ld a,[wWhichPokemon]	;get the index of the pokemon we are copying from
	call SkipFixedLengthTextEntries	;go to the data of the corresponding pokemon
	
	ld [hl],0	;initialize to 0
	ld a,[de]	;load the status bit into a
	
	bit 7,a		;confused bit set?
	jr z,.skipConfused
	set 3,[hl]		;otherwise, set the bit
.skipConfused
	inc de
	inc de
	ld a,[de]
	bit 0,a		;toxic bit set?
	jr z,.skipToxic
	set 0,[hl]		;set toxic bit
.skipToxic
	bit 4,a		;fear bit set?
	jr z,.skipFear
	set 4,[hl]		;set fear bit
.skipFear
	bit 5,a		;delayed damage bit set?
	jr z,.skipDelayedDamage
	set 1,[hl]		;set delayed damage bit
.skipDelayedDamage
	bit 6,a		;cursed bit set?
	jr z,.skipCursed
	set 2,[hl]		;set cursed bit
.skipCursed
	ld a, [H_WHOSETURN]
	and a
	ret nz	;return and don't save morale if its the enemys turn
	ld bc,wPartyMon1Morale-wPartyMon1SecondaryStatus
	add hl,bc		;hl now points to morale
	ld a,[wBattleMonMorale]
	ld [hl],a
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
	ld de,W_PLAYERTOXICCOUNTER	;where to read from
	jr z, .loadDisabledPointers	;don't load enemy data if its the players turn
	ld hl,wEnemyPartyMon1ToxicCounter	;start of stored toxic counter
	ld de,W_ENEMYTOXICCOUNTER	;where to read from
.loadDisabledPointers
	push de
	push hl
	ld hl,wPlayerPartyMon1DisabledMove	;start of stored disabled byte
	ld de,W_PLAYERDISABLEDMOVE	;where to read from
	jr z, .loadCursedFear	;don't load enemy data if its the players turn
	ld hl,wEnemyPartyMon1DisabledMove	;start of stored disabled byte
	ld de,W_ENEMYDISABLEDMOVE	;where to read from
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
	ld de,W_PLAYERCONFUSEDCOUNTER	;where to read from
	jr z, .beginLoading	;don't load enemy data if its the players turn
	ld hl,wEnemyPartyMon1ConfusedCounter	;start of stored confused counter
	ld de,W_ENEMYCONFUSEDCOUNTER	;where to read from
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