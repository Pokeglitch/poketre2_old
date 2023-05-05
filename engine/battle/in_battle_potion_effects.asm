;to update the pokemon stats based upon the held item
ApplyPlayerHeldItemStatBoost:
	ld de, wPlayerMonUnmodifiedAttack
	ld hl, wPlayerMonUnmodifiedSpecialDefense
	ld bc, wBattleMonHeldItem
	jr ApplyHeldItemStatBoost

ApplyEnemyHeldItemStatBoost:
	ld de, wEnemyMonUnmodifiedAttack
	ld hl, wEnemyMonUnmodifiedSpecialDefense
	ld bc, wEnemyMonHeldItem
	;fall through

ApplyHeldItemStatBoost:
	ld a,[bc]	;load the held item id
	push hl	;save pointer to special defense
	ld b, a
	ld c, 5	;5 stats to check
	ld hl,HeldItemToStatTable
.loop
	ld a,[hli]	;load the potion
	cp b
	jr z, .SpDefCheck	;if the held item matches the one in the list, then apply the stat boost
	dec c
	jr nz, .loop
	pop hl
	ret

; multiply stat at hl by 1.25
; cap stat at 999
.SpDefCheck
	ld a,c
	cp a,5		;stat ID #5?
	jr nz,.skipSpDef
	pop de	;set de to the special defense pointer
	jr .boostStat
.skipSpDef
	pop hl	;remove the stored special defense pointer
	dec a	;we want c to start at 0 instead of 1
	add a
	ld h,0
	ld l,a
	add hl,de
	push hl
	pop de	;de = pointer to desired attack
.boostStat
	ld a,[de]
	inc de
	ld h,a
	ld a,[de]
	ld l,a    ; hl = damage
	ld b,h
	ld c,l    ; bc = damage
	srl b
	rr c      ; bc = floor(0.5 * damage)
	srl b
	rr c      ; bc = floor(0.25 * damage)
	srl b
	rr c      ; bc = floor(0.125 * damage)
	add hl,bc
	ld a,h
	cp 4		;hight byte 4?
	jr nc,.setTo999	;set to 999 if over 3
	cp $03	;high byte 03?
	jr nz,.skipSettingTo999	;if lower than 03, then not 999
	ld a,l
	cp $E8	;low byte e8 (1000)?
	jr c,.skipSettingTo999 ;if lower than e8, then don't set to 999	
.setTo999
	ld hl,999
.skipSettingTo999
	ld a,l
	ld [de],a
	dec de
	ld a,h
	ld [de],a
	ret
	
;list of potion in the reverse order of the stats they apply (sp defense, sp.attack, speed, defense, attack)
HeldItemToStatTable:
	db VITAL_BRACE
	db FORCE_BRACE
	db QUICK_BRACE
	db GUARD_BRACE
	db POWER_BRACE

;to update the pokemon stats if a pokemon steals a held item in battle:
ApplyNewHeldItemStatEffects:
	ld a, [H_WHOSETURN]
	and a
	jr z, .playersTurn	;skip to players turn
	call ApplyEnemyHeldItemStatBoost
	jr .finish
.playersTurn
	call ApplyPlayerHeldItemStatBoost
	;fall through
.finish
	call CalculateModifiedStats	;no need to apply burn/paralysis or potion because they are already applied to the base stat
	ret
	
	
;to reduce the pokemons stats when they lose their item in battle:
ReversePlayerBattleHeldItemStatEffects:
	ld de, wPlayerMonUnmodifiedSpecialDefense
	ld hl, wPartyMon1Attack	;load the stored attack
	ld a,[wPlayerMonNumber]	;pokemon index
	push de
	ld de, wPlayerMonUnmodifiedAttack
	jp RemoveStatEffects
	
ReverseEnemyBattleHeldItemStatEffects:
	ld de, wEnemyMonUnmodifiedSpecialDefense
	ld hl, wEnemyMon1Attack	;load the stored attack
	ld a,[wEnemyMonPartyPos]	;pokemon index
	push de
	ld de, wEnemyMonUnmodifiedAttack
	jp RemoveStatEffects
	
	

;to update the pokemon stats if a potion is active when the pokemon is sent out:
ApplyPlayerPotionStatBoost:
	ld de, wPlayerMonUnmodifiedAttack
	ld hl, wPlayerMonUnmodifiedSpecialDefense
	ld bc, wActivePotion
	jr ApplyPotionStatBoost

ApplyEnemyPotionStatBoost:
	ld de, wEnemyMonUnmodifiedAttack
	ld hl, wEnemyMonUnmodifiedSpecialDefense
	ld bc, wEnemyActivePotion
	;fall through

