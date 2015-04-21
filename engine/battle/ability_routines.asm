;to exit the damage routing without doing any more calcs
ExitDamageRoutine:
	pop af		;remove the first return
	pop af		;remove the pokemon abilities
	pop af		;remove the pokemon abilities
	pop af		;remove the second return
	pop af		;remove the third return
	ret

;see if the the ability id in a matches the attacking pokemons first ability or second
SetAttackingAbilityTextBit:
	ld a,[wWhichAbilityUsed]	;load the ability id into a
	ld hl,wBattleDamageText
	and a	;ability 1?
	jr nz,.secondAbility
	set 4,[hl]					;set the "modified by attacker 1st ability" text bit
	ret
.secondAbility
	set 5,[hl]					;set the "modified by attacker 2nd ability" text bit
	ret
	
;see if the the ability id in a matches the defendings pokemons first ability or second
SetDefendingAbilityTextBit:
	ld a,[wWhichAbilityUsed]	;load the ability id into a
	ld hl,wBattleDamageText
	and a	;ability 1?
	jr nz,.secondAbility
	set 6,[hl]					;set the "modified by defender 1st ability" text bit
	ret
.secondAbility
	set 7,[hl]					;set the "modified by defender 2nd ability" text bit
	ret
	
;to set the appropriate bit for "Ability Caused No damage"
SetAbilityNoDamageTextBit:
	ld a,[wWhichAbilityUsed]	;load the ability id into a
	ld hl,wBattleNoDamageText
	and a	;ability 1?
	jr nz,.secondAbility
	set 1,[hl]					;set the "modified by defender 1st ability" text bit
	ret
.secondAbility
	set 2,[hl]					;set the "modified by defender 2nd ability" text bit
	ret
	
;The routine to run if the attacking pokemon had the headpiece ability
HeadpieceModifyDamage:
	call GetCurrentAttack		;get the attack being used
	call IsHeadAttack		;is it a head attack
	ret nc		;return if not head attack
	call MultiplyDamageBy15		;boost the damage by 1.5
	jp SetAttackingAbilityTextBit	;set the bit for the attacking ability

;The routine to run if the attacking pokemon had the flying dragon ability
FlyingDragonModifyDamage:
	ld b, AERO		;set b to AERO
	jr ThirdTypeCheckCommon	;check to see if the attack is equal to this type

;The routine to run if the attacking pokemon had the rawhide ability
RawhideModifyDamage:
	ld b, BONE		;set b to BONE
	;fall through

;checks if the type is equal to the value in b.  If so, double the damage
ThirdTypeCheckCommon:
	ld a,[wd11e]	;get the attack type
	cp b		;is it equal to the given type?
	ret nz		;return if not
	call MultiplyDamageBy15		;otherwise, multiply damage by 1.5
	jp SetAttackingAbilityTextBit	;set the bit for the attacking ability

;The routine to run if the defending pokemon had the porous ability
PorousModifyDamage:
	ld b,WATER
	jr AbsorbDamageCommon

;The routine to run if the defending pokemon had the recharge ability
RechargeModifyDamage:
	ld b,ELECTRIC
	;fall through
	
;if the attack type matches the type in b, then defender absorbs 1/8th the damage
AbsorbDamageCommon:
	ld a,[wd11e]	;get the attack type
	cp b		;is it equal to the given type?
	ret nz		;return if not
	call MultiplyDamageBy025		;otherwise, divide the damage by 8
	ld hl,wAdditionalBattleBits1
	set 0,[hl]					;set the "add damage instead of subtract" bit
	call SetDefendingAbilityTextBit	;set the bit for the defender ability
	call EnsureDamageIsNotZero	;if the damage is zero, make it 1
	jp ExitDamageRoutine	;don't do any more damage calcs
	
;to divide the damage by 4
MultiplyDamageBy025:
	ld hl,W_DAMAGE + 1
	ld a,[hld]
	ld h,[hl]
	ld l,a    ; hl = damage
	ld b,h
	ld c,l    ; bc = damage
	srl b
	rr c      ; bc = floor(0.5 * damage)
	srl b
	rr c      ; bc = floor(0.25 * damage)
.storeDamage
; store damage
	ld a,b
	ld [W_DAMAGE],a
	ld a,c
	ld [W_DAMAGE + 1],a
	ret


;The routine to run if the defending pokemon had the stench ability
StenchModifyDamage:
	call GetCurrentAttack		;get the attack being used
	call IsPhysicalAttack		;is it a piercing attack
	ret nc		;return if not physical attack
	jr ZeroDamage1in8Chance	;set damage to 0 (12.5% chance)

;The routine to run if the defending pokemon had the invisible wall ability
InvisibleWallModifyDamage:
	call GetCurrentAttack		;get the attack being used
	call IsPhysicalAttack		;is it a piercing attack
	ret c		;return if it is a physical attack
	;fall through

;1/8 chance of an attack causing 0 damage based upon defender ability
ZeroDamage1in8Chance:
	call FarBattleRandom	;get random number
	cp a,$32		;12.5% chance
	ret nc			;return if over 32
	call SetAbilityNoDamageTextBit	;set the bit for the defender ability
	call SetDamageToZero		;set the damage to 0
	jp ExitDamageRoutine
	
;The routine to run if the defending pokemon had the fluffy ability
FluffyModifyDamage:
	call GetCurrentAttack		;get the attack being used
	call IsPiercingAttack		;is it a piercing attack
	ret c		;return if it is a piercing attack
	call GetCurrentAttack		;get the attack being used
	call IsPhysicalAttack		;is it a piercing attack
	ret nc		;return if not physical attack
	call MultiplyDamageBy075		;otherwise, multiply damage by 0.75
	jp SetDefendingAbilityTextBit	;set the bit for the defender ability
	
;to multiply the damage by 0.75
MultiplyDamageBy075:
	ld hl,W_DAMAGE + 1
	ld a,[hld]
	ld h,[hl]
	ld l,a    ; hl = damage
	ld b,h
	ld c,l    ; bc = damage
	srl b
	rr c      ; bc = floor(0.5 * damage)
	push bc
	pop hl		;hl = bc = 50%
	srl b
	rr c      ; bc = floor(0.25 * damage)
	add hl,bc	;hl = 75%
.storeDamage
; store damage
	ld a,h
	ld [W_DAMAGE],a
	ld a,l
	ld [W_DAMAGE + 1],a
	ret