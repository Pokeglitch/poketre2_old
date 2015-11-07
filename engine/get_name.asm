INCLUDE "text/monster_names.asm"
INCLUDE "text/move_names.asm"
INCLUDE "text/item_names.asm"
INCLUDE "text/trainer_names.asm"
INCLUDE "text/trainer_first_names.asm"

GetMachineName:: ; 2ff3 (0:2ff3)
; copies the name of the TM/HM in [wd11e] to wcd6d
	ld hl,TechnicalPrefix ; points to "TM"
	ld bc,2
	ld de,wcd6d
	call CopyData

; now get the machine number and convert it to text
	ld a,[wd11e]
	sub TM_01 - 1
	ld b, "0"
.FirstDigit
	sub 10
	jr c,.SecondDigit
	inc b
	jr .FirstDigit
.SecondDigit
	add 10
	push af
	ld a,b
	ld [de],a
	inc de
	pop af
	ld b, "0"
	add b
	ld [de],a
	inc de
	ld a,"@"
	ld [de],a
	ret

TechnicalPrefix:: ; 303c (0:303c)
	db "TM"
	
_GetItemNameD0B5::
	ld a,[wd0b5]
	jr _GetItemNameCommon
	
_GetItemName::
	ld a,[wd11e]
	;fall through
	
_GetItemNameCommon::
	cp TM_01
	jr nc, GetMachineName
	
	ld hl,ItemNames
	jr GetNameCommon
	
_GetMaleTrainerName::
	ld hl,MaleTrainerNames
	jr GetNameFromD0B5
	
_GetFemaleTrainerName::
	ld hl,FemaleTrainerNames
	jr GetNameFromD0B5
	
_GetFloorName::
	ld hl,ElevatorFloorNames
	jr GetNameFromD0B5
	
_GetMoveNameD0B5::
	ld hl,MoveNames
	jr GetNameFromD0B5
	
_GetMoveName::
	ld a,[wd11e]
	ld hl,MoveNames
	jr GetNameCommon
	
_GetTrainerName: ; 13a58 (4:7a58)
	ld hl, wGrassRate
	ld a, [wLinkState]
	and a
	jr nz,.copyName
	ld hl, wRivalName
	ld a, [wTrainerClass]
	cp RIVAL
	jr z,.copyName
	ld hl,TrainerNames
	call GetNameCommon
	ld h,d
	ld l,e
.copyName
	ld de, wTrainerName
	ld bc, $d
	jp CopyData


GetNameFromD0B5::
	ld a,[wd0b5]
GetNameCommon::
	ld b,a
	ld c,0
.nextName
	ld d,h
	ld e,l
.nextChar
	ld a,[hli]
	cp a, "@"
	jr nz,.nextChar
	inc c           ;entry counter
	ld a,b          ;wanted entry
	cp c
	jr nz,.nextName
	ld h,d
	ld l,e
	ld de,wcd6d
	ld bc,$0014
	call CopyData
	ret	
	
_GetMonName:
	ld a,[wd11e]
	jr _GetMonNameCommon
	
_GetMonNameD0B5::
	ld a,[wd0b5]
	
_GetMonNameCommon::
	dec a
	ld hl,MonsterNames
	ld c,10
	ld b,0
	call AddNTimes
	ld de,wcd6d
	ld bc,10
	call CopyData
	ld hl,wcd6d + 10
	ld [hl], "@"
	ret