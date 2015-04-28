;make sure 'wWhichPokemon' holds the correct pokemon index for both player and enemy

;dont forget to load the disabled attack index

;Loading this data occurs at:
;LoadBattleMonFromParty and LoadEnemyMonFromParty 
;For enemy, make sure to the "ApplyPotionStatBoost"

;For Wild pokemon, just initialize the stat modifiers and make sure special defense gets loaded (LoadEnemyMonData)
;--everything else will already be initialized to 0

;In 'SendOutMon' and 'EnemySendOutFirstMon', remove where it clears disabled bytes, and temporary status bits
;check to see where confusion and toxic counters get cleared
;also reload the disabled move ID to wPlayerDisabledMoveNumber and wEnemyDisabledMoveNumber (do this by reading the move list and finding the ID of the respective move index. set to 0 if not disabled)
;-What happens if a pokemon learns a move and erases a disabled move? it should reset the disabled byte for both battle mon and stored bytes

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
	ld hl,wPartyMon1SpDefense	;special defense pointer
	ld de,wBattleMonUnmodifiedSpecialDefense	;where to save to
	ld a, [H_WHOSETURN]
	and a
	jr z, .saveSpDef	;don't load enemy data if its the players turn
	ld hl,wEnemyMon1SpDefense	;special defense pointer
	ld de,wEnemyMonUnmodifiedSpecialDefense	;where to save to
.saveSpDef
	ld a,[wWhichPokemon]	;get the index of the pokemon we are copying from
	ld bc,wPartyMon2 - wPartyMon1	;the difference between each pokemon
	
.getPKSpDefLoop
	and a
	jr z,.copySpDef		;exit when we reach zero
	add hl,bc	;move to next pokemon
	dec a
	jr .getPKSpDefLoop	;loop
	
.copySpDef
	ld a,[hli]
	ld [de],a
	inc de
	ld a,[hl]
	ld [de],a	;store the special defense into the in-battle unmodified special defense
	
	;now load the other additional bytes
	ld hl,wPartyMon1Abilities	;start of additional bytes pointer
	ld de,wBattleMonAbility	;where to save to
	ld bc,W_PLAYERBATTSTATUS1	;temporary battle bits
	ld a, [H_WHOSETURN]
	and a
	jr z, .saveAdditionalBytes	;don't load enemy data if its the players turn
	ld hl,wEnemyMon1Abilities	;start of additional bytes pointer
	ld de,wEnemyMonAbility	;where to save to
	ld bc,W_ENEMYBATTSTATUS1	;temporary battle bits
.saveAdditionalBytes
	push bc
	push hl
	ld a,[wWhichPokemon]	;get the index of the pokemon we are copying from
	call SkipFixedLengthTextEntries	;go to the data of the corresponding pokemon
	ld bc,7		;size of data we copy over
	call CopyData	;copy the data from hl to de
	
	pop hl
	ld de,wPartyMon1SecondaryStatus - wPartyMon1Abilities
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
	ld hl,wPlayerPartyMon1DisabledMove	;start of stored disabled byte
	ld de,W_PLAYERDISABLEDMOVE	;where to save to
	jr z, .loadCursedFear	;don't load enemy data if its the players turn
	ld hl,wEnemyPartyMon1DisabledMove	;start of stored disabled byte
	ld de,W_ENEMYDISABLEDMOVE	;where to save to
.loadCursedFear
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
	
	;load the disabled attack index:
	
	pop hl
	pop de
	call .goToPokemonIndex	;go to corresponding pokemon in list
	ld a,[hl]
	ld [de],a	;restore the toxic byte
	pop hl
	pop de
	ld a,[wWhichPokemon]
	push af
	rr a	;divide by two, since they are grouped together by 2
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
	
	
;storing data to the pokemon occurs at:
;FaintEnemyPokemon and SwitchEnemyMon and ReadPlayerMonCurHPAndStatus
;just set to zero for FaintEnemyPokemon and if HP is zero for player pokemon
;just make sure this occurs before 'LoadExtraMonBytesIntoBattle' gets run

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
	call IsHordeOrTrainerBattle
	ret z	;return if wild battle
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
	ret

;to clear the stored battles bytes for the current pokemon
ClearBattleBytes:
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
	rr a	;divide by two, since they are grouped together by 2
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