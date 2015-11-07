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
	
_GetItemName::
	ld a,[wd0b5]
	cp TM_01
	jr nc, GetMachineName
	
	ld hl,ItemNames
	jr GetNameCommon
	
_GetMaleTrainerName::
	ld hl,MaleTrainerNames
	jr GetNameCommon
	
_GetFemaleTrainerName::
	ld hl,FemaleTrainerNames
	jr GetNameCommon
	
_GetFloorName::
	ld hl,ElevatorFloorNames
	jr GetNameCommon
	
_GetMoveName::
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

	
GetNameCommon::
	ld a,[wd0b5]
	ld b,a
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
	ld de,wcd6d
	ret	
	
_GetMonName::
	ld a,[wd11e]
	dec a
	ld hl,MonsterNames
	ld c,10
	ld b,0
	call AddNTimes
	ld de,wcd6d
	push de
	ld bc,10
	call CopyData
	ld hl,wcd6d + 10
	ld [hl], "@"
	pop de
	ret