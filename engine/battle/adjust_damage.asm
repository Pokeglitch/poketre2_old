; function to adjust the base damage of an attack to account for type effectiveness
_AdjustDamageForMoveType: ; 3e3a5 (f:63a5)
; values for player turn
	ld hl,wBattleMonType
	ld a,[hli]
	ld b,a    ; b = type 1 of attacker
	ld c,[hl] ; c = type 2 of attacker
	ld hl,wEnemyMonType
	ld a,[hli]
	ld d,a    ; d = type 1 of defender
	ld e,[hl] ; e = type 2 of defender
	ld a,[W_PLAYERMOVETYPE]
	ld [wd11e],a
	ld a,[H_WHOSETURN]
	and a
	jr z,.next
; values for enemy turn
	push bc
	push de
	pop bc
	pop de	; swap bc and de
	ld a,[W_ENEMYMOVETYPE]
	ld [wd11e],a
.next
	ld a,[wd11e] ; move type
	cp b ; does the move type match type 1 of the attacker?
	jr z,.sameTypeAttackBonus
	cp c ; does the move type match type 2 of the attacker?
	jr nz,.skipSameTypeAttackBonus
.sameTypeAttackBonus
; if the move type matches one of the attacker's types
	call MultiplyDamageBy15
	ld hl,wDamageMultipliers
	set 7,[hl]
.skipSameTypeAttackBonus
	ld a,[wd11e]
	ld hl,TypeEffects
	add a
	push bc
	ld b,0
	ld c,a
	add hl,bc	;hl = pointer to row for the attack type
	pop bc
	ld a,[hli]
	ld h,[hl]
	ld l,a		;hl = pointer to type chart for attack type
	call LookFor0xDamage	;check for 0x damage
	ld a,d
	cp e		;does the defender have two matching types?
	jr nz,.notMatchingTypes	;skip down if not
	ld e,$FF	;otherwise, load $FF into e
	
.notMatchingTypes
	ld bc,$0014	;look for 2x damage
	call CheckTypeTableForDamage
	ld bc,$0105	;look for 0.5 damage
	call CheckTypeTableForDamage
	
	;do remaining checks
	call HoloOrShadowCheck
	call Landscape0xDamageCheck
	call Landscape15xDamageCheck
	call WeatherDamageCheck
	call EnvironmentDamageCheck
	call RemainingDamageChecks
	
	;update the damage multipliers
	ld hl,wDamageMultipliers
	ld a,[hl]
	ld [wExactDamageMultipler],a		;store the exact damage modifier value
	push af
	and a,$80	;only get bit 7
	ld b,a		;backup bit 7
	pop af
	res 7,a		;remove bit 7
	
	cp a,$15	;is it less than $15?
	jr nc,.greaterThan15
	
	cp a,$0a	;is it $0a?
	jr z,.finish		;then finish
	
	ld a,5		;load "not very effective" multiplier
	jr .finish
	
.greaterThan15
	cp a,$23	;is it 23? (doubled, but then halved)
	jr nz,.superEffective
	ld a,$0a	;otherwise, set it to the default multipler
	jr .finish
	
.superEffective
	ld a,$14	;load the super effective multiplier
	
.finish
	add b		;reload the bit 7
	ld [hl],a	;save
	call EnsureDamageIsNotZero	;if the damage is zero, make it 1
	ld a,[wd11e]	;load type into a
	ld [wWhichTypeUsed],a	;store into "which type used"
	ret
	
;to check the type chart table to try to find 0x damage
LookFor0xDamage:
	push hl
	push bc
	push de
	ld a,2
	;to skip through the first two sets of data in the type chart (they are for 2x and 0.5x)
.loop1
	push af
.loop2
	ld a,[hli]
	cp a,$FF	;reached the end of this line?
	jr nz,.loop2
	pop af
	dec a
	jr nz,.loop1
;parse the 0x row loop
.loop3
	ld a,[hli]	;get the value in the 0x row
	cp a,$FF	;the end?
	jr z,.finish	;finish if so
	cp a,d	;match type 1?
	jr z,.setToZero	;set to zero if so
	cp a,e	;match type 2?
	jr nz,.loop3	;loop if not
;to set the damage to zero
.setToZero
	call SetDamageToZero
	pop de
	pop bc
	pop hl
	pop af	;remove the return
	ret
