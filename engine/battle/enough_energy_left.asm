DecreaseD11EBy1_8:
	ld a,[wd11e]
	call DecreaseABy1_8
	ld [wd11e],a
	ret

DecreaseABy1_8:
	push af
	srl a		;divide by 2 (50%)
	srl a		;divide by 2 again (25%)
	srl a		;divide by 2 again (12.5%)
	ld d,a		;store into d
	pop af
	sub d		;subtract 12.5%
	ret

GetPlayerReqEnergy:
	ld a,[wBattleMonLearnedTraits]
	jr GetReqEnergyCommon
GetEnemyReqEnergy:
	;to adjust if skill active
	ld a,[wEnemyMonLearnedTraits]
	;fall through
	
GetReqEnergyCommon:
	bit EnergySkill,a		;does the pokemon have the energy skill?
	ld a,[hl]
	jr z,.afterSkillAdjust		;skip down if no adjustment
	;else, decrease by 12.5%
	push de
	call DecreaseABy1_8
	pop de
.afterSkillAdjust
	dec a
	ret
	
;return value in d
;1 = has enough
;0 = not enough
EnemyMoveHaveEnoughPP:
	ld hl,wEnemyMonPP
	ld a,[hli]
	and a
	jr nz,.enough		;has enough if the high byte is not zero
	ld a,[hl]
	ld e,a		;load the low byte into e
	ld a,[wEnemyMoveListIndex]
	ld c,a		;which move we check
	ld b,0
	
	ld hl,wEnemyMonMoves
	add hl,bc
	ld a,[hli]		;get the move id
	dec a
	ld hl,Moves + 5
	ld c,a
	ld a, MoveEnd-Moves
	
.getMaxLoop
	add hl,bc
	dec a
	jr nz,.getMaxLoop
	
	call GetEnemyReqEnergy
	cp e		;compare to the pokemons energy
	jr c,.enough		;has enough if carry (e is higher)
	
.notEnough
	ld d,0
	ret
.enough
	ld d,1
	ret
	
;return value in d
;2 = only disabled
;1 = has enough
;0 = not enough
DoesEnemyMonHasEnoughPP:
	ld hl,wEnemyMonPP
	ld a,[hli]
	and a
	jr nz,.enough		;has enough if the high byte is not zero
	ld a,[hl]
	ld e,a		;load the low byte into e
	ld bc,0		;which move we check
	ld a,[wEnemyDisabledMove]
	swap a
	and a,$0F
	dec a
	ld d,a		;store disabled move index into d
.getMoveloop
	ld hl,wEnemyMonMoves
	add hl,bc
	push bc
	ld a,[hli]		;get the move id
	and a
	jr z,.finish	;finish with 'not enough' if the move is empty
	dec a
	ld hl,Moves + 5
	ld c,a
	ld a, MoveEnd-Moves
.getMaxLoop
	add hl,bc
	dec a
	jr nz,.getMaxLoop
	pop bc
	call GetEnemyReqEnergy
	cp e		;compare to the pokemons energy
	jr c,.checkDisabled		;has enough if carry (e is higher) so check if diasbled
.continueMaxCheck
	inc c
	ld a,4
	cp c
	jr nz,.getMoveloop		;loop if we havent checked four moves
.finish
	pop bc
.notEnough
	ld a,d
	cp $FE		;was there a move that had enough, but is just disabled?>
	jr nz,.returnNotEnough	;sleep if not
	ld d,2
	ret
.returnNotEnough
	ld d,0
	ret
.checkDisabled
	ld a,c
	cp d		;is this move disabled?
	jr nz,.enough	;if not, then we have enough
	ld d,$FE	;otherwise, set d to $FE
	jr .continueMaxCheck	;and keep checking
.enough
	ld d,1
	ret
	
;return value in d
;1 = has enough
;0 = not enough
DoesBattleMonHasEnoughPP:
	ld hl,wActiveCheats2
	bit RedBullCheat,[hl]
	jr nz,.enough		;return if the red bull cheat is on (no decreasing pp)
	ld hl,wBattleMonPP
	ld a,[hli]
	and a
	jr nz,.enough		;has enough if the high byte is not zero
	ld a,[hl]
	ld e,a		;load the low byte into e
	ld bc,0		;which move we check
	ld a,[wPlayerDisabledMove]
	swap a
	and a,$0F
	dec a
	ld d,a		;store disabled move index into d
.getMoveloop
	ld hl,wBattleMonMoves
	add hl,bc
	push bc
	ld a,[hli]		;get the move id
	and a
	jr z,.finish	;finish with 'not enough' if the move is empty
	dec a
	ld hl,Moves + 5
	ld c,a
	ld a, MoveEnd-Moves
.getMaxLoop
	add hl,bc
	dec a
	jr nz,.getMaxLoop
	pop bc
	call GetPlayerReqEnergy
	cp e		;compare to the pokemons energy
	jr c,.checkDisabled		;has enough if carry (e is higher) so check if diasbled
.continueMaxCheck
	inc c
	ld a,4
	cp c
	jr nz,.getMoveloop		;loop if we havent checked four moves
.finish
	pop bc
.notEnough
	xor a
	ld [H_WHOSETURN], a ; set player's turn (for text)	
	ld a,d
	cp $FE		;was there a move that had enough, but is just disabled?>
	jr nz,.sleep	;sleep if not
	ld hl, OnlyDisabledMoveLeft
	call PrintText
	jr .returnNotEnough
.sleep
	callab BattleRandom
	ld a,[wBattleRandom]
	and SLP ; sleep mask
	jr nz,.notSleepZero
	ld a,4		;if zero, set to 4
.notSleepZero
	ld [wBattleMonStatus], a
	ld hl, NotEnoughEnergyLeft
	call PrintText
	callab PlaySleepAnimation
.returnNotEnough
	ld d,0
	ret
.checkDisabled
	ld a,c
	cp d		;is this move disabled?
	jr nz,.enough	;if not, then we have enough
	ld d,$FE	;otherwise, set d to $FE
	jr .continueMaxCheck	;and keep checking
.enough
	ld d,1
	ret
	
OnlyDisabledMoveLeft:
	far_text _OnlyDisabledMoveLeft
	done
	
NotEnoughEnergyLeft: ; 3d430 (f:5430)
	far_text _NotEnoughEnergyLeft
	done