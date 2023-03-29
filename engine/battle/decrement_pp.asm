DecrementEnemyPP:
	;get the PP required for this move
	ld a,[wEnemyMoveListIndex]
	ld [wCurrentMenuItem],a
	ld a, 5
	ld [wMonDataLocation], a
	callab GetMaxPP

	;to adjust if skill active
	ld a,[wEnemyMonLearnedTraits]
	bit EnergySkill,a		;does the pokemon have the energy skill?
	jr z,.afterSkillAdjust		;skip down if no adjustment
	;else, decrease by 12.5%
	callab DecreaseD11EBy1_8
.afterSkillAdjust
; after using a move, decrement pp in battle and (if not transformed?) in party
	ld hl, wEnemyBattleStatus1
	ld a, [hli]          ; load the wEnemyBattleStatus1 pokemon status flags and increment hl to load the
	                     ; wEnemyBattleStatus2 status flags later
	and a, (1 << StoringEnergy) | (1 << ThrashingAbout) | (1 << AttackingMultipleTimes)
	ret nz               ; if any of these statuses are true, don't decrement PP
	bit UsingRage, [hl]
	ret nz               ; don't decrement PP either if Pokemon is using Rage
	ld hl, wEnemyMonPP  ; PP of first move (in battle)
	
; decrement PP in the battle struct	
	call _DecrementPP    
	ld a,[wIsInBattle]
	dec a
	ret z		;return if wild battle
	
; decrement PP in the party struct	
	ld hl, wEnemyMon1PP  ; PP of first move (in party)
	ld a, [wEnemyMonPartyPos] ; which mon in party is active
	ld bc, wPartyMon2 - wPartyMon1
	call AddNTimes       ; calculate address of the mon to modify
	jr _DecrementPP
	

	
	
DecrementPP: ; 68000 (1a:4000)

	ld a, [wLinkState]
	cp LINK_STATE_BATTLING
	jr nz, .noCheats	;no cheats if link battle
	
	ld hl,wActiveCheats2
	bit RedBullCheat,[hl]
	ret nz		;return if the red bull cheat is on (no decreasing pp)
	
.noCheats
	;get the PP required for this move
	ld a, [wPlayerMonNumber]
	ld [wWhichPokemon], a
	ld a, $4
	ld [wMonDataLocation], a
	callab GetMaxPP

	;to adjust if skill active
	ld a,[wBattleMonLearnedTraits]
	bit EnergySkill,a		;does the pokemon have the energy skill?
	jr z,.afterSkillAdjust		;skip down if no adjustment
	;else, decrease by 12.5%
	callab DecreaseD11EBy1_8
.afterSkillAdjust
; after using a move, decrement pp in battle and (if not transformed?) in party
	ld hl, wPlayerBattleStatus1
	ld a, [hli]          ; load the wPlayerBattleStatus1 pokemon status flags and increment hl to load the
	                     ; wPlayerBattleStatus2 status flags later
	and a, (1 << StoringEnergy) | (1 << ThrashingAbout) | (1 << AttackingMultipleTimes)
	ret nz               ; if any of these statuses are true, don't decrement PP
	bit UsingRage, [hl]
	ret nz               ; don't decrement PP either if Pokemon is using Rage
	ld hl, wBattleMonPP  ; PP of first move (in battle)
	
; decrement PP in the battle struct	
	call _DecrementPP    
	
; decrement PP in the party struct	
	ld hl, wPartyMon1PP  ; PP of first move (in party)
	ld a, [wPlayerMonNumber] ; which mon in party is active
	ld bc, wPartyMon2 - wPartyMon1
	call AddNTimes       ; calculate address of the mon to modify
_DecrementPP:
	ld a,[wd11e]
	cpl
	inc a
	ld c,a
	ld b,-1		;bc = negative max pp
	
	push hl
	ld a,[hli]
	ld l,[hl]
	ld h,a		;hl = current pp
	
	add hl,bc		;substract the pp of the attack from the current pp
	
	pop bc	;bc = pointer to pp
	ld a,h
	ld [bc],a
	inc bc
	ld a,l
	ld [bc],a	
	ret