ApplyPotionStatBoost:
	ld a, [wLinkState]
	cp LINK_STATE_BATTLING
	ret z ; return if link battle
	ld a,[bc]	;load the active potion id
	push hl	;save pointer to special defense
	ld b, a
	ld c, 5	;5 stats to check
	ld hl,PotionToStatTable
.loop
	ld a,[hli]	;load the potion
	cp b
	jr z, .SpDefCheck	;if the active potion matches the one in the list, then apply the stat boost
	dec c
	jr nz, .loop
	pop hl
	ret

; multiply stat at hl by 1.25
; cap stat at 999
.SpDefCheck
	ld a,c
	cp a,5		;stat ID #5?
	jr nz,.skipSpDef
	pop de	;set de to the special defense pointer
	jr .boostStat
.skipSpDef
	pop hl	;remove the stored special defense pointer
	dec a	;we want c to start at 0 instead of 1
	add a
	ld h,0
	ld l,a
	add hl,de
	push hl
	pop de	;de = pointer to desired attack
.boostStat
	ld a,[de]
	inc de
	ld h,a
	ld a,[de]
	ld l,a    ; hl = damage
	ld b,h
	ld c,l    ; bc = damage
	srl b
	rr c      ; bc = floor(0.5 * damage)
	srl b
	rr c      ; bc = floor(0.25 * damage)
	add hl,bc
	ld a,h
	cp 4		;hight byte 4?
	jr nc,.setTo999	;set to 999 if over 3
	cp $03	;high byte 03?
	jr nz,.skipSettingTo999	;if lower than 03, then not 999
	ld a,l
	cp $E8	;low byte e8 (1000)?
	jr c,.skipSettingTo999 ;if lower than e8, then don't set to 999	
.setTo999
	ld hl,999
.skipSettingTo999
	ld a,l
	ld [de],a
	dec de
	ld a,h
	ld [de],a
	ret
	
;list of potion in the reverse order of the stats they apply (sp defense, sp.attack, speed, defense, attack)
PotionToStatTable:
	db IMPEDE_POTION
	db FORCE_POTION
	db SPEED_POTION
	db SHIELD_POTION
	db CLAW_POTION
	
;to reduce the pokemons stats when a potion wears out:
ReversePlayerBattlePotionEffects:
	ld de, wPlayerMonUnmodifiedSpecialDefense
	ld hl, wPartyMon1Attack	;load the stored attack
	ld a,[wPlayerMonNumber]	;pokemon index
	push de
	push af
	push hl
	ld de, wPlayerMonUnmodifiedAttack
	ld hl, wActivePotion
	ld bc, wPotionCounter
	jr RemovePotionEffects
	
ReverseEnemyBattlePotionEffects:
	ld de, wEnemyMonUnmodifiedSpecialDefense
	ld hl, wEnemyMon1Attack	;load the stored attack
	ld a,[wEnemyMonPartyPos]	;pokemon index
	push de
	push af
	push hl
	ld de, wEnemyMonUnmodifiedAttack
	ld hl, wEnemyActivePotion
	ld bc, wEnemyPotionCounter
	;fall through
	
RemovePotionEffects:
	ld a,[hl]
	ld [hl],NO_POTION	;reset the potion
	xor a
	ld [bc],a	;reset the counter
	
	pop hl		;recover the party attack position
	pop af	;a = what pokemon in party
	
RemoveStatEffects:
	ld bc,wPartyMon2 - wPartyMon1	;the difference between each pokemon
	call AddNTimes	;go to the appropriate pokemon	
	
	;copy from the party to the in battle stats
	push hl
	ld bc, 8
	call CopyData
	pop hl
	
	ld bc,wPartyMon1Attack - wPartyMon1SpDefense
	add hl,bc	;set hl to special defense from party
	
	pop de		;recover the unmodified special defense byte
	
	ld a,[hli]
	ld [de],a	;store high byte
	inc de
	ld a,[hl]
	ld [de],a	;store low byte

	ld a,[H_WHOSETURN]
	call ApplyNewPotionEffects
	call ApplyNewHeldItemStatEffects
	call ApplyBurnAndParalysisPenalties
	call CalculateModifiedStats
	ret

;to update the pokemon stats if a potion is used in battle:
ApplyNewPotionEffects:
	ld a, [H_WHOSETURN]
	and a
	jr z, .playersTurn	;skip to players turn
	call ApplyEnemyPotionStatBoost
	jr .finish
.playersTurn
	call ApplyPlayerPotionStatBoost
	;fall through
.finish
	call CalculateModifiedStats	;no need to apply burn/paralysis or held item because they are already applied to the base stat
	ret