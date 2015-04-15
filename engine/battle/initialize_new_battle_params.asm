;to initialize the new battle params
InitNewBattleParams:
	ret

;to load the landscape for this map into a
GetMapLandscape:
	ld a,0
	ret
	
	
;to see if the map is an outdoor map
IsLandscapeOutdoor:
	ld a,[wBattleLandscape]		;load the landscape
	bit 4,a						;is it a temporary landscape?
	call nz,GetMapLandscape		;if so, then get the original landscape
	and a,$0F					;only keep the landscape value
	ld hl,OutdoorLandscapes
	ld de,1
	jp IsInArray				;try to find it in the array

;to see if the attack in a is a head attack
IsHeadAttack:
	ld hl,HeadBasedMovesTables
	ld de,1
	jp IsInArray

;to see if the attack in a is a physical attack
IsPhysicalAttack:
	ld hl,PhysicalMovesTable
	ld de,1
	jp IsInArray