.finish
	push de	;save types
	;check if the attack is a physical attack
	call GetCurrentAttack
	call IsPhysicalAttack
	pop de
	jr nc,.return		;return if not
	ld a,d	;check first type
	push de
	call IsNonPhysicalType	;is it nonphysical?
	pop de
	jr c,.setToZero	;set to zero if so
	ld a,e	;check second type
	call IsNonPhysicalType
	jr c,.setToZero	;set to zero if so
.return
	pop de
	pop bc
	pop hl
	ret
	
;to set the damage to zero
SetDamageToZero:
	xor a
	ld hl,W_DAMAGE
	ld [hli],a
	ld [hl],a	;zero the damage
	inc a
	ld [W_MOVEMISSED],a	;make the move miss
	
	ld hl,wDamageMultipliers
	ld a,[hl]
	and a,$80
	ld [hl],a	;only save bit 7 of the damage multiplier
	ret

;to check the type chart table to find 2x damage or 0.5x damage
;b = index of row we are looking at (0 = 2x, 1 = 0.5x)
;c = damage multiplier for that row
CheckTypeTableForDamage:
	push hl
	ld a,b
;loop to go to the correct row
.loop1
	and a
	jr z,.readRowLoop	;exit loop when a=0 (which was b at start)
	push af
.loop2
	ld a,[hli]
	cp a,$FF	;reached the end of the row?
	jr nz,.loop2	;loop if not
	pop af
	dec a
	jr .loop1	;go to next row

;to read the row
.readRowLoop
	ld a,[hli]
	cp a,$FF
	jr z,.finish	;return when we reached the end
	cp a,d	;match type 1?
	call z,MultiplyDamageByAmount	;then multiply
	cp a,e	;match type 2?
	call z,MultiplyDamageByAmount	;then multiply
	jr .readRowLoop

.finish
	pop hl
	ret

;to multiply the damage by the amount given in c	
MultiplyDamageByAmount:
	push hl
	push bc
	push de
	ld a,c	;load multiplier into a
	ld [H_MULTIPLIER],a
	;set up the multiplicand values
	xor a
	ld [H_MULTIPLICAND],a
	ld hl,W_DAMAGE
	ld a,[hli]
	ld [H_MULTIPLICAND + 1],a
	ld a,[hld]
	ld [H_MULTIPLICAND + 2],a
	call Multiply
	
	ld a,10		;load the divisor
	ld [H_DIVISOR],a
	ld b,$04
	call Divide
	ld a,[H_QUOTIENT + 2]
	ld [hli],a
	ld a,[H_QUOTIENT + 3]
	ld [hl],a
	
	ld hl,wDamageMultipliers
	ld a,[hl]
	add a,c		;add multiplier
	ld [hl],a
	
	pop de
	pop bc
	pop hl
	ret

;to boost the damage if the pokemon is holographic/shadow and the type matches
HoloOrShadowCheck:
	ld a,[wBattleMonTraits]	;load the player traits
	ld b,a					;store into b
	ld a,[H_WHOSETURN]		;load whose turn
	and a
	jr nz,.enemyTurn		;skip down if enemy
	ld a,[wEnemyMonTraits]	;load enemy mon traits
	ld b,a					;store into b
.enemyTurn
	push bc
	ld a,[wd11e]			;load the attack type into A
	cp a,SHADOW				;shadow type?
	jr nz,.notShadow		;skip if not
	
	ld a,b
	and SHADOW_TRAIT	;is the other pokemon also a shadow?
	ld c,5	;load "half the damage"
	call nz,MultiplyDamageByAmount	;half the damage if so
	jr .finish
	
.notShadow
	cp a,HOLO				;is the attack holo type?
	jr nz,.finish			;skip down if not
	ld a,b
	and SHADOW_TRAIT			;is the pokemon shadow
	ld c,20
	call nz,MultiplyDamageByAmount	;DOUBLE the damage if so
	
.finish
	pop bc
	ld a,b
	and SHADOW_TRAIT	;is the other pokemon shadow?
	jr z,.return	;return if not
	call GetCurrentAttack
	call IsPhysicalAttack	;is it a physical attack?
	jr nc,.return	;return if not
	call SetDamageToZero
	pop af	;remove the return
.return
	ret
	
