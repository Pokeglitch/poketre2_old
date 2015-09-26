;to go through the party list and PC list to remove pokemon that have the 'caught in current battle' bit set
RemovePokemonCaughtInBattle:
	call RemovePCPokemonCaughtInBattle
	call RemovePartyPokemonCaughtInBattle
	ret
	
RemovePCPokemonCaughtInBattle:
	ld a,1
	ld [wRemoveCaughtPokemonFromWhere],a	;specify the PC box
	ld hl,wPartyMon1Traits	;pointer to the first mon traits
	ld a,[wNumInBox]		;number of pokemon in the box
	push hl
	jr RemovePokemonCaughtInBattleCommon
	
RemovePartyPokemonCaughtInBattle:
	xor a
	ld [wRemoveCaughtPokemonFromWhere],a	;specify the party
	ld hl,wPartyMon1Traits	;pointer to the first mon traits
	ld a,[wPartyCount]		;number of pokemon in the party
	push hl
	
RemovePokemonCaughtInBattleCommon:
	pop hl		;recover the pointer to the first mon traits
	and a
	ret z		;return when we have no more pokemon left
	push hl		;save the pointer to the first mon traits
	
	push af
	dec a	;start at 0
	push af	;save the index	
	call SkipFixedLengthTextEntries	;go to the pokemon trait
	pop af	;get the index
	bit CaughtInCurrentBattleTrait,[hl]		;was this pokemon caught in the current battle?
	jr z,.dontRemove	;dont remove if not
	ld [wWhichPokemon],a	;save the pokemon index
	call RemovePokemon	;remove the pokemon	
.dontRemove
	pop af
	dec a
	jr RemovePokemonCaughtInBattleCommon	;loop

;to go through the party and PC list to unset the 'caught in current battle' bit
ResetPokemonCaughtInBattleBit:
	call ResetPCPokemonCaughtInBattleBit
	call ResetPartyPokemonCaughtInBattleBit
	ret
	
ResetPCPokemonCaughtInBattleBit:
	ld hl,wPartyMon1Traits	;pointer to the first mon traits
	ld a,[wNumInBox]		;number of pokemon in the box
	jr ResetPokemonCaughtInBattleBitCommon
	
ResetPartyPokemonCaughtInBattleBit:
	ld hl,wPartyMon1Traits	;pointer to the first mon traits
	ld a,[wPartyCount]		;number of pokemon in the party
	
ResetPokemonCaughtInBattleBitCommon:
	ld bc,11	;size of the section for each pokemon
.loop
	and a
	ret z		;return when we have no more pokemon left	
	res CaughtInCurrentBattleTrait,[hl]		;reset the 'caught in current battle' bit
	add hl,bc	;move to next pokemon
	dec a
	jr .loop	;loop
	