
;ffe4 holds the pokemon index in the party (starting at 1)	
	
	

NewTrainerMonMoves:
	push hl	
	call CopyTypes
	
	push hl
	pop de		;move the pointer into de
	
	ld a,[wEnemyTrainerMovesRoutine]
	ld hl,NewTrainerMonMovesTable
	call RunTrainerRoutineFromTable
	
	pop hl
	ld bc,wPartyMon1SpDefense - wPartyMon1Type
	add hl,bc	;move hl past the 'moves' section
	ret

NewTrainerMonMovesTable:
	dw TrainerMoves_Default
	
;just run the default moves function
TrainerMoves_Default:
	call NewMonMoves
	ret








NewTrainerDVs:
	push hl
	ld a,[wEnemyTrainerDVRoutine]
	ld hl,NewTrainerDVsTable
	call RunTrainerRoutineFromTable
	call AdjustDVsBasedOnGender
	pop hl
	jp FinishCopyDVs

NewTrainerDVsTable:
	dw TrainerDVs_Random
	dw TrainerDVs_Zero
	dw TrainerDVs_Max
	dw TrainerDVs_Avg
	dw TrainerDVs_RandomMaxSpeed
	dw TrainerDVs_RandomMaxHP
	
TrainerDVs_Avg:
	ld a,$77
	jr CopyDVsAIntoBC
	
TrainerDVs_Max:
	ld a,$FF
	jr CopyDVsAIntoBC
	
TrainerDVs_Zero:
	xor a
	jr CopyDVsAIntoBC
	

TrainerDVs_Random:
	call GenerateRandomDVs
	ret
	
TrainerDVs_RandomMaxSpeed:
	call GenerateRandomDVs
	jp SetDVMaxSpeed
	
TrainerDVs_RandomMaxHP:
	call GenerateRandomDVs
	jp SetDVMaxHP
	
;shared Trainer DV routines
CopyDVsAIntoBC:
	ld b,a
	ld c,a
	ret
	
SetDVMaxSpeed:
	push af
	ld a,b
	or a,$F0		;set the high nybble (speed) to max
	ld b,a
	pop af
	ret
	
SetDVMaxHP:
	or a,$F0		;set the high nybble (HP) to max
	ret

	
	
	
	
	

NewTrainerHeldItem:
	push hl
	ld a,[wEnemyTrainerHeldItemRoutine]
	ld hl,NewTrainerHeldItemTable
	call RunTrainerRoutineFromTable
	pop hl
	jp FinishCopyHeldItem

NewTrainerHeldItemTable:
	dw TrainerHeldItem_None
	
TrainerHeldItem_None:
	xor a
	ret
	
	
	
	
	
	
;no need to pop hl, FinishCopyTraits takes care of it
NewTrainerTraits:
	push hl
	ld a,[wEnemyTrainerTraitsRoutine]
	ld hl,NewTrainerTraitsTable
	call RunTrainerRoutineFromTable
	jp FinishCopyTraits

NewTrainerTraitsTable:
	dw TrainerTraits_Default
	
TrainerTraits_Default:
	call GetNewMonGender
	ret


	
	
	
	

NewTrainerLearnedTraits:
	push hl
	ld a,[wEnemyTrainerLearnedTraitsRoutine]
	ld hl,NewTrainerLearnedTraitsTable
	call RunTrainerRoutineFromTable
	pop hl
	jp FinishCopyLearnedTraits

NewTrainerLearnedTraitsTable:
	dw TrainerLearnedTraits_None
	
TrainerLearnedTraits_None:
	xor a
	ret

	
	
	
	
	

;returns the morale in a
NewTrainerMorale:
	push hl
	ld a,[wEnemyTrainerMoraleRoutine]
	ld hl,NewTrainerMoraleTable
	call RunTrainerRoutineFromTable
	pop hl
	jp FinishCopyMorale

NewTrainerMoraleTable:
	dw TrainerMorale_Base
	
TrainerMorale_Base:
	ld a, [wMonHBaseMorale]
	ret
	
	
	
	
	
AdjustVaryPKLevelForMap:
	ret