;to check the landscape to see if it matches the type, and multiply by 1.5 if so
Landscape15xDamageCheck:
	ld a,[wBattleLandscape]	;load the landscape
	and a,$7F				;ignore the "temporary?" bit
	ld d,0
	ld e,a
	ld hl,LandscapeType15Table	;pointer to the landscape vs type for 1.5 table
	add hl,de				;hl now points to the byte matching the landscape id
	ld a,[hl]
	ld b,a
	ld a,[wd11e]			;get the move type
	cp b					;do they match?
	ret nz					;return if not
	call MultiplyDamageBy15		;else, multiple by 1.5
	ld hl,wBattleDamageText
	set 0,[hl]				;set the "modified by environment" text bit
	ret
	
;to check the landscape to see if it matches type. if so, zero the damage
Landscape0xDamageCheck:
	ld a,[wd11e]			;get the move type
	ld b,a	;store into b
	ld a,[wBattleLandscape]	;load the landscape
	and a,$7F				;ignore the "temporary?" bit
	ld c,a	;store into c
	ld hl,LandscapeType0Table	;pointer to the landscape vs type for 0 table
	
.loop
	ld a,[hli]	;get the first byte in the row
	cp a,$FF
	ret z		;return if we've reached the end
	cp c		;does the landscape match?
	inc hl
	jr nz,.loop			;loop if no match
	dec hl
	ld a,[hli]	;get next value
	cp b					;does it match the type
	jr nz,.loop					;loop

	ld hl,wBattleNoDamageText
	set 0,[hl]				;set the "modified by environment" text bit
	call SetDamageToZero		;set the damage to zero
	pop af					;remove the return
	ret
		
;to see if the type matches the type effected by the weather, and multiply by 1.5 if so
WeatherDamageCheck:
	call IsLandscapeOutdoor		;are we in an outdoor landscape?
	ret nc						;return if not
	ld a,[wBattleWeather]		;load the weather
	ld d,0
	ld e,a
	ld hl,WeatherType15Table
	add hl,de					;hl now points to the index in the table that matches the weather id
	ld a,[hl]
	ld b,a
	ld a,[wd11e]			;get the move type
	cp b					;do they match?
	ret nz					;return if not
	call MultiplyDamageBy15		;else, multiple by 1.5
	ld hl,wBattleDamageText
	set 1,[hl]				;set the "modified by weather" text bit
	ret

;to see if the type matches the type effected by the weather, and multiply by 1.5 if so
EnvironmentDamageCheck:
	ld a,[wBattleEnvironment]
	push af
	call IsLandscapeOutdoor		;are we in an outdoor landscape?
	jr nc,.skipTimeCheck		;skip the time check if so
	pop af				;reload the environment
	push af
	and TEMPORY_TIME			;is the day/night reversed?
	jr z,.notTemporary		;then skip down
	pop af
	push af
	inc a			;otherwise, switch bit 0
.notTemporary
	ld c,COSMIC		;load cosmic into c
	and NIGHT_TIME	;skip down if night time
	jr nz,.skipDayTime		;skip adding the daytime type if so
	ld c,$FF	;load the daytime type into c (was plant, but removed)
.skipDayTime
	ld a,[wd11e]	;load the attack type into a
	cp c		;does it match?
	jr nz,.skipTimeCheck	;skip down if not
	call MultiplyDamageBy15	;otherwise increase the damage
	ld hl,wBattleDamageText
	set 3,[hl]				;set the "modified by time of day" text bit
.skipTimeCheck
	ld a,[wd11e]
	ld c,a		;store the attack type into c
	pop af		;reload the environment
	rrc a
	rrc a		;get rid of the first two bits (we already checked them)
	ld b,6
	ld hl,EnvironmentType15Table	;load the environment table into hl
.loop
	bit 0,a		;check the bit
	jr z,.noMatch	;skip down if no match
	push af
	ld a,[hl]		;load the type it affects into a
	cp a,c			;does the match the attack type?
	call z,MultiplyDamageBy15	;multiply the damage if so
	push hl
	ld hl,wBattleDamageText
	set 2,[hl]				;set the "modified by environment" text bit
	pop hl
	pop af
.noMatch
	rrc a
	inc hl
	dec b
	jr nz,.loop	;check the next bit
	ret

;to check for other ways the damage might be modified
RemainingDamageChecks:
	ld a,[wBattleLandscape]		;check the battle landscape
	and a,$7F				;ignore the "temporary?" bit
	cp VIRTUAL_REALITY_SCAPE		;is it virtual reality?
	jr nz,.skipVirtualReality			;skip down if not
	call GetCurrentAttack		;load the current attack into a
	call IsPhysicalAttack		;is it a physical attack
	jr nc,.skipVirtualReality	;skip down if not
	ld hl,wBattleNoDamageText
	set 0,[hl]				;set the "modified by environment" text bit
	call SetDamageToZero		;set the damage to zero
	pop af					;remove the return
	ret
	
