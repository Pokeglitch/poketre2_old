ReadTrainer: ; 39c53 (e:5c53)

; don't change any moves in a link battle
	ld a,[wLinkState]
	and a
	ret nz
	
; set [wEnemyPartyCount] to 0, [wEnemyPartyMons] to FF
; XXX first is total enemy pokemon?
; XXX second is species of first pokemon?
	ld hl,wEnemyPartyCount
	xor a
	ld [hli],a
	dec a
	ld [hl],a

; get the pointer to trainer data for this class
	ld hl,TrainerDataPointers
	ld a,[wCurOpponent]
	sub $C9 ; convert value from pokemon to trainer
	add a,a
	ld c,a
	ld b,0
	add hl,bc ; hl points to trainer class
	ld a,[hli]
	ld h,[hl]
	ld l,a
	ld a,[wTrainerNo]
	
	ld b,a	;b contains the trainer index
	ld de,wEnemyTrainerAddMonRoutinesEnd - wEnemyTrainerAddMonRoutines		;set size that appears at the start of each trainer party header

.FindTrainer
	dec b
	jr z,.IterateTrainer


	add hl,de		;skip past the set size of the party header
	ld a,[hli]		;get the number of pokemon in the party
	add l
	ld l,a			;increment l by the number of pokemon in the party
	jr nc,.noCarry	;if we didn't carry, then dont increment h as well
	inc h
.noCarry
	jr .FindTrainer

; if the first byte of trainer data is FF,
; - each pokemon has a specific level
;      (as opposed to the whole team being of the same level)
; else the first byte is the level of every pokemon on the team
.IterateTrainer
	;copy the party header bytes
	push de
	pop bc		;bc = size to copy
	ld de,wEnemyTrainerAddMonRoutines
	call CopyData		;copy the data (hl = where to copy from)

	ld a,[hli]	;get the number of pokemon in a
	push af		;store
.LoopTrainerData
	pop af
	and a
	jr z,.FinishUp		;if we have reached the end, then finish up
	dec a
	push af
	
	call NewTrainerLevels		;get the level for this pokemon	
	ld a,[hli]		;get the pokemon and increment hl
	ld [wcf91],a ; write species somewhere (XXX why?)
	call SeeIfPokemonShouldEvolve		;see if the pokemon should be evolved, based on the level
	ld a,ENEMY_PARTY_DATA
	ld [wMonDataLocation],a
	push hl
	call AddPartyMon
	pop hl
	jr .LoopTrainerData
.FinishUp
	ld a,[wEnemyTrainerFirstNameID]
	ld [wd0b5],a		;the name index
	ld hl,FemaleTrainerList
	ld a,[wCurOpponent]
	ld c,a
.findFemaleLoop
	ld a,[hli]
	cp $FF
	jr z,.storeMaleName	;store the name if we've reached the end
	cp c		;if it doesnt match, then go to the next one
	jr nz,.findFemaleLoop
.female
	call GetFemaleTrainerName
	jr .storeName
.storeMaleName
	call GetMaleTrainerName
.storeName
	ld a,b
	ld [wNameListType],a
	ld a,BANK(MaleTrainerNames)
	ld [wPredefBank],a
	ld a," "
	ld [wEnemyTrainerFirstName],a		;set the first character of first name to be a space
	ld hl,wcd6d
	ld de,wEnemyTrainerFirstName + 1
	ld bc,11
	call CopyData	;copy the name to everything after the space
	
; clear wAmountMoneyWon addresses
	xor a
	ld de,wAmountMoneyWon
	ld [de],a
	inc de
	ld [de],a
	inc de
	ld [de],a
	ld a,[wCurEnemyLVL]
	ld b,a
.LastLoop
; update wAmountMoneyWon addresses (money to win) based on enemy's level
	ld hl,wTrainerBaseMoney + 1
	ld c,2 ; wAmountMoneyWon is a 3-byte number
	push bc
	predef AddBCDPredef
	pop bc
	inc de
	inc de
	dec b
	jr nz,.LastLoop ; repeat wCurEnemyLVL times
	ret
	
	
	


NewWildMonLevel::
	call GetVaryPKLevel
	
	;adjust for the maps min/max level
	call AdjustVaryPKLevelForMap
	
	;add random value between 0-7 to the level
	push af ;save the level

	callab BattleRandom
	ld a,[wBattleRandom]
	and a,$07		;only keep the lower 3 bits
	add 3			;increase by 3, so the lowest possible level is 3
	ld b,a		;store into b
	
	pop af	;recover the level
	add b	;add the random value
	
	ld [wCurEnemyLVL],a	;save
	ret
	
;if the level in a is less than the min for the map, then set it to the min
;if the level in a is greater than the max, set it to the max
AdjustVaryPKLevelForMap::
	ret

;stores the new level into wCurEnemyLVL
NewTrainerLevels::
	push hl
	ld a,[wEnemyTrainerBaseLevel]
	ld hl,wEnemyTrainerBaseLevelRoutineTables
	call RunTrainerRoutineFromTable
	ld b,a	;store the level
	ld a,[wEnemyTrainerLevelRoutine]
	ld hl,NewTrainerLevelsTable
	call RunTrainerRoutineFromTable
	ld [wCurEnemyLVL],a
	pop hl
	ret
	
;function for what to use the base level for a trainers party
wEnemyTrainerBaseLevelRoutineTables:
	dw TrainerBaseLevel_UseVaryPK
	dw TrainerBaseLevel_HighestLevelInParty
	dw TrainerBaseLevel_MaxOfBoth
	dw TrainerBaseLevel_MinOfBoth
	dw TrainerBaseLevel_AvgOfBoth
	
TrainerBaseLevel_UseVaryPK:
	call GetVaryPKLevel
	ret
	
TrainerBaseLevel_HighestLevelInParty:
TrainerBaseLevel_MaxOfBoth:
TrainerBaseLevel_MinOfBoth:
TrainerBaseLevel_AvgOfBoth:
	ret
	
	
;functions to run to determine how to modify the base level based on the pokemon index in the party
NewTrainerLevelsTable:
	dw NewTrainerLevel_Fixed
	dw NewTrainerLevel_ProgressiveInc
	
NewTrainerLevel_Fixed:
	ld a,b
	ret
	
NewTrainerLevel_ProgressiveInc
	ld a,[wEnemyPartyCount]		;get the pokemon index (number of pokemon in party before this one is added)
	add b
	ret
	
	
	
	
GetVaryPKLevel:
	ld a,5
	ret
	
	
SeeIfPokemonShouldEvolve:
	ld a,[wcf91]
	ret
	