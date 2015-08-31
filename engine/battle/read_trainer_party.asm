ReadTrainer: ; 39c53 (e:5c53)

; don't change any moves in a link battle
	ld a,[wLinkState]
	and a
	ret nz

	call LoadNewTrainerPartyBytes		;load the routine IDs this trainer uses for its party mons
	
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
	call LoadTrainerDataInfo
	ld b,a
	
; At this point b contains the trainer number,
; and hl points to the trainer class.
; Our next task is to iterate through the trainers,
; decrementing b each time, until we get to the right one.
.outer
	dec b
	jr z,.IterateTrainer
.inner
	ld a,[hli]
	and a
	jr nz,.inner
	jr .outer

; if the first byte of trainer data is FF,
; - each pokemon has a specific level
;      (as opposed to the whole team being of the same level)
; else the first byte is the level of every pokemon on the team
.IterateTrainer
	ld a,[hli]
	cp $FF ; is the trainer special?
	jr z,.SpecialTrainer ; if so, check for special moves
	ld [wEnemyTrainerBaseLevel],a		;store as the base level
.LoopTrainerData
	call NewTrainerLevels		;get the level for this pokemon
	ld a,[hli]
	and a ; have we reached the end of the trainer data?
	jr z,.FinishUp
	call SeeIfPokemonShouldEvolve		;see if the pokemon should be evolved, based on the level
	ld [wcf91],a ; write species somewhere (XXX why?)
	ld a,1
	ld [wcc49],a
	push hl
	call AddPartyMon
	pop hl
	jr .LoopTrainerData
.SpecialTrainer
; if this code is being run:
; - each pokemon has a specific level
;      (as opposed to the whole team being of the same level)
	ld a,[hli]
	and a ; have we reached the end of the trainer data?
	jr z,.FinishUp
	ld b,a
	call GetVaryPKLevel
	add b		;add the base level to the vary PK level
	ld [W_CURENEMYLVL],a
	ld a,[hli]		;get the pokemon
	call SeeIfPokemonShouldEvolve		;see if the pokemon should be evolved, based on the level
	ld [wcf91],a
	ld a,1
	ld [wcc49],a
	push hl
	call AddPartyMon
	pop hl
	jr .SpecialTrainer
.FinishUp
; clear wAmountMoneyWon addresses
	xor a       
	ld de,wAmountMoneyWon
	ld [de],a
	inc de
	ld [de],a
	inc de
	ld [de],a
	ld a,[W_CURENEMYLVL]
	ld b,a
.LastLoop
; update wAmountMoneyWon addresses (money to win) based on enemy's level
	ld hl,wd047
	ld c,2 ; wAmountMoneyWon is a 3-byte number
	push bc
	predef AddBCDPredef
	pop bc
	inc de
	inc de
	dec b
	jr nz,.LastLoop ; repeat W_CURENEMYLVL times
	ret
	
	
;hl is the pointer to the table which holds the pointers for teach trainer
LoadTrainerDataInfo:
	ld a,[W_CUROPPONENT]
	sub $C9 ; convert value from pokemon to trainer
	add a,a
	ld c,a
	ld b,0
	add hl,bc ; hl points to trainer class
	ld a,[hli]
	ld h,[hl]
	ld l,a
	ld a,[W_TRAINERNO]
	ret
	
	
;to load the routine IDs used by this trainer
LoadNewTrainerPartyBytes:
	ld hl,NewTrainerPartyRoutineIDsTable
	call LoadTrainerDataInfo
	;hl is the pointer to the table for this trainer, a is the index
	ld bc,7		;size of each row
	call AddNTimes	;hl will now point to the row for this specific trainer
	
	ld de,wEnemyTrainerAddMonRoutines
	jp CopyData		;copy the data
	
NewTrainerPartyRoutineIDsTable:


;level function, moves function, dvs function, learned traits function, held item function, traits function, morale functions


NewWildMonLevel:
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
	
	ld [W_CURENEMYLVL],a	;save
	ret
	
;if the level in a is less than the min for the map, then set it to the min
;if the level in a is greater than the max, set it to the max
AdjustVaryPkLevelForMap:
	ret

;stores the new level into W_CURENEMYLVL
NewTrainerLevels:
	push hl
	ld a,[wEnemyTrainerBaseLevel]
	ld hl,wEnemyTrainerBaseLevelRoutineTables
	call RunTrainerRoutineFromTable
	ld b,a	;store the level
	ld a,[wEnemyTrainerLevelRoutine]
	ld hl,NewTrainerLevelsTable
	call RunTrainerRoutineFromTable
	ld [W_CURENEMYLVL],a
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