.skipVirtualReality
	ld hl,wBattleMonAbility1		;load the first player ability
	ld a,[hli]
	ld b,a
	ld c,[hl]			;bc contains the player pokemon abilities
	ld hl,wEnemyMonAbility1		;load the first enemy ability
	ld a,[hli]
	ld d,a
	ld e,[hl]		;de contains the enemy pokemon abilities
	ld a,[H_WHOSETURN]
	and a
	jr z,.checkFirstAbility
	push bc
	push de
	pop bc
	pop de		;swap bc and de
.checkFirstAbility	;bc = attacker, de = defender
	;check the first attacker ability
	xor a	;load ability 1 into a
	ld [wWhichAbilityUsed],a	;store into which ability used
	ld a,b
	ld hl,AttackerAbilityModifyDamagePointers
	call CheckAbilityTable
	
	;to check the second attacker ability
	ld a,1	;load ability 2 into a
	ld [wWhichAbilityUsed],a	;store into which ability used
	ld a,c
	ld hl,AttackerAbilityModifyDamagePointers
	call CheckAbilityTable
	
	;if the defender has a substitute up, then don't check the defenders abilities
	ld hl,W_ENEMYBATTSTATUS2	;load enemy status
	ld a,[H_WHOSETURN]
	and a
	jr z,.playersTurn
	ld hl,W_PLAYERBATTSTATUS2	;load players status
.playersTurn
	ld a,[hl]
	bit HasSubstituteUp,a ; does the player have a substitute?
	jr nz,.skipDefenderAbilities	;skip if so	

	;to check the first defense ability
	xor a	;load ability 1 into a
	ld [wWhichAbilityUsed],a	;store into which ability used
	ld a,d
	ld hl,DefenderAbilityModifyDamagePointers
	call CheckAbilityTable
	
	;to check the second defender ability
	ld a,1	;load ability 2 into a
	ld [wWhichAbilityUsed],a	;store into which ability used
	ld a,e
	ld hl,DefenderAbilityModifyDamagePointers
	call CheckAbilityTable	
.skipDefenderAbilities
	ret

;to check the ability table in hl for the ability in a
CheckAbilityTable:
	push bc
	push de
	ld de,3	;size of row
	call IsInArray
	call c,.runAbilityRoutine	;run the routine if so
	pop de
	pop bc
	ret
	
;to run the ability routine found in the table
.runAbilityRoutine:
	inc hl
	ld a,[hli]
	ld h,[hl]
	ld l,a
	jp hl
	
;Abilities that modify damage for the attacking pokemon
AttackerAbilityModifyDamagePointers:
	db AB_HEADPIECE
	dw HeadpieceModifyDamage
	db AB_FLYING_DRAGON
	dw FlyingDragonModifyDamage
	db AB_RAWHIDE
	dw RawhideModifyDamage
	db $FF
	
;Abilities that modify damage for the defending pokemon
DefenderAbilityModifyDamagePointers:
	db AB_POROUS
	dw PorousModifyDamage
	db AB_RECHARGE
	dw RechargeModifyDamage
	db AB_STENCH
	dw StenchModifyDamage
	db AB_INVISIBLE_WALL
	dw InvisibleWallModifyDamage
	db AB_FLUFFY
	dw FluffyModifyDamage
	db $FF

INCLUDE "engine/battle/ability_routines.asm"

	
;to multiply the damage by 1.5
MultiplyDamageBy15:
	ld hl,W_DAMAGE + 1
	ld a,[hld]
	ld h,[hl]
	ld l,a    ; hl = damage
	ld b,h
	ld c,l    ; bc = damage
	srl b
	rr c      ; bc = floor(0.5 * damage)
	add hl,bc ; hl = floor(1.5 * damage)
; store damage
	ld a,h
	ld [W_DAMAGE],a
	ld a,l
	ld [W_DAMAGE + 1],a
	ret
	
;to set the damage to 1 if it is zero
EnsureDamageIsNotZero:
	ld hl,W_DAMAGE
	ld a,[hli]
	and a
	ret nz		;return if first byte isnt 0
	ld a,[hl]
	and a
	ret nz		;return if second byte isnt 0
	ld a,1		;load 1 into a
	ld [hl],a	;store into the low damage byte
	ret