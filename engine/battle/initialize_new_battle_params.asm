;to initialize the new battle params
InitNewBattleParams:
	ret

;to load the landscape for this map into a
GetMapLandscape:
	ld a,0
	ret
	
FarBattleRandom:
	push de
	push hl
	push bc
	callab BattleRandom
	ld a,[wBattleRandom]
	pop bc
	pop hl
	pop de
	ret
	
;to see if the map is an outdoor map
IsLandscapeOutdoor:
	ld a,[wBattleLandscape]		;load the landscape
	bit 7,a						;is it a temporary landscape?
	call nz,GetMapLandscape		;if so, then get the original landscape
	and a,$7F				;ignore the "temporary?" bit
	ld hl,OutdoorLandscapes
	ld de,1
	jp IsInArray				;try to find it in the array

;to get the current attack into a
GetCurrentAttack:
	ld a,[W_ENEMYMOVENUM]	;load the enemy move into a
	push af
	ld a,[H_WHOSETURN]
	and a
	jr nz,.finish		;finish if enemy turn
	pop af
	ld a,[W_PLAYERMOVENUM]
	push af
.finish
	pop af
	ret
	
	
;to see if the attack in a is a head attack
IsHeadAttack:
	ld hl,HeadBasedMovesTables
	ld de,1
	jp IsInArray

IsPlayerAttackPhysical:
	ld a,[W_PLAYERMOVENUM]
	jr IsPhysicalAttack

IsEnemyAttackPhysical:
	ld a,[W_ENEMYMOVENUM]
	;fall through

;to see if the attack in a is a physical attack
IsPhysicalAttack:
	ld hl,PhysicalMovesTable
	ld de,1
	jp IsInArray
	
;to see if the given type (in a) is non physical
IsNonPhysicalType:
	ld hl,NonPhysicalTypeTable
	ld de,1
	jp IsInArray
	
;to see if the given attack is a piercing attack
IsPiercingAttack:
	ld hl,PiercingMovesTable
	ld de,1
	call IsInArray
	ret c	;return if the move is a piercing attack
	ld a,[wd11e]	;get move type
	ld hl,PiercingTypesTable
	ld de,1
	jp IsInArray	;check if the type is in the piercing types table