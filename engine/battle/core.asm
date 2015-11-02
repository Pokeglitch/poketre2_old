BattleCore:

; These are move effects (second value from the Moves table in bank $E).
ResidualEffects1: ; 3c000 (f:4000)
; most non-side effects
	db CONVERSION_EFFECT
	db HAZE_EFFECT
	db SWITCH_AND_TELEPORT_EFFECT
	db MIST_EFFECT
	db FOCUS_ENERGY_EFFECT
	db CONFUSION_EFFECT
	db HEAL_EFFECT
	db TRANSFORM_EFFECT
	db LIGHT_SCREEN_EFFECT
	db REFLECT_EFFECT
	db POISON_EFFECT
	db PARALYZE_EFFECT
	db SUBSTITUTE_EFFECT
	db MIMIC_EFFECT
	db LEECH_SEED_EFFECT
	db SPLASH_EFFECT
	db -1
SetDamageEffects: ; 3c011 (f:4011)
; moves that do damage but not through normal calculations
; e.g., Super Fang, Psywave
	db SUPER_FANG_EFFECT
	db SPECIAL_DAMAGE_EFFECT
	db -1
ResidualEffects2: ; 3c014 (f:4014)
; non-side effects not included in ResidualEffects1
; stat-affecting moves, sleep-inflicting moves, and Bide
; e.g., Meditate, Bide, Hypnosis
	db $01
	db ATTACK_UP1_EFFECT
	db DEFENSE_UP1_EFFECT
	db SPEED_UP1_EFFECT
	db SPECIAL_UP1_EFFECT
	db ACCURACY_UP1_EFFECT
	db EVASION_UP1_EFFECT
	db ATTACK_DOWN1_EFFECT
	db DEFENSE_DOWN1_EFFECT
	db SPEED_DOWN1_EFFECT
	db SPECIAL_DOWN1_EFFECT
	db ACCURACY_DOWN1_EFFECT
	db EVASION_DOWN1_EFFECT
	db BIDE_EFFECT
	db SLEEP_EFFECT
	db ATTACK_UP2_EFFECT
	db DEFENSE_UP2_EFFECT
	db SPEED_UP2_EFFECT
	db SPECIAL_UP2_EFFECT
	db ACCURACY_UP2_EFFECT
	db EVASION_UP2_EFFECT
	db ATTACK_DOWN2_EFFECT
	db DEFENSE_DOWN2_EFFECT
	db SPEED_DOWN2_EFFECT
	db SPECIAL_DOWN2_EFFECT
	db ACCURACY_DOWN2_EFFECT
	db EVASION_DOWN2_EFFECT
	db -1
AlwaysHappenSideEffects: ; 3c030 (f:4030)
; Attacks that aren't finished after they faint the opponent.
	db DRAIN_HP_EFFECT
	db EXPLODE_EFFECT
	db DREAM_EATER_EFFECT
	db PAY_DAY_EFFECT
	db TWO_TO_FIVE_ATTACKS_EFFECT
	db $1E
	db ATTACK_TWICE_EFFECT
	db RECOIL_EFFECT
	db TWINEEDLE_EFFECT
	db RAGE_EFFECT
	db -1
SpecialEffects: ; 3c03b (f:403b)
; Effects from arrays 2, 4, and 5B, minus Twineedle and Rage.
; Includes all effects that do not need to be called at the end of
; ExecutePlayerMove (or ExecuteEnemyMove), because they have already been handled
	db DRAIN_HP_EFFECT
	db EXPLODE_EFFECT
	db DREAM_EATER_EFFECT
	db PAY_DAY_EFFECT
	db SWIFT_EFFECT
	db TWO_TO_FIVE_ATTACKS_EFFECT
	db $1E
	db CHARGE_EFFECT
	db SUPER_FANG_EFFECT
	db SPECIAL_DAMAGE_EFFECT
	db FLY_EFFECT
	db ATTACK_TWICE_EFFECT
	db JUMP_KICK_EFFECT
	db RECOIL_EFFECT
	; fallthrough to Next EffectsArray
SpecialEffectsCont: ; 3c049 (f:4049)
; damaging moves whose effect is executed prior to damage calculation
	db THRASH_PETAL_DANCE_EFFECT
	db TRAPPING_EFFECT
	db -1

StartBattle: ; 3c11e (f:411e)
	xor a
	ld [wPartyGainExpFlags], a
	ld [wPartyFoughtCurrentEnemyFlags], a
	ld [wActionResultOrTookBattleTurn], a
	inc a
	ld [wFirstMonsNotOutYet], a
	ld hl, wEnemyMon1HP
	ld bc, wEnemyMon2 - wEnemyMon1 - 1
	ld d, $3
.findFirstAliveEnemyMonLoop
	inc d
	ld a, [hli]
	or [hl]
	jr nz, .foundFirstAliveEnemyMon
	add hl, bc
	jr .findFirstAliveEnemyMonLoop
.foundFirstAliveEnemyMon
	ld a, d
	ld [wSerialExchangeNybbleReceiveData], a
	ld a, [wIsInBattle]
	dec a ; is it a trainer battle?
	call nz, EnemySendOutFirstMon ; if it is a trainer battle, send out enemy mon
	ld c, 40
	call DelayFrames
	call SaveScreenTilesToBuffer1
.checkAnyPartyAlive
	call AnyPartyAlive
	ld a, d
	and a
	jp z, HandlePlayerBlackOut ; jump if no mon is alive
	call LoadScreenTilesFromBuffer1
	ld a, [wBattleType]
	and a ; is it a normal battle?
	jp z, .playerSendOutFirstMon ; if so, send out player mon
; safari zone battle
.displaySafariZoneBattleMenu
	call DisplayBattleMenu
	ret c ; return if the player ran from battle
	ld a, [wActionResultOrTookBattleTurn]
	and a ; was the item used successfully?
	jr z, .displaySafariZoneBattleMenu ; if not, display the menu again; XXX does this ever jump?
	ld a, [wNumSafariBalls]
	and a
	jr nz, .notOutOfSafariBalls
	call LoadScreenTilesFromBuffer1
	ld hl, .outOfSafariBallsText
	jp PrintText
.notOutOfSafariBalls
	callab PrintSafariZoneBattleText
	ld a, [wEnemyMonSpeed + 1]
	add a
	ld b, a ; init b (which is later compared with random value) to (enemy speed % 256) * 2
	jp c, EnemyRan ; if (enemy speed % 256) > 127, the enemy runs
	ld a, [wSafariBaitFactor]
	and a ; is bait factor 0?
	jr z, .checkEscapeFactor
; bait factor is not 0
; divide b by 4 (making the mon less likely to run)
	srl b
	srl b
.checkEscapeFactor
	ld a, [wSafariEscapeFactor]
	and a ; is escape factor 0?
	jr z, .compareWithRandomValue
; escape factor is not 0
; multiply b by 2 (making the mon more likely to run)
	sla b
	jr nc, .compareWithRandomValue
; cap b at 255
	ld b, $ff
.compareWithRandomValue
	call Random
	cp b
	jr nc, .checkAnyPartyAlive
	jr EnemyRan ; if b was greater than the random value, the enemy runs

.outOfSafariBallsText
	far_text _OutOfSafariBallsText
	done

.playerSendOutFirstMon
	xor a
	ld [wWhichPokemon], a
.findFirstAliveMonLoop
	call HasMonFainted
	jr nz, .foundFirstAliveMon
; fainted, go to the next one
	ld hl, wWhichPokemon
	inc [hl]
	ld a,[wMaxPartyMons]
	cp [hl]		;have we reached the last pokemon
	jr nz,.findFirstAliveMonLoop	;loop if not
	;should I set the wWhichPokemon index to 0 here?  how often does it get used?  will there be bugs if it it is larger than the party?
	ld hl,wPresetTraits
	set PresetLastStand,[hl]		;otherwise, make sure the next pokemon loaded is a HUMAN last stand mode
	ld a,HUMAN
	jr .saveSpecies
.foundFirstAliveMon
	ld a, [wWhichPokemon]
	ld [wPlayerMonNumber], a
	inc a
	ld hl, wPartySpecies - 1
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [hl] ; species
.saveSpecies
	ld [wcf91], a
	ld [wBattleMonSpecies2], a
	call LoadScreenTilesFromBuffer1
	ld a,[wBattleMonSpecies2]
	cp HUMAN	;are we sending out human?
	jr z,.skipSlidingSprite	;then dont slide away trainer sprite
	coord hl, 1, 5
	ld a, $9
	call SlideTrainerPicOffScreen
.skipSlidingSprite
	call SaveScreenTilesToBuffer1
	ld a, [wWhichPokemon]
	ld c, a
	ld b, FLAG_SET
	push bc
	ld hl, wPartyGainExpFlags
	predef FlagActionPredef
	ld hl, wPartyFoughtCurrentEnemyFlags
	pop bc
	predef FlagActionPredef
	callab LoadPlayerMonData
	call LoadScreenTilesFromBuffer1
	call SendOutMon
	jr MainInBattleLoop

; wild mon or link battle enemy ran from battle
EnemyRan: ; 3c202 (f:4202)
	call LoadScreenTilesFromBuffer1
	ld a, [wLinkState]
	cp LINK_STATE_BATTLING
	ld hl, WildRanText
	jr nz, .printText
; link battle
	xor a
	ld [wBattleResult], a
	ld hl, EnemyRanText
.printText
	call PrintText
	ld a, SFX_RUN
	call PlaySoundWaitForCurrent
	xor a
	ld [H_WHOSETURN], a
	jpab AnimationSlideEnemyMonOff

WildRanText: ; 3c229 (f:4229)
	far_text _WildRanText
	done

EnemyRanText: ; 3c22e (f:422e)
	far_text _EnemyRanText
	done

MainInBattleLoop: ; 3c233 (f:4233)
	call ReadPlayerMonCurHPAndStatus
	ld hl, wBattleMonHP
	ld a, [hli]
	or [hl] ; is battle mon HP 0?
	jp z, HandlePlayerMonFainted  ; if battle mon HP is 0, jump
	ld hl, wEnemyMonHP
	ld a, [hli]
	or [hl] ; is enemy mon HP 0?
	jp z, HandleEnemyMonFainted ; if enemy mon HP is 0, jump
	call SaveScreenTilesToBuffer1
	xor a
	ld [wFirstMonsNotOutYet], a
	ld a, [wPlayerBattleStatus2]
	and (1 << NeedsToRecharge) | (1 << UsingRage) ; check if the player is using Rage or needs to recharge
	jr nz, .selectEnemyMove
; the player is not using Rage and doesn't need to recharge
	ld hl, wEnemyBattleStatus1
	res Flinched, [hl] ; reset flinch bit
	ld hl, wPlayerBattleStatus1
	res Flinched, [hl] ; reset flinch bit
	ld a, [hl]
	and (1 << ThrashingAbout) | (1 << ChargingUp) ; check if the player is thrashing about or charging for an attack
	jr nz, .selectEnemyMove ; if so, jump
; the player is neither thrashing about nor charging for an attack
	call DisplayBattleMenu ; show battle menu
	ret c ; return if player ran from battle
	ld a, [wEscapedFromBattle]
	and a
	ret nz ; return if pokedoll was used to escape from battle
	ld a, [wBattleMonStatus]
	and (1 << FRZ) | SLP ; is mon frozen or asleep?
	jr nz, .selectEnemyMove ; if so, jump
	ld a, [wPlayerBattleStatus1]
	and (1 << StoringEnergy) | (1 << UsingTrappingMove) ; check player is using Bide or using a multi-turn attack like wrap
	jr nz, .selectEnemyMove ; if so, jump
	ld a, [wEnemyBattleStatus1]
	bit UsingTrappingMove, a ; check if enemy is using a multi-turn attack like wrap
	jr z, .selectPlayerMove ; if not, jump
; enemy is using a mult-turn attack like wrap, so player is trapped and cannot execute a move
	ld a, $ff
	ld [wPlayerSelectedMove], a
	jr .selectEnemyMove
.selectPlayerMove
	ld a, [wActionResultOrTookBattleTurn]
	and a ; has the player already used the turn (e.g. by using an item, trying to run or switching pokemon)
	jr nz, .selectEnemyMove
	ld [wMoveMenuType], a
	inc a
	ld [wAnimationID], a
	xor a
	ld [wMenuItemToSwap], a
	call MoveSelectionMenu
	push af
	call LoadScreenTilesFromBuffer1
	call DrawHUDsAndHPBars
	pop af
	jr nz, MainInBattleLoop ; if the player didn't select a move, jump
.selectEnemyMove
	call SelectEnemyMove
	ld a, [wLinkState]
	cp LINK_STATE_BATTLING
	jr nz, .noLinkBattle
; link battle
	ld a, [wSerialExchangeNybbleReceiveData]
	cp $f
	jp z, EnemyRan
	cp $e
	jr z, .noLinkBattle
	cp $d
	jr z, .noLinkBattle
	sub $4
	jr c, .noLinkBattle
; the link battle enemy has switched mons
	ld a, [wPlayerBattleStatus1]
	bit UsingTrappingMove, a ; check if using multi-turn move like Wrap
	jr z, .asm_3c2dd
	ld a, [wPlayerMoveListIndex]
	ld hl, wBattleMonMoves
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [hl]
	cp METRONOME ; a MIRROR MOVE check is missing, might lead to a desync in link battles
	             ; when combined with multi-turn moves
	jr nz, .asm_3c2dd
	ld [wPlayerSelectedMove], a
.asm_3c2dd
	callab SwitchEnemyMon
.noLinkBattle
	ld a, [wPlayerSelectedMove]
	cp QUICK_ATTACK
	jr nz, .playerDidNotUseQuickAttack
	ld a, [wEnemySelectedMove]
	cp QUICK_ATTACK
	jr z, .compareSpeed  ; if both used Quick Attack
	jp .playerMovesFirst ; if player used Quick Attack and enemy didn't
.playerDidNotUseQuickAttack
	ld a, [wEnemySelectedMove]
	cp QUICK_ATTACK
	jr z, .enemyMovesFirst ; if enemy used Quick Attack and player didn't
	ld a, [wPlayerSelectedMove]
	cp COUNTER
	jr nz, .playerDidNotUseCounter
	ld a, [wEnemySelectedMove]
	cp COUNTER
	jr z, .compareSpeed ; if both used Counter
	jr .enemyMovesFirst ; if player used Counter and enemy didn't
.playerDidNotUseCounter
	ld a, [wEnemySelectedMove]
	cp COUNTER
	jr z, .playerMovesFirst ; if enemy used Counter and player didn't
.compareSpeed
	ld de, wBattleMonSpeed ; player speed value
	ld hl, wEnemyMonSpeed ; enemy speed value
	ld c, $2
	call StringCmp ; compare speed values
	jr z, .speedEqual
	jr nc, .playerMovesFirst ; if player is faster
	jr .enemyMovesFirst ; if enemy is faster
.speedEqual ; 50/50 chance for both players
	ld a, [$ffaa]
	cp $2
	jr z, .invertOutcome
	call BattleRandom
	cp $80
	jr c, .playerMovesFirst
	jr .enemyMovesFirst
.invertOutcome
	call BattleRandom
	cp $80
	jr c, .enemyMovesFirst
	jr .playerMovesFirst
.enemyMovesFirst
	ld a, $1
	ld [H_WHOSETURN], a
	ld [wWhoAttackedFirst],a
	callab TrainerAI
	jr c, .AIActionUsedEnemyFirst
	call ExecuteEnemyMove
	ld a, [wEscapedFromBattle]
	and a ; was Teleport, Road, or Whirlwind used to escape from battle?
	ret nz ; if so, return
	ld a, b
	and a
	jp z, HandlePlayerMonFainted
.AIActionUsedEnemyFirst
	call HandlePoisonBurnLeechSeed
	jp z, HandleEnemyMonFainted
	call DrawHUDsAndHPBars
	call ExecutePlayerMove
	ld a, [wEscapedFromBattle]
	and a ; was Teleport, Road, or Whirlwind used to escape from battle?
	ret nz ; if so, return
	ld a, b
	and a
	jp z, HandleEnemyMonFainted
	call HandlePoisonBurnLeechSeed
	jp z, HandlePlayerMonFainted
	call DrawHUDsAndHPBars
	call CheckNumAttacksLeft
	jp MainInBattleLoop
.playerMovesFirst
	xor a
	ld [wWhoAttackedFirst],a
	call ExecutePlayerMove
	ld a, [wEscapedFromBattle]
	and a ; was Teleport, Road, or Whirlwind used to escape from battle?
	ret nz ; if so, return
	ld a, b
	and a
	jp z, HandleEnemyMonFainted
	call HandlePoisonBurnLeechSeed
	jp z, HandlePlayerMonFainted
	call DrawHUDsAndHPBars
	ld a, $1
	ld [H_WHOSETURN], a
	callab TrainerAI
	jr c, .AIActionUsedPlayerFirst
	call ExecuteEnemyMove
	ld a, [wEscapedFromBattle]
	and a ; was Teleport, Road, or Whirlwind used to escape from battle?
	ret nz ; if so, return
	ld a, b
	and a
	jp z, HandlePlayerMonFainted
.AIActionUsedPlayerFirst
	call HandlePoisonBurnLeechSeed
	jp z, HandleEnemyMonFainted
	call DrawHUDsAndHPBars
	call CheckNumAttacksLeft
	jp MainInBattleLoop

HandlePoisonBurnLeechSeed: ; 3c3bd (f:43bd)
	ld de,wPlayerBattleStatus3
	push de		;store the battle status 3 (for toxic bit)
	ld hl, wBattleMonHP
	ld de, wBattleMonStatus
	ld bc, wPlayerMonStatMods
	ld a, [H_WHOSETURN]
	and a
	jr z, .playersTurn
	pop de
	ld de,wEnemyBattleStatus3	;replace the battle status 3
	push de
	ld hl, wEnemyMonHP
	ld de, wEnemyMonStatus
	ld bc, wEnemyMonStatMods
.playersTurn
	ld a, [de]
	pop de	;recover the battle status 3 byte
	bit 7,a		;radioactive?
	jr nz,.radioactive
	and (1 << BRN) | (1 << PSN)
	jr z, .notBurnedOrPoisoned
	push hl
	ld hl, HurtByPoisonText
	and 1 << BRN
	jr z, .toxicCheck	;check if toxic (since its poison)
	ld hl, HurtByBurnText
	ld a,[de]
	bit 0,a	;wound?
	jr z,.printText	;print text if not
	ld hl,HurtByWoundText
	jr .printText
.toxicCheck
	ld a,[de]
	bit 0,a	;toxic?
	jr z,.printText	;print text if not
	ld hl,BadlyHurtByPoisonText
.printText
	call PrintText
	xor a
	ld [wAnimationType], a
	ld a,BURN_PSN_ANIM
	call PlayNonMoveAnimation   ; play burn/poison animation
	pop hl
	call HandlePoisonBurnLeechSeed_DecreaseOwnHP
.notBurnedOrPoisoned
	ld de, wPlayerBattleStatus2
	ld a, [H_WHOSETURN]
	and a
	jr z, .playersTurn2
	ld de, wEnemyBattleStatus2
.playersTurn2
	ld a, [de]
	add a
	jr nc, .notLeechSeeded
	push hl
	ld a, [H_WHOSETURN]
	push af
	xor $1
	ld [H_WHOSETURN], a
	xor a
	ld [wAnimationType], a
	ld a,ABSORB
	call PlayMoveAnimation ; play leech seed animation (from opposing mon)
	pop af
	ld [H_WHOSETURN], a
	pop hl
	call HandlePoisonBurnLeechSeed_DecreaseOwnHP
	call HandlePoisonBurnLeechSeed_IncreaseEnemyHP
	push hl
	ld hl, HurtByLeechSeedText
	call PrintText
	pop hl
.notLeechSeeded
	ld a, [hli]
	or [hl]
	ret nz          ; test if fainted
	call DrawHUDsAndHPBars
	ld c, 20
	call DelayFrames
	xor a
	ret
.radioactive
	call BattleRandom
	cp a,$7F		;50% chance of effect
	jr c,.notBurnedOrPoisoned	;if its greater, then check leech seed
	push bc
	push de
	push hl
	ld hl,HurtByRadioText
	call PrintText
	xor a
	ld [wAnimationType], a
	ld a,BURN_PSN_ANIM
	call PlayNonMoveAnimation   ; play burn/poison animation
	pop hl
	pop de
	pop bc
	call HandleRadio_DecreaseOwnStats
	jr .notBurnedOrPoisoned	;check leech seed

HurtByPoisonText: ; 3c42e (f:442e)
	far_text _HurtByPoisonText
	done
	
BadlyHurtByPoisonText: ; 3c42e (f:442e)
	far_text _BadlyHurtByPoisonText
	done
HurtByWoundText: ; 3c42e (f:442e)
	far_text _HurtByWoundText
	done
HurtByRadioText:
	far_text _HurtByRadioText
	done

HurtByBurnText: ; 3c433 (f:4433)
	far_text _HurtByBurnText
	done

HurtByLeechSeedText: ; 3c438 (f:4438)
	far_text _HurtByLeechSeedText
	done
	
;to randomly decrease a pokemons stats (due to radio)
; bc points to the first stat mod
HandleRadio_DecreaseOwnStats:
	push de
	push hl
	push bc
	call BattleRandom
	ld h,0
	ld l,7
.loop
	sub a,36	;subtract a by 36
	jr c,.applyEffect	;if we've gone below 0, then apply the affect
	dec l
	jr z,.damageHP	;if we've done this seven times, then just damage the HP
	jr .loop	;otherwise, loop
.applyEffect
	dec l	;set l to index starting from 0
	pop bc	;get the pointer to the stats
	push bc
	push hl
	add hl,bc		;hl now points to the respective stat
	push hl
	pop bc			;bc now points to respective stat
	ld a,[bc]
	dec a		;was it already the lowest possible?
	pop hl
	jr z,.damageHP	;damage the hp if so
	ld [bc],a	;store new stat into the ram
	push hl ;save the stat index
	
	call CalcModStatsSavewD11E
	
	pop hl	;load the stat index
	call PrintRadioStatText
	jr .finish
.damageHP
	ld hl,wBattleMonHP
	ld a,[H_WHOSETURN]
	and a
	jr z,.damageHPskip	;if its the players turn, then don't load the enemy hp
	ld hl,wEnemyMonHP
.damageHPskip
	call HandlePoisonBurnLeechSeed_DecreaseOwnHP
.finish
	pop bc
	pop hl
	pop de
	ret
	
;to print the textbox for which stat was affected by Radio
PrintRadioStatText:
	ld a,l
	ld hl,RadioStatTextTable	;pointer to table
	add a
	ld c,a
	ld b,0
	add hl,bc
	ld a,[hli]
	ld h,[hl]
	ld l,a		;hl contains text pointer
	call PrintText
	ret

RadioStatTextTable:
	dw RadioAttackText
	dw RadioDefenseText
	dw RadioSpeedText
	dw RadioSpAttackText
	dw RadioAccuracyText
	dw RadioEvasionText
	dw RadioSpDefenseText
	

RadioAttackText:
	far_text _RadioAttackText
	done

RadioDefenseText:
	far_text _RadioDefenseText
	done

RadioSpeedText:
	far_text _RadioSpeedText
	done

RadioSpAttackText:
	far_text _RadioSpAttackText
	done

RadioAccuracyText:
	far_text _RadioAccuracyText
	done

RadioEvasionText:
	far_text _RadioEvasionText
	done

RadioSpDefenseText:
	far_text _RadioSpDefenseText
	done


; decreases the mon's current HP by 1/16 of the Max HP (multiplied by number of toxic ticks if active)
; note that the toxic ticks are considered even if the damage is not poison (hence the Leech Seed glitch)
; hl: HP pointer
; bc (out): total damage
HandlePoisonBurnLeechSeed_DecreaseOwnHP: ; 3c43d (f:443d)
	push hl
	push hl
	ld bc, $e      ; skip to max HP
	add hl, bc
	ld a, [hli]    ; load max HP
	ld [wHPBarMaxHP+1], a
	ld b, a
	ld a, [hl]
	ld [wHPBarMaxHP], a
	ld c, a
	srl b
	rr c
	srl b
	rr c
	srl c
	srl c         ; c = max HP/16 (assumption: HP < 1024)
	ld a, c
	and a
	jr nz, .nonZeroDamage
	inc c         ; damage is at least 1
.nonZeroDamage
	ld hl, wPlayerBattleStatus3
	ld de, wPlayerToxicCounter
	ld a, [H_WHOSETURN]
	and a
	jr z, .playersTurn
	ld hl, wEnemyBattleStatus3
	ld de, wEnemyToxicCounter
.playersTurn
	bit BadlyPoisoned, [hl]
	jr z, .noToxic
	ld a, [de]    ; increment toxic counter
	inc a
	ld [de], a
	ld hl, $0000
.toxicTicksLoop
	add hl, bc
	dec a
	jr nz, .toxicTicksLoop
	ld b, h       ; bc = damage * toxic counter
	ld c, l
.noToxic
	pop hl
	inc hl
	ld a, [hl]    ; subtract total damage from current HP
	ld [wHPBarOldHP], a
	sub c
	ld [hld], a
	ld [wHPBarNewHP], a
	ld a, [hl]
	ld [wHPBarOldHP+1], a
	sbc b
	ld [hl], a
	ld [wHPBarNewHP+1], a
	jr nc, .noOverkill
	xor a         ; overkill: zero HP
	ld [hli], a
	ld [hl], a
	ld [wHPBarNewHP], a
	ld [wHPBarNewHP+1], a
.noOverkill
	call UpdateCurMonHPBar
	pop hl
	ret

; adds bc to enemy HP
; bc isn't updated if HP substracted was capped to prevent overkill
HandlePoisonBurnLeechSeed_IncreaseEnemyHP: ; 3c4a3 (f:44a3)
	push hl
	ld hl, wEnemyMonMaxHP
	ld a, [H_WHOSETURN]
	and a
	jr z, .playersTurn
	ld hl, wBattleMonMaxHP
.playersTurn
	ld a, [hli]
	ld [wHPBarMaxHP+1], a
	ld a, [hl]
	ld [wHPBarMaxHP], a
	ld de, wBattleMonHP - wBattleMonMaxHP
	add hl, de           ; skip back from max hp to current hp
	ld a, [hl]
	ld [wHPBarOldHP], a ; add bc to current HP
	add c
	ld [hld], a
	ld [wHPBarNewHP], a
	ld a, [hl]
	ld [wHPBarOldHP+1], a
	adc b
	ld [hli], a
	ld [wHPBarNewHP+1], a
	ld a, [wHPBarMaxHP]
	ld c, a
	ld a, [hld]
	sub c
	ld a, [wHPBarMaxHP+1]
	ld b, a
	ld a, [hl]
	sbc b
	jr c, .noOverfullHeal
	ld a, b                ; overfull heal, set HP to max HP
	ld [hli], a
	ld [wHPBarNewHP+1], a
	ld a, c
	ld [hl], a
	ld [wHPBarNewHP], a
.noOverfullHeal
	ld a, [H_WHOSETURN]
	xor $1
	ld [H_WHOSETURN], a
	call UpdateCurMonHPBar
	ld a, [H_WHOSETURN]
	xor $1
	ld [H_WHOSETURN], a
	pop hl
	ret

UpdateCurMonHPBar: ; 3c4f6 (f:44f6)
	coord hl, 10, 9    ; tile pointer to player HP bar
	ld a, [H_WHOSETURN]
	and a
	ld a, $1
	jr z, .playersTurn
	coord hl, 2, 2    ; tile pointer to enemy HP bar
	xor a
.playersTurn
	push bc
	ld [wHPBarType], a
	predef UpdateHPBar2
	pop bc
	ret

CheckNumAttacksLeft: ; 3c50f (f:450f)
	ld a, [wPlayerNumAttacksLeft]
	and a
	jr nz, .checkEnemy
; player has 0 attacks left
	ld hl, wPlayerBattleStatus1
	res UsingTrappingMove, [hl] ; player not using multi-turn attack like wrap any more
.checkEnemy
	ld a, [wEnemyNumAttacksLeft]
	and a
	ret nz
; enemy has 0 attacks left
	ld hl, wEnemyBattleStatus1
	res UsingTrappingMove, [hl] ; enemy not using multi-turn attack like wrap any more
	ret

HandleEnemyMonFainted: ; 3c525 (f:4525)
	xor a
	ld [wInHandlePlayerMonFainted], a
	call FaintEnemyPokemon
	call AnyPartyAlive
	ld a, d
	and a
	jp z, HandlePlayerBlackOut ; if no party mons are alive, the player blacks out
	ld hl, wBattleMonHP
	ld a, [hli]
	or [hl] ; is battle mon HP zero?
	call nz, DrawPlayerHUDAndHPBar ; if battle mon HP is not zero, draw player HD and HP bar
	ld a, [wIsInBattle]
	dec a
	ret z ; return if it's a wild battle
	call AnyEnemyPokemonAliveCheck
	jp z, TrainerBattleVictory
	ld hl, wBattleMonHP
	ld a, [hli]
	or [hl] ; does battle mon have 0 HP?
	jr nz, .skipReplacingBattleMon ; if not, skip replacing battle mon
	ld a,[wPresetTraits]
	bit PresetLastStand,a	;is the last stand bit set?
	jr z,.notForceLastStand		;if not, then dont go into last stand
	callab LoadPlayerMonData
	call SendOutMon
	jr .skipReplacingBattleMon
.notForceLastStand
	ld a,[wBattleMonSpecies2]
	cp HUMAN		;is the player already in last stand mode?
	jr nz,.skipReplacingBattleMon	;then dont allow player to choose next mon
	call DoUseNextMonDialogue ; this call is useless in a trainer battle. it shouldn't be here
	ret c
	call ChooseNextMon
.skipReplacingBattleMon
	ld a, $1
	ld [wActionResultOrTookBattleTurn], a
	call ReplaceFaintedEnemyMon
	jp z, EnemyRan
	xor a
	ld [wActionResultOrTookBattleTurn], a
	jp MainInBattleLoop

FaintEnemyPokemon: ; 0x3c567
	call ReadPlayerMonCurHPAndStatus
	call GetHordeIsInBattle
	dec a
	jr z, .wild
	ld a, [wEnemyMonPartyPos]
	ld hl, wEnemyMon1HP
	ld bc, wEnemyMon2 - wEnemyMon1
	call AddNTimes
	xor a
	ld [hli], a
	ld [hl], a
	callab StoreExtraEnemyMonBytesFromBattle
.wild
	ld hl, wPlayerBattleStatus1
	res AttackingMultipleTimes, [hl]
; Bug. This only zeroes the high byte of the player's accumulated damage,
; setting the accumulated damage to itself mod 256 instead of 0 as was probably
; intended. That alone is problematic, but this mistake has another more severe
; effect. This function's counterpart for when the player mon faints,
; RemoveFaintedPlayerMon, zeroes both the high byte and the low byte. In a link
; battle, the other player's Game Boy will call that function in response to
; the enemy mon (the player mon from the other side's perspective) fainting,
; and the states of the two Game Boys will go out of sync unless the damage
; was congruent to 0 modulo 256.
	xor a
	ld [wPlayerBideAccumulatedDamage], a
	ld hl, wEnemyStatsToDouble ; clear enemy statuses
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ld [wEnemyDisabledMove], a
	ld [wEnemyDisabledMoveNumber], a
	ld [wEnemyMonMinimized], a
	ld hl, wPlayerUsedMove
	ld [hli], a
	ld [hl], a
	ld a,[wEnemyMonSpecies2]
	cp HUMAN
	jr nz,.slideDown	;slide mon down if not human
	coord hl, 18, 0
	ld a,8
	call SlideTrainerPicOffScreen	;if human, then just scroll offscreen
	jr .skipDown
.slideDown
	coord hl, 12, 5
	coord de, 12, 6
	call SlideDownFaintedMonPic
.skipDown
	ld hl, wTileMap
	ld bc, $40b
	call ClearScreenArea
	ld a, [wIsInBattle]
	dec a
	jr z, .wild_win
	xor a
	ld [wFrequencyModifier], a
	ld [wTempoModifier], a
	ld a, SFX_FAINT_FALL
	call PlaySoundWaitForCurrent
.sfxwait
	ld a, [wChannelSoundIDs + CH4]
	cp SFX_FAINT_FALL
	jr z, .sfxwait
	ld a, SFX_FAINT_THUD
	call PlaySound
	call WaitForSoundToFinish
	jr .sfxplayed
.wild_win
	call EndLowHealthAlarm
	ld a, MUSIC_DEFEATED_WILD_MON
	call PlayBattleVictoryMusic
.sfxplayed
	ld hl, wBattleMonHP
	ld a, [hli]
	or [hl]
	jr nz, .playermonnotfaint
	ld a, [wInHandlePlayerMonFainted]
	and a ; was this called by HandlePlayerMonFainted?
	jr nz, .playermonnotfaint ; if so, don't call RemoveFaintedPlayerMon twice
	call RemoveFaintedPlayerMon
.playermonnotfaint
	call AnyPartyAlive
	ld a, d
	and a
	ret z
	ld hl, EnemyMonFaintedText
	ld a,[wEnemyMonSpecies2]
	cp HUMAN
	jr nz,.notHuman
	ld hl,TrainerRetreatedText
.notHuman
	call PrintText
	call PrintEmptyString
	call SaveScreenTilesToBuffer1
	xor a
	ld [wBattleResult], a
	ld b, EXP__ALL
	call IsItemInBag
	push af
	jr z, .giveExpToMonsThatFought ; if no exp all, then jump

; the player has exp all
; first, we halve the values that determine exp gain
; the enemy mon base stats are added to stat exp, so they are halved
; the base exp (which determines normal exp) is also halved
	ld hl, wEnemyMonBaseStats
	ld b, $7
.halveExpDataLoop
	srl [hl]
	inc hl
	dec b
	jr nz, .halveExpDataLoop

; give exp (divided evenly) to the mons that actually fought in battle against the enemy mon that has fainted
; if exp all is in the bag, this will be only be half of the stat exp and normal exp, due to the above loop
.giveExpToMonsThatFought
	xor a
	ld [wBoostExpByExpAll], a
	callab GainExperience
	pop af
	ret z ; return if no exp all

; the player has exp all
; now, set the gain exp flag for every party member
; half of the total stat exp and normal exp will divided evenly amongst every party member
	ld a, $1
	ld [wBoostExpByExpAll], a
	ld a, [wPartyCount]
	ld b, 0
.gainExpFlagsLoop
	scf
	rl b
	dec a
	jr nz, .gainExpFlagsLoop
	ld a, b
	ld [wPartyGainExpFlags], a
	jpab GainExperience

EnemyMonFaintedText: ; 0x3c63e
	far_text _EnemyMonFaintedText
	done

EndLowHealthAlarm: ; 3c643 (f:4643)
; This function is called when the player has the won the battle. It turns off
; the low health alarm and prevents it from reactivating until the next battle.
	xor a
	ld [wLowHealthAlarm], a ; turn off low health alarm
	ld [wChannelSoundIDs + CH4], a
	inc a
	ld [wLowHealthAlarmDisabled], a ; prevent it from reactivating
	ret

AnyEnemyPokemonAliveCheck: ; 3c64f (f:464f)
	ld a, [wEnemyPartyCount]
	ld b, a
	xor a
	ld hl, wEnemyMon1HP
	ld de, wEnemyMon2 - wEnemyMon1
.nextPokemon
	or [hl]
	inc hl
	or [hl]
	dec hl
	add hl, de
	dec b
	jr nz, .nextPokemon
	and a
	ret nz		;return if there are pokemon left
	ld a,[wEnemyMonSpecies2]
	cp HUMAN		;is the current pokemon 'human'?
	ld a,0		;load 0 into a anyway
	jr z,.returnNoPokemon	;then return no pokemon if so (already was in last stand mode)
	ld hl,wPreBattleBits
	bit EnemyCanUseLastStand,[hl]		;can the enemy use last stand?
	ret
.returnNoPokemon
	and a	;set zero flag
	ret

; stores whether enemy ran in Z flag
ReplaceFaintedEnemyMon: ; 3c664 (f:4664)
	ld hl, wEnemyHPBarColor
	ld e, $30
	call GetBattleHealthBarColor
	callab DrawEnemyPokeballs
	ld a, [wLinkState]
	cp LINK_STATE_BATTLING
	jr nz, .notLinkBattle
; link battle
	call LinkBattleExchangeData
	ld a, [wSerialExchangeNybbleReceiveData]
	cp $f
	ret z
	call LoadScreenTilesFromBuffer1
.notLinkBattle
	call EnemySendOut
	xor a
	ld [wEnemyMoveNum], a
	ld [wActionResultOrTookBattleTurn], a
	ld [wAILayer2Encouragement], a
	inc a ; reset Z flag
	ret

TrainerBattleVictory: ; 3c696 (f:4696)
	call EndLowHealthAlarm
	ld b, MUSIC_DEFEATED_GYM_LEADER
	ld a, [wGymLeaderNo]
	and a
	jr nz, .gymleader
	ld b, MUSIC_DEFEATED_TRAINER
.gymleader
	ld a, [wTrainerClass]
	cp SONY3 ; final battle against rival
	jr nz, .notrival
	ld b, MUSIC_DEFEATED_GYM_LEADER
	ld hl, wFlags_D733
	set 1, [hl]
.notrival
	ld a, [wLinkState]
	cp LINK_STATE_BATTLING
	ld a, b
	call nz, PlayBattleVictoryMusic
	ld hl, TrainerDefeatedText
	call PrintText
	ld a, [wLinkState]
	cp LINK_STATE_BATTLING
	ret z
	call ScrollTrainerPicAfterBattle
	ld c, 40
	call DelayFrames
	call PrintEndBattleText
; win money
	ld hl, MoneyForWinningText
	call PrintText
	ld de, wPlayerMoney + 2
	ld hl, wAmountMoneyWon + 2
	ld c, $3
	predef_jump AddBCDPredef

MoneyForWinningText: ; 3c6e4 (f:46e4)
	far_text _MoneyForWinningText
	done

TrainerDefeatedText: ; 3c6e9 (f:46e9)
	far_text _TrainerDefeatedText
	done
TrainerRetreatedText: ; 3c6e9 (f:46e9)
	far_text _TrainerRetreatedText
	done

PlayBattleVictoryMusic: ; 3c6ee (f:46ee)
	push af
	ld a, $ff
	ld [wNewSoundID], a
	call PlaySoundWaitForCurrent
	ld c, BANK(Music_DefeatedTrainer)
	pop af
	call PlayMusic
	jp Delay3

HandlePlayerMonFainted: ; 3c700 (f:4700)
	ld a, 1
	ld [wInHandlePlayerMonFainted], a
	call RemoveFaintedPlayerMon
	call AnyPartyAlive     ; test if any more mons are alive
	ld a, d
	and a
	jp z, HandlePlayerBlackOut
	ld hl, wEnemyMonHP
	ld a, [hli]
	or [hl] ; is enemy mon's HP 0?
	jr nz, .doUseNextMonDialogue ; if not, jump
; the enemy mon has 0 HP
	call FaintEnemyPokemon
	ld a, [wIsInBattle]
	dec a
	ret z            ; if wild encounter, battle is over
	call AnyEnemyPokemonAliveCheck
	jp z, TrainerBattleVictory
.doUseNextMonDialogue
	ld a,[wPresetTraits]
	bit PresetLastStand,a	;is the last stand bit set?
	jr z,.notForcedLastStand		;if not, then skip down
	callab LoadPlayerMonData
	call SendOutMon		;send out the next mon (last stand)
	jr .skipChoosingNextMon
.notForcedLastStand
	ld a,[wBattleMonSpecies2]
	cp HUMAN		;is the player already in last stand mode?
	jr z,.skipChoosingNextMon	;if so, then dont show the next mon dialogue
.showNextMonDialogue
	call DoUseNextMonDialogue
	ret c ; return if the player ran from battle
	call ChooseNextMon
.skipChoosingNextMon
	ld hl, wEnemyMonHP
	ld a, [hli]
	or [hl]
	jp nz, MainInBattleLoop ; if the enemy mon has more than 0 HP, go back to battle loop
; the enemy mon has 0 HP
	ld a, $1
	ld [wActionResultOrTookBattleTurn], a
	call ReplaceFaintedEnemyMon
	jp z, EnemyRan ; if enemy ran from battle rather than sending out another mon, jump
	xor a
	ld [wActionResultOrTookBattleTurn], a
	jp MainInBattleLoop

; resets flags, slides mon's pic down, plays cry, and prints fainted message
RemoveFaintedPlayerMon: ; 3c741 (f:4741)
	ld a, [wPlayerMonNumber]
	ld c, a
	ld hl, wPartyGainExpFlags
	ld b, FLAG_RESET
	predef FlagActionPredef ; clear gain exp flag for fainted mon
	ld hl, wEnemyBattleStatus1
	res 2, [hl]   ; reset "attacking multiple times" flag
	ld a, [wLowHealthAlarm]
	bit 7, a      ; skip sound flag (red bar (?))
	jr z, .skipWaitForSound
	ld a, $ff
	ld [wLowHealthAlarm], a ;disable low health alarm
	call WaitForSoundToFinish
.skipWaitForSound
; a is 0, so this zeroes the enemy's accumulated damage.
	ld hl, wEnemyBideAccumulatedDamage
	ld [hli], a
	ld [hl], a
	ld [wBattleMonStatus], a
	call ReadPlayerMonCurHPAndStatus
	coord hl, 9, 7
	lb bc, 5, 11
	call ClearScreenArea
	coord hl, 1, 10
	coord de, 1, 11
	call SlideDownFaintedMonPic
	ld a, $1
	ld [wBattleResult], a

; When the player mon and enemy mon faint at the same time and the fact that the
; enemy mon has fainted is detected first (e.g. when the player mon knocks out
; the enemy mon using a move with recoil and faints due to the recoil), don't
; play the player mon's cry or show the "[player mon] fainted!" message.
	ld a, [wInHandlePlayerMonFainted]
	and a ; was this called by HandleEnemyMonFainted?
	ret z ; if so, return

	ld a, [wBattleMonSpecies]
	call PlayCry
	ld hl, PlayerMonFaintedText
	jp PrintText

PlayerMonFaintedText: ; 3c796 (f:4796)
	far_text _PlayerMonFaintedText
	done

; asks if you want to use next mon
; stores whether you ran in C flag
DoUseNextMonDialogue: ; 3c79b (f:479b)
	call PrintEmptyString
	call SaveScreenTilesToBuffer1
	ld a, [wIsInBattle]
	and a
	dec a
	ret nz ; return if it's a trainer battle
	ld hl, UseNextMonText
	call PrintText
.displayYesNoBox
	coord hl, 13, 9
	lb bc, 10, 14
	ld a, TWO_OPTION_MENU
	ld [wTextBoxID], a
	call DisplayTextBoxID
	ld a, [wMenuExitMethod]
	cp CHOSE_SECOND_ITEM ; did the player choose NO?
	jr z, .tryRunning ; if the player chose NO, try running
	and a ; reset carry
	ret
.tryRunning
	ld a, [wCurrentMenuItem]
	and a
	jr z, .displayYesNoBox ; xxx when does this happen?
	callab TryRunningFromBattle2
	ret

UseNextMonText: ; 3c7d3 (f:47d3)
	far_text _UseNextMonText
	done

; choose next player mon to send out
; stores whether enemy mon has no HP left in Z flag
ChooseNextMon: ; 3c7d8 (f:47d8)
	ld a, BATTLE_PARTY_MENU
	ld [wPartyMenuTypeOrMessageID], a
	call DisplayPartyMenu
.checkIfMonChosen
	jr nc, .monChosen
.goBackToPartyMenu
	call GoBackToPartyMenu
	jr .checkIfMonChosen
.monChosen
	call HasMonFainted
	jr z, .goBackToPartyMenu ; if mon fainted, you have to choose another
	ld a, [wLinkState]
	cp LINK_STATE_BATTLING
	jr nz, .notLinkBattle
	inc a
	ld [wActionResultOrTookBattleTurn], a
	call LinkBattleExchangeData
.notLinkBattle
	xor a
	ld [wActionResultOrTookBattleTurn], a
	call ClearSprites
	ld a, [wWhichPokemon]
	ld [wPlayerMonNumber], a
	ld c, a
	ld hl, wPartyGainExpFlags
	ld b, FLAG_SET
	push bc
	predef FlagActionPredef
	pop bc
	ld hl, wPartyFoughtCurrentEnemyFlags
	predef FlagActionPredef
	callab LoadPlayerMonData
	call GBPalWhiteOut
	call LoadHudTilePatterns
	call LoadScreenTilesFromBuffer1
	call RunDefaultPaletteCommand
	call GBPalNormal
	call SendOutMon
	ld hl, wEnemyMonHP
	ld a, [hli]
	or [hl]
	ret

; called when player is out of usable mons.
; prints approriate lose message, sets carry flag if player blacked out (special case for initial rival fight)
HandlePlayerBlackOut: ; 3c837 (f:4837)
	ld a, [wLinkState]
	cp LINK_STATE_BATTLING
	jr z, .notSony1Battle
	ld a, [wCurOpponent]
	cp OPP_SONY1
	jr nz, .notSony1Battle
	coord hl, 0, 0  ; sony 1 battle
	lb bc, 8, 21
	call ClearScreenArea
	call ScrollTrainerPicAfterBattle
	ld c, 40
	call DelayFrames
	ld hl, Sony1WinText
	call PrintText
	ld a, [wCurMap]
	cp OAKS_LAB
	ret z            ; starter battle in oak's lab: don't black out
.notSony1Battle
	ld b, SET_PAL_BATTLE_BLACK
	call RunPaletteCommand
	ld a,[wBattleMonSpecies2]
	cp HUMAN		;was the last pokemon to faint a human?
	jr z,.skipText	;then don't display the blacked out text
	ld hl, PlayerBlackedOutText2
	ld a, [wLinkState]
	cp LINK_STATE_BATTLING
	jr nz, .noLinkBattle
	ld hl, LinkBattleLostText
.noLinkBattle
	call PrintText
.skipText
	ld a, [wd732]
	res 5, a
	ld [wd732], a
	call ClearScreen
	scf
	ret

Sony1WinText: ; 3c884 (f:4884)
	far_text _Sony1WinText
	done

PlayerBlackedOutText2: ; 3c889 (f:4889)
	far_text _PlayerBlackedOutText2
	done

LinkBattleLostText: ; 3c88e (f:488e)
	far_text _LinkBattleLostText
	done

; slides pic of fainted mon downwards until it disappears
; bug: when this is called, [H_AUTOBGTRANSFERENABLED] is non-zero, so there is screen tearing
SlideDownFaintedMonPic: ; 3c893 (f:4893)
	ld a, [wd730]
	push af
	set 6, a
	ld [wd730], a
	ld b, 7 ; number of times to slide
.slideStepLoop ; each iteration, the mon is slid down one row
	push bc
	push de
	push hl
	ld b, 6 ; number of rows
.rowLoop
	push bc
	push hl
	push de
	ld bc, $7
	call CopyData
	pop de
	pop hl
	ld bc, -20
	add hl, bc
	push hl
	ld h, d
	ld l, e
	add hl, bc
	ld d, h
	ld e, l
	pop hl
	pop bc
	dec b
	jr nz, .rowLoop
	ld bc, 20
	add hl, bc
	ld de, SevenSpacesText
	call PlaceString
	ld c, 2
	call DelayFrames
	pop hl
	pop de
	pop bc
	dec b
	jr nz, .slideStepLoop
	pop af
	ld [wd730], a
	ret

SevenSpacesText: ; 3c8d7 (f:48d7)
	db "       @"

; slides the player or enemy trainer off screen
; a is the number of tiles to slide it horizontally (always 9 for the player trainer or 8 for the enemy trainer)
; if a is 8, the slide is to the right, else it is to the left
; bug: when this is called, [H_AUTOBGTRANSFERENABLED] is non-zero, so there is screen tearing
SlideTrainerPicOffScreen: ; 3c8df (f:48df)
	ld [hSlideAmount], a
	ld c, a
.slideStepLoop ; each iteration, the trainer pic is slid one tile left/right
	push bc
	push hl
	ld b, 7 ; number of rows
.rowLoop
	push hl
	ld a, [hSlideAmount]
	ld c, a
.columnLoop
	ld a, [hSlideAmount]
	cp 8
	jr z, .slideRight
.slideLeft ; slide player sprite off screen
	ld a, [hld]
	ld [hli], a
	inc hl
	jr .nextColumn
.slideRight ; slide enemy trainer sprite off screen
	ld a, [hli]
	ld [hld], a
	dec hl
.nextColumn
	dec c
	jr nz, .columnLoop
	pop hl
	ld de, 20
	add hl, de
	dec b
	jr nz, .rowLoop
	ld c, 2
	call DelayFrames
	pop hl
	pop bc
	dec c
	jr nz, .slideStepLoop
	ret

; send out a trainer's mon
EnemySendOut: ; 3c90e (f:490e)
	ld hl,wPartyGainExpFlags
	xor a
	ld [hl],a
	ld a,[wPlayerMonNumber]
	ld c,a
	ld b,FLAG_SET
	push bc
	predef FlagActionPredef
	ld hl,wPartyFoughtCurrentEnemyFlags
	xor a
	ld [hl],a
	pop bc
	predef FlagActionPredef

; don't change wPartyGainExpFlags or wPartyFoughtCurrentEnemyFlags
EnemySendOutFirstMon: ; 3c92a (f:492a)
	xor a
	ld hl,wEnemyStatsToDouble ; clear enemy statuses
	ld [hli],a
	ld [hli],a
	inc hl
	inc hl
	res Transformed,[hl]		;turn off the transformed bit
	ld [wEnemyMonMinimized],a
	ld hl,wPlayerUsedMove
	ld [hli],a
	ld [hl],a
	dec a
	ld [wAICount],a
	ld hl,wPlayerBattleStatus1
	res 5,[hl]
	coord hl, 18, 0
	ld a,8
	call SlideTrainerPicOffScreen
	call PrintEmptyString
	call SaveScreenTilesToBuffer1
	ld a,[wLinkState]
	cp LINK_STATE_BATTLING
	jr nz,.next
	ld a,[wSerialExchangeNybbleReceiveData]
	sub 4
	ld [wWhichPokemon],a
	jr .next3
.next
	ld b,$FF
.next2
	inc b
	ld a,[wEnemyPartyCount]	;load total number of enemy pokemon into a
	cp b		;compare to b
	jr z,.lastStand	;if we've gone through every pokemon, then trainer will be going into last stand mode
	ld a,[wEnemyMonPartyPos]
	cp b
	jr z,.next2
	ld hl,wEnemyMon1
	ld a,b
	ld [wWhichPokemon],a
	push bc
	ld bc,wEnemyMon2 - wEnemyMon1
	call AddNTimes
	pop bc
	inc hl
	ld a,[hli]
	ld c,a
	ld a,[hl]
	or c		;is pokemon fainted?
	jr z,.next2	;loop if so
	jr .next3	;otherwise, load the pokemon name and level from party
.lastStand
	xor a
	ld [wWhichPokemon],a		;just set which pokemon as the first pokemon (to avoid any possible issues in other scripts)
	ld a,[wEnemyMon1Level]		;use the first pokemon level as the level
	ld [wCurEnemyLVL],a
	ld a,HUMAN		;pokemon id
	jr .loadEnemyData	;and load the data
.next3
	ld a,[wWhichPokemon]
	ld hl,wEnemyMon1Level
	ld bc,wEnemyMon2 - wEnemyMon1
	call AddNTimes
	ld a,[hl]
	ld [wCurEnemyLVL],a
	ld a,[wWhichPokemon]
	inc a
	ld hl,wEnemyPartyCount
	ld c,a
	ld b,0
	add hl,bc
	ld a,[hl]
.loadEnemyData
	ld [wEnemyMonSpecies2],a
	ld [wcf91],a
	callab LoadEnemyMonData
	ld hl,wEnemyMonHP
	ld a,[hli]
	ld [wLastSwitchInEnemyMonHP],a
	ld a,[hl]
	ld [wLastSwitchInEnemyMonHP + 1],a
	ld a,1
	ld [wCurrentMenuItem],a
	ld a,[wFirstMonsNotOutYet]
	dec a
	jr z,.next4
	ld a,[wPartyCount]
	dec a
	jr z,.next4
	ld a,[wLinkState]
	cp LINK_STATE_BATTLING
	jr z,.next4
	ld a,[wOptions]
	bit 6,a
	jr nz,.next4
	ld a,[wEnemyMonSpecies2]
	cp HUMAN	;is the next pokemon a human?
	jr z,.next4	;then no 'about to use' text
	ld hl, TrainerAboutToUseText
	call PrintText
	coord hl, 0, 7
	lb bc, 8, 1
	ld a,TWO_OPTION_MENU
	ld [wTextBoxID],a
	call DisplayTextBoxID
	ld a,[wCurrentMenuItem]
	and a
	jr nz,.next4
	ld a,BATTLE_PARTY_MENU
	ld [wPartyMenuTypeOrMessageID],a
	call DisplayPartyMenu
.next9
	ld a,1
	ld [wCurrentMenuItem],a
	jr c,.next7
	ld hl,wPlayerMonNumber
	ld a,[wWhichPokemon]
	cp [hl]
	jr nz,.next6
	ld hl,AlreadyOutText
	call PrintText
.next8
	call GoBackToPartyMenu
	jr .next9
.next6
	call HasMonFainted
	jr z,.next8
	xor a
	ld [wCurrentMenuItem],a
.next7
	call GBPalWhiteOut
	call LoadHudTilePatterns
	call LoadScreenTilesFromBuffer1
.next4
	call ClearSprites
	coord hl, 0, 0
	lb bc, 4, 11
	call ClearScreenArea
	ld b, SET_PAL_BATTLE
	call RunPaletteCommand
	call GBPalNormal
	ld a,[wEnemyMonSpecies2]
	ld [wcf91],a
	ld [wd0b5],a
	cp HUMAN	;is the next pokemon a human?
	jr nz,.notHuman
	call _LoadTrainerPic	;otherwise, load enemy went into last stand mode text
	ld a,$CF
	ld [$FFE1],a
	call ScrollTrainerPicAfterBattle	;slide in the trainer pic
	ld hl,TrainerLastStandText
	call PrintText
	ld hl,TrainerLastStandText2
	call PrintText
	jr .dontLoadPokemonSprite
.notHuman
	ld hl,TrainerSentOutText
	call PrintText
	call GetMonHeader
	ld de,vFrontPic
	call LoadMonFrontSprite
	ld a,-$31
	ld [hStartTileID],a
	coord hl, 15, 6
	predef AnimateSendingOutMon
	ld a,[wEnemyMonSpecies2]
	call PlayCry
.dontLoadPokemonSprite
	call DrawEnemyHUDAndHPBar
	ld a,[wCurrentMenuItem]
	and a
	ret nz
	xor a
	ld [wPartyGainExpFlags],a
	ld [wPartyFoughtCurrentEnemyFlags],a
	call SaveScreenTilesToBuffer1
	jp SwitchPlayerMon

TrainerAboutToUseText: ; 3ca79 (f:4a79)
	far_text _TrainerAboutToUseText
	done

TrainerSentOutText: ; 3ca7e (f:4a7e)
	far_text _TrainerSentOutText
	done
TrainerLastStandText: ; 3ca7e (f:4a7e)
	far_text _TrainerLastStandText
	done
TrainerLastStandText2: ; 3ca7e (f:4a7e)
	far_text _TrainerLastStandText2
	done

; tests if the player has any pokemon that are not fainted
; sets d = 0 if all fainted, d != 0 if some mons are still alive
AnyPartyAlive: ; 3ca83 (f:4a83)
	ld a, [wPartyCount]
	ld e, a
	xor a
	ld hl, wPartyMon1HP
	ld bc, wPartyMon2 - wPartyMon1 - 1
.partyMonsLoop
	or [hl]
	inc hl
	or [hl]
	add hl, bc
	dec e
	jr nz, .partyMonsLoop
	ld d, a
	and a
	ret nz	;return if there are pokemon that aren't fainted
	ld a,[wIsInBattle]
	and a
	jr nz,.battleCheck	;run the battle check if we are not in battle
	ld hl,wTotems
	bit LastStandTotem,[hl]		;is last stand on?
	ret z		;return if not
	ld hl,wLastStandHP	;load in the last stand hp
	ld a,[hli]	;load last stand high byte into a
	or [hl]		;if last stand hp (high or low) are not zero, then a will be non zero
	ld d,a		;store into d
	ret
.battleCheck
	ld a,[wBattleMonSpecies2]
	cp HUMAN		;is the current pokemon already human?
	ld a,0	;set a to zero anyway
	jr z,.checkLastStandHp		;check hp if we are already in last stand mode
	ld hl,wTotems
	bit LastStandTotem,[hl]		;is last stand on?
	ret z		;return if not
.checkLastStandHp
	ld hl,wLastStandHP	;load in the last stand hp
	ld a,[hli]	;load last stand high byte into a
	or [hl]		;if last stand hp (high or low) are not zero, then a will be non zero
	ld d,a		;store into d
	ret z
	ld hl,wPresetTraits
	set PresetLastStand,[hl]		;set the bit so the next pokemon loaded will be Human
	ret
	

; tests if player mon has fainted
; stores whether mon has fainted in Z flag
HasMonFainted: ; 3ca97 (f:4a97)
	ld a, [wWhichPokemon]
	ld hl, wPartyMon1HP
	ld bc, wPartyMon2 - wPartyMon1
	call AddNTimes
	ld a, [hli]
	or [hl]
	ret nz
	ld a, [wFirstMonsNotOutYet]
	and a
	jr nz, .done
	ld hl, NoWillText
	call PrintText
.done
	xor a
	ret

NoWillText: ; 3cab4 (f:4ab4)
	far_text _NoWillText
	done
	
;to load the last stand moves:
LoadLastStandMoves:
	ret
	
;to get the player level
GetPlayerLevel:
	ld a,10
	ret
	
SendOutMon: ; 3cc91 (f:4c91)
	callab PrintSendOutMonMessage
	ld hl, wEnemyMonHP
	ld a, [hli]
	or [hl] ; is enemy mon HP zero?
	jp z, .skipDrawingEnemyHUDAndHPBar; if HP is zero, skip drawing the HUD and HP bar
	call DrawEnemyHUDAndHPBar
.skipDrawingEnemyHUDAndHPBar
	call DrawPlayerHUDAndHPBar
	predef LoadMonBackPic
	xor a
	ld [$ffe1], a
	ld hl, wBattleAndStartSavedMenuItem
	ld [hli], a
	ld [hl], a
	ld [wBoostExpByExpAll], a
	ld [wDamageMultipliers], a
	ld [wPlayerMoveNum], a
	ld hl, wPlayerUsedMove
	ld [hli], a
	ld [hl], a
	ld hl, wPlayerStatsToDouble
	ld [hli], a
	ld [hli], a
	ld [wPlayerMonMinimized], a
	ld b, SET_PAL_BATTLE
	call RunPaletteCommand
	ld hl, wEnemyBattleStatus1
	res UsingTrappingMove, [hl]
	ld a,[wBattleMonSpecies2]
	cp HUMAN		;human being sent out?
	jr z,.skipAnimation	;dont show animation if so
	ld a, $1
	ld [H_WHOSETURN], a
	ld a, POOF_ANIM
	call PlayNonMoveAnimation
	coord hl, 4, 11
	predef AnimateSendingOutMon
	ld a, [wcf91]
	call PlayCry
	call PrintEmptyString
.skipAnimation
	jp SaveScreenTilesToBuffer1

; reads player's current mon's HP into wBattleMonHP
ReadPlayerMonCurHPAndStatus: ; 3cd43 (f:4d43)
	ld a,[wBattleMonSpecies2]
	cp HUMAN		;are we in last stand mode?
	jr nz,.notHuman
	ld hl,wLastStandHP
	ld a,[wBattleMonHP]
	ld [hli],a
	ld a,[wBattleMonHP+1]
	ld [hli],a
	ld a,[wBattleMonStatus]
	and a,%11111000	;dont copy any sleeping status
	ld [hli],a
	xor a
	push hl
	ld hl,wPlayerBattleStatus3
	bit 0,[hl]	;toxic bit set?
	jr z,.skipToxic
	set Toxic2,a		;set toxic bit
.skipToxic
	bit 5,[hl]	;delayed damage bit set?
	jr z,.skipDelayedDamage
	set DelayedDamage2,a		;set delayed damage bit
.skipDelayedDamage
	pop hl
	ld [hli],a
	ld a,[wBattleMonDelayedDamage]
	ld [hli],a
	ld a,[wBattleMonDelayedDamage + 1]
	ld [hli],a
	ld a,[wBattleMonDelayedDamageCounter]
	ld [hl],a	;store delayed damage counter
	jr .checkMrMime
.notHuman
	ld a, [wPlayerMonNumber]
	ld hl, wPartyMon1HP
	ld bc, wPartyMon2 - wPartyMon1
	call AddNTimes
	ld d, h
	ld e, l
	ld hl, wBattleMonHP
	ld bc, $4               ; 2 bytes HP, 1 byte unknown (unused?), 1 byte status
	call CopyData
	callab StoreExtraPlayerMonBytesFromBattle
.checkMrMime
	ld a,[wEnemyMonSpecies2]
	cp MR_MIME	;mr mime?
	jr nz,.finish	;finish if not
	ld a,[wEnemyMonHP]
	ld [wMrMimeHP],a
	ld a,[wEnemyMonHP+1]
	ld [wMrMimeHP + 1],a
	ld a,[wEnemyMonStatus]
	ld [wMrMimeStatus],a
	xor a
	push hl
	ld hl,wEnemyBattleStatus3
	bit 0,[hl]	;toxic bit set?
	jr z,.skipToxic2
	set Toxic2,a		;set toxic bit
.skipToxic2
	pop hl
	ld [wMrMimeSecondaryStatus],a
.finish
	predef SaveInBattle
	ret

DrawHUDsAndHPBars::
	call DrawPlayerHUDAndHPBar
	jp DrawEnemyHUDAndHPBar

DrawPlayerHUDAndHPBar::
	callab _DrawPlayerHUDAndHPBar
	ret
	
DrawEnemyHUDAndHPBar::
	callab _DrawEnemyHUDAndHPBar
	ret
	
GetBattleHealthBarColor: ; 3ce90 (f:4e90)
	ld b, [hl]
	call GetHealthBarColor
	ld a, [hl]
	cp b
	ret z
	ld b, $1
	jp RunPaletteCommand
	
DisplayBattleMenu:
	callab _DisplayBattleMenu
	ret

SwitchPlayerMon: ; 3d1ba (f:51ba)
	callab RetreatMon
	ld c, 50
	call DelayFrames
	callab AnimateRetreatingPlayerMon
	ld a, [wWhichPokemon]
	ld [wPlayerMonNumber], a
	ld c, a
	ld b, FLAG_SET
	push bc
	ld hl, wPartyGainExpFlags
	predef FlagActionPredef
	pop bc
	ld hl, wPartyFoughtCurrentEnemyFlags
	predef FlagActionPredef
	callab LoadPlayerMonData
	call SendOutMon
	call SaveScreenTilesToBuffer1
	ld a, $2
	ld [wCurrentMenuItem], a
	and a
	ret

AlreadyOutText: ; 3d1f5 (f:51f5)
	far_text _AlreadyOutText
	done

MoveSelectionMenu: ; 3d219 (f:5219)
	ld a, [wMoveMenuType]
	dec a
	jr z, .mimicmenu
	dec a
	jr z, .relearnmenu
	jr .regularmenu

.loadmoves
	ld de, wMoves
	ld bc, NUM_MOVES
	call CopyData
	callab FormatMovesString
	ret

.writemoves
	ld de, wMovesString
	ld a, [hFlags_0xFFF6]
	set 2, a
	ld [hFlags_0xFFF6], a
	call PlaceString
	ld a, [hFlags_0xFFF6]
	res 2, a
	ld [hFlags_0xFFF6], a
	ret

.regularmenu
	call AnyMoveToSelect
	ret z
	ld hl, wBattleMonMoves
	call .loadmoves
	coord hl, 4, 12
	ld b, $4
	ld c, $e
	di
	call TextBoxBorder
	coord hl, 4, 12
	ld [hl], $7a
	coord hl, 10, 12
	ld [hl], $7e
	ei
	coord hl, 6, 13
	call .writemoves
	ld b, $5
	ld a, $c
	jr .menuset
.mimicmenu
	ld hl, wEnemyMonMoves
	call .loadmoves
	coord hl, 0, 7
	ld b, $4
	ld c, $e
	call TextBoxBorder
	coord hl, 2, 8
	call .writemoves
	ld b, $1
	ld a, $7
	jr .menuset
.relearnmenu
	ld a, [wWhichPokemon]
	ld hl, wPartyMon1Moves
	ld bc, wPartyMon2 - wPartyMon1
	call AddNTimes
	call .loadmoves
	coord hl, 4, 7
	ld b, $4
	ld c, $e
	call TextBoxBorder
	coord hl, 6, 8
	call .writemoves
	ld b, $5
	ld a, $7
.menuset
	ld hl, wTopMenuItemY
	ld [hli], a ; wTopMenuItemY
	ld a, b
	ld [hli], a ; wTopMenuItemX
	ld a, [wMoveMenuType]
	cp $1
	jr z, .selectedmoveknown
	ld a, $1
	jr nc, .selectedmoveknown
	ld a, [wPlayerMoveListIndex]
	inc a
.selectedmoveknown
	ld [hli], a ; wCurrentMenuItem
	inc hl ; wTileBehindCursor untouched
	ld a, [wNumMovesMinusOne]
	inc a
	inc a
	ld [hli], a ; wMaxMenuItem
	ld a, [wMoveMenuType]
	dec a
	ld b, D_UP | D_DOWN | A_BUTTON
	jr z, .matchedkeyspicked
	dec a
	ld b, D_UP | D_DOWN | A_BUTTON | B_BUTTON
	jr z, .matchedkeyspicked
	ld a, [wLinkState]
	cp LINK_STATE_BATTLING
	jr z, .matchedkeyspicked
	ld a, [wFlags_D733]
	bit BIT_TEST_BATTLE, a
	ld b, D_UP | D_DOWN | A_BUTTON | B_BUTTON | SELECT
	jr z, .matchedkeyspicked
	ld b, $ff
.matchedkeyspicked
	ld a, b
	ld [hli], a ; wMenuWatchedKeys
	ld a, [wMoveMenuType]
	cp $1
	jr z, .movelistindex1
	ld a, [wPlayerMoveListIndex]
	inc a
.movelistindex1
	ld [hl], a
; fallthrough

SelectMenuItem: ; 3d2fe (f:52fe)
	ld a, [wMoveMenuType]
	and a
	jr z, .battleselect
	dec a
	jr nz, .select
	coord hl, 1, 14
	ld de, WhichTechniqueString
	call PlaceString
	jr .select
.battleselect
	ld a, [wFlags_D733]
	bit BIT_TEST_BATTLE, a
	jr nz, .select
	call PrintMenuItem
	ld a, [wMenuItemToSwap]
	and a
	jr z, .select
	coord hl, 5, 13
	dec a
	ld bc, SCREEN_WIDTH
	call AddNTimes
	ld [hl], $ec
.select
	ld hl, hFlags_0xFFF6
	set 1, [hl]
	call HandleMenuInput
	ld hl, hFlags_0xFFF6
	res 1, [hl]
	bit 6, a
	jp nz, CursorUp ; up
	bit 7, a
	jp nz, CursorDown ; down
	bit 2, a
	jp nz, SwapMovesInMenu ; select
	bit 1, a ; B, but was it reset above?
	push af
	xor a
	ld [wMenuItemToSwap], a
	ld a, [wCurrentMenuItem]
	dec a
	ld [wCurrentMenuItem], a
	ld b, a
	ld a, [wMoveMenuType]
	dec a ; if not mimic
	jr nz, .nob
	pop af
	ret
.nob
	dec a
	ld a, b
	ld [wPlayerMoveListIndex], a
	jr nz, .moveselected
	pop af
	ret
.moveselected
	pop af
	ret nz
	;get the PP required for this move
	ld a, [wPlayerMonNumber]
	ld [wWhichPokemon], a
	ld a, $4
	ld [wMonDataLocation], a
	callab GetMaxPP
	
	;see if the player has enough PP to use this move
	ld a,[wBattleMonPP]
	and a		;is the high byte zero?
	jr nz,.enoughPP		;if not, then there is enough PP
	ld hl,wActiveCheats2
	bit RedBullCheat,[hl]
	jr nz,.enoughPP		;if cheat is active, then there is enough PP
	ld a,[wBattleMonPP + 1]
	ld hl,wd11e	;hl = PP used for this move
	cp [hl]		;if the pp required is greater than what is remaining, then say not enough PP
	jr c, .nopp
.enoughPP
	ld a, [wPlayerDisabledMove]
	swap a
	and $f
	dec a
	cp c
	jr z, .disabled
	ld a, [wPlayerBattleStatus3]
	bit 3, a ; transformed
	jr nz, .dummy ; game freak derp
.dummy
	ld a, [wCurrentMenuItem]
	ld hl, wBattleMonMoves
	ld c, a
	ld b, $0
	add hl, bc
	ld a, [hl]
	ld [wPlayerSelectedMove], a
	xor a
	ret
.disabled
	ld hl, MoveDisabledText
	jr .print
.nopp
	ld hl, MoveNoPPText
.print
	call PrintText
	call LoadScreenTilesFromBuffer1
	jp MoveSelectionMenu

MoveNoPPText: ; 3d3ae (f:53ae)
	far_text _MoveNoPPText
	done

MoveDisabledText: ; 3d3b3 (f:53b3)
	far_text _MoveDisabledText
	done

WhichTechniqueString: ; 3d3b8 (f:53b8)
	db "WHICH TECHNIQUE?@"

CursorUp: ; 3d3c9 (f:53c9)
	ld a, [wCurrentMenuItem]
	and a
	jp nz, SelectMenuItem
	call EraseMenuCursor
	ld a, [wNumMovesMinusOne]
	inc a
	ld [wCurrentMenuItem], a
	jp SelectMenuItem

CursorDown: ; 3d3dd (f:53dd)
	ld a, [wCurrentMenuItem]
	ld b, a
	ld a, [wNumMovesMinusOne]
	inc a
	inc a
	cp b
	jp nz, SelectMenuItem
	call EraseMenuCursor
	ld a, $1
	ld [wCurrentMenuItem], a
	jp SelectMenuItem

AnyMoveToSelect: ; 3d3f5 (f:53f5)
	ld a,0
	ld [wPlayerSelectedMove], a
	callab DoesBattleMonHasEnoughPP
	ld a,d
	and a
	ret


SwapMovesInMenu: ; 3d435 (f:5435)
	ld a, [wMenuItemToSwap]
	and a
	jr z, .noMenuItemSelected
	ld hl, wBattleMonMoves
	call .swapBytes ; swap moves
	ld hl, wBattleMonPP
	call .swapBytes ; swap move PP
; update the index of the disabled move if necessary
	ld hl, wPlayerDisabledMove
	ld a, [hl]
	swap a
	and $f
	ld b, a
	ld a, [wCurrentMenuItem]
	cp b
	jr nz, .next
	ld a, [hl]
	and $f
	ld b, a
	ld a, [wMenuItemToSwap]
	swap a
	add b
	ld [hl], a
	jr .swapMovesInPartyMon
.next
	ld a, [wMenuItemToSwap]
	cp b
	jr nz, .swapMovesInPartyMon
	ld a, [hl]
	and $f
	ld b, a
	ld a, [wCurrentMenuItem]
	swap a
	add b
	ld [hl], a
.swapMovesInPartyMon
	ld hl, wPartyMon1Moves
	ld a, [wPlayerMonNumber]
	ld bc, wPartyMon2 - wPartyMon1
	call AddNTimes
	push hl
	call .swapBytes ; swap moves
	pop hl
	ld bc, wPartyMon1PP - wPartyMon1Moves
	add hl, bc
	call .swapBytes ; swap move PP
	xor a
	ld [wMenuItemToSwap], a ; deselect the item
	jp MoveSelectionMenu
.swapBytes
	push hl
	ld a, [wMenuItemToSwap]
	dec a
	ld c, a
	ld b, 0
	add hl, bc
	ld d, h
	ld e, l
	pop hl
	ld a, [wCurrentMenuItem]
	dec a
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [de]
	ld b, [hl]
	ld [hl], a
	ld a, b
	ld [de], a
	ret
.noMenuItemSelected
	ld a, [wCurrentMenuItem]
	ld [wMenuItemToSwap], a ; select the current menu item for swapping
	jp MoveSelectionMenu

PrintMenuItem: ; 3d4b6 (f:54b6)
	xor a
	ld [H_AUTOBGTRANSFERENABLED], a
	coord hl, 0, 8
	ld b, $3
	ld c, $9
	call TextBoxBorder
	ld a, [wPlayerDisabledMove]
	and a
	jr z, .notDisabled
	swap a
	and $f
	ld b, a
	ld a, [wCurrentMenuItem]
	cp b
	jr nz, .notDisabled
	coord hl, 1, 10
	ld de, DisabledText
	call PlaceString
	jr .moveDisabled
.notDisabled
	ld hl, wCurrentMenuItem
	dec [hl]
	xor a
	ld [H_WHOSETURN], a
	ld hl, wBattleMonMoves
	ld a, [wCurrentMenuItem]
	ld c, a
	ld b, $0 ; which item in the menu is the cursor pointing to? (0-3)
	add hl, bc ; point to the item (move) in memory
	ld a, [hl]
	ld [wPlayerSelectedMove], a ; update wPlayerSelectedMove even if the move
	                            ; isn't actually selected (just pointed to by the cursor)
	ld a, [wPlayerMonNumber]
	ld [wWhichPokemon], a
	ld a, BATTLE_MON_DATA
	ld [wMonDataLocation], a
	callab GetMaxPP
	ld hl, wCurrentMenuItem
	ld c, [hl]
	inc [hl]
	ld b, $0
	ld hl, wBattleMonPP
	add hl, bc
	ld a, [hl]
	and $3f
	ld [wcd6d], a
; print TYPE/<type> and <curPP>/<maxPP>	
	coord hl, 5, 11
	ld de, wd11e
	ld bc, $102
	call PrintNumber
	coord hl, 8, 11
	ld [hl], "P"
	inc hl
	ld [hl], "P"
	coord hl, 1, 9
	ld de, TypeText
	call PlaceString
	coord hl, 5, 9
	ld [hl], "/"
	call GetCurrentMove 
	coord hl, 2, 10
	predef PrintMoveType
.moveDisabled
	ld a, $1
	ld [H_AUTOBGTRANSFERENABLED], a
	jp Delay3

DisabledText: ; 3d555 (f:5555)
IF DEF(_YELLOW)
	db "Disabled!@"
ELSE
	db "disabled!@"
ENDC

TypeText: ; 3d55f (f:555f)
	db "TYPE@"

EnemyOnlyDisabledMoveLeft:
	far_text _OnlyDisabledMoveLeft
	done
	
NotEnoughEnergyLeftText: ; 3d430 (f:5430)
	far_text _NotEnoughEnergyLeft
	done
	
SelectEnemyMove: ; 3d564 (f:5564)
	ld a, [wLinkState]
	sub LINK_STATE_BATTLING
	jr nz, .noLinkBattle
; link battle
	call SaveScreenTilesToBuffer1
	call LinkBattleExchangeData
	call LoadScreenTilesFromBuffer1
	ld a, [wSerialExchangeNybbleReceiveData]
	cp $e
	jp z,EnemyOutOfEnergy
	cp $d
	jr z, .unableToSelectMove
	cp $4
	ret nc
	ld [wEnemyMoveListIndex], a
	ld c, a
	ld hl, wEnemyMonMoves
	ld b, $0
	add hl, bc
	ld a, [hl]
.done
	ld [wEnemySelectedMove], a
	ret
.noLinkBattle
	ld a, [wEnemyBattleStatus2]
	and (1 << NeedsToRecharge) | (1 << UsingRage) ; need to recharge or using rage
	ret nz
	ld hl, wEnemyBattleStatus1
	ld a, [hl]
	and (1 << ChargingUp) | (1 << ThrashingAbout) ; using a charging move or thrash/petal dance
	ret nz
	ld a, [wEnemyMonStatus]
	and SLP | 1 << FRZ ; sleeping or frozen
	ret nz
	ld a, [wEnemyBattleStatus1]
	and (1 << UsingTrappingMove) | (1 << StoringEnergy) ; using a trapping move like wrap or bide
	ret nz
	ld a, [wPlayerBattleStatus1]
	bit UsingTrappingMove, a ; caught in player's trapping move (e.g. wrap)
	jr z, .canSelectMove
.unableToSelectMove
	ld a, $ff
	jr .done
.canSelectMove
	ld hl, wEnemyMonMoves+1 ; 2nd enemy move
	ld a, [hld]
	and a
	jr nz, .atLeastTwoMovesAvailable
	ld a, [wEnemyDisabledMove]
	and a
	jr nz,EnemyOnlyDisabledLeft	;unable to move is only move is disabled
.atLeastTwoMovesAvailable
	ld a, [wIsInBattle]
	dec a
	jr z, .chooseRandomMove ; wild encounter
	callab AIEnemyTrainerChooseMoves
.chooseRandomMove
	callab DoesEnemyMonHasEnoughPP
	dec d
	jr z,.findMove	;if it was 1, then there is enough pp somewhere, find it
	dec d
	jr z,EnemyOnlyDisabledLeft	;if it was 2, then only disable moves left
	jr EnemyOutOfEnergy	;otherwise, it is out of energy
.findMove
	push hl
	call BattleRandom
	ld b, $1
	cp $3f ; select move 1, [0,3e] (63/256 chance)
	jr c, .moveChosen
	inc hl
	inc b
	cp $7f ; select move 2, [3f,7e] (64/256 chance)
	jr c, .moveChosen
	inc hl
	inc b
	cp $be ; select move 3, [7f,bd] (63/256 chance)
	jr c, .moveChosen
	inc hl
	inc b ; select move 4, [be,ff] (66/256 chance)
.moveChosen
	ld a, b
	dec a
	ld [wEnemyMoveListIndex], a
	ld a, [wEnemyDisabledMove]
	swap a
	and $f
	cp b
	ld a, [hl]
	pop hl
	jr z, .findMove ; move disabled, try again
	and a
	jr z, .findMove ; move non-existant, try again
	callab EnemyMoveHaveEnoughPP
	dec d
	jr nz,.chooseRandomMove	;not enough pp, try again
EnemyChooseMoveDone:
	ld [wEnemySelectedMove], a
	ret
EnemyOutOfEnergy:
	ld a,1
	ld [H_WHOSETURN], a ; set enemy's turn
	call EnemyFallAsleepNoEnergy
	xor a
	jr EnemyChooseMoveDone
EnemyOnlyDisabledLeft:
	ld a,1
	ld [H_WHOSETURN], a ; set enemy's turn
	ld hl, EnemyOnlyDisabledMoveLeft
	call PrintText
	xor a
	jr EnemyChooseMoveDone

PlayerFallAsleepNoEnergy:
	ld hl,wBattleMonStatus
	jr FallAsleepNoEnergyCommon
	
EnemyFallAsleepNoEnergy:
	ld hl,wEnemyMonStatus
	;fall through
FallAsleepNoEnergyCommon:
	call BattleRandom
	and SLP ; sleep mask
	jr nz,.notSleepZero
	ld a,4		;if zero, set to 4
.notSleepZero
	or [hl]
	ld [hl],a
	ld hl,NotEnoughEnergyLeftText
	call PrintText
	jp PlaySleepAnimation
	
; this appears to exchange data with the other gameboy during link battles
LinkBattleExchangeData: ; 3d605 (f:5605)
	ld a, $ff
	ld [wSerialExchangeNybbleReceiveData], a
	ld a, [wPlayerMoveListIndex]
	cp $f ; is the player running from battle?
	jr z, .doExchange
	ld a, [wActionResultOrTookBattleTurn]
	and a ; is the player switching in another mon?
	jr nz, .switching
; the player used a move
	ld a, [wPlayerSelectedMove]
	ld b, $e
	dec b
	inc a
	jr z, .next
	ld a, [wPlayerMoveListIndex]
	jr .doExchange
.switching
	ld a, [wWhichPokemon]
	add 4
	ld b, a
.next
	ld a, b
.doExchange
	ld [wSerialExchangeNybbleSendData], a
	callab PrintWaitingText
.syncLoop1
	call Serial_ExchangeNybble
	call DelayFrame
	ld a, [wSerialExchangeNybbleReceiveData]
	inc a
	jr z, .syncLoop1
	ld b, 10
.syncLoop2
	call DelayFrame
	call Serial_ExchangeNybble
	dec b
	jr nz, .syncLoop2
	ld b, 10
.syncLoop3
	call DelayFrame
	call Serial_SendZeroByte
	dec b
	jr nz, .syncLoop3
	ret


ExecutePlayerMove: ; 3d65e (f:565e)
	xor a
	ld [H_WHOSETURN], a ; set player's turn
	ld a, [wPlayerSelectedMove]
	inc a
	jp z, ExecutePlayerMoveDone ; for selected move = FF, skip most of player's turn
	xor a
	ld [wMoveMissed], a
	ld [wMonIsDisobedient], a
	ld [wMoveDidntMiss], a
	ld a, $a
	ld [wDamageMultipliers], a
	ld a, [wActionResultOrTookBattleTurn]
	and a ; has the player already used the turn (e.g. by using an item, trying to run or switching pokemon)
	jp nz, ExecutePlayerMoveDone
	call CheckPlayerStatusConditions
	ld a,[wPlayerSelectedMove]
	and a
	jp z,ExecutePlayerMoveDone		;if move is zero, then don't attack
	call GetCurrentMove
	ld hl, wPlayerBattleStatus1
	bit ChargingUp, [hl] ; charging up for attack
	jr nz, PlayerCanExecuteChargingMove
	call CheckForDisobedience
	jp z, ExecutePlayerMoveDone

CheckIfPlayerNeedsToChargeUp: ; 3d69a (f:569a)
	ld a, [wPlayerMoveEffect]
	cp CHARGE_EFFECT
	jp z, JumpMoveEffect
	cp FLY_EFFECT
	jp z, JumpMoveEffect
	jr PlayerCanExecuteMove

; in-battle stuff
PlayerCanExecuteChargingMove: ; 3d6a9 (f:56a9)
	ld hl,wPlayerBattleStatus1
	res ChargingUp,[hl] ; reset charging up and invulnerability statuses if mon was charging up for an attack
	                    ; being fully paralyzed or hurting oneself in confusion removes charging up status
	                    ; resulting in the Pokemon being invulnerable for the whole battle
	res Invulnerable,[hl]
PlayerCanExecuteMove: ; 3d6b0 (f:56b0)
	call PrintMonName1Text
	callab DecrementPP
	ld a,[wPlayerMoveEffect] ; effect of the move just used
	ld hl,ResidualEffects1
	ld de,1
	call IsInArray
	jp c,JumpMoveEffect ; ResidualEffects1 moves skip damage calculation and accuracy tests
	                    ; unless executed as part of their exclusive effect functions
	ld a,[wPlayerMoveEffect]
	ld hl,SpecialEffectsCont
	ld de,1
	call IsInArray
	call c,JumpMoveEffect ; execute the effects of SpecialEffectsCont moves (e.g. Wrap, Thrash) but don't skip anything
PlayerCalcMoveDamage: ; 3d6dc (f:56dc)
	ld a,[wPlayerMoveEffect]
	ld hl,SetDamageEffects
	ld de,1
	call IsInArray
	jp c,.moveHitTest ; SetDamageEffects moves (e.g. Seismic Toss and Super Fang) skip damage calculation
	call CriticalHitTest
	call HandleCounterMove
	jr z,handleIfPlayerMoveMissed
	call GetDamageVarsForPlayerAttack
	call CalculateDamage
	jp z,playerCheckIfFlyOrChargeEffect ; for moves with 0 BP, skip any further damage calculation and, for now, skip MoveHitTest
	               ; for these moves, accuracy tests will only occur if they are called as part of the effect itself
	call AdjustDamageForMoveType
	call RandomizeDamage
.moveHitTest
	call MoveHitTest
handleIfPlayerMoveMissed
	ld a,[wMoveMissed]
	and a
	jr z,GetPlayerAnimationType
	ld a,[wPlayerMoveEffect]
	sub a,EXPLODE_EFFECT
	jr z,playPlayerMoveAnimation ; don't play any animation if the move missed, unless it was EXPLODE_EFFECT
	jr playerCheckIfFlyOrChargeEffect
GetPlayerAnimationType
	ld a,[wPlayerMoveEffect]
	and a
	ld a,4 ; move has no effect other than dealing damage
	jr z,playPlayerMoveAnimation
	ld a,5 ; move has effect
playPlayerMoveAnimation
	push af
	ld a,[wPlayerBattleStatus2]
	bit HasSubstituteUp,a
	ld hl,HideSubstituteShowMonAnim
	ld b,BANK(HideSubstituteShowMonAnim)
	call nz,Bankswitch
	pop af
	ld [wAnimationType],a
	ld a,[wPlayerMoveNum]
	call PlayMoveAnimation
	call HandleExplodingAnimation
	call DrawPlayerHUDAndHPBar
	ld a,[wPlayerBattleStatus2]
	bit HasSubstituteUp,a
	ld hl,ReshowSubstituteAnim
	ld b,BANK(ReshowSubstituteAnim)
	call nz,Bankswitch
	jr MirrorMoveCheck
playerCheckIfFlyOrChargeEffect
	ld c,30
	call DelayFrames
	ld a,[wPlayerMoveEffect]
	cp a,FLY_EFFECT
	jr z,.playAnim
	cp a,CHARGE_EFFECT
	jr z,.playAnim
	jr MirrorMoveCheck
.playAnim
	xor a
	ld [wAnimationType],a
	ld a,STATUS_AFFECTED_ANIM
	call PlayNonMoveAnimation
MirrorMoveCheck
	ld a,[wPlayerMoveEffect]
	cp a,MIRROR_MOVE_EFFECT
	jr nz,.metronomeCheck
	call MirrorMoveCopyMove
	jp z,ExecutePlayerMoveDone
	xor a
	ld [wMonIsDisobedient],a
	jp CheckIfPlayerNeedsToChargeUp ; if Mirror Move was successful go back to damage calculation for copied move
.metronomeCheck
	cp a,METRONOME_EFFECT
	jr nz,.next
	call MetronomePickMove
	jp CheckIfPlayerNeedsToChargeUp ; Go back to damage calculation for the move picked by Metronome
.next
	ld a,[wPlayerMoveEffect]
	ld hl,ResidualEffects2
	ld de,1
	call IsInArray
	jp c,JumpMoveEffect ; done here after executing effects of ResidualEffects2
	ld a,[wMoveMissed]
	and a
	jr z,.moveDidNotMiss
	call PrintMoveFailureText
	ld a,[wPlayerMoveEffect]
	cp a,EXPLODE_EFFECT ; even if Explosion or Selfdestruct missed, its effect still needs to be activated
	jr z,.notDone
	jp ExecutePlayerMoveDone ; otherwise, we're done if the move missed
.moveDidNotMiss
	call ApplyAttackToEnemyPokemon
	call PrintCriticalOHKOText
	callab DisplayEffectiveness
	ld a,1
	ld [wMoveDidntMiss],a
.notDone
	ld a,[wPlayerMoveEffect]
	ld hl,AlwaysHappenSideEffects
	ld de,1
	call IsInArray
	call c,JumpMoveEffect ; not done after executing effects of AlwaysHappenSideEffects
	ld hl,wEnemyMonHP
	ld a,[hli]
	ld b,[hl]
	or b
	ret z ; don't do anything else if the enemy fainted
	call HandleBuildingRage

	ld hl,wPlayerBattleStatus1
	bit AttackingMultipleTimes,[hl]
	jr z,.executeOtherEffects
	ld a,[wPlayerNumAttacksLeft]
	dec a
	ld [wPlayerNumAttacksLeft],a
	jp nz,GetPlayerAnimationType ; for multi-hit moves, apply attack until PlayerNumAttacksLeft hits 0 or the enemy faints.
	                             ; damage calculation and accuracy tests only happen for the first hit
	res AttackingMultipleTimes,[hl] ; clear attacking multiple times status when all attacks are over
	ld hl,MultiHitText
	call PrintText
	xor a
	ld [wPlayerNumHits],a
.executeOtherEffects
	ld a,[wPlayerMoveEffect]
	and a
	jp z,ExecutePlayerMoveDone
	ld hl,SpecialEffects
	ld de,1
	call IsInArray
	call nc,JumpMoveEffect ; move effects not included in SpecialEffects or in either of the ResidualEffect arrays,
	; which are the effects not covered yet. Rage effect will be executed for a second time (though it's irrelevant).
	; Includes side effects that only need to be called if the target didn't faint.
	; Responsible for executing Twineedle's second side effect (poison).
	jp ExecutePlayerMoveDone

MultiHitText: ; 3d805 (f:5805)
	far_text _MultiHitText
	done

ExecutePlayerMoveDone: ; 3d80a (f:580a)
	xor a
	ld [wActionResultOrTookBattleTurn],a
	ld b,1
	ret

	
;if the player is still trying to use the move, then print the text
;otherwise, dont because the previous one supersedes it
PrintCantUseMoveText:
	call PrintText	
CantUseMove:
	ld de,wPlayerUsedMove
	ld hl,wPlayerBattleStatus1
	ld bc,wPlayerMoveEffect
	ld a, [H_WHOSETURN]
	and a
	jr z, .playersTurn
	ld de,wEnemyUsedMove
	ld hl,wEnemyBattleStatus1
	ld bc,wEnemyMoveEffect
.playersTurn
	xor a
	ld [de],a	;used move
	ld a,1 << Confused
	and [hl]		;reset all bits except confused
	ld [hli],a
	ld a,~(1 << GettingPumped || 1<< NeedsToRecharge || 1<< UsingRage)
	and [hl]		;reset focus energy, recharge, and rage bits
	ld [hl],a
	ld a,[bc]	;move effect
	cp a,FLY_EFFECT
	jr z,.FlyOrChargeEffect
	cp a,CHARGE_EFFECT
	jr nz,.finish
.FlyOrChargeEffect
	xor a
	ld [wAnimationType],a
	ld a,STATUS_AFFECTED_ANIM
	call PlayNonMoveAnimation
.finish
	pop hl
	pop hl	;skip the two previous return
	ld hl,ExecutePlayerMoveDone
	ld de,ExecuteEnemyMoveDone
	;fall through
JumpBasedOnWhoseTurn:
	ld a, [H_WHOSETURN]
	and a
	jr z,.jump
	push de
	pop hl
.jump
	jp [hl]
	
PlaySleepAnimation:
	xor a
	ld [wAnimationType],a
	ld a, [H_WHOSETURN]
	and a
	ld a,SLP_ANIM - 1
	jr z,.dontIncAnimID
	inc a	;if enemy turn, inc the animation id
.dontIncAnimID
	jp PlayNonMoveAnimation
	
CheckSleepStatus:
	ld a,[hl]
	and a,SLP ; sleep mask
	ret z
; sleeping
	dec [hl]
	dec a	; decrement number of turns left
	jr z,.WakeUp ; if the number of turns hit 0, wake up
; fast asleep
	ld hl,FastAsleepText
	call PrintText
	call PlaySleepAnimation
	jr .sleepDone
.WakeUp
	ld hl, EarlyBirdText2	;load 
	ld a, AB_EARLY_BIRD
	call DoesAttackerHaveAbility	;check to see if the pokemon has the early bird ability
	and a
	jr nz,.printWokeUp	;print the early bird ability if so
	ld hl, WokeUpText	;otherwise, print normal woke up text
.printWokeUp
	call PrintText
	call RegainWakeupEnergy
.sleepDone
	jp CantUseMove
	
CheckFrozenStatus:
	bit FRZ,[hl] ; frozen?
	ret z
	ld hl,IsFrozenText
	jp PrintCantUseMoveText

CheckCantMoveStatus:
	bit UsingTrappingMove,[hl] ; is enemy using a mult-turn move like wrap?
	ret z
	ld hl,CantMoveText
	jp PrintCantUseMoveText
	
CheckFlinchedStatus:
	bit Flinched,[hl]
	ret z
	call BattleRandom
	cp $20
	ld hl,FlinchedText
	jr nc,.printFlinchText	;87.5% chance of no fear
	push de
	push af
	call PrintText
	pop af
	and %00000111		;only keep the lower 3 bits
	pop hl	;hl = cursed/fear counter
	or [hl]		;append to the fear counter
	ld [hl],a
	ld hl,BecameFrightenedText
.printFlinchText
	jp PrintCantUseMoveText
	
CheckRechargeStatus:
	bit NeedsToRecharge,[hl]
	ret z
	ld hl,MustRechargeText
	jp PrintCantUseMoveText
	
CheckParalysisStatus:
	bit PAR,[hl]
	ret z
	call BattleRandom
	cp a,$3F ; 25% to be fully paralyzed
	ret nc
	ld hl,FullyParalyzedText
	jp PrintCantUseMoveText
	
CheckAnyMoveDisabled:
	ld a,[hl]
	and a
	ret z
	dec a
	ld [hl],a
	and $f ; did Disable counter hit 0?
	ret nz
	ld [hl],a
	ld [de],a
	ld hl,DisabledNoMoreText
	push de
	call PrintText
	pop de
	ret
	
CheckUseDisabledMove:
; prevents a disabled move that was selected before being disabled from being used
	ld a,[de]
	and a
	ret z
	cp [hl]
	ret nz
	ld [wd11e], a
	call GetMoveName
	ld hl, MoveIsDisabledText
	jp PrintCantUseMoveText
	
CheckFearStatus:
	ld a,[hl]	;load the fear counter
	and a,$0F
	ret z
	dec [hl]
	dec a
	jr nz,.hasFear	;pokemon is still scared
	ld hl,RegainedCourageText
	jp PrintText
.hasFear
	call BattleRandom
	cp a,$80	;50% fear
	jr nc,.tooScaredToMove	;if so, pokemon is too scared to move
	cp a,$20	;12.5% pokemon leaving battle
	ret nc	;if greater than e7, then continue to next check
	
	;TODO
	;put function here to switch player pokemon from battle (if possible)
	
.tooScaredToMove
	ld hl,TooScaredToMoveText
	jp PrintCantUseMoveText

CheckCursedStatus:
	ld a,[hl]
	and a,$F0
	ret z
	ld a,[hl]
	sub a,$10
	ld [hl],a
	and a,$F0
	jr nz,.printIsCursedText
	ld hl,CursedNoMoreText
	jr .printCursedText
.printIsCursedText
	ld hl,IsCursedText
.printCursedText
	jp PrintText
	
CheckConfusedStatus:
	ld a,[hl]
	and a
	ret z		;return if not confused
	dec [hl]
	jr nz,.IsConfused
	ld hl,ConfusedNoMoreText
	jp PrintText
.IsConfused
	ld hl,IsConfusedText
	call PrintText
	xor a
	ld [wAnimationType],a
	ld a, [H_WHOSETURN]
	and a
	ld a,CONF_ANIM - 1
	jr z,.dontIncAnimID
	inc a	;if enemy turn, inc the animation id
.dontIncAnimID
	call PlayNonMoveAnimation
	call BattleRandom
	cp a,$80 ; 50% chance to hurt itself
	ret c
	call HandleSelfConfusionDamage
	jp CantUseMove
	
HandleSelfConfusionDamage:
	ld hl, HurtItselfText
	call PrintText
	ld hl,wEnemyMonDefense
	ld de,wBattleMonDefense
	ld bc,wPlayerMoveEffect
	
	ld a,[H_WHOSETURN]
	and a
	jr z,.playersTurn

	ld hl,wBattleMonDefense
	ld de,wEnemyMonDefense
	ld bc,wEnemyMoveEffect
.playersTurn
	ld a, [hli]	;defender defense
	push af
	ld a, [hld]
	push af
	ld a, [de]	;attacker defense
	ld [hli], a
	inc de
	ld a, [de]
	ld [hl], a
	push de
	push bc
	push bc
	pop hl	;hl = move effect
	ld a, [hl]
	push af
	xor a
	ld [hli], a
	ld [wCriticalHitOrOHKO], a ; self-inflicted confusion damage can't be a Critical Hit
	ld a, 40 ; 40 base power
	ld [hli], a
	xor a
	ld [hl], a
	ld hl,GetDamageVarsForPlayerAttack
	ld de,GetDamageVarsForEnemyAttack
	call JumpBasedOnWhoseTurn
	call CalculateDamage
	pop af
	pop hl
	ld [hl], a
	pop hl	; defender defense + 1
	pop af
	ld [hld], a
	pop af
	ld [hl], a
	xor a
	ld [wAnimationType], a
	call SwapWhoseTurn
	call PlayMoveAnimation
	call DrawPlayerHUDAndHPBar
	call SwapWhoseTurn
	ld hl,ApplyDamageToPlayerPokemon
	ld de,ApplyDamageToEnemyPokemon
	jp JumpBasedOnWhoseTurn
	
ApplyBideStatus:
	xor a
	ld [de],a	;move num
	push hl
	push bc
	ld hl,wDamage
	ld a,[hli]
	ld b,a
	ld c,[hl]
	pop hl	;bc, accumulated damage + 1
	ld a,[hl]
	add c ; accumulate damage taken
	ld [hld],a
	ld a,[hl]
	adc b
	ld [hl],a
	pop hl	; hl = num attacks left
	dec [hl] ; did Bide counter hit 0?
	jr z,.unleashEnergy
	pop hl
	pop hl	;recover 2 of the 3 that were already pushed
	jp CantUseMove
.unleashEnergy
	pop hl	;battle status 1
	res StoringEnergy,[hl] ; not using bide any more
	ld hl,UnleashedEnergyText
	call PrintText
	ld a,1
	pop bc	;move power
	ld [bc],a
	pop hl	;hl = accumulated damage + 1
	ld a,[hld]
	add a
	ld b,a
	ld [wDamage + 1],a
	ld a,[hl]
	rl a ; double the damage
	ld [wDamage],a
	or b
	jr nz,.next
	ld a,1
	ld [wMoveMissed],a
.next
	xor a
	ld [hli],a
	ld [hl],a
	ld a,BIDE
	pop hl	; move num
	ld [hl],a
	pop hl		;remove the return
	ld hl,handleIfPlayerMoveMissed
	ld de,handleIfEnemyMoveMissed
	jp JumpBasedOnWhoseTurn

ApplyThrashStatus:
	ld [hl],THRASH
	ld hl,ThrashingAboutText
	push bc
	push de
	call PrintText
	pop de
	pop hl	;num attacks left
	dec [hl] ; did Thrashing About counter hit 0?
	pop hl	;battle status 1
	jr z,.ThrashHitZero
	pop hl		;remove the return
	ld hl,PlayerCalcMoveDamage
	ld de,EnemyCalcMoveDamage
	jp JumpBasedOnWhoseTurn
.ThrashHitZero
	res ThrashingAbout,[hl] ; no longer thrashing about
	set Confused,[hl] ; confused
	call BattleRandom
	and a,3
	inc a
	inc a ; confused for 2-5 turns
	ld [de],a	;confused counter
	pop hl	;remove the return
	ret
	
CheckMultiturnMove:
	bit UsingTrappingMove,[hl] ; is mon using multi-turn move?
	ret z
	push bc
	ld hl,AttackContinuesText
	call PrintText
	pop hl	;num attacks left
	dec [hl]	;decrease the counter
	pop hl
	pop hl	;remove the 2 returns
	ld hl,GetPlayerAnimationType
	ld de,GetEnemyAnimationType
	jp JumpBasedOnWhoseTurn
	
CheckRageStatus:
	bit UsingRage, [hl] ; is mon using rage?
	ret z ; if we made it this far, mon can move normally this turn
	push de
	ld a, RAGE
	ld [wd11e], a
	call GetMoveName
	call CopyStringToCF4B
	xor a
	pop de	;move effect
	ld [de], a
	pop hl
	pop hl	;remove the 2 returns
	ld hl,PlayerCanExecuteMove
	ld de,EnemyCanExecuteMove
	jp JumpBasedOnWhoseTurn
	
CheckHasEnoughEnergy:
	push de
	ld b,BANK(PlayerMoveHaveEnoughPP)
	call Bankswitch
	ld a,d
	and a
	pop de
	ret nz		;return if there is enough
	ld a,[de]
	ld [wd11e], a
	call GetMoveName
	ld hl,DoesntHaveEnergyToUseMoveText
	jp PrintCantUseMoveText
	
; checks for various status conditions affecting the player mon
; stores whether the mon cannot use a move this turn in Z flag
CheckPlayerStatusConditions: ; 3d854 (f:5854)
	ld hl,wBattleMonStatus
	call CheckSleepStatus
	call CheckFrozenStatus
	ld hl,wEnemyBattleStatus1
	call CheckCantMoveStatus
	ld hl,wPlayerBattleStatus1
	ld de,wBattleMonCursedFearCounter
	call CheckFlinchedStatus
	ld hl,wPlayerBattleStatus2
	call CheckRechargeStatus
	ld hl,wBattleMonStatus
	call CheckParalysisStatus
	ld hl,wPlayerDisabledMove
	ld de,wPlayerDisabledMoveNumber
	call CheckAnyMoveDisabled
	ld hl,wPlayerSelectedMove
	call CheckUseDisabledMove
	ld hl,PlayerMoveHaveEnoughPP
	ld de,wPlayerMoveNum
	call CheckHasEnoughEnergy
	ld hl,wBattleMonCursedFearCounter
	call CheckFearStatus
	call CheckCursedStatus
	ld hl,wPlayerConfusedCounter
	call CheckConfusedStatus
	ld hl,wPlayerBattleStatus1
	bit StoringEnergy,[hl] ; is mon using bide?
	jr z,.notBideStatus
	ld de,wPlayerMoveNum
	push hl
	ld hl,wPlayerBideAccumulatedDamage + 1
	ld bc,wPlayerMovePower
	ld de,wPlayerBattleStatus1
	push hl
	push bc
	push de
	ld de,wPlayerMoveNum
	ld hl,wPlayerNumAttacksLeft
	ld bc,wPlayerBideAccumulatedDamage + 1
	jp ApplyBideStatus
.notBideStatus
	ld bc,wPlayerNumAttacksLeft
	bit ThrashingAbout,[hl] ; is mon using thrash or petal dance?
	jr z,.notThrashStatus
	push hl
	ld hl,wPlayerMoveNum
	ld de,wPlayerConfusedCounter
	jp ApplyThrashStatus
.notThrashStatus
	call CheckMultiturnMove
	ld de,wPlayerMoveEffect
	ld hl,wPlayerBattleStatus2
	call CheckRageStatus
	ret

FastAsleepText: ; 3da3d (f:5a3d)
	far_text _FastAsleepText
	done

RegainedEnergy:
	far_text _RegainedEnergy
	done
	
WokeUpText: ; 3da42 (f:5a42)
	far_text _WokeUpText
	done

IsFrozenText: ; 3da47 (f:5a47)
	far_text _IsFrozenText
	done

FullyParalyzedText: ; 3da4c (f:5a4c)
	far_text _FullyParalyzedText
	done

FlinchedText: ; 3da51 (f:5a51)
	far_text _FlinchedText
	done
	
TooScaredToMoveText:
	far_text _TooScaredToMoveText
	done
	
DoesntHaveEnergyToUseMoveText:
	far_text _DoesntHaveEnergyToUseMoveText
	done
	
BecameFrightenedText:
	far_text _BecameFrightenedText
	done
	
RegainedCourageText:
	far_text _RegainedCourageText
	done
	
InvisibleNoMoreText:
	far_text _InvisibleNoMoreText
	done
	
IsInvisibleText:
	far_text _IsInvisibleText
	done
	
CursedNoMoreText:
	far_text _CursedNoMoreText
	done
	
IsCursedText:
	far_text _IsCursedText
	done
	
LimitedByCursedText:
	far_text _LimitedByCursedText
	done

MustRechargeText: ; 3da56 (f:5a56)
	far_text _MustRechargeText
	done

DisabledNoMoreText: ; 3da5b (f:5a5b)
	far_text _DisabledNoMoreText
	done

IsConfusedText: ; 3da60 (f:5a60)
	far_text _IsConfusedText
	done

HurtItselfText: ; 3da65 (f:5a65)
	far_text _HurtItselfText
	done

ConfusedNoMoreText: ; 3da6a (f:5a6a)
	far_text _ConfusedNoMoreText
	done

SavingEnergyText: ; 3da6f (f:5a6f)
	far_text _SavingEnergyText
	done

UnleashedEnergyText: ; 3da74 (f:5a74)
	far_text _UnleashedEnergyText
	done

ThrashingAboutText: ; 3da79 (f:5a79)
	far_text _ThrashingAboutText
	done

AttackContinuesText: ; 3da7e (f:5a7e)
	far_text _AttackContinuesText
	done

CantMoveText: ; 3da83 (f:5a83)
	far_text _CantMoveText
	done

MoveIsDisabledText: ; 3daa8 (f:5aa8)
	far_text _MoveIsDisabledText
	done

SwapWhoseTurn:
	ld a,[H_WHOSETURN]
	inc a
	and %00000001	;swap the first bit
	ld [H_WHOSETURN], a
	ret
	
PrintMonName1Text: ; 3daf5 (f:5af5)
	ld hl,wEnemyMonInvisibilityCounter
	ld a, [H_WHOSETURN]
	and a
	jp z, .afterLoad		;skip down if players turn
	ld hl,wBattleMonInvisibilityCounter
.afterLoad
	ld a,[hl]
	and a	;invisible?
	jr z,.skipInvisible
	dec a
	ld [hl],a	;store new counter
	jr nz,.isInvisible	;continue if its not at zero
	ld hl,InvisibleNoMoreText
	jr .printInvisibleText
.isInvisible
	ld hl,IsInvisibleText
	;fall through
	
.printInvisibleText
	call PrintText
	;fall through
	
.skipInvisible
	ld hl, MonUsedText
	jp PrintText
	
MonUsedText:
	far_text _MonUsedText
	done

PrintMoveFailureText: ; 3dbe2 (f:5be2)
	ld de, wPlayerMoveEffect
	ld a, [H_WHOSETURN]
	and a
	jr z, .playersTurn
	ld de, wEnemyMoveEffect
.playersTurn
	ld a,[wBattleNoDamageText]
	and a
	jr nz,.additionalNoDamageText
	ld hl, DoesntAffectMonText
	ld a, [wDamageMultipliers]
	and $7f
	jr z, .gotTextToPrint
	ld hl, AttackMissedText
	ld a, [wCriticalHitOrOHKO]
	cp $ff
	jr nz, .gotTextToPrint
	ld hl, UnaffectedText
.gotTextToPrint
	push de
	call PrintText
.afterTextPrinted
	xor a
	ld [wCriticalHitOrOHKO], a
	pop de
	ld a, [de]
	cp JUMP_KICK_EFFECT
	ret nz

	; if you get here, the mon used jump kick or hi jump kick and missed
	ld hl, wDamage ; since the move missed, wDamage will always contain 0 at this point.
	                ; Thus, recoil damage will always be equal to 1
	                ; even if it was intended to be potential damage/8.
	ld a, [hli]
	ld b, [hl]
	srl a
	rr b
	srl a
	rr b
	srl a
	rr b
	ld [hl], b
	dec hl
	ld [hli], a
	or b
	jr nz, .applyRecoil
	inc a
	ld [hl], a
.applyRecoil
	ld hl, KeptGoingAndCrashedText
	call PrintText
	ld b, $4
	predef PredefShakeScreenHorizontally
	ld a, [H_WHOSETURN]
	and a
	jr nz, .enemyTurn
	jp ApplyDamageToPlayerPokemon
.enemyTurn
	jp ApplyDamageToEnemyPokemon
.additionalNoDamageText
	push de
	callab DisplayAdditionalNoDamageText
	jr .afterTextPrinted

AttackMissedText: ; 3dc42 (f:5c42)
	far_text _AttackMissedText
	done

KeptGoingAndCrashedText: ; 3dc47 (f:5c47)
	far_text _KeptGoingAndCrashedText
	done

UnaffectedText: ; 3dc4c (f:5c4c)
	far_text _UnaffectedText
	done

PrintDoesntAffectText: ; 3dc51 (f:5c51)
	ld hl, DoesntAffectMonText
	jp PrintText

DoesntAffectMonText: ; 3dc57 (f:5c57)
	far_text _DoesntAffectMonText
	done

; if there was a critical hit or an OHKO was successful, print the corresponding text
PrintCriticalOHKOText: ; 3dc5c (f:5c5c)
	ld a, [wCriticalHitOrOHKO]
	and a
	jr z, .done ; do nothing if there was no critical hit or successful OHKO
	dec a
	add a
	ld hl, CriticalOHKOTextPointers
	ld b, $0
	ld c, a
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call PrintText
	xor a
	ld [wCriticalHitOrOHKO], a
.done
	ld c, 20
	jp DelayFrames

CriticalOHKOTextPointers: ; 3dc7a (f:5c7a)
	dw CriticalHitText
	dw OHKOText

CriticalHitText: ; 3dc7e (f:5c7e)
	far_text _CriticalHitText
	done

OHKOText: ; 3dc83 (f:5c83)
	far_text _OHKOText
	done

; checks if a traded mon will disobey due to lack of badges
; stores whether the mon will use a move in Z flag
CheckForDisobedience: ; 3dc88 (f:5c88)
	xor a
	ld [wMonIsDisobedient], a
	ld a, [wLinkState]
	cp LINK_STATE_BATTLING
	jr nz, .checkIfMonIsTraded
	ld a, $1
	and a
	ret
; compare the mon's original trainer ID with the player's ID to see if it was traded
.checkIfMonIsTraded
	ld hl, wPartyMon1OTID
	ld bc, wPartyMon2 - wPartyMon1
	ld a, [wPlayerMonNumber]
	call AddNTimes
	ld a, [wPlayerID]
	cp [hl]
	jr nz, .monIsTraded
	inc hl
	ld a, [wPlayerID + 1]
	cp [hl]
	jp z, .canUseMove
; it was traded
.monIsTraded
; what level might disobey?
	ld hl, wObtainedBadges
	bit 7, [hl]
	ld a, 101
	jr nz, .next
	bit 5, [hl]
	ld a, 70
	jr nz, .next
	bit 3, [hl]
	ld a, 50
	jr nz, .next
	bit 1, [hl]
	ld a, 30
	jr nz, .next
	ld a, 10
.next
	ld b, a
	ld c, a
	ld a, [wBattleMonLevel]
	ld d, a
	add b
	ld b, a
	jr nc, .noCarry
	ld b, $ff ; cap b at $ff
.noCarry
	ld a, c
	cp d
	jp nc, .canUseMove
.loop1
	call BattleRandom
	swap a
	cp b
	jr nc, .loop1
	cp c
	jp c, .canUseMove
.loop2
	call BattleRandom
	cp b
	jr nc, .loop2
	cp c
	jr c, .useRandomMove
	ld a, d
	sub c
	ld b, a
	call BattleRandom
	swap a
	sub b
	jr c, .monNaps
	cp b
	jr nc, .monDoesNothing
	ld hl, WontObeyText
	call PrintText
	call HandleSelfConfusionDamage
	jp .cannotUseMove
.monNaps
	call BattleRandom
	and SLP ; sleep mask
	jr nz,.notSleepZero
	ld a,4		;if zero, set to 4
.notSleepZero
	ld hl,wBattleMonStatus
	or [hl]
	ld [hl],a
	ld hl, BeganToNapText
	jr .printText
.monDoesNothing
	call BattleRandom
	and $3
	ld hl, LoafingAroundText
	and a
	jr z, .printText
	ld hl, WontObeyText
	dec a
	jr z, .printText
	ld hl, TurnedAwayText
	dec a
	jr z, .printText
	ld hl, IgnoredOrdersText
.printText
	call PrintText
	jr .cannotUseMove
.useRandomMove
	ld a, [wBattleMonMoves + 1]
	and a ; is the second move slot empty?
	jr z, .monDoesNothing ; mon will not use move if it only knows one move
	ld a, [wPlayerDisabledMoveNumber]
	and a
	jr nz, .monDoesNothing
; check if only one move has remaining PP
	ld hl, wBattleMonPP
	push hl
	ld a, [hli]
	and $3f
	ld b, a
	ld a, [hli]
	and $3f
	add b
	ld b, a
	ld a, [hli]
	and $3f
	add b
	ld b, a
	ld a, [hl]
	and $3f
	add b
	pop hl
	push af
	ld a, [wCurrentMenuItem]
	ld c, a
	ld b, $0
	add hl, bc
	ld a, [hl]
	and $3f
	ld b, a
	pop af
	cp b
	jr z, .monDoesNothing ; mon will not use move if only one move has remaining PP
	ld a, $1
	ld [wMonIsDisobedient], a
	ld a, [wMaxMenuItem]
	ld b, a
	ld a, [wCurrentMenuItem]
	ld c, a
.chooseMove
	call BattleRandom
	and $3
	cp b
	jr nc, .chooseMove ; if the random number is greater than the move count, choose another
	cp c
	jr z, .chooseMove ; if the random number matches the move the player selected, choose another
	ld [wCurrentMenuItem], a
	ld hl, wBattleMonPP
	ld e, a
	ld d, $0
	add hl, de
	ld a, [hl]
	and a ; does the move have any PP left?
	jr z, .chooseMove ; if the move has no PP left, choose another
	ld a, [wCurrentMenuItem]
	ld c, a
	ld b, $0
	ld hl, wBattleMonMoves
	add hl, bc
	ld a, [hl]
	ld [wPlayerSelectedMove], a
	call GetCurrentMove
.canUseMove
	ld a, $1
	and a; clear Z flag
	ret
.cannotUseMove
	xor a ; set Z flag
	ret

LoafingAroundText: ; 3ddb6 (f:5db6)
	far_text _LoafingAroundText
	done

BeganToNapText: ; 3ddbb (f:5dbb)
	far_text _BeganToNapText
	done

WontObeyText: ; 3ddc0 (f:5dc0)
	far_text _WontObeyText
	done

TurnedAwayText: ; 3ddc5 (f:5dc5)
	far_text _TurnedAwayText
	done

IgnoredOrdersText: ; 3ddca (f:5dca)
	far_text _IgnoredOrdersText
	done

; sets b, c, d, and e for the CalculateDamage routine in the case of an attack by the player mon
GetDamageVarsForPlayerAttack: ; 3ddcf (f:5dcf)
	xor a
	ld hl, wDamage ; damage to eventually inflict, initialise to zero
	ldi [hl], a
	ld [hl], a
	ld hl, wPlayerMovePower
	ld a, [hli]
	and a
	ld d, a ; d = move power
	ret z ; return if move power is zero
	push de
	callab IsPlayerAttackPhysical	;is the player attack physical?
	pop de
	jr nc, .specialAttack		;if not, then load special 
.physicalAttack
	ld hl, wEnemyMonDefense
	ld a, [hli]
	ld b, a
	ld c, [hl] ; bc = enemy defense
	ld a, [wEnemyBattleStatus3]
	bit HasReflectUp, a ; check for Reflect
	call nz, DoubleBCUpTo999 ;if the enemy has used Reflect, double the enemy's defense
.physicalAttackCritCheck
	ld hl, wBattleMonAttack
	jr .scaleStats
.specialAttack
	ld hl, wEnemyMonSpecialDefense
	ld a, [hli]
	ld b, a
	ld c, [hl] ; bc = enemy special defense
	ld a, [wEnemyBattleStatus3]
	bit HasLightScreenUp, a ; check for Light Screen
	call nz, DoubleBCUpTo999 ; if the enemy has used Light Screen, double the enemy's special
	ld hl, wBattleMonSpecial
	;fall through
	
; if either the offensive or defensive stat is too large to store in a byte, scale both stats by dividing them by 4
; this allows values with up to 10 bits (values up to 1023) to be handled
; anything larger will wrap around
.scaleStats
	ld a, [hli]
	ld l, [hl]
	ld h, a ; hl = player's offensive stat
	or b ; is either high byte nonzero?
	jr z, .next ; if not, we don't need to scale
; bc /= 4 (scale enemy's defensive stat)
	call DivideBCBy4AndNonZero
; hl /= 4 (scale player's offensive stat)
	srl h
	rr l
	srl h
	rr l
	ld a, l
	or h ; is the player's offensive stat 0?
	jr nz, .next
	inc l ; if the player's offensive stat is 0, bump it up to 1
.next
	ld b, l ; b = player's offensive stat (possibly scaled)
	        ; (c already contains enemy's defensive stat (possibly scaled))
	ld a, [wBattleMonLevel]
	ld e, a ; e = level
	ld a, [wCriticalHitOrOHKO]
	and a ; check for critical hit
	jr z, .done
	sla e ; double level if it was a critical hit
.done
	ld a, 1
	and a
	ret
	
;to double bc, but not exceed 999
DoubleBCUpTo999:
	push af
	sla c
	rl b
	ld a,b
	cp 4
	jr nc,.setTo999	;over over 3, then set to 999
	cp 3
	jr nz,.finish		;if not 3, then finish
	ld a,c
	cp $e8
	jr c,.finish		;if under $3e8, then finish
.setTo999
	ld bc,999
.finish
	pop af
	ret
	
;to divide bc by 4 and make sure its non zero
DivideBCBy4AndNonZero:
	push af
	srl b
	rr c
	srl b
	rr c
	ld a,b
	or c
	jr nz,.finish		;finish if not zero
	inc c		;set to 1 if it was zero
.finish
	pop af
	ret

; sets b, c, d, and e for the CalculateDamage routine in the case of an attack by the enemy mon
GetDamageVarsForEnemyAttack: ; 3de75 (f:5e75)
	ld hl, wDamage ; damage to eventually inflict, initialise to zero
	xor a
	ld [hli], a
	ld [hl], a
	ld hl, wEnemyMovePower
	ld a, [hli]
	ld d, a ; d = move power
	and a
	ret z ; return if move power is zero
	push de
	callab IsEnemyAttackPhysical
	pop de
	jr nc, .specialAttack		;run special attack if so
.physicalAttack
	ld hl, wBattleMonDefense
	ld a, [hli]
	ld b, a
	ld c, [hl] ; bc = player defense
	ld a, [wPlayerBattleStatus3]
	bit HasReflectUp, a ; check for Reflect
	call nz, DoubleBCUpTo999 ; if the player has used Reflect, double the player's defense (dont go over 999)
	ld hl, wEnemyMonAttack
	jr .scaleStats
.specialAttack
	ld hl, wBattleMonSpecialDefense
	ld a, [hli]
	ld b, a
	ld c, [hl]
	ld a, [wPlayerBattleStatus3]
	bit HasLightScreenUp, a ; check for Light Screen
	call nz, DoubleBCUpTo999 ; if the player has used Light Screen, double the player's special
	ld hl, wEnemyMonSpecial
	;fall through
	
; if either the offensive or defensive stat is too large to store in a byte, scale both stats by dividing them by 4
; this allows values with up to 10 bits (values up to 1023) to be handled
; anything larger will wrap around
.scaleStats
	ld a, [hli]
	ld l, [hl]
	ld h, a ; hl = enemy's offensive stat
	or b ; is either high byte nonzero?
	jr z, .next ; if not, we don't need to scale
; bc /= 4 (scale player's defensive stat)
	call DivideBCBy4AndNonZero
; hl /= 4 (scale enemy's offensive stat)
	srl h
	rr l
	srl h
	rr l
	ld a, l
	or h ; is the enemy's offensive stat 0?
	jr nz, .next
	inc l ; if the enemy's offensive stat is 0, bump it up to 1
.next
	ld b, l ; b = enemy's offensive stat (possibly scaled)
	        ; (c already contains player's defensive stat (possibly scaled))
	ld a, [wEnemyMonLevel]
	ld e, a
	ld a, [wCriticalHitOrOHKO]
	and a ; check for critical hit
	jr z, .done
	sla e ; double level if it was a critical hit
.done
	ld a, $1
	and a
	ret

CalculateDamage: ; 3df65 (f:5f65)
; input:
;	b: attack
;	c: opponent defense
;	d: base power
;	e: level

	ld a, [H_WHOSETURN] ; whose turn?
	and a
	ld a, [wPlayerMoveEffect]
	jr z, .effect
	ld a, [wEnemyMoveEffect]
.effect

; EXPLODE_EFFECT halves defense.
	cp a, EXPLODE_EFFECT
	jr nz, .ok
	srl c
	jr nz, .ok
	inc c ; ...with a minimum value of 1 (used as a divisor later on)
.ok

; Multi-hit attacks may or may not have 0 bp.
	cp a, TWO_TO_FIVE_ATTACKS_EFFECT
	jr z, .skipbp
	cp a, $1e
	jr z, .skipbp

; Calculate OHKO damage based on remaining HP.
	cp a, OHKO_EFFECT
	jp z, JumpToOHKOMoveEffect

; Don't calculate damage for moves that don't do any.
	ld a, d ; base power
	and a
	ret z
.skipbp
	ld hl,wBattleMonLearnedTraits
	ld a, [H_WHOSETURN] ; whose turn?
	and a
	jr z, .skipEnemySkills		;dont load enemy skills if player turn
	ld hl,wEnemyMonLearnedTraits
.skipEnemySkills
	bit BoostUnder60Skill,[hl]		;does the pokemon have the 'boost under 60' skill?
	jr z,.afterSkillCheck		;skip down if not
	ld a,d
	cp 61		;compare the attack base power to 61
	jr nc,.afterSkillCheck		;if the base power was over 60, then dont modify
	srl a	;divide by 2
	add d
	ld d,a		;d = d * 1.5	
.afterSkillCheck
	xor a
	ld hl, H_DIVIDEND
	ldi [hl], a
	ldi [hl], a
	ld [hl], a

; Multiply level by 2
	ld a, e ; level
	add a
	jr nc, .nc
	push af
	ld a, 1
	ld [hl], a
	pop af
.nc
	inc hl
	ldi [hl], a

; Divide by 5
	ld a, 5
	ldd [hl], a
	push bc
	ld b, 4
	call Divide
	pop bc

; Add 2
	inc [hl]
	inc [hl]

	inc hl ; multiplier

; Multiply by attack base power
	ld [hl], d
	call Multiply

; Multiply by attack stat
	ld [hl], b
	call Multiply

; Divide by defender's defense stat
	ld [hl], c
	ld b, 4
	call Divide

; Divide by 50
	ld [hl], 50
	ld b, 4
	call Divide

	ld hl, wDamage
	ld b, [hl]
	ld a, [H_QUOTIENT + 3]
	add b
	ld [H_QUOTIENT + 3], a
	jr nc, .asm_3dfd0

	ld a, [H_QUOTIENT + 2]
	inc a
	ld [H_QUOTIENT + 2], a
	and a
	jr z, .asm_3e004

.asm_3dfd0
	ld a, [H_QUOTIENT]
	ld b, a
	ld a, [H_QUOTIENT + 1]
	or a
	jr nz, .asm_3e004

	ld a, [H_QUOTIENT + 2]
	cp 998 / $100
	jr c, .asm_3dfe8
	cp 998 / $100 + 1
	jr nc, .asm_3e004
	ld a, [H_QUOTIENT + 3]
	cp 998 % $100
	jr nc, .asm_3e004

.asm_3dfe8
	inc hl
	ld a, [H_QUOTIENT + 3]
	ld b, [hl]
	add b
	ld [hld], a

	ld a, [H_QUOTIENT + 2]
	ld b, [hl]
	adc b
	ld [hl], a
	jr c, .asm_3e004

	ld a, [hl]
	cp 998 / $100
	jr c, .asm_3e00a
	cp 998 / $100 + 1
	jr nc, .asm_3e004
	inc hl
	ld a, [hld]
	cp 998 % $100
	jr c, .asm_3e00a

.asm_3e004
; cap at 997
	ld a, 997 / $100
	ld [hli], a
	ld a, 997 % $100
	ld [hld], a

.asm_3e00a
; add 2
	inc hl
	ld a, [hl]
	add 2
	ld [hld], a
	jr nc, .done
	inc [hl]

.done
; minimum damage is 1
	ld a, 1
	and a
	ret

JumpToOHKOMoveEffect: ; 3e016 (f:6016)
	call JumpMoveEffect
	ld a, [wMoveMissed]
	dec a
	ret
	
	
; high critical hit moves
HighCriticalMoves: ; 3e08e (f:608e)
	db KARATE_CHOP
	db RAZOR_LEAF
	db DRAGON_BREATH
	db SLASH
	db $FF

; determines if attack is a critical hit
; azure heights claims "the fastest pokémon (who are,not coincidentally,
; among the most popular) tend to CH about 20 to 25% of the time."
CriticalHitTest: ; 3e023 (f:6023)
	xor a
	ld [wCriticalHitOrOHKO], a
	ld a, [H_WHOSETURN]
	and a
	ld a, [wEnemyMonSpecies]
	jr nz, .asm_3e032
	ld a, [wBattleMonSpecies]
.asm_3e032
	ld [wd0b5], a
	call GetMonHeader
	ld a, [wMonHBaseSpeed]
	ld b, a
	srl b                        ; (effective (base speed/2))
	ld a, [H_WHOSETURN]
	and a
	ld hl, wPlayerMovePower
	ld de, wPlayerBattleStatus2
	jr z, .calcCriticalHitProbability
	ld hl, wEnemyMovePower
	ld de, wEnemyBattleStatus2
.calcCriticalHitProbability
	ld a, [hld]                  ; read base power from RAM
	and a
	ret z                        ; do nothing if zero
	dec hl
	ld c, [hl]                   ; read move id
	ld a, [de]
	bit GettingPumped, a         ; test for focus energy
	jr nz, .focusEnergyUsed      ; bug: using focus energy causes a shift to the right instead of left,
	                             ; resulting in 1/4 the usual crit chance
	sla b                        ; (effective (base speed/2)*2)
	jr nc, .noFocusEnergyUsed
	ld b, $ff                    ; cap at 255/256
	jr .noFocusEnergyUsed
.focusEnergyUsed
	srl b
.noFocusEnergyUsed
	ld hl, HighCriticalMoves     ; table of high critical hit moves
.Loop
	ld a, [hli]                  ; read move from move table
	cp c                         ; does it match the move about to be used?
	jr z, .HighCritical          ; if so, the move about to be used is a high critical hit ratio move
	inc a                        ; move on to the next move, FF terminates loop
	jr nz, .Loop                 ; check the next move in HighCriticalMoves
	srl b                        ; /2 for regular move (effective (base speed / 2))
	jr .SkipHighCritical         ; continue as a normal move
.HighCritical
	sla b                        ; *2 for high critical hit moves
	jr nc, .noCarry
	ld b, $ff                    ; cap at 255/256
.noCarry
	sla b                        ; *4 for high critical move (effective (base speed/2)*8))
	jr nc, .SkipHighCritical
	ld b, $ff
.SkipHighCritical
	call BattleRandom            ; generates a random value, in "a"
	rlc a
	rlc a
	rlc a
	cp b                         ; check a against calculated crit rate
	ret nc                       ; no critical hit if no borrow
	ld a, $1
	ld [wCriticalHitOrOHKO], a   ; set critical hit flag
	ret

; function to determine if Counter hits and if so, how much damage it does
HandleCounterMove: ; 3e093 (f:6093)
; The variables checked by Counter are updated whenever the cursor points to a new move in the battle selection menu.
; This is irrelevant for the opponent's side outside of link battles, since the move selection is controlled by the AI.
; However, in the scenario where the player switches out and the opponent uses Counter,
; the outcome may be affected by the player's actions in the move selection menu prior to switching the Pokemon.
; This might also lead to desync glitches in link battles.

	ld a,[H_WHOSETURN] ; whose turn
	and a
; player's turn
	ld hl,wEnemySelectedMove
	ld de,wEnemyMovePower
	ld a,[wPlayerSelectedMove]
	jr z,.next
; enemy's turn
	ld hl,wPlayerSelectedMove
	ld de,wPlayerMovePower
	ld a,[wEnemySelectedMove]
.next
	cp a,COUNTER
	ret nz ; return if not using Counter
	ld a,$01
	ld [wMoveMissed],a ; initialize the move missed variable to true (it is set to false below if the move hits)
	ld a,[hl]
	cp a,COUNTER
	ret z ; miss if the opponent's last selected move is Counter.
	ld a,[de]
	and a
	ret z ; miss if the opponent's last selected move's Base Power is 0.
; check if the move the target last selected was Normal or Fighting type
	inc de
	ld a,[de]
	and a ; normal type
	jr z,.counterableType
	cp a,FIGHTING
	jr z,.counterableType
; if the move wasn't Normal or Fighting type, miss
	xor a
	ret
.counterableType
	ld hl,wDamage
	ld a,[hli]
	or [hl]
	ret z ; If we made it here, Counter still misses if the last move used in battle did no damage to its target.
	      ; wDamage is shared by both players, so Counter may strike back damage dealt by the Counter user itself
	      ; if the conditions meet, even though 99% of the times damage will come from the target.
; if it did damage, double it
	ld a,[hl]
	add a
	ldd [hl],a
	ld a,[hl]
	adc a
	ld [hl],a
	jr nc,.noCarry
; damage is capped at 0xFFFF
	ld a,$ff
	ld [hli],a
	ld [hl],a
.noCarry
	xor a
	ld [wMoveMissed],a
	call MoveHitTest ; do the normal move hit test in addition to Counter's special rules
	xor a
	ret

ApplyAttackToEnemyPokemon: ; 3e0df (f:60df)
	ld a,[wPlayerMoveEffect]
	cp a,OHKO_EFFECT
	jr z,ApplyDamageToEnemyPokemon
	cp a,SUPER_FANG_EFFECT
	jr z,.superFangEffect
	cp a,SPECIAL_DAMAGE_EFFECT
	jr z,.specialDamage
	ld a,[wPlayerMovePower]
	and a
	jp z,ApplyAttackToEnemyPokemonDone ; no attack to apply if base power is 0
	jr ApplyDamageToEnemyPokemon
.superFangEffect
; set the damage to half the target's HP
	ld hl,wEnemyMonHP
	ld de,wDamage
	ld a,[hli]
	srl a
	ld [de],a
	inc de
	ld b,a
	ld a,[hl]
	rr a
	ld [de],a
	or b
	jr nz,ApplyDamageToEnemyPokemon
; make sure Super Fang's damage is always at least 1
	ld a,$01
	ld [de],a
	jr ApplyDamageToEnemyPokemon
.specialDamage
	ld hl,wBattleMonLevel
	ld a,[hl]
	ld b,a ; Seismic Toss deals damage equal to the user's level
	ld a,[wPlayerMoveNum]
	cp a,SEISMIC_TOSS
	jr z,.storeDamage
	cp a,NIGHT_SHADE
	jr z,.storeDamage
	ld b,SONICBOOM_DAMAGE ; 20
	cp a,SONICBOOM
	jr z,.storeDamage
	ld b,DRAGON_RAGE_DAMAGE ; 40
	cp a,DRAGON_RAGE
	jr z,.storeDamage
; Psywave
	ld a,[hl]
	ld b,a
	srl a
	add b
	ld b,a ; b = level * 1.5
; loop until a random number in the range [1, b) is found
	call BattleRandom
	jr .skipSubtract	;skip the sub b the first time
.loop
	sub a,b	;reduce the random value by b
.skipSubtract
	cp b
	jr nc,.loop ;if greater than or equal to b, then subtract b and try again
	and a
	jr nz,.skipZero	;if the random value was not zero, then dont increase
	inc a	;otherwise, increase to 1
.skipZero
	ld b,a
.storeDamage ; store damage value at b
	ld hl,wDamage
	xor a
	ld [hli],a
	ld a,b
	ld [hl],a

ApplyDamageToEnemyPokemon: ; 3e142 (f:6142)
	ld a,[wPlayerBattleStatus3]
	bit 6,a		;cursed?
	jr z,.enemyNotCursed	;skip down if not
	ld hl,wPreviousAttackDamage
	ld de,wDamage
	ld a,[de]
	cp a,[hl]	;compare current damage high to previous damage high
	inc hl
	inc de
	jr c,.enemyNotCursed	;if the previous damage was higher, then skip down
	jr nz,.enemyHigherCursed 	;if they are not equal, then we know the current damage is higher
	ld a,[de]
	ld b,a
	ld a,[hl]
	cp a,b	;compare previous damage low to current damage low
	jr nc,.enemyNotCursed	;if the current damage is less than or equal to previous damage, skip down
.enemyHigherCursed
	call BattleRandom
	cp a,$40	;25% chance of no effect
	jr c,.enemyNotCursed	;if random was less than $40, then no effect
	ld a,[hld]
	ld b,a	;store into b
	ld [de],a
	dec de
	ld a,[hl]
	ld [de],a		;set the current damage to the previous damage
	or b		;both zero?
	jr nz,.cursedNotZero
	ld a,1
	inc de
	ld [de],a		;otherwise, set to 1
.cursedNotZero
	ld hl,LimitedByCursedText
	call PrintText
	
.enemyNotCursed
	ld hl,wDamage
	ld a,[hli]
	ld b,a
	ld a,[hl]
	or b
	jr z,ApplyAttackToEnemyPokemonDone ; we're done if damage is 0
	ld a,[wEnemyBattleStatus2]
	bit HasSubstituteUp,a ; does the enemy have a substitute?
	jp nz,AttackSubstitute
	ld a,[wAdditionalBattleBits1]
	bit 0,a		;are we adding damage to the pokemon instead?
	jp nz,AddDamageToEnemyPokemon
; subtract the damage from the pokemon's current HP
; also, save the current HP at wHPBarOldHP
	ld a,[hld]
	ld b,a
	ld a,[wEnemyMonHP + 1]
	ld [wHPBarOldHP],a
	sub b
	ld [wEnemyMonHP + 1],a
	ld a,[hl]
	ld b,a
	ld a,[wEnemyMonHP]
	ld [wHPBarOldHP+1],a
	sbc b
	ld [wEnemyMonHP],a
	jr nc,.animateHpBar
; if more damage was done than the current HP, zero the HP and set the damage (wDamage)
; equal to how much HP the pokemon had before the attack
	ld a,[wHPBarOldHP+1]
	ld [hli],a
	ld a,[wHPBarOldHP]
	ld [hl],a
	xor a
	ld hl,wEnemyMonHP
	ld [hli],a
	ld [hl],a
.animateHpBar
	ld hl,wEnemyMonMaxHP
	ld a,[hli]
	ld [wHPBarMaxHP+1],a
	ld a,[hl]
	ld [wHPBarMaxHP],a
	ld hl,wEnemyMonHP
	ld a,[hli]
	ld [wHPBarNewHP+1],a
	ld a,[hl]
	ld [wHPBarNewHP],a
	coord hl, 2, 2
	xor a
	ld [wHPBarType],a
	predef UpdateHPBar2 ; animate the HP bar shortening
ApplyAttackToEnemyPokemonDone: ; 3e19d (f:619d)
	jp DrawHUDsAndHPBars

ApplyAttackToPlayerPokemon: ; 3e1a0 (f:61a0)
	ld a,[wEnemyMoveEffect]
	cp a,OHKO_EFFECT
	jr z,ApplyDamageToPlayerPokemon
	cp a,SUPER_FANG_EFFECT
	jr z,.superFangEffect
	cp a,SPECIAL_DAMAGE_EFFECT
	jr z,.specialDamage
	ld a,[wEnemyMovePower]
	and a
	jp z,ApplyAttackToPlayerPokemonDone
	jr ApplyDamageToPlayerPokemon
.superFangEffect
; set the damage to half the target's HP
	ld hl,wBattleMonHP
	ld de,wDamage
	ld a,[hli]
	srl a
	ld [de],a
	inc de
	ld b,a
	ld a,[hl]
	rr a
	ld [de],a
	or b
	jr nz,ApplyDamageToPlayerPokemon
; make sure Super Fang's damage is always at least 1
	ld a,$01
	ld [de],a
	jr ApplyDamageToPlayerPokemon
.specialDamage
	ld hl,wEnemyMonLevel
	ld a,[hl]
	ld b,a
	ld a,[wEnemyMoveNum]
	cp a,SEISMIC_TOSS
	jr z,.storeDamage
	cp a,NIGHT_SHADE
	jr z,.storeDamage
	ld b,SONICBOOM_DAMAGE
	cp a,SONICBOOM
	jr z,.storeDamage
	ld b,DRAGON_RAGE_DAMAGE
	cp a,DRAGON_RAGE
	jr z,.storeDamage
; Psywave
	ld a,[hl]
	ld b,a
	srl a
	add b
	ld b,a ; b = attacker's level * 1.5
; loop until a random number in the range [0, b) is found
; this differs from the range when the player attacks, which is [1, b)
; it's possible for the enemy to do 0 damage with Psywave, but the player always does at least 1 damage
	call BattleRandom
	jr .skipDown	;dont subtract b the first time
.loop
	sub a,b	;subtract b if it didn't carry the first time
.skipDown
	cp b
	jr nc,.loop
	and a
	jr nz,.notZero	;if not zero, then dont increase
	inc a		;otherwise, set minimum to 1
.notZero
	ld b,a
.storeDamage
	ld hl,wDamage
	xor a
	ld [hli],a
	ld a,b
	ld [hl],a

ApplyDamageToPlayerPokemon: ; 3e200 (f:6200)
	ld a,[wEnemyBattleStatus3]
	bit 6,a		;cursed?
	jr z,.notCursed
	ld hl,wPreviousAttackDamage
	ld de,wDamage
	ld a,[de]
	cp a,[hl]	;compare current damage high to previous damage high
	inc hl
	inc de
	jr c,.notCursed	;if the previous damage was higher, then skip down
	jr nz,.higherCursed	;if they are not equal, then we know the current one is higher
	ld a,[de]
	ld b,a
	ld a,[hl]
	cp a,b	;compare previous damage low to current damage low
	jr nc,.notCursed	;if the current damage is less than or equal to previous damage, skip down
.higherCursed
	call BattleRandom
	cp a,$40	;25% chance of no effect
	jr c,.notCursed	;if random was less than $40, then no effect
	ld a,[hld]
	ld b,a	;store into b
	ld [de],a
	dec de
	ld a,[hl]
	ld [de],a		;set the current damage to the previous damage
	or b		;both zero?
	jr nz,.enemyCursedNotZero
	ld a,1
	inc de
	ld [de],a	;otherwise, set to 1
.enemyCursedNotZero
	ld hl,LimitedByCursedText
	call PrintText
	
.notCursed
	ld hl,wDamage
	ld a,[hli]
	ld b,a
	ld a,[hl]
	or b
	jr z,ApplyAttackToPlayerPokemonDone ; we're done if damage is 0
	ld a,[wPlayerBattleStatus2]
	bit HasSubstituteUp,a ; does the player have a substitute?
	jp nz,AttackSubstitute
	ld a,[wAdditionalBattleBits1]
	bit 0,a		;are we adding damage to the pokemon instead?
	jp nz,AddDamageToPlayerPokemon
; subtract the damage from the pokemon's current HP
; also, save the current HP at wHPBarOldHP and the new HP at wHPBarNewHP
	ld a,[hld]
	ld b,a
	ld a,[wBattleMonHP + 1]
	ld [wHPBarOldHP],a
	sub b
	ld [wBattleMonHP + 1],a
	ld [wHPBarNewHP],a
	ld b,[hl]
	ld a,[wBattleMonHP]
	ld [wHPBarOldHP+1],a
	sbc b
	ld [wBattleMonHP],a
	ld [wHPBarNewHP+1],a
	jr nc,.animateHpBar
; if more damage was done than the current HP, zero the HP and set the damage (wDamage)
; equal to how much HP the pokemon had before the attack
	ld a,[wHPBarOldHP+1]
	ld [hli],a
	ld a,[wHPBarOldHP]
	ld [hl],a
	xor a
	ld hl,wBattleMonHP
	ld [hli],a
	ld [hl],a
	ld hl,wHPBarNewHP
	ld [hli],a
	ld [hl],a
.animateHpBar
	ld hl,wBattleMonMaxHP
	ld a,[hli]
	ld [wHPBarMaxHP+1],a
	ld a,[hl]
	ld [wHPBarMaxHP],a
	coord hl, 10, 9
	ld a,$01
	ld [wHPBarType],a
	predef UpdateHPBar2 ; animate the HP bar shortening
ApplyAttackToPlayerPokemonDone
	jp DrawHUDsAndHPBars

AttackSubstitute: ; 3e25e (f:625e)
; Unlike the two ApplyAttackToPokemon functions, Attack Substitute is shared by player and enemy.
; Self-confusion damage as well as Hi-Jump Kick and Jump Kick recoil cause a momentary turn swap before being applied.
; If the user has a Substitute up and would take damage because of that,
; damage will be applied to the other player's Substitute.
; Normal recoil such as from Double-Edge isn't affected by this glitch,
; because this function is never called in that case.

	ld hl,SubstituteTookDamageText
	call PrintText
; values for player turn
	ld de,wEnemySubstituteHP
	ld bc,wEnemyBattleStatus2
	ld a,[H_WHOSETURN]
	and a
	jr z,.applyDamageToSubstitute
; values for enemy turn
	ld de,wPlayerSubstituteHP
	ld bc,wPlayerBattleStatus2
.applyDamageToSubstitute
	ld hl,wDamage
	ld a,[hli]
	and a
	jr nz,.substituteBroke ; damage > 0xFF always breaks substitutes
; subtract damage from HP of substitute
	ld a,[de]
	sub [hl]
	ld [de],a
	ret nc
.substituteBroke
; If the target's Substitute breaks, wDamage isn't updated with the amount of HP
; the Substitute had before being attacked.
	ld h,b
	ld l,c
	res HasSubstituteUp,[hl] ; unset the substitute bit
	ld hl,SubstituteBrokeText
	call PrintText
; flip whose turn it is for the next function call
	ld a,[H_WHOSETURN]
	xor a,$01
	ld [H_WHOSETURN],a
	callab HideSubstituteShowMonAnim ; animate the substitute breaking
; flip the turn back to the way it was
	ld a,[H_WHOSETURN]
	xor a,$01
	ld [H_WHOSETURN],a
	ld hl,wPlayerMoveEffect ; value for player's turn
	and a
	jr z,.nullifyEffect
	ld hl,wEnemyMoveEffect ; value for enemy's turn
.nullifyEffect
	xor a
	ld [hl],a ; zero the effect of the attacker's move
	jp DrawHUDsAndHPBars

SubstituteTookDamageText: ; 3e2ac (f:62ac)
	far_text _SubstituteTookDamageText
	done

SubstituteBrokeText: ; 3e2b1 (f:62b1)
	far_text _SubstituteBrokeText
	done

; this function raises the attack modifier of a pokemon using Rage when that pokemon is attacked
HandleBuildingRage: ; 3e2b6 (f:62b6)
; values for the player turn
	ld hl,wEnemyBattleStatus2
	ld de,wEnemyMonStatMods
	ld bc,wEnemyMoveNum
	ld a,[H_WHOSETURN]
	and a
	jr z,.next
; values for the enemy turn
	ld hl,wPlayerBattleStatus2
	ld de,wPlayerMonStatMods
	ld bc,wPlayerMoveNum
.next
	bit UsingRage,[hl] ; is the pokemon being attacked under the effect of Rage?
	ret z ; return if not
	ld a,[de]
	cp a,$0d ; maximum stat modifier value
	ret z ; return if attack modifier is already maxed
	ld a,[H_WHOSETURN]
	xor a,$01 ; flip turn for the stat modifier raising function
	ld [H_WHOSETURN],a
; temporarily change the target pokemon's move to $00 and the effect to the one
; that causes the attack modifier to go up one stage
	ld h,b
	ld l,c
	ld [hl],$00 ; null move number
	inc hl
	ld [hl],ATTACK_UP1_EFFECT
	push hl
	ld hl,BuildingRageText
	call PrintText
	call StatModifierUpEffect ; stat modifier raising function
	pop hl
	xor a
	ldd [hl],a ; null move effect
	ld a,RAGE
	ld [hl],a ; restore the target pokemon's move number to Rage
	ld a,[H_WHOSETURN]
	xor a,$01 ; flip turn back to the way it was
	ld [H_WHOSETURN],a
	ret

BuildingRageText: ; 3e2f8 (f:62f8)
	far_text _BuildingRageText
	done

; copy last move for Mirror Move
; sets zero flag on failure and unsets zero flag on success
MirrorMoveCopyMove: ; 3e2fd (f:62fd)
; Mirror Move makes use of ccf1 (wPlayerUsedMove) and ccf2 (wEnemyUsedMove) addresses,
; which are mainly used to print the "[Pokemon] used [Move]" text.
; Both are set to 0 whenever a new Pokemon is sent out
; ccf1 is also set to 0 whenever the player is fast asleep or frozen solid.
; ccf2 is also set to 0 whenever the enemy is fast asleep or frozen solid.

	ld a,[H_WHOSETURN]
	and a
; values for player turn
	ld a,[wEnemyUsedMove]
	ld hl,wPlayerSelectedMove
	ld de,wPlayerMoveNum
	jr z,.next
; values for enemy turn
	ld a,[wPlayerUsedMove]
	ld de,wEnemyMoveNum
	ld hl,wEnemySelectedMove
.next
	ld [hl],a
	cp a,MIRROR_MOVE ; did the target Pokemon last use Mirror Move, and miss?
	jr z,.mirrorMoveFailed
	and a ; has the target selected any move yet?
	jr nz,ReloadMoveData
.mirrorMoveFailed
	ld hl,MirrorMoveFailedText
	call PrintText
	xor a
	ret

MirrorMoveFailedText: ; 3e324 (f:6324)
	far_text _MirrorMoveFailedText
	done

; function used to reload move data for moves like Mirror Move and Metronome
ReloadMoveData: ; 3e329 (f:6329)
	ld [wd11e],a
	dec a
	ld hl,Moves
	ld bc,MoveEnd - Moves
	call AddNTimes
	ld a,BANK(Moves)
	call FarCopyData ; copy the move's stats
	call IncrementMovePP
; the follow two function calls are used to reload the move name
	call GetMoveName
	call CopyStringToCF4B
	ld a,$01
	and a
	ret

; function that picks a random move for metronome
MetronomePickMove: ; 3e348 (f:6348)
	xor a
	ld [wAnimationType],a
	ld a,METRONOME
	call PlayMoveAnimation ; play Metronome's animation
; values for player turn
	ld de,wPlayerMoveNum
	ld hl,wPlayerSelectedMove
	ld a,[H_WHOSETURN]
	and a
	jr z,.pickMoveLoop
; values for enemy turn
	ld de,wEnemyMoveNum
	ld hl,wEnemySelectedMove
; loop to pick a random number in the range [1, $a5) to be the move used by Metronome
.pickMoveLoop
	call BattleRandom
	and a
	jr z,.pickMoveLoop	;try again if zero
	cp a,METRONOME
	jr z,.pickMoveLoop	;try again if metronome
	ld [hl],a
	jr ReloadMoveData

; this function increments the current move's PP
; it's used to prevent moves that run another move within the same turn
; (like Mirror Move and Metronome) from losing 2 PP
IncrementMovePP: ; 3e373 (f:6373)
	ld a,[H_WHOSETURN]
	and a
; values for player turn
	ld hl,wBattleMonPP
	ld de,wPartyMon1PP
	ld a,[wPlayerMoveListIndex]
	jr z,.next
; values for enemy turn
	ld hl,wEnemyMonPP
	ld de,wEnemyMon1PP
	ld a,[wEnemyMoveListIndex]
.next
	ld b,$00
	ld c,a
	add hl,bc
	inc [hl] ; increment PP in the currently battling pokemon memory location
	ld h,d
	ld l,e
	add hl,bc
	ld a,[H_WHOSETURN]
	and a
	ld a,[wPlayerMonNumber] ; value for player turn
	jr z,.updatePP
	ld a,[wEnemyMonPartyPos] ; value for enemy turn
.updatePP
	ld bc,wEnemyMon2 - wEnemyMon1
	call AddNTimes
	inc [hl] ; increment PP in the party memory location
	ret

; some tests that need to pass for a move to hit
MoveHitTest: ; 3e56b (f:656b)
; player's turn
	ld hl,wEnemyBattleStatus1
	ld de,wPlayerMoveEffect
	ld bc,wEnemyMonStatus
	ld a,[H_WHOSETURN]
	and a
	jr z,.dreamEaterCheck
; enemy's turn
	ld hl,wPlayerBattleStatus1
	ld de,wEnemyMoveEffect
	ld bc,wBattleMonStatus
.dreamEaterCheck
	ld a,[de]
	cp a,DREAM_EATER_EFFECT
	jr nz,.swiftCheck
	ld a,[bc]
	and a,SLP ; is the target pokemon sleeping?
	jp z,.moveMissed
.swiftCheck
	ld a,[de]
	cp a,SWIFT_EFFECT
	ret z ; Swift never misses (interestingly, Azure Heights lists this is a myth, but it appears to be true)
	call CheckTargetSubstitute ; substitute check (note that this overwrites a)
	jr z,.checkForDigOrFlyStatus
; this code is buggy. it's supposed to prevent HP draining moves from working on substitutes.
; since $7b79 overwrites a with either $00 or $01, it never works.
	cp a,DRAIN_HP_EFFECT
	jp z,.moveMissed
	cp a,DREAM_EATER_EFFECT
	jp z,.moveMissed
.checkForDigOrFlyStatus
	bit Invulnerable,[hl]
	jp nz,.moveMissed
	ld a,[H_WHOSETURN]
	and a
	jr nz,.enemyTurn
.playerTurn
; this checks if the move effect is disallowed by mist
	ld a,[wPlayerMoveEffect]
	cp a,ATTACK_DOWN1_EFFECT
	jr c,.skipEnemyMistCheck
	cp a,HAZE_EFFECT + 1
	jr c,.enemyMistCheck
	cp a,ATTACK_DOWN2_EFFECT
	jr c,.skipEnemyMistCheck
	cp a,REFLECT_EFFECT + 1
	jr c,.enemyMistCheck
	jr .skipEnemyMistCheck
.enemyMistCheck
; if move effect is from $12 to $19 inclusive or $3a to $41 inclusive
; i.e. the following moves
; GROWL, TAIL WHIP, LEER, STRING SHOT, SAND-ATTACK, SMOKESCREEN, KINESIS,
; FLASH, CONVERSION*, HAZE*, SCREECH, LIGHT SCREEN*, REFLECT*
; the moves that are marked with an asterisk are not affected since this
; function is not called when those moves are used
	ld a,[wEnemyBattleStatus2]
	bit ProtectedByMist,a ; is mon protected by mist?
	jp nz,.moveMissed
.skipEnemyMistCheck
	ld a,[wPlayerBattleStatus2]
	bit UsingXAccuracy,a ; is the player using X Accuracy?
	ret nz ; if so, always hit regardless of accuracy/evasion
	jr .calcHitChance
.enemyTurn
	ld a,[wEnemyMoveEffect]
	cp a,ATTACK_DOWN1_EFFECT
	jr c,.skipPlayerMistCheck
	cp a,HAZE_EFFECT + 1
	jr c,.playerMistCheck
	cp a,ATTACK_DOWN2_EFFECT
	jr c,.skipPlayerMistCheck
	cp a,REFLECT_EFFECT + 1
	jr c,.playerMistCheck
	jr .skipPlayerMistCheck
.playerMistCheck
; similar to enemy mist check
	ld a,[wPlayerBattleStatus2]
	bit ProtectedByMist,a ; is mon protected by mist?
	jp nz,.moveMissed
.skipPlayerMistCheck
	ld a,[wEnemyBattleStatus2]
	bit UsingXAccuracy,a ; is the enemy using X Accuracy?
	ret nz ; if so, always hit regardless of accuracy/evasion
.calcHitChance
	call CalcHitChance ; scale the move accuracy according to attacker's accuracy and target's evasion
	ld a,[wPlayerMoveAccuracy]
	ld b,a
	ld a,[H_WHOSETURN]
	and a
	jr z,.doAccuracyCheck
	ld a,[wEnemyMoveAccuracy]
	ld b,a
.doAccuracyCheck
; if the random number generated is greater than or equal to the scaled accuracy, the move misses
; note that this means that even the highest accuracy is still just a 255/256 chance, not 100%
	call BattleRandom
	cp b
	jr nc,.moveMissed
	ret
.moveMissed
	xor a
	ld hl,wDamage ; zero the damage
	ld [hli],a
	ld [hl],a
	inc a
	ld [wMoveMissed],a
	ld a,[H_WHOSETURN]
	and a
	jr z,.playerTurn2
.enemyTurn2
	ld hl,wEnemyBattleStatus1
	res UsingTrappingMove,[hl] ; end multi-turn attack e.g. wrap
	ret
.playerTurn2
	ld hl,wPlayerBattleStatus1
	res UsingTrappingMove,[hl] ; end multi-turn attack e.g. wrap
	ret
	
	
;to see if the move has a better accuracy in the current weather:
CheckMoveAccuracyInWeather:
	push af
	push bc
	push hl
	ld bc,-4
	add hl,bc		;hl points to attack id
	ld a,[hl]
	ld c,a		;c = attack id
	ld hl,MovesWeatherAccuracyTable
	ld a,[wBattleWeather]
	ld b,a		;b = battle weather
.loop
	ld a,[hli]
	cp $FF		;end of table?
	jr z,.finish
	cp c		;attacks match?
	jr nz,.incHLandLoop
	ld a,[hl]
	cp b		;weather matches?
	jr z,.matchFound	;then store the new accuracy
.incHLandLoop
	inc hl
	inc hl
	jr .loop
.matchFound
	inc hl
	ld a,[hl]		;new accuracy
	pop hl
	ld [hl],a		;store new accuracy
	jr .finishSkipHL

.finish
	pop hl
.finishSkipHL
	pop bc
	pop af
	ret
	
;move, weather, new accuracy
MovesWeatherAccuracyTable:
	db TORNADO,WIND_STORM_WEATHER,98 percent
	db THUNDER,THUNDER_STORM_WEATHER,98 percent
	db BLIZZARD,SNOW_STORM_WEATHER,98 percent
	db $FF
	
;to temporaily alter the accuracy and evasion modifiers
AlterAccuracyAndEvasionModifiers:
	push de
	push hl
	ld a,[wBattleMonHeldItem]
	push af
	ld hl,wEnemyMonInvisibilityCounter
	ld a,[wBattleMonAbility1]
	ld d,a
	ld a,[wBattleMonAbility2]
	ld e,a
	ld a,[H_WHOSETURN]
	and a
	jr z,.skipEnemyInvisibility
	pop af
	ld a,[wEnemyMonHeldItem]
	push af
	ld hl,wBattleMonInvisibilityCounter
	ld a,[wEnemyMonAbility1]
	ld d,a
	ld a,[wEnemyMonAbility2]
	ld e,a
.skipEnemyInvisibility
	ld a,[hl]		;load the counter into a
	and a
	jr z,.skipInvisible
	ld c,13		;set the evasion counter to the max if invisible
.skipInvisible
	pop af		;retrieve the held item
	cp GOGGLES	;holding goggles?
	jr z,.afterWeather		;then unaffected by the weather
	ld a,[wBattleWeather]
	and a
	jr z,.afterWeather
	;pokemon with AB_SEE_THROUGH are not physically affected by the weather
	ld a, AB_SEE_THROUGH
	cp d
	jr z,.afterWeather
	cp e
	jr z,.afterWeather
	
	dec b		;decrease the accuracy
	jr nz,.afterWeather	;if its not zero, then skip down
	inc b		;set back to 1
.afterWeather
	push bc
	push de
	;night time & outdoor decrease accuracy, unless ability is AB_NOCTURNAL
	callab IsLandscapeOutdoor
	pop de
	pop bc
	jr nc,.afterDayNight
	ld a,[wBattleEnvironment]
	bit TemporaryTimeBit,a			;is the day/night reversed?
	jr z,.notTemporary		;skip down if not
	inc a		;swap the first bit if so
.notTemporary
	bit NightTimeBit,a
	jr z,.afterDayNight		;if not nighttime, then skip down
	ld a, AB_NOCTURNAL
	cp d
	jr z,.afterDayNight
	cp e
	jr z,.afterDayNight
	
	dec b		;decrease the accuracy
	jr nz,.afterDayNight	;if its not zero, then skip down
	inc b		;set back to 1
	
.afterDayNight
	ld hl,wBattleMonLearnedTraits
	ld de,wEnemyMonLearnedTraits
	ld a,[H_WHOSETURN]
	and a
	jr z,.skipEnemySkills		;skip down if players turn
	push de
	push hl
	pop de
	pop hl		;swap hl and de
.skipEnemySkills
	bit AccuracySkill,[hl]		;does the attacking pokemon have increased accuracy?
	jr z,.checkEvade		;skip down if not
	inc b		;increase the accuracy
	ld a,b
	cp 14		;is it maxxed out?
	jr nz,.checkEvade		;skip down if not
	dec b
.checkEvade
	ld a,[de]
	bit EvasionSkill,a		;does the defending pokemon have increased evade?
	jr z,.afterSkills		;skip down if not
	inc c		;incrase the evade
	ld a,c
	cp 14		;is it maxxed?
	jr nz,.afterSkills		;skip down if not
	dec c
.afterSkills
	ld hl,wBattleMonHeldItem
	ld de,wEnemyMonHeldItem
	ld a,[H_WHOSETURN]
	and a
	jr z,.skipEnemyHeldItem		;skip down if players turn
	push hl
	push de
	pop hl
	pop de
.skipEnemyHeldItem
	ld a,[hl]		;load attackers held item
	cp CLOVER		;is it CLOVER?
	jr nz,.checkHeldItemEvade		;skip down if not
	inc b		;increase the accuracy
	ld a,b
	cp 14		;is it maxxed out?
	jr nz,.checkHeldItemEvade		;skip down if not
	dec b
.checkHeldItemEvade
	ld a,[de]
	cp CAMOUFLAGE		;is defender holding CAMOUFLAGE?
	jr nz,.afterHeldItems		;skip down if not
	inc c		;incrase the evade
	ld a,c
	cp 14		;is it maxxed?
	jr nz,.afterHeldItems		;skip down if not
	dec c
.afterHeldItems
	pop hl
	pop de
	ret
	
; values for player turn
CalcHitChance: ; 3e624 (f:6624)
	ld hl,wPlayerMoveAccuracy
	ld a,[wPlayerMonAccuracyMod]
	ld b,a
	ld a,[wEnemyMonEvasionMod]
	ld c,a
	ld a,[H_WHOSETURN]
	and a
	jr z,.next
; values for enemy turn
	ld hl,wEnemyMoveAccuracy
	ld a,[wEnemyMonAccuracyMod]
	ld b,a
	ld a,[wPlayerMonEvasionMod]
	ld c,a
.next
	call CheckMoveAccuracyInWeather		;check the move num and see if the weather increases the accuracy
	call AlterAccuracyAndEvasionModifiers
	ld a,$0e
	sub c
	ld c,a ; c = 14 - EVASIONMOD (this "reflects" the value over 7, so that an increase in the target's evasion
	       ; decreases the hit chance instead of increasing the hit chance)
; zero the high bytes of the multiplicand
	xor a
	ld [H_MULTIPLICAND],a
	ld [H_MULTIPLICAND + 1],a
	ld a,[hl]
	ld [H_MULTIPLICAND + 2],a ; set multiplicand to move accuracy
	push hl
	ld d,$02 ; loop has two iterations
; loop to do the calculations, the first iteration multiplies by the accuracy ratio and
; the second iteration multiplies by the evasion ratio
.loop
	push bc
	ld hl, StatModifierRatios  ; stat modifier ratios
	dec b
	sla b
	ld c,b
	ld b,$00
	add hl,bc ; hl = address of stat modifier ratio
	pop bc
	ld a,[hli]
	ld [H_MULTIPLIER],a ; set multiplier to the numerator of the ratio
	call Multiply
	ld a,[hl]
	ld [H_DIVISOR],a ; set divisor to the the denominator of the ratio
	                 ; (the dividend is the product of the previous multiplication)
	ld b,$04 ; number of bytes in the dividend
	call Divide
	ld a,[H_QUOTIENT + 3]
	ld b,a
	ld a,[H_QUOTIENT + 2]
	or b
	jp nz,.nextCalculation
; make sure the result is always at least one
	ld [H_QUOTIENT + 2],a
	ld a,$01
	ld [H_QUOTIENT + 3],a
.nextCalculation
	ld b,c
	dec d
	jr nz,.loop
	ld a,[H_QUOTIENT + 2]
	and a ; is the calculated hit chance over 0xFF?
	ld a,[H_QUOTIENT + 3]
	jr z,.storeAccuracy
; if calculated hit chance over 0xFF
	ld a,$ff ; set the hit chance to 0xFF
.storeAccuracy
	pop hl
	ld [hl],a ; store the hit chance in the move accuracy variable
	ret

; multiplies damage by a random percentage from ~85% to 100%
RandomizeDamage: ; 3e687 (f:6687)
	ld hl, wDamage
	ld a, [hli]
	and a
	jr nz, .DamageGreaterThanOne
	ld a, [hl]
	cp 2
	ret c ; return if damage is equal to 0 or 1
.DamageGreaterThanOne
	xor a
	ld [H_MULTIPLICAND], a
	dec hl
	ld a, [hli]
	ld [H_MULTIPLICAND + 1], a
	ld a, [hl]
	ld [H_MULTIPLICAND + 2], a
; loop until a random number greater than or equal to 217 is generated
	call BattleRandom
	rrca
	jr .skipAdd	;dont add 39 the first time
.loop
	add a,39	;add 39 to the random value (255-216)
.skipAdd
	cp 217
	jr c, .loop
	ld [H_MULTIPLIER], a
	call Multiply ; multiply damage by the random number, which is in the range [217, 255]
	ld a, 255
	ld [H_DIVISOR], a
	ld b, $4
	call Divide ; divide the result by 255
; store the modified damage
	ld a, [H_QUOTIENT + 2]
	ld hl, wDamage
	ld [hli], a
	ld a, [H_QUOTIENT + 3]
	ld [hl], a
	ret

; for more detailed commentary, see equivalent function for player side (ExecutePlayerMove)
ExecuteEnemyMove: ; 3e6bc (f:66bc)
	ld a, [wEnemySelectedMove]
	inc a
	jp z, ExecuteEnemyMoveDone
	ld a, [wLinkState]
	cp LINK_STATE_BATTLING
	jr nz, .executeEnemyMove
	ld b, $1
	ld a, [wSerialExchangeNybbleReceiveData]
	cp $e
	jr z, .executeEnemyMove
	cp $4
	ret nc
.executeEnemyMove
	ld hl, wAILayer2Encouragement
	inc [hl]
	xor a
	ld [wMoveMissed], a
	ld [wMoveDidntMiss], a
	ld a, $a
	ld [wDamageMultipliers], a
	call CheckEnemyStatusConditions
	ld a,[wEnemySelectedMove]
	and a
	jp z,ExecuteEnemyMoveDone
	ld hl, wEnemyBattleStatus1
	bit ChargingUp, [hl] ; is the enemy charging up for attack?
	jr nz, EnemyCanExecuteChargingMove ; if so, jump
	call GetCurrentMove

CheckIfEnemyNeedsToChargeUp: ; 3e6fc (f:66fc)
	ld a, [wEnemyMoveEffect]
	cp CHARGE_EFFECT
	jp z, JumpMoveEffect
	cp FLY_EFFECT
	jp z, JumpMoveEffect
	jr EnemyCanExecuteMove
EnemyCanExecuteChargingMove: ; 3e70b (f:670b)
	ld hl, wEnemyBattleStatus1
	res ChargingUp, [hl] ; no longer charging up for attack
	res Invulnerable, [hl] ; no longer invulnerable to typical attacks
	ld a, [wEnemyMoveNum]
	ld [wd0b5], a
	ld a, BANK(MoveNames)
	ld [wPredefBank], a
	ld a, MOVE_NAME
	ld [wNameListType], a
	call GetName
	ld de, wcd6d
	call CopyStringToCF4B
EnemyCanExecuteMove: ; 3e72b (f:672b)
	callab DecrementEnemyPP
	xor a
	ld [wMonIsDisobedient], a
	call PrintMonName1Text
	ld a, [wEnemyMoveEffect]
	ld hl, ResidualEffects1
	ld de, $1
	call IsInArray
	jp c, JumpMoveEffect
	ld a, [wEnemyMoveEffect]
	ld hl, SpecialEffectsCont
	ld de, $1
	call IsInArray
	call c, JumpMoveEffect
EnemyCalcMoveDamage: ; 3e750 (f:6750)
	call SwapPlayerAndEnemyLevels
	ld a, [wEnemyMoveEffect]
	ld hl, SetDamageEffects
	ld de, $1
	call IsInArray
	jp c, EnemyMoveHitTest
	call CriticalHitTest
	call HandleCounterMove
	jr z, handleIfEnemyMoveMissed
	call SwapPlayerAndEnemyLevels
	call GetDamageVarsForEnemyAttack
	call SwapPlayerAndEnemyLevels
	call CalculateDamage
	jp z, EnemyCheckIfFlyOrChargeEffect
	call AdjustDamageForMoveType
	call RandomizeDamage

EnemyMoveHitTest: ; 3e77f (f:677f)
	call MoveHitTest
handleIfEnemyMoveMissed: ; 3e782 (f:6782)
	ld a, [wMoveMissed]
	and a
	jr z, .asm_3e791
	ld a, [wEnemyMoveEffect]
	cp EXPLODE_EFFECT
	jr z, asm_3e7a0
	jr EnemyCheckIfFlyOrChargeEffect
.asm_3e791
	call SwapPlayerAndEnemyLevels

GetEnemyAnimationType: ; 3e794 (f:6794)
	ld a, [wEnemyMoveEffect]
	and a
	ld a, $1
	jr z, playEnemyMoveAnimation
	ld a, $2
	jr playEnemyMoveAnimation
asm_3e7a0: ; 3e7a0 (f:67a0)
	call SwapPlayerAndEnemyLevels
	xor a
playEnemyMoveAnimation: ; 3e7a4 (f:67a4)
	push af
	ld a, [wEnemyBattleStatus2]
	bit HasSubstituteUp, a ; does mon have a substitute?
	ld hl, HideSubstituteShowMonAnim
	ld b, BANK(HideSubstituteShowMonAnim)
	call nz, Bankswitch
	pop af
	ld [wAnimationType], a
	ld a, [wEnemyMoveNum]
	call PlayMoveAnimation
	call HandleExplodingAnimation
	call DrawEnemyHUDAndHPBar
	ld a, [wEnemyBattleStatus2]
	bit HasSubstituteUp, a ; does mon have a substitute?
	ld hl, ReshowSubstituteAnim
	ld b, BANK(ReshowSubstituteAnim)
	call nz, Bankswitch ; slide the substitute's sprite out
	jr EnemyCheckIfMirrorMoveEffect

EnemyCheckIfFlyOrChargeEffect: ; 3e7d1 (f:67d1)
	call SwapPlayerAndEnemyLevels
	ld c, 30
	call DelayFrames
	ld a, [wEnemyMoveEffect]
	cp FLY_EFFECT
	jr z, .playAnim
	cp CHARGE_EFFECT
	jr z, .playAnim
	jr EnemyCheckIfMirrorMoveEffect
.playAnim
	xor a
	ld [wAnimationType], a
	ld a,STATUS_AFFECTED_ANIM
	call PlayNonMoveAnimation
EnemyCheckIfMirrorMoveEffect: ; 3e7ef (f:67ef)
	ld a, [wEnemyMoveEffect]
	cp MIRROR_MOVE_EFFECT
	jr nz, .notMirrorMoveEffect
	call MirrorMoveCopyMove
	jp z, ExecuteEnemyMoveDone
	jp CheckIfEnemyNeedsToChargeUp
.notMirrorMoveEffect
	cp METRONOME_EFFECT
	jr nz, .notMetronomeEffect
	call MetronomePickMove
	jp CheckIfEnemyNeedsToChargeUp
.notMetronomeEffect
	ld a, [wEnemyMoveEffect]
	ld hl, ResidualEffects2
	ld de, $1
	call IsInArray
	jp c, JumpMoveEffect
	ld a, [wMoveMissed]
	and a
	jr z, .asm_3e82b
	call PrintMoveFailureText
	ld a, [wEnemyMoveEffect]
	cp EXPLODE_EFFECT
	jr z, .asm_3e83e
	jp ExecuteEnemyMoveDone
.asm_3e82b
	call ApplyAttackToPlayerPokemon
	call PrintCriticalOHKOText
	callab DisplayEffectiveness
	ld a, 1
	ld [wMoveDidntMiss], a
.asm_3e83e
	ld a, [wEnemyMoveEffect]
	ld hl, AlwaysHappenSideEffects
	ld de, $1
	call IsInArray
	call c, JumpMoveEffect
	ld hl, wBattleMonHP
	ld a, [hli]
	ld b, [hl]
	or b
	ret z
	call HandleBuildingRage
	ld hl, wEnemyBattleStatus1
	bit AttackingMultipleTimes, [hl] ; is mon hitting multiple times? (example: double kick)
	jr z, .asm_3e873
	push hl
	ld hl, wEnemyNumAttacksLeft
	dec [hl]
	pop hl
	jp nz, GetEnemyAnimationType
	res AttackingMultipleTimes, [hl] ; mon is no longer hitting multiple times
	ld hl, HitXTimesText
	call PrintText
	xor a
	ld [wEnemyNumHits], a
.asm_3e873
	ld a, [wEnemyMoveEffect]
	and a
	jr z, ExecuteEnemyMoveDone
	ld hl, SpecialEffects
	ld de, $1
	call IsInArray
	call nc, JumpMoveEffect
	jr ExecuteEnemyMoveDone

HitXTimesText: ; 3e887 (f:6887)
	far_text _HitXTimesText
	done
	
ExecuteEnemyMoveDone: ; 3e88c (f:688c)
	ld b, $1
	ret

; checks for various status conditions affecting the enemy mon
; stores whether the mon cannot use a move this turn in Z flag
CheckEnemyStatusConditions: ; 3e88f (f:688f)
	ld hl,wEnemyMonStatus
	call CheckSleepStatus
	call CheckFrozenStatus
	ld hl,wPlayerBattleStatus1
	call CheckCantMoveStatus
	ld hl,wEnemyBattleStatus1
	ld de,wEnemyMonCursedFearCounter
	call CheckFlinchedStatus
	ld hl,wEnemyBattleStatus2
	call CheckRechargeStatus
	ld hl,wEnemyMonStatus
	call CheckParalysisStatus
	ld hl,wEnemyDisabledMove
	ld de,wEnemyDisabledMoveNumber
	call CheckAnyMoveDisabled
	ld hl,wEnemySelectedMove
	call CheckUseDisabledMove
	ld hl,EnemyMoveHaveEnoughPP
	ld de,wEnemyMoveNum
	call CheckHasEnoughEnergy
	ld hl,wEnemyMonCursedFearCounter
	call CheckFearStatus
	call CheckCursedStatus
	ld hl,wEnemyConfusedCounter
	call CheckConfusedStatus
	ld hl,wEnemyBattleStatus1
	bit StoringEnergy,[hl] ; is mon using bide?
	jr z,.notBideStatus
	ld de,wEnemyMoveNum
	push hl
	ld hl,wEnemyBideAccumulatedDamage + 1
	ld bc,wEnemyMovePower
	ld de,wEnemyBattleStatus1
	push hl
	push bc
	push de
	ld de,wEnemyMoveNum
	ld hl,wEnemyNumAttacksLeft
	ld bc,wEnemyBideAccumulatedDamage + 1
	jp ApplyBideStatus
.notBideStatus
	ld bc,wEnemyNumAttacksLeft
	bit ThrashingAbout,[hl] ; is mon using thrash or petal dance?
	jr z,.notThrashStatus
	push hl
	ld hl,wEnemyMoveNum
	ld de,wEnemyConfusedCounter
	jp ApplyThrashStatus
.notThrashStatus
	call CheckMultiturnMove
	ld de,wEnemyMoveEffect
	ld hl,wEnemyBattleStatus2
	call CheckRageStatus
	ret

GetCurrentMove: ; 3eabe (f:6abe)
	ld a, [H_WHOSETURN]
	and a
	jp z, .player
	ld de, wEnemyMoveNum
	ld a, [wEnemySelectedMove]
	jr .selected
.player
	ld de, wPlayerMoveNum
	ld a, [wFlags_D733]
	bit 0, a
	ld a, [wTestBattlePlayerSelectedMove]
	jr nz, .selected
	ld a, [wPlayerSelectedMove]
.selected
	ld [wd0b5], a
	dec a
	ld hl, Moves
	ld bc, $6
	call AddNTimes
	ld a, BANK(Moves)
	call FarCopyData

	ld a, BANK(MoveNames)
	ld [wPredefBank], a
	ld a, MOVE_NAME
	ld [wNameListType], a
	call GetName
	ld de, wcd6d
	jp CopyStringToCF4B

; calls BattleTransition to show the battle transition animation and initializes some battle variables
DoBattleTransitionAndInitBattleVariables: ; 3ec32 (f:6c32)
	ld a, [wLinkState]
	cp LINK_STATE_BATTLING
	jr nz, .next
; link battle
	xor a
	ld [wMenuJoypadPollCount], a
	callab DisplayLinkBattleVersusTextBox
	ld a, $1
	ld [wUpdateSpritesEnabled], a
	call ClearScreen
.next
	call DelayFrame
	predef BattleTransition
	callab LoadHudAndHpBarAndStatusTilePatterns
	ld a, $1
	ld [H_AUTOBGTRANSFERENABLED], a
	ld a, $ff
	ld [wUpdateSpritesEnabled], a
	call ClearSprites
	call ClearScreen
	xor a
	ld [H_AUTOBGTRANSFERENABLED], a
	ld [hWY], a
	ld [rWY], a
	ld [hTilesetType], a
	ld hl, wPlayerStatsToDouble
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ld [wPlayerDisabledMove], a
	ret

; swaps the level values of the BattleMon and EnemyMon structs
SwapPlayerAndEnemyLevels: ; 3ec81 (f:6c81)
	push bc
	ld a, [wBattleMonLevel]
	ld b, a
	ld a, [wEnemyMonLevel]
	ld [wBattleMonLevel], a
	ld a, b
	ld [wEnemyMonLevel], a
	pop bc
	ret

ScrollTrainerPicAfterBattle: ; 3ed12 (f:6d12)
	jpab _ScrollTrainerPicAfterBattle

ApplyBurnAndParalysisPenaltiesToPlayer: ; 3ed1a (f:6d1a)
	ld a, $1
	jr ApplyBurnAndParalysisPenalties

ApplyBurnAndParalysisPenaltiesToEnemy: ; 3ed1e (f:6d1e)
	xor a

ApplyBurnAndParalysisPenalties: ; 3ed1f (f:6d1f)
	ld [H_WHOSETURN], a
	call QuarterSpeedDueToParalysis
	jp HalveAttackDueToBurn

QuarterSpeedDueToParalysis: ; 3ed27 (f:6d27)
	ld de,wBattleMonStatus
	ld hl,wPlayerMonUnmodifiedSpeed + 1
	ld bc,wPlayerBattleStatus3
	ld a, [H_WHOSETURN]
	and a
	jr nz, .checkStatus	;check status
	ld de,wEnemyMonStatus
	ld hl,wEnemyMonUnmodifiedSpeed + 1
	ld bc,wEnemyBattleStatus3
.checkStatus
	ld a,[de]
	and 1 << PAR
	jr nz,.quarterStat	;quarter stat if paralyzed
	ld a,[bc]
	bit 6,a
	ret z		;return if not cursed
.quarterStat
	ld a, [hld]
	ld b, a
	ld a, [hl]
	srl a
	rr b
	srl a
	rr b
	ld [hli], a
	or b
	jr nz, .storeSpeed
	ld b, 1 ; give the stat a minimum of at least one speed point
.storeSpeed
	ld [hl], b
	ret

HalveAttackDueToBurn: ; 3ed64 (f:6d64)
	ld de,wBattleMonStatus
	ld hl, wPlayerMonUnmodifiedAttack + 1
	ld a, [H_WHOSETURN]
	and a
	jr nz, .checkStatus
	ld de,wEnemyMonStatus
	ld hl, wEnemyMonUnmodifiedAttack + 1
.checkStatus
	ld a, [de]
	and 1 << BRN
	ret z ; return if pokemon not burnt
	ld a, [hld]
	ld b, a
	ld a, [hl]
	srl a
	rr b
	ld [hli], a
	or b
	jr nz, .storeAttack
	ld b, 1 ; give the player a minimum of at least one attack point
.storeAttack
	ld [hl], b
	ret
		
;this is based on whose turn
CalcModStatsSavewD11E:
	ld a,[H_WHOSETURN]
	and a
	jr z,CalcPlayerModStatsSavewD11E
	;fall through if enemy turn
	
CalcEnemyModStatsSavewD11E:
	ld a,[wd11e]
	push af	;back up d11e
	ld a, 1 ;enemy stats
	ld [wd11e],a	;load whose turn into d11e
	call CalculateModifiedStats	;update the stats
	pop af
	ld [wd11e],a	;restore d11e
	ret
	
CalcPlayerModStatsSavewD11E:
	ld a,[wd11e]
	push af	;back up d11e
	ld a,0	;players stats
	ld [wd11e],a	;load whose turn into d11e
	call CalculateModifiedStats	;update the stats
	pop af
	ld [wd11e],a	;restore d11e
	ret

CalculateModifiedStats: ; 3ed99 (f:6d99)
	ld c, 0
.loop
	call CalculateModifiedStat
	inc c
	ld a, c
	cp 5
	jr nz, .loop
	ret

; calculate modified stat for stat c (0 = attack, 1 = defense, 2 = speed, 3 = special attack, 4 = special defense)
CalculateModifiedStat: ; 3eda5 (f:6da5)
	push bc
	ld a,c
	cp 4		;is it special defense?
	jr nz,.notSpecialDefense
	ld a, [wd11e]
	and a
	ld a,0		;set to 0 (we don't need to make any further pointer adjustments)
	ld c,a
	push bc		;save c
	ld hl, wBattleMonSpecialDefense
	ld de, wPlayerMonUnmodifiedSpecialDefense
	ld bc, wPlayerMonSpecialDefenseMod
	jr z, .next
	ld hl, wEnemyMonSpecialDefense
	ld de, wEnemyMonUnmodifiedSpecialDefense
	ld bc, wEnemyMonSpecialDefenseMod
	jr .next
.notSpecialDefense
	push bc
	ld a, [wCalculateWhoseStats]
	and a
	ld a, c
	ld hl, wBattleMonAttack
	ld de, wPlayerMonUnmodifiedAttack
	ld bc, wPlayerMonStatMods
	jr z, .next
	ld hl, wEnemyMonAttack
	ld de, wEnemyMonUnmodifiedAttack
	ld bc, wEnemyMonStatMods
.next
	add c
	ld c, a
	jr nc, .noCarry1
	inc b
.noCarry1
	ld a, [bc]
	pop bc
	ld b, a
	push bc
	sla c
	ld b, 0
	add hl, bc
	ld a, c
	add e
	ld e, a
	jr nc, .noCarry2
	inc d
.noCarry2
	pop bc
	push hl
	ld hl, StatModifierRatios
	dec b
	sla b
	ld c, b
	ld b, 0
	add hl, bc
	xor a
	ld [H_MULTIPLICAND], a
	ld a, [de]
	ld [H_MULTIPLICAND + 1], a
	inc de
	ld a, [de]
	ld [H_MULTIPLICAND + 2], a
	ld a, [hli]
	ld [H_MULTIPLIER], a
	call Multiply
	ld a, [hl]
	ld [H_DIVISOR], a
	ld b, $4
	call Divide
	pop hl
	ld a,[H_DIVIDEND + 1]
	and a
	jr nz,.capStatAt999		;if this is non-zero, then cap the stat at 999
	ld a,[H_DIVIDEND]
	and a
	jr nz,.capStatAt999		;if this is non-zero, then cap the stat at 999
	ld a, [H_DIVIDEND + 3]
	sub 999 % $100	;e7
	ld a, [H_DIVIDEND + 2]
	sbc 999 / $100	;3
	jp c, .storeNewStatValue
; cap the stat at 999
.capStatAt999
	ld a, 999 / $100
	ld [H_DIVIDEND + 2], a
	ld a, 999 % $100
	ld [H_DIVIDEND + 3], a
.storeNewStatValue
	ld a, [H_DIVIDEND + 2]
	ld [hli], a
	ld b, a
	ld a, [H_DIVIDEND + 3]
	ld [hl], a
	or b
	jr nz, .done
	inc [hl] ; if the stat is 0, bump it up to 1
.done
	pop bc
	ret

LoadHudAndHpBarAndStatusTilePatterns: ; 3ee58 (f:6e58)
	call LoadHpBarAndStatusTilePatterns

LoadHudTilePatterns: ; 3ee5b (f:6e5b)
	ld a, [rLCDC]
	add a ; is LCD disabled?
	jr c, .lcdEnabled
.lcdDisabled
	ld hl, BattleHudTiles1
	ld de, vChars2 + $6d0
	ld bc, BattleHudTiles1End - BattleHudTiles1
	ld a, BANK(BattleHudTiles1)
	call FarCopyDataDouble
	ld hl, BattleHudTiles2
	ld de, vChars2 + $730
	ld bc, BattleHudTiles3End - BattleHudTiles2
	ld a, BANK(BattleHudTiles2)
	jp FarCopyDataDouble
.lcdEnabled
	ld de, BattleHudTiles1
	ld hl, vChars2 + $6d0
	lb bc, BANK(BattleHudTiles1), (BattleHudTiles1End - BattleHudTiles1) / $8
	call CopyVideoDataDouble
	ld de, BattleHudTiles2
	ld hl, vChars2 + $730
	lb bc, BANK(BattleHudTiles2), (BattleHudTiles3End - BattleHudTiles2) / $8
	jp CopyVideoDataDouble

PrintEmptyString: ; 3ee94 (f:6e94)
	ld hl, .emptyString
	jp PrintText
.emptyString
	done


;to check to see if the current battle is occuring in replay mode
;returns nz if replay mode
IsReplayMode:
	ld hl,wAdditionalBattleTypeBits
	bit 4,[hl]		;is replay bit set?
	ret
	

BattleRandom:
; Link battles use a shared PRNG.
	ld a, [wLinkState]
	cp LINK_STATE_BATTLING
	jp z,.linkBattle	;link battle if so
	call Random
	jr .finish
.linkBattle
	push hl
	push bc
	ld a, [wLinkBattleRandomNumberListIndex]
	ld c, a
	ld b, 0
	ld hl, wLinkBattleRandomNumberList
	add hl, bc
	inc a
	ld [wLinkBattleRandomNumberListIndex], a
	cp 9
	ld a, [hl]
	pop bc
	pop hl
	ld [wBattleRandom],a	;store a (in case we ran this from a different bank)
	ret c

; if we picked the last seed, we need to recalculate the nine seeds
	push hl
	push bc
	push af

; point to seed 0 so we pick the first number the next time
	xor a
	ld [wLinkBattleRandomNumberListIndex], a

	ld hl, wLinkBattleRandomNumberList
	ld b, 9
.loop
	ld a, [hl]
	ld c, a
; multiply by 5
	add a
	add a
	add c
; add 1
	inc a
	ld [hli], a
	dec b
	jr nz, .loop

	pop af
	pop bc
	pop hl
	ld [wBattleRandom],a	;store a (in case we ran this from a different bank)
	ret
.finish
	ld [wBattleRandom],a	;store a (in case we ran this from a different bank)
	push bc
	push de
	push hl
	
	call IsReplayMode	;are we watching a replay?
	jr z,.storeRandom	;if not, then store the value to the SRAM
	call GetReplayValue	;get the next replay value
	jr .exit
.storeRandom
	call SaveReplayValue	;save the replay value that is in wBattleRandom
.exit
	ld a,[wBattleRandom]	;load the value into back a
	pop hl
	pop de
	pop bc
	ret

HandleExplodingAnimation: ; 3eed3 (f:6ed3)
	ld a, [H_WHOSETURN]
	and a
	ld hl, wEnemyMonType1
	ld de, wEnemyBattleStatus1
	ld a, [wPlayerMoveNum]
	jr z, .asm_3eeea
	ld hl, wBattleMonType1
	ld de, wEnemyBattleStatus1
	ld a, [wEnemyMoveNum]
.asm_3eeea
	cp SELFDESTRUCT
	jr z, .asm_3eef1
	cp EXPLOSION
	ret nz
.asm_3eef1
	ld a, [de]
	bit Invulnerable, a ; fly/dig
	ret nz
	ld a, [hli]
	cp GHOST
	ret z
	ld a, [hl]
	cp GHOST
	ret z
	ld a, [wMoveMissed]
	and a
	ret nz
	ld a, 5
	ld [wAnimationType], a

PlayMoveAnimation: ; 3ef07 (f:6f07)
	ld [wAnimationID],a
	call Delay3
	predef_jump MoveAnimation
			
PlayNonMoveAnimation:
	ld [wAnimationID],a
	call Delay3
	predef_jump NonMoveAnimation

InitBattle: ; 3ef12 (f:6f12)
	ld a, [wCurOpponent]
	and a
	jr z, DetermineWildOpponent

InitOpponent: ; 3ef18 (f:6f18)
	ld a, [wCurOpponent]
	ld [wcf91], a
	ld [wEnemyMonSpecies2], a
	jr InitBattleCommon

DetermineWildOpponent: ; 3ef23 (f:6f23)
	ld a, [wd732]
	bit 1, a
	jr z, .asm_3ef2f
	ld a, [hJoyHeld]
	bit 1, a ; B button pressed?
	ret nz
.asm_3ef2f
	ld a, [wNumberOfNoRandomBattleStepsLeft]
	and a
	ret nz
	callab TryDoWildEncounter
	ret nz
	callab AutoSaveHardMode		;autosave, if we are in hard mode
InitBattleCommon: ; 3ef3d (f:6f3d)
	ld a, [wMapPalOffset]
	push af
	ld hl, wLetterPrintingDelayFlags
	ld a, [hl]
	push af
	res 1, [hl]
	ld a,[wWhichScreen]
	push af
	ld a,BattleScreen
	ld [wWhichScreen],a
	callab InitBattleVariables
	ld a, [wEnemyMonSpecies2]
	sub 200		;this will cause a bug if we ever encounter a wild pokemon whose index is c8 or higher. but we shouldn't
	jp c, InitWildBattle
	ld [wTrainerClass], a
	call GetTrainerInformation
	callab ReadTrainer
	call DoBattleTransitionAndInitBattleVariables
	call _LoadTrainerPic
	xor a
	ld [wEnemyMonSpecies2], a
	ld [hStartTileID], a
	dec a
	ld [wAICount], a
	coord hl, 12, 0
	predef CopyUncompressedPicToTilemap
	ld a, $ff
	ld [wEnemyMonPartyPos], a
	ld a, $2
	ld [wIsInBattle], a
	jp _InitBattleCommon

InitWildBattle: ; 3ef8b (f:6f8b)
	ld a, $1
	ld [wIsInBattle], a
	ld a,[wTotems]
	bit IronTotem,a		;iron totem set?
	jr z,.notIronTotem	;dont double if not
	ld a,[wCurEnemyLVL]
	add a		;double
	ld [wCurEnemyLVL],a
.notIronTotem
	callab LoadEnemyMonData
	call DoBattleTransitionAndInitBattleVariables
	ld de, vFrontPic
	call LoadMonFrontSprite ; load mon sprite
.spriteLoaded
	xor a
	ld [wTrainerClass], a
	ld [hStartTileID], a
	coord hl, 12, 0
	predef CopyUncompressedPicToTilemap

; common code that executes after init battle code specific to trainer or wild battles
_InitBattleCommon: ; 3efeb (f:6feb)
	ld b, SET_PAL_BATTLE_BLACK
	call RunPaletteCommand
	callab SlidePlayerAndEnemySilhouettesOnScreen
	xor a
	ld [H_AUTOBGTRANSFERENABLED], a
	ld hl, .emptyString
	call PrintText
	call SaveScreenTilesToBuffer1	
	call ClearScreen
	ld a, $98
	ld [H_AUTOBGTRANSFERDEST + 1], a
	ld a, $1
	ld [H_AUTOBGTRANSFERENABLED], a
	call Delay3
	ld a, $9c
	ld [H_AUTOBGTRANSFERDEST + 1], a
	call LoadScreenTilesFromBuffer1
	coord hl, 9, 7
	lb bc, 5, 10
	call ClearScreenArea
	coord hl, 1, 0
	lb bc, 4, 10
	call ClearScreenArea
	call ClearSprites
	ld a, [wIsInBattle]
	dec a ; is it a wild battle?
	call z, DrawEnemyHUDAndHPBar ; draw enemy HUD and HP bar if it's a wild battle
	call StartBattle
	callab EndOfBattle
	
	pop af
	ld [wWhichScreen],a
	
	pop af
	ld [wLetterPrintingDelayFlags], a
	pop af
	ld [wMapPalOffset], a
	ld a, [wSavedTilesetType]
	ld [hTilesetType], a
	scf
	ret
.emptyString
	done

_LoadTrainerPic: ; 3f04b (f:704b)
; wd033-wd034 contain pointer to pic
	ld a, [wTrainerPicPointer]
	ld e, a
	ld a, [wTrainerPicPointer + 1]
	ld d, a ; de contains pointer to trainer pic
	ld a,[wTrainerClass]
	cp SONY1	;are we battling the rival?
	jr z,.checkTotem	;if so, then check the totem
	cp SONY2	;battle the 2nd rival trainer data?
	jr nz,.loadSprite	;if not, then load sprite
;otherwise, we are loading the rival pic, so check totem
.checkTotem
	ld a,[wTotems]
	bit RoleReversalTotem,a		;role reversal
	jr z,.loadSprite		;load the sprite if not
	ld hl,JamesPicFront
	ld a,l
	ld e,l
	ld [wTrainerPicPointer],a
	ld a,h
	ld d,h
	ld [wTrainerPicPointer + 1],a	;otherwise, save JamesPicFront instead
.loadSprite
	ld a, Bank(JamesPicFront)
	call UncompressSpriteFromDE
	ld de, vFrontPic
	ld a, $77
	ld c, a
	jp LoadUncompressedSpriteData

; unreferenced
ResetCryModifiers: ; 3f069 (f:7069)
	xor a
	ld [wFrequencyModifier], a
	ld [wTempoModifier], a
	jp PlaySound

; animates the mon "growing" out of the pokeball
AnimateSendingOutMon: ; 3f073 (f:7073)
	ld a, [wPredefRegisters]
	ld h, a
	ld a, [wPredefRegisters + 1]
	ld l, a
	ld a, [hStartTileID]
	ld [hBaseTileID], a
	ld b, $4c
	ld a, [wIsInBattle]
	and a
	jr z, .notInBattle
	add b
	ld [hl], a
	call Delay3
	ld bc, -(SCREEN_WIDTH * 2 + 1)
	add hl, bc
	ld a, 1
	ld [wDownscaledMonSize], a
	lb bc, 3, 3
	predef CopyDownscaledMonTiles
	ld c, 4
	call DelayFrames
	ld bc, -(SCREEN_WIDTH * 2 + 1)
	add hl, bc
	xor a
	ld [wDownscaledMonSize], a
	lb bc, 5, 5
	predef CopyDownscaledMonTiles
	ld c, 5
	call DelayFrames
	ld bc, -(SCREEN_WIDTH * 2 + 1)
	jr .next
.notInBattle
	ld bc, -(SCREEN_WIDTH * 6 + 3)
.next
	add hl, bc
	ld a, [hBaseTileID]
	add $31
	jr CopyUncompressedPicToHL
	
DrawEvoEggSprite:
	xor a
	coord hl, 7, 2
	call CopyUncompressedPicToHL
	xor a
	ld [wSpriteFlipped], a
	ret
	
CopyUncompressedPicToTilemap: ; 3f0c6 (f:70c6)
	ld a, [wPredefRegisters]
	ld h, a
	ld a, [wPredefRegisters + 1]
	ld l, a
	ld a, [hStartTileID]
CopyUncompressedPicToHL: ; 3f0d0 (f:70d0)
	lb bc, 7, 7
	ld de, SCREEN_WIDTH
	push af
	ld a, [wSpriteFlipped]
	and a
	jr nz, .flipped
	pop af
.loop
	push bc
	push hl
.innerLoop
	ld [hl], a
	add hl, de
	inc a
	dec c
	jr nz, .innerLoop
	pop hl
	inc hl
	pop bc
	dec b
	jr nz, .loop
	ret

.flipped
	push bc
	ld b, 0
	dec c
	add hl, bc
	pop bc
	pop af
.flippedLoop
	push bc
	push hl
.flippedInnerLoop
	ld [hl], a
	add hl, de
	inc a
	dec c
	jr nz, .flippedInnerLoop
	pop hl
	dec hl
	pop bc
	dec b
	jr nz, .flippedLoop
	ret

JumpMoveEffect: ; 3f132 (f:7132)
	call _JumpMoveEffect
	ld b, $1
	ret

_JumpMoveEffect: ; 3f138 (f:7138)
	ld a, [H_WHOSETURN]
	and a
	ld a, [wPlayerMoveEffect]
	jr z, .next1
	ld a, [wEnemyMoveEffect]
.next1
	dec a ; subtract 1, there is no special effect for 00
	add a ; x2, 16bit pointers
	ld hl, MoveEffectPointerTable
	ld b, 0
	ld c, a
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp [hl] ; jump to special effect handler

MoveEffectPointerTable: ; 3f150 (f:7150)
	 dw SleepEffect               ; unused effect
	 dw PoisonEffect              ; POISON_SIDE_EFFECT1
	 dw DrainHPEffect             ; DRAIN_HP_EFFECT
	 dw FreezeBurnParalyzeEffect  ; BURN_SIDE_EFFECT1
	 dw FreezeBurnParalyzeEffect  ; FREEZE_SIDE_EFFECT
	 dw FreezeBurnParalyzeEffect  ; PARALYZE_SIDE_EFFECT1
	 dw ExplodeEffect             ; EXPLODE_EFFECT
	 dw DrainHPEffect             ; DREAM_EATER_EFFECT
	 dw $0000                     ; MIRROR_MOVE_EFFECT
	 dw StatModifierUpEffect      ; ATTACK_UP1_EFFECT
	 dw StatModifierUpEffect      ; DEFENSE_UP1_EFFECT
	 dw StatModifierUpEffect      ; SPEED_UP1_EFFECT
	 dw StatModifierUpEffect      ; SPECIAL_UP1_EFFECT
	 dw StatModifierUpEffect      ; ACCURACY_UP1_EFFECT
	 dw StatModifierUpEffect      ; EVASION_UP1_EFFECT
	 dw PayDayEffect              ; PAY_DAY_EFFECT
	 dw $0000                     ; SWIFT_EFFECT
	 dw StatModifierDownEffect    ; ATTACK_DOWN1_EFFECT
	 dw StatModifierDownEffect    ; DEFENSE_DOWN1_EFFECT
	 dw StatModifierDownEffect    ; SPEED_DOWN1_EFFECT
	 dw StatModifierDownEffect    ; SPECIAL_DOWN1_EFFECT
	 dw StatModifierDownEffect    ; ACCURACY_DOWN1_EFFECT
	 dw StatModifierDownEffect    ; EVASION_DOWN1_EFFECT
	 dw ConversionEffect          ; CONVERSION_EFFECT
	 dw HazeEffect                ; HAZE_EFFECT
	 dw BideEffect                ; BIDE_EFFECT
	 dw ThrashPetalDanceEffect    ; THRASH_PETAL_DANCE_EFFECT
	 dw SwitchAndTeleportEffect   ; SWITCH_AND_TELEPORT_EFFECT
	 dw TwoToFiveAttacksEffect    ; TWO_TO_FIVE_ATTACKS_EFFECT
	 dw TwoToFiveAttacksEffect    ; unused effect
	 dw FlinchSideEffect           ; FLINCH_SIDE_EFFECT1
	 dw SleepEffect               ; SLEEP_EFFECT
	 dw PoisonEffect              ; POISON_SIDE_EFFECT2
	 dw FreezeBurnParalyzeEffect  ; BURN_SIDE_EFFECT2
	 dw FreezeBurnParalyzeEffect  ; unused effect
	 dw FreezeBurnParalyzeEffect  ; PARALYZE_SIDE_EFFECT2
	 dw FlinchSideEffect           ; FLINCH_SIDE_EFFECT2
	 dw OneHitKOEffect            ; OHKO_EFFECT
	 dw ChargeEffect              ; CHARGE_EFFECT
	 dw $0000                     ; SUPER_FANG_EFFECT
	 dw $0000                     ; SPECIAL_DAMAGE_EFFECT
	 dw TrappingEffect            ; TRAPPING_EFFECT
	 dw ChargeEffect              ; FLY_EFFECT
	 dw TwoToFiveAttacksEffect    ; ATTACK_TWICE_EFFECT
	 dw $0000                     ; JUMP_KICK_EFFECT
	 dw MistEffect                ; MIST_EFFECT
	 dw FocusEnergyEffect         ; FOCUS_ENERGY_EFFECT
	 dw RecoilEffect              ; RECOIL_EFFECT
	 dw ConfusionEffect           ; CONFUSION_EFFECT
	 dw StatModifierUpEffect      ; ATTACK_UP2_EFFECT
	 dw StatModifierUpEffect      ; DEFENSE_UP2_EFFECT
	 dw StatModifierUpEffect      ; SPEED_UP2_EFFECT
	 dw StatModifierUpEffect      ; SPECIAL_UP2_EFFECT
	 dw StatModifierUpEffect      ; ACCURACY_UP2_EFFECT
	 dw StatModifierUpEffect      ; EVASION_UP2_EFFECT
	 dw HealEffect                ; HEAL_EFFECT
	 dw TransformEffect           ; TRANSFORM_EFFECT
	 dw StatModifierDownEffect    ; ATTACK_DOWN2_EFFECT
	 dw StatModifierDownEffect    ; DEFENSE_DOWN2_EFFECT
	 dw StatModifierDownEffect    ; SPEED_DOWN2_EFFECT
	 dw StatModifierDownEffect    ; SPECIAL_DOWN2_EFFECT
	 dw StatModifierDownEffect    ; ACCURACY_DOWN2_EFFECT
	 dw StatModifierDownEffect    ; EVASION_DOWN2_EFFECT
	 dw ReflectLightScreenEffect  ; LIGHT_SCREEN_EFFECT
	 dw ReflectLightScreenEffect  ; REFLECT_EFFECT
	 dw PoisonEffect              ; POISON_EFFECT
	 dw ParalyzeEffect            ; PARALYZE_EFFECT
	 dw StatModifierDownEffect    ; ATTACK_DOWN_SIDE_EFFECT
	 dw StatModifierDownEffect    ; DEFENSE_DOWN_SIDE_EFFECT
	 dw StatModifierDownEffect    ; SPEED_DOWN_SIDE_EFFECT
	 dw StatModifierDownEffect    ; SPECIAL_DOWN_SIDE_EFFECT
	 dw StatModifierDownEffect    ; unused effect
	 dw StatModifierDownEffect    ; unused effect
	 dw StatModifierDownEffect    ; unused effect
	 dw StatModifierDownEffect    ; unused effect
	 dw ConfusionSideEffect       ; CONFUSION_SIDE_EFFECT
	 dw TwoToFiveAttacksEffect    ; TWINEEDLE_EFFECT
	 dw $0000                     ; unused effect
	 dw SubstituteEffect          ; SUBSTITUTE_EFFECT
	 dw HyperBeamEffect           ; HYPER_BEAM_EFFECT
	 dw RageEffect                ; RAGE_EFFECT
	 dw MimicEffect               ; MIMIC_EFFECT
	 dw $0000                     ; METRONOME_EFFECT
	 dw LeechSeedEffect           ; LEECH_SEED_EFFECT
	 dw SplashEffect              ; SPLASH_EFFECT
	 dw DisableEffect             ; DISABLE_EFFECT
	 dw ChangeWeatherEffect       ; CREATE_WEATHER_EFFECT
	 dw ChangeTimeEffect          ; NIGHT_EFFECT
	 dw EarthquakeEffect          ; EARTHQUAKE_EFFECT
	 dw TrapAndSlowEffect         ; TRAP_AND_SLOW_EFFECT
	 dw ChangeWeatherEffect       ; FORCE_NEW_WEATHER_EFFECT
	 dw ChangeLandscapeEffect     ; CHANGE_LANDSCAPE_EFFECT
	 dw ChangeLandscapeEffect     ; FORCE_CHANGE_LANDSCAPE_EFFECT
	 dw $0000                     ; unused effect
	 dw ChangeEnvironmentEffect   ; FORCE_CHANGE_ENVIRONMENT_EFFECT
	 dw $0000                     ; unused effect
	 dw FearEffect                ; INDUCE_FEAR_EFFECT
	 dw FearEffect                ; FORCE_INDUCE_FEAR_EFFECT
	 dw TwiceWithFlinchEffect     ; TWICE_WITH_FLINCH_EFFECT
	 dw NightAndHealEffect        ; NIGHT_AND_HEAL_EFFECT
	 dw ChangeEnvironmentEffect   ; ENVIRONMENT_AND_ATTACK_EFFECT
	 dw RadioactiveEffect         ; RADIOACTIVATE_EFFECT
	 dw $0000                     ; unused effect
	 dw InvisibilityEffect        ; INVISIBILITY_EFFECT
	 dw FlinchAndBoneEffect       ; FLINCH_AND_BONE_EFFECT
	 dw DecayEffect               ; DECAY_EFFECT
	 dw ChangeTimeEffect          ; DAY_EFFECT
	 dw FlytrapEffect             ; FLYTRAP_EFFECT
	 dw OcclumencyEffect          ; OCCLUMENCY_EFFECT
	 dw StatModifierUpEffect      ; INC_SPEC_ATTACK_EFFECT
	 dw StatModifierUpEffect      ; INC_SPEC_DEFENSE_EFFECT
	 dw WallEffect                ; WALL_EFFECT
	 dw HeatTreatEffect           ; HEAT_TREAT_EFFECT
	 dw $0000                     ; unused effect
	 dw CurseEffect               ; CURSE_EFFECT
	 dw CurseEffect               ; FORCE_CURSE_AND_ATTACK_EFFECT
	 dw FairyDustEffect           ; FAIRY_DUST_EFFECT
	 dw AdaptabilityEffect        ; ADAPTABILITY_EFFECT
	 dw StickyBombEffect          ; STICKY_BOMB_EFFECT
	 dw ChangeLandscapeEffect     ; CHANGE_LANDSCAPE_ATTACK_EFFECT
	 dw CloneEffect               ; CLONE_EFFECT
	 dw MoltEffect                ; MOLT_EFFECT
	 dw TripleAttackEffect        ; TRIPLE_PECK_EFFECT
	 dw TornadoEffect             ; TORNADO_EFFECT
	 dw MultiAftershocksEffect    ; MULTI_ATTACKS_AFTERSHOCKS_EFFECTS
     dw ChangeWeatherEffect       ; CHANGE_WEATHER_AND_ATTACK_EFFECTS
	 dw StatModifierDownEffect    ; DEC_SPEC_ATTACK_EFFECT
	 dw StatModifierDownEffect    ; DEC_SPEC_DEFENSE_EFFECT

SleepEffect: ; 3f1fc (f:71fc)
	ld de, wEnemyMonStatus
	ld bc, wEnemyBattleStatus2
	ld a, [H_WHOSETURN]
	and a
	jp z, .sleepEffect
	ld de, wBattleMonStatus
	ld bc, wPlayerBattleStatus2

.sleepEffect
	ld a, [de]
	ld b, a
	and $7
	jr z, .notAlreadySleeping ; can't affect a mon that is already asleep
	ld hl, AlreadyAsleepText
	jp PrintText
.notAlreadySleeping
	ld a, b
	and a
	jr nz, .didntAffect ; can't affect a mon that is already statused
	push de
	call MoveHitTest ; apply accuracy tests
	pop de
	ld a, [wMoveMissed]
	and a
	jr nz, .didntAffect
; set target's sleep counter to a random number between 1 and 7
	ld a,AB_INSOMNIA	;check to see if the pokemon has the insomnia ability
	call DoesDefenderHaveAbility
	and a
	jr z,.setSleepCounter	;if not, then skip down
	ld hl, InsomniaText2
	jp PrintText
.setSleepCounter
	ld a,[bc]
	res NeedsToRecharge, a ; target no longer needs to recharge
	ld [bc],a
	ld a,AB_EARLY_BIRD
	call DoesDefenderHaveAbility	;check to see if the pokemon has the early bird ability
	and a
	jr z,.getRandom	;get a random value if not
	ld a,1	;otherwise, set to 1
	jr .notZero	;and skip down
.getRandom
	call BattleRandom
	jr .skipSub	;dont subtract the first time
.loop
	sub a,7	;subtract 7 from the value
.skipSub
	cp 8	;compare to 8
	jr nc, .loop	;loop if it was 8 or greater
	and a
	jr nz,.notZero	;skip down if not zer
	inc a	;if zero, set to 1
.notZero	
	ld [de], a
	call PlayCurrentMoveAnimation2
	ld hl, FellAsleepText
	jp PrintText
.didntAffect
	jp PrintDidntAffectText

FellAsleepText: ; 3f245 (f:7245)
	far_text _FellAsleepText
	done

AlreadyAsleepText: ; 3f24a (f:724a)
	far_text _AlreadyAsleepText
	done

PoisonEffect: ; 3f24f (f:724f)
	ld hl, wEnemyMonStatus
	ld de, wPlayerMoveEffect
	ld a, [H_WHOSETURN]
	and a
	jr z, .poisonEffect
	ld hl, wBattleMonStatus
	ld de, wEnemyMoveEffect
.poisonEffect
	call CheckTargetSubstitute
	jr nz, .noEffect ; can't posion a substitute target
	ld a, [hli]
	ld b, a
	and a
	jr nz, .noEffect ; miss if target is already statused
	ld a, [hli]
	cp POISON ; can't posion a poison-type target
	jr z, .noEffect
	ld a, [hld]
	cp POISON ; can't posion a poison-type target
	jr z, .noEffect
	ld a, [de]
	cp POISON_SIDE_EFFECT1
	ld b, $34 ; ~20% chance of poisoning
	jr z, .sideEffectTest
	cp POISON_SIDE_EFFECT2
	ld b, $67 ; ~40% chance of poisoning
	jr z, .sideEffectTest
	push hl
	push de
	call MoveHitTest ; apply accuracy tests
	pop de
	pop hl
	ld a, [wMoveMissed]
	and a
	jr nz, .didntAffect
	jr .inflictPoison
.sideEffectTest
	call BattleRandom
	cp b ; was side effect successful?
	ret nc
.inflictPoison
	dec hl
	set 3, [hl] ; mon is now poisoned
	push de
	dec de
	ld a, [H_WHOSETURN]
	and a
	ld b, ANIM_C7
	ld hl, wPlayerBattleStatus3
	ld a, [de]
	ld de, wPlayerToxicCounter
	jr nz, .ok
	ld b, ANIM_A9
	ld hl, wEnemyBattleStatus3
	ld de, wEnemyToxicCounter
.ok
	cp TOXIC
	jr nz, .normalPoison ; done if move is not Toxic
	set BadlyPoisoned, [hl] ; else set Toxic battstatus
	xor a
	ld [de], a
	ld hl, BadlyPoisonedText
	jr .asm_3f2c0
.normalPoison
	ld hl, PoisonedText
.asm_3f2c0
	pop de
	ld a, [de]
	cp POISON_EFFECT
	jr z, .asm_3f2cd
	ld a, b
	call PlayBattleAnimation2
	jp PrintText
.asm_3f2cd
	call PlayCurrentMoveAnimation2
	jp PrintText
.noEffect
	ld a, [de]
	cp POISON_EFFECT
	ret nz
.didntAffect
	ld c, 50
	call DelayFrames
	jp PrintDidntAffectText

PoisonedText: ; 3f2df (f:72df)
	far_text _PoisonedText
	done

BadlyPoisonedText: ; 3f2e4 (f:72e4)
	far_text _BadlyPoisonedText
	done

DrainHPEffect: ; 3f2e9 (f:72e9)
	jpab DrainHPEffect_

ExplodeEffect: ; 3f2f1 (f:72f1)
	ld hl, wBattleMonHP
	ld de, wPlayerBattleStatus2
	ld a, [H_WHOSETURN]
	and a
	jr z, .faintUser
	ld hl, wEnemyMonHP
	ld de, wEnemyBattleStatus2
.faintUser
	xor a
	ld [hli], a ; set the mon's HP to 0
	ld [hli], a
	inc hl
	ld [hl], a ; set mon's status to 0
	ld a, [de]
	res Seeded, a ; clear mon's leech seed status
	ld [de], a
	ret

FreezeBurnParalyzeEffect: ; 3f30c (f:730c)
	xor a
	ld [wAnimationType], a
	call CheckTargetSubstitute ; test bit 4 of d063/d068 flags [target has substitute flag]
	ret nz ; return if they have a substitute, can't effect them
	ld a, [H_WHOSETURN]
	and a
	jp nz, opponentAttacker
	ld a, [wEnemyMonStatus]
	and a
	jp nz, CheckDefrost ; can't inflict status if opponent is already statused
	ld a, [wPlayerMoveType]
	ld b, a
	ld a, [wEnemyMonType1]
	cp b ; do target type 1 and move type match?
	ret z  ; return if they match (an ice move can't freeze an ice-type, body slam can't paralyze a normal-type, etc.)
	ld a, [wEnemyMonType2]
	cp b ; do target type 2 and move type match?
	ret z  ; return if they match
	ld a, [wPlayerMoveEffect]
	cp a, PARALYZE_SIDE_EFFECT1 + 1 ; 10% status effects are 04, 05, 06 so 07 will set carry for those
	ld b, $1a ; 0x1A/0x100 or 26/256 = 10.2%~ chance
	jr c, .next1 ; branch ahead if this is a 10% chance effect..
	ld b, $4d ; else use 0x4D/0x100 or 77/256 = 30.1%~ chance
	sub a, $1e ; subtract $1E to map to equivalent 10% chance effects
.next1
	push af
	call BattleRandom ; get random 8bit value for probability test
	cp b
	pop bc
	ret nc ; do nothing if random value is >= 1A or 4D [no status applied]
	ld a, b ; what type of effect is this?
	cp a, BURN_SIDE_EFFECT1
	jr z, .burn
	cp a, FREEZE_SIDE_EFFECT
	jr z, .freeze
; .paralyze
	ld a, 1 << PAR
	ld [wEnemyMonStatus], a
	call QuarterSpeedDueToParalysis ; quarter speed of affected mon
	ld a, ANIM_A9
	call PlayBattleAnimation
	jp PrintMayNotAttackText ; print paralysis text
.burn
	ld a, 1 << BRN
	ld [wEnemyMonStatus], a
	call HalveAttackDueToBurn ; halve attack of affected mon
	ld a, ANIM_A9
	call PlayBattleAnimation
	ld hl, BurnedText
	jp PrintText
.freeze
	call ClearHyperBeam ; resets hyper beam (recharge) condition from target
	ld a, 1 << FRZ
	ld [wEnemyMonStatus], a
	ld a, ANIM_A9
	call PlayBattleAnimation
	ld hl, FrozenText
	jp PrintText
opponentAttacker: ; 3f382 (f:7382)
	ld a, [wBattleMonStatus] ; mostly same as above with addresses swapped for opponent
	and a
	jp nz, CheckDefrost
	ld a, [wEnemyMoveType]
	ld b, a
	ld a, [wBattleMonType1]
	cp b
	ret z
	ld a, [wBattleMonType2]
	cp b
	ret z
	ld a, [wEnemyMoveEffect]
	cp a, PARALYZE_SIDE_EFFECT1 + 1
	ld b, $1a
	jr c, .next1
	ld b, $4d
	sub a, $1e
.next1
	push af
	call BattleRandom
	cp b
	pop bc
	ret nc
	ld a, b
	cp a, BURN_SIDE_EFFECT1
	jr z, .burn
	cp a, FREEZE_SIDE_EFFECT
	jr z, .freeze
	ld a, 1 << PAR
	ld [wBattleMonStatus], a
	call QuarterSpeedDueToParalysis
	jp PrintMayNotAttackText
.burn
	ld a, 1 << BRN
	ld [wBattleMonStatus], a
	call HalveAttackDueToBurn
	ld hl, BurnedText
	jp PrintText
.freeze
; hyper beam bits aren't reseted for opponent's side
	ld a, 1 << FRZ
	ld [wBattleMonStatus], a
	ld hl, FrozenText
	jp PrintText

BurnedText: ; 3f3d8 (f:73d8)
	far_text _BurnedText
	done

FrozenText: ; 3f3dd (f:73dd)
	far_text _FrozenText
	done

CheckDefrost: ; 3f3e2 (f:73e2)
; any fire-type move that has a chance inflict burn (all but Fire Spin) will defrost a frozen target
	and a, 1 << FRZ	; are they frozen?
	ret z ; return if so
	ld a, [H_WHOSETURN]
	and a
	jr nz, .opponent
	;player [attacker]
	ld a, [wPlayerMoveType]
	sub a, FIRE
	ret nz ; return if type of move used isn't fire
	ld [wEnemyMonStatus], a	; set opponent status to 00 ["defrost" a frozen monster]
	ld hl, wEnemyMon1Status
	ld a, [wEnemyMonPartyPos]
	ld bc, wEnemyMon2 - wEnemyMon1
	call AddNTimes
	xor a
	ld [hl], a ; clear status in roster
	ld hl, FireDefrostedText
	jr .common
.opponent
	ld a, [wEnemyMoveType]	; same as above with addresses swapped
	sub a, FIRE
	ret nz
	ld [wBattleMonStatus], a
	ld hl, wPartyMon1Status
	ld a, [wPlayerMonNumber]
	ld bc, wPartyMon2 - wPartyMon1
	call AddNTimes
	xor a
	ld [hl], a
	ld hl, FireDefrostedText
.common
	jp PrintText

FireDefrostedText: ; 3f423 (f:7423)
	far_text _FireDefrostedText
	done

StatModifierUpEffect: ; 3f428 (f:7428)
	ld hl, wPlayerMonStatMods
	ld de, wPlayerMoveEffect
	ld a, [H_WHOSETURN]
	and a
	jr z, .statModifierUpEffect
	ld hl, wEnemyMonStatMods
	ld de, wEnemyMoveEffect
.statModifierUpEffect
	ld a, [de]
	sub ATTACK_UP1_EFFECT
	cp EVASION_UP1_EFFECT + $3 - ATTACK_UP1_EFFECT ; covers all +1 effects
	jr c, .incrementStatMod
	sub ATTACK_UP2_EFFECT - ATTACK_UP1_EFFECT ; map +2 effects to equivalent +1 effect
.incrementStatMod
	ld c, a
	ld b, $0
	add hl, bc
	ld b, [hl]
	inc b ; increment corresponding stat mod
	ld a, $d
	cp b ; can't raise stat past +6 ($d or 13)
	jp c, PrintNothingHappenedText
	ld a, [de]
	cp ATTACK_UP1_EFFECT + $8 ; is it a +2 effect?
	jr c, .ok
	inc b ; if so, increment stat mod again
	ld a, $d
	cp b ; unless it's already +6
	jr nc, .ok
	ld b, a
.ok
	ld [hl], b
	ld a, c
	cp $4
	jr nc, UpdateStatDone ; jump if mod affected is evasion/accuracy
	push hl
	ld hl, wBattleMonAttack + 1
	ld de, wPlayerMonUnmodifiedAttack
	ld a, [H_WHOSETURN]
	and a
	jr z, .pointToStats
	ld hl, wEnemyMonAttack + 1
	ld de, wEnemyMonUnmodifiedAttack
.pointToStats
	push bc
	sla c
	ld b, $0
	add hl, bc ; hl = modified stat
	ld a, c
	add e
	ld e, a
	jr nc, .checkIf999
	inc d ; de = unmodified (original) stat
.checkIf999
	pop bc
	ld a, [hld]
	sub 999 % $100 ; check if stat is already 999
	jr nz, .recalculateStat
	ld a, [hl]
	sbc 999 / $100
	jp z, RestoreOriginalStatModifier
.recalculateStat ; recalculate affected stat
                 ; paralysis and burn penalties, as well as badge boosts are ignored
	push hl
	push bc
	ld hl, StatModifierRatios
	dec b
	sla b
	ld c, b
	ld b, $0
	add hl, bc
	pop bc
	xor a
	ld [H_MULTIPLICAND], a
	ld a, [de]
	ld [H_MULTIPLICAND + 1], a
	inc de
	ld a, [de]
	ld [H_MULTIPLICAND + 2], a
	ld a, [hli]
	ld [H_MULTIPLIER], a
	call Multiply
	ld a, [hl]
	ld [H_DIVISOR], a
	ld b, $4
	call Divide
	pop hl
; cap at 999
	ld a,[H_PRODUCT + 1]
	and a
	jr nz,.capAt999		;if this value was not zero, then it overflowed. so cap at 999
	ld a,[H_DIVIDEND]
	and a
	jr nz,.capAt999		;if this is non-zero, then cap the stat at 999
	ld a, [H_PRODUCT + 3]
	sub 999 % $100
	ld a, [H_PRODUCT + 2]
	sbc 999 / $100
	jp c, UpdateStat
.capAt999
	ld a, 999 / $100
	ld [H_MULTIPLICAND + 1], a
	ld a, 999 % $100
	ld [H_MULTIPLICAND + 2], a

UpdateStat: ; 3f4c3 (f:74c3)
	ld a, [H_PRODUCT + 2]
	ld [hli], a
	ld a, [H_PRODUCT + 3]
	ld [hl], a
	pop hl
UpdateStatDone: ; 3f4ca (f:74ca)
	ld b, c
	inc b
	call PrintStatText
	ld hl, wPlayerBattleStatus2
	ld de, wPlayerMoveNum
	ld bc, wPlayerMonMinimized
	ld a, [H_WHOSETURN]
	and a
	jr z, .asm_3f4e6
	ld hl, wEnemyBattleStatus2
	ld de, wEnemyMoveNum
	ld bc, wEnemyMonMinimized
.asm_3f4e6
	ld a, [de]
	cp MINIMIZE
	jr nz, .asm_3f4f9
 ; if a substitute is up, slide off the substitute and show the mon pic before
 ; playing the minimize animation
	bit HasSubstituteUp, [hl]
	push af
	push bc
	ld hl, HideSubstituteShowMonAnim
	ld b, BANK(HideSubstituteShowMonAnim)
	push de
	call nz, Bankswitch
	pop de
.asm_3f4f9
	call PlayCurrentMoveAnimation
	ld a, [de]
	cp MINIMIZE
	jr nz, .applyBadgeBoostsAndStatusPenalties
	pop bc
	ld a, $1
	ld [bc], a
	ld hl, ReshowSubstituteAnim
	ld b, BANK(ReshowSubstituteAnim)
	pop af
	call nz, Bankswitch
.applyBadgeBoostsAndStatusPenalties
	ld a, [H_WHOSETURN]
	and a
;	call z, ApplyBadgeStatBoosts ; whenever the player uses a stat-up move, badge boosts get reapplied again to every stat,
	                             ; even to those not affected by the stat-up move (will be boosted further)
	ld hl, MonsStatsRoseText
	call PrintText

; these shouldn't be here
	call QuarterSpeedDueToParalysis ; apply speed penalty to the player whose turn is not, if it's paralyzed
	jp HalveAttackDueToBurn ; apply attack penalty to the player whose turn is not, if it's burned

RestoreOriginalStatModifier: ; 3f520 (f:7520)
	pop hl
	dec [hl]

PrintNothingHappenedText: ; 3f522 (f:7522)
	ld hl, NothingHappenedText
	jp PrintText

MonsStatsRoseText: ; 3f528 (f:7528)
	far_text _MonsStatsRoseText
	asm_text
	ld hl, GreatlyRoseText
	ld a, [H_WHOSETURN]
	and a
	ld a, [wPlayerMoveEffect]
	jr z, .asm_3f53b
	ld a, [wEnemyMoveEffect]
.asm_3f53b
	cp ATTACK_DOWN1_EFFECT
	jr nc,.finish
	ld hl, RoseText
.finish
	place_string_end_asm_text
	done

GreatlyRoseText: ; 3f542 (f:7542)
	far_text _GreatlyRoseText

RoseText: ; 3f547 (f:7547)
	far_text _RoseText
	done

StatModifierDownEffect: ; 3f54c (f:754c)
	ld hl, wEnemyMonStatMods
	ld de, wPlayerMoveEffect
	ld bc, wEnemyBattleStatus1
	ld a, [H_WHOSETURN]
	and a
	jr z, .statModifierDownEffect
	ld hl, wPlayerMonStatMods
	ld de, wEnemyMoveEffect
	ld bc, wPlayerBattleStatus1
	ld a, [wLinkState]
	cp LINK_STATE_BATTLING
	jr z, .statModifierDownEffect
	call BattleRandom
	cp $40 ; 1/4 chance to miss by in regular battle
	jp c, MoveMissed
.statModifierDownEffect
	call CheckTargetSubstitute ; can't hit through substitute
	jp nz, MoveMissed
	ld a, [de]
	cp ATTACK_DOWN_SIDE_EFFECT
	jr c, .nonSideEffect
	call BattleRandom
	cp $55 ; 85/256 chance for side effects
	jp nc, CantLowerAnymore
	ld a, [de]
	sub ATTACK_DOWN_SIDE_EFFECT ; map each stat to 0-3
	jr .decrementStatMod
.nonSideEffect ; non-side effects only
	push hl
	push de
	push bc
	call MoveHitTest ; apply accuracy tests
	pop bc
	pop de
	pop hl
	ld a, [wMoveMissed]
	and a
	jp nz, MoveMissed
	ld a, [bc]
	bit Invulnerable, a ; fly/dig
	jp nz, MoveMissed
	ld a, [de]
	sub ATTACK_DOWN1_EFFECT
	cp EVASION_DOWN1_EFFECT + $3 - ATTACK_DOWN1_EFFECT ; covers al -1 effects
	jr c, .decrementStatMod
	sub ATTACK_DOWN2_EFFECT - ATTACK_DOWN1_EFFECT ; map -2 effects to corresponding -1 effect
.decrementStatMod
	ld c, a
	ld b, $0
	add hl, bc
	ld b, [hl]
	dec b ; dec corresponding stat mod
	jp z, CantLowerAnymore ; if stat mod is 1 (-6), can't lower anymore
	ld a, [de]
	cp ATTACK_DOWN2_EFFECT - $16 ; $24
	jr c, .ok
	cp EVASION_DOWN2_EFFECT + $5 ; $44
	jr nc, .ok
	dec b ; stat down 2 effects only (dec mod again)
	jr nz, .ok
	inc b ; increment mod to 1 (-6) if it would become 0 (-7)
.ok
	ld [hl], b ; save modified mod
	ld a, c
	cp $4
	jr nc, UpdateLoweredStatDone ; jump for evasion/accuracy
	push hl
	push de
	ld hl, wEnemyMonAttack + 1
	ld de, wEnemyMonUnmodifiedAttack
	ld a, [H_WHOSETURN]
	and a
	jr z, .pointToStat
	ld hl, wBattleMonAttack + 1
	ld de, wPlayerMonUnmodifiedAttack
.pointToStat
	push bc
	sla c
	ld b, $0
	add hl, bc ; hl = modified stat
	ld a, c
	add e
	ld e, a
	jr nc, .asm_3f5e4
	inc d ; de = unmodified stat
.asm_3f5e4
	pop bc
	ld a, [hld]
	sub $1 ; can't lower stat below 1 (-6)
	jr nz, .recalculateStat
	ld a, [hl]
	and a
	jp z, CantLowerAnymore_Pop
.recalculateStat
; recalculate affected stat
; paralysis and burn penalties, as well as badge boosts are ignored
	push hl
	push bc
	ld hl, StatModifierRatios
	dec b
	sla b
	ld c, b
	ld b, $0
	add hl, bc
	pop bc
	xor a
	ld [H_MULTIPLICAND], a
	ld a, [de]
	ld [H_MULTIPLICAND + 1], a
	inc de
	ld a, [de]
	ld [H_MULTIPLICAND + 2], a
	ld a, [hli]
	ld [H_MULTIPLIER], a
	call Multiply
	ld a, [hl]
	ld [H_DIVISOR], a
	ld b, $4
	call Divide
	pop hl
	ld a, [H_PRODUCT + 3]
	ld b, a
	ld a, [H_PRODUCT + 2]
	or b
	jp nz, UpdateLoweredStat
	ld [H_MULTIPLICAND + 1], a
	ld a, $1
	ld [H_MULTIPLICAND + 2], a

UpdateLoweredStat: ; 3f624 (f:7624)
	ld a, [H_PRODUCT + 2]
	ld [hli], a
	ld a, [H_PRODUCT + 3]
	ld [hl], a
	pop de
	pop hl
UpdateLoweredStatDone: ; 3f62c (f:762c)
	ld b, c
	inc b
	push de
	call PrintStatText
	pop de
	ld a, [de]
	cp $44
	jr nc, .ApplyBadgeBoostsAndStatusPenalties
	call PlayCurrentMoveAnimation2
.ApplyBadgeBoostsAndStatusPenalties
	ld a, [H_WHOSETURN]
	and a
;	call nz, ApplyBadgeStatBoosts ; whenever the player uses a stat-down move, badge boosts get reapplied again to every stat,
	                              ; even to those not affected by the stat-up move (will be boosted further)
	ld hl, MonsStatsFellText
	call PrintText

; These where probably added given that a stat-down move affecting speed or attack will override
; the stat penalties from paralysis and burn respectively.
; But they are always called regardless of the stat affected by the stat-down move.
	call QuarterSpeedDueToParalysis
	jp HalveAttackDueToBurn

CantLowerAnymore_Pop: ; 3f64d (f:764d)
	pop de
	pop hl
	inc [hl]

CantLowerAnymore: ; 3f650 (f:7650)
	ld a, [de]
	cp ATTACK_DOWN_SIDE_EFFECT
	ret nc
	ld hl, NothingHappenedText
	jp PrintText

MoveMissed: ; 3f65a (f:765a)
	ld a, [de]
	cp $44
	ret nc
	jp ConditionalPrintButItFailed

MonsStatsFellText: ; 3f661 (f:7661)
	far_text _MonsStatsFellText
	asm_text
	ld hl, FellText
	ld a, [H_WHOSETURN]
	and a
	ld a, [wPlayerMoveEffect]
	jr z, .asm_3f674
	ld a, [wEnemyMoveEffect]
.asm_3f674
	cp $1a
	jr c,.finish
	cp $44
	jr nc,.finish
	ld hl, GreatlyFellText
.finish
	place_string_end_asm_text
	done

GreatlyFellText: ; 3f67e (f:767e)
	far_text _GreatlyFellText

FellText: ; 3f683 (f:7683)
	far_text _FellText
	done

PrintStatText: ; 3f688 (f:7688)
	ld hl, StatsTextStrings
	ld c, "@"
.asm_3f68d
	dec b
	jr z, .asm_3f696
.asm_3f690
	ld a, [hli]
	cp c
	jr z, .asm_3f68d
	jr .asm_3f690
.asm_3f696
	ld de, wcf4b
	ld bc, $a
	jp CopyData

StatsTextStrings: ; 3f69f (f:769f)
	db "ATTACK@"
	db "DEFENSE@"
	db "SPEED@"
	db "SPECIAL@"
	db "ACCURACY@"
	db "EVADE@"

StatModifierRatios: ; 3f6cb (f:76cb)
; first byte is numerator, second byte is denominator
	db 25, 100  ; 0.25
	db 28, 100  ; 0.28
	db 33, 100  ; 0.33
	db 40, 100  ; 0.40
	db 50, 100  ; 0.50
	db 66, 100  ; 0.66
	db  1,   1  ; 1.00
	db 15,  10  ; 1.50
	db  2,   1  ; 2.00
	db 25,  10  ; 2.50
	db  3,   1  ; 3.00
	db 35,  10  ; 3.50
	db  4,   1  ; 4.00

BideEffect: ; 3f6e5 (f:76e5)
	ld hl, wPlayerBattleStatus1
	ld de, wPlayerBideAccumulatedDamage
	ld bc, wPlayerNumAttacksLeft
	ld a, [H_WHOSETURN]
	and a
	jr z, .bideEffect
	ld hl, wEnemyBattleStatus1
	ld de, wEnemyBideAccumulatedDamage
	ld bc, wEnemyNumAttacksLeft
.bideEffect
	set StoringEnergy, [hl] ; mon is now using bide
	xor a
	ld [de], a
	inc de
	ld [de], a
	ld [wPlayerMoveEffect], a
	ld [wEnemyMoveEffect], a
	call BattleRandom
	and $1
	inc a
	inc a
	ld [bc], a ; set Bide counter to 2 or 3 at random
	ld a, [H_WHOSETURN]
	add XSTATITEM_ANIM
	jp PlayBattleAnimation2

ThrashPetalDanceEffect: ; 3f717 (f:7717)
	ld hl, wPlayerBattleStatus1
	ld de, wPlayerNumAttacksLeft
	ld a, [H_WHOSETURN]
	and a
	jr z, .thrashPetalDanceEffect
	ld hl, wEnemyBattleStatus1
	ld de, wEnemyNumAttacksLeft
.thrashPetalDanceEffect
	set ThrashingAbout, [hl] ; mon is now using thrash/petal dance
	call BattleRandom
	and $1
	inc a
	inc a
	ld [de], a ; set thrash/petal dance counter to 2 or 3 at random
	ld a, [H_WHOSETURN]
	add ANIM_B0
	jp PlayBattleAnimation2

SwitchAndTeleportEffect: ; 3f739 (f:7739)
	ld a, [H_WHOSETURN]
	and a
	jr nz, .asm_3f791
	ld a, [wIsInBattle]
	dec a
	jr nz, .asm_3f77e
	ld a, [wCurEnemyLVL]
	ld b, a
	ld a, [wBattleMonLevel]
	cp b
	jr nc, .asm_3f76e
	add b
	ld c, a
	inc c
	call BattleRandom
	jr .skipSubtract	;don't subtract c the first time
.loop1
	sub a,c	;subtract c from a
.skipSubtract
	cp c
	jr nc, .loop1	;loop if its c or greater
	srl b
	srl b
	cp b
	jr nc, .asm_3f76e
	ld c, 50
	call DelayFrames
	ld a, [wPlayerMoveNum]
	cp TELEPORT
	jp nz, PrintDidntAffectText
	jp PrintButItFailedText_
.asm_3f76e
	call ReadPlayerMonCurHPAndStatus
	xor a
	ld [wAnimationType], a
	inc a
	ld [wEscapedFromBattle], a
	ld a, [wPlayerMoveNum]
	jr .asm_3f7e4
.asm_3f77e
	ld c, 50
	call DelayFrames
	ld hl, IsUnaffectedText
	ld a, [wPlayerMoveNum]
	cp TELEPORT
	jp nz, PrintText
	jp PrintButItFailedText_
.asm_3f791
	ld a, [wIsInBattle]
	dec a
	jr nz, .asm_3f7d1
	ld a, [wBattleMonLevel]
	ld b, a
	ld a, [wCurEnemyLVL]
	cp b
	jr nc, .asm_3f7c1
	add b
	ld c, a
	inc c
	call BattleRandom
	jr .skipSubtract2	;dont subtract c the first time
.loop2
	sub a,c		;subtract a by c
.skipSubtract2
	cp c
	jr nc, .loop2	;loop if greater than or equal to c
	srl b
	srl b
	cp b
	jr nc, .asm_3f7c1
	ld c, 50
	call DelayFrames
	ld a, [wEnemyMoveNum]
	cp TELEPORT
	jp nz, PrintDidntAffectText
	jp PrintButItFailedText_
.asm_3f7c1
	call ReadPlayerMonCurHPAndStatus
	xor a
	ld [wAnimationType], a
	inc a
	ld [wEscapedFromBattle], a
	ld a, [wEnemyMoveNum]
	jr .asm_3f7e4
.asm_3f7d1
	ld c, 50
	call DelayFrames
	ld hl, IsUnaffectedText
	ld a, [wEnemyMoveNum]
	cp TELEPORT
	jp nz, PrintText
	jp ConditionalPrintButItFailed
.asm_3f7e4
	push af
	call PlayMoveAnimation3
	ld c, 20
	call DelayFrames
	pop af
	ld hl, RanFromBattleText
	cp TELEPORT
	jr z, .asm_3f7ff
	ld hl, RanAwayScaredText
	cp ROAR
	jr z, .asm_3f7ff
	ld hl, WasBlownAwayText
.asm_3f7ff
	jp PrintText

RanFromBattleText: ; 3f802 (f:7802)
	far_text _RanFromBattleText
	done

RanAwayScaredText: ; 3f807 (f:7807)
	far_text _RanAwayScaredText
	done

WasBlownAwayText: ; 3f80c (f:780c)
	far_text _WasBlownAwayText
	done

TwoToFiveAttacksEffect: ; 3f811 (f:7811)
	ld hl, wPlayerBattleStatus1
	ld de, wPlayerNumAttacksLeft
	ld bc, wPlayerNumHits
	ld a, [H_WHOSETURN]
	and a
	jr z, .twoToFiveAttacksEffect
	ld hl, wEnemyBattleStatus1
	ld de, wEnemyNumAttacksLeft
	ld bc, wEnemyNumHits
.twoToFiveAttacksEffect
	bit AttackingMultipleTimes, [hl] ; is mon attacking multiple times?
	ret nz
	set AttackingMultipleTimes, [hl] ; mon is now attacking multiple times
	ld hl, wPlayerMoveEffect
	ld a, [H_WHOSETURN]
	and a
	jr z, .setNumberOfHits
	ld hl, wEnemyMoveEffect
.setNumberOfHits
	ld a, [hl]
	cp TWINEEDLE_EFFECT
	jr z, .twineedle
	cp ATTACK_TWICE_EFFECT
	ld a, $2 ; number of hits it's always 2 for ATTACK_TWICE_EFFECT
	jr z, .saveNumberOfHits
; for TWO_TO_FIVE_ATTACKS_EFFECT 3/8 chance for 2 and 3 hits, and 1/8 chance for 4 and 5 hits
	call BattleRandom
	and $3
	cp $2
	jr c, .asm_3f851
	call BattleRandom
	and $3
.asm_3f851
	inc a
	inc a
	push hl
	push af
	ld hl,wBattleMonLearnedTraits
	ld a, [H_WHOSETURN]
	and a
	jr z, .skipEnemySkills	;skip down if players turn
	ld hl,wEnemyMonLearnedTraits
.skipEnemySkills
	pop af
	bit LongerMultiSkill,[hl]		;does the pokemon have the 'longer multiturn' skill?	
	pop hl
	jr z,.saveNumberOfHits		;skip down if not
	cp 5		;is it already 5?
	jr z,.saveNumberOfHits		;skip down if so
	inc a	
.saveNumberOfHits
	ld [de], a
	ld [bc], a
	ret
.twineedle
	ld a, POISON_SIDE_EFFECT1
	ld [hl], a ; set Twineedle's effect to poison effect
	jr .saveNumberOfHits

FlinchSideEffect: ; 3f85b (f:785b)
	call CheckTargetSubstitute
	ret nz
	ld hl, wEnemyBattleStatus1
	ld de, wPlayerMoveEffect
	ld a, [H_WHOSETURN]
	and a
	jr z, .flinchSideEffect
	ld hl, wPlayerBattleStatus1
	ld de, wEnemyMoveEffect
.flinchSideEffect
	ld a, [de]
	cp FLINCH_SIDE_EFFECT1
	ld b, $1a ; ~10% chance of flinch
	jr z, .gotEffectChance
	ld b, $4d ; ~30% chance of flinch
.gotEffectChance
	call BattleRandom
	cp b
	ret nc
	ld a, [H_WHOSETURN]
	and a
	ld a,[wBattleMonLearnedTraits]
	jr nz, .skipEnemyTurn	;skip down if enemys turn
	ld a,[wEnemyMonLearnedTraits]
.skipEnemyTurn
	bit NoFlinchSkill,a		;does the pokemon have the no-flinch skill?
	jr z,.doesntHaveNoFlinchSkill		;then pokemon will flinch
	
	call BattleRandom
	cp $F4		;95% chance
	ret c		;if under $F4, then dont flinch
	
.doesntHaveNoFlinchSkill
	set Flinched, [hl] ; set mon's status to flinching
	call ClearHyperBeam
	ret

OneHitKOEffect: ; 3f884 (f:7884)
	jpab OneHitKOEffect_

ChargeEffect: ; 3f88c (f:788c)
	ld hl, wPlayerBattleStatus1
	ld de, wPlayerMoveEffect
	ld a, [H_WHOSETURN]
	and a
	ld b, XSTATITEM_ANIM
	jr z, .chargeEffect
	ld hl, wEnemyBattleStatus1
	ld de, wEnemyMoveEffect
	ld b, ANIM_AF
.chargeEffect
	dec de ; de contains enemy or player MOVENUM
	ld a, [de]
	cp FLY
	jr nz, .checkDig
	ld a,[wBattleLandscape]
	and a,$7F				;ignore the "temporary?" bit
	cp a,UNDERGROUND_SCAPE	;underground?
	jr nz,.notUnderground
	;decrement PP
	call DecrementPlayerOrEnemyPP
	call PrintMonName1Text	;print pk used fly
	ld c,$38
	call DelayFrames
	ld hl,AeroNotUndergroundText
	jr .printText
.notUnderground
	set Invulnerable, [hl] ; mon is now invulnerable to typical attacks (fly/dig)
	ld b, TELEPORT_NONMOVE ; load Teleport's animation
	jr .canUseChargeMove
	
.checkDig
	cp DIG
	jr nz, .checkDive
	ld a,[wBattleLandscape]
	and a,$7F				;ignore the "temporary?" bit
	cp a,SKY_SCAPE	;sky?
	jr nz,.notSky
	;decrement PP
	call DecrementPlayerOrEnemyPP
	call PrintMonName1Text	;print "pk used dig"
	ld c,$38
	call DelayFrames
	ld hl,EarthNotInSkyText	
	jr .printText
.notSky
	set Invulnerable, [hl] ; mon is now invulnerable to typical attacks (fly/dig)
	ld b, ANIM_C0
	jr .canUseChargeMove
	
.checkDive
	cp DIVE
	jr nz,.canUseChargeMove
	ld a,[wBattleLandscape]
	and a,$7F				;ignore the "temporary?" bit
	cp a,WATER_SCAPE	;water?
	jr z,.diveInWater	;then we can attack
	cp a,UNDERWATER_SCAPE	;underwater?
	jr z,.diveInWater	;then we can attack
	;decrement PP
	call DecrementPlayerOrEnemyPP
	call PrintMonName1Text	;print "pk used dive"
	ld c,$38
	call DelayFrames
	ld hl,WaterAttackOnlyInWaterText	
	jr .printText
.diveInWater
	set Invulnerable, [hl] ; mon is now invulnerable to typical attacks (fly/dig)
	ld b, ANIM_C0
	;fall through
	
	
.canUseChargeMove
	set ChargingUp, [hl]
	xor a
	ld [wAnimationType], a
	ld a, b
	call PlayBattleAnimation
	ld a, [de]
	ld [wChargeMoveNum], a
	ld hl, ChargeMoveEffectText
	call PrintText
	;check to see if the pokemon can also attack in the same turn
	call CanChargeMoveAttackInCurrentTurn
	ret nz		;return if not
	
	ld a, [H_WHOSETURN]
	and a
	jr nz,.enemyTurn
	call PlayerCanExecuteChargingMove		;apply the attack damage if player turn
	pop af
	ret
.enemyTurn
	call EnemyCanExecuteChargingMove		;apply the attack damage for enemy turn
	pop af		;remove the return (which will set b to 1)
	ret
.printText
	jp PrintText

;to see if the environment is set up for a pokemon to skip charging up
CanChargeMoveAttackInCurrentTurn:
	ld a,[wWhichTrade]		;load attack into a
	ld b,a
	ld hl,ChargeMoveSkipLandscapeTable
	ld a,[wBattleLandscape]
	ld c,a
.landscapeLoop	
	ld a,[hli]
	cp $FF		;end of table?
	jr z,.weatherCheck
	cp b		;attacks match?
	jr nz,.incHLandLandscapeLoop
	ld a,[hl]
	cp c		;landscapes match?
	jr z,.returnSuccess	;then return success
.incHLandLandscapeLoop
	inc hl
	jr .landscapeLoop
	
.weatherCheck
	ld hl,ChargeMoveSkipWeatherTable
	ld a,[wBattleWeather]
	ld c,a
.weatherLoop	
	ld a,[hli]
	cp $FF		;end of table?
	jr z,.otherCheck
	cp b		;attacks match?
	jr nz,.incHLandWeatherLoop
	ld a,[hl]
	cp c		;weathers match?
	jr z,.returnSuccess	;then return success
.incHLandWeatherLoop
	inc hl
	jr .weatherLoop

.otherCheck
	ld hl,ChargeMoveSkipAdditionalCheckTable
	ld de,3
	ld a,b
	call IsInArray	;see if the attack is in the array
	jr nc,.finish	;exit if the attack is not in the array
	inc hl
	ld a,[hli]
	ld h,[hl]
	ld l,a
	jp hl		;run the other check
	
.finish
	xor a
	inc a		;unset the zero flag
	ret
.returnSuccess
	xor a
	ret

;move, landscape
ChargeMoveSkipLandscapeTable:
	db SKY_ATTACK,SKY_SCAPE
	db FLY,SKY_SCAPE
	db DIG,UNDERGROUND_SCAPE
	db DIVE,UNDERWATER_SCAPE
	db $FF
	
;move, weather
ChargeMoveSkipWeatherTable:
	db RAZOR_WIND,WIND_STORM_WEATHER
	db $FF
	
;move, function
ChargeMoveSkipAdditionalCheckTable:
	db SOLARBEAM
	dw SolarbeamSkipChargingCheck
	db $FF
	
SolarbeamSkipChargingCheck:
	callab IsLandscapeOutdoor
	jr nc,.finish	;finish if not
	ld a,[wBattleEnvironment]
	bit TemporaryTimeBit,a			;is the day/night reversed?
	jr z,.notTemporary		;skip down if not
	inc a			;otherwise, switch bit 0
.notTemporary
	and NIGHT_TIME
	jr nz,.finish	;skip down if night time
	ld a,[wBattleWeather]
	and a
	jr z,.returnSuccess		;if there is no weather, then return success
.finish
	xor a
	inc a		;unset the zero flag
	ret
.returnSuccess
	xor a
	ret
	
EarthNotInSkyText:
	far_text _SkyNoDamageText
	done
	
WaterAttackOnlyInWaterText:
	far_text _WaterAttackOnlyInWaterText
	done

AeroNotUndergroundText:
	far_text _UndegroundNoDamageText
	done
	
ChargeMoveEffectText: ; 3f8c8 (f:78c8)
	far_text _ChargeMoveEffectText
	asm_text
	ld a, [wChargeMoveNum]
	cp RAZOR_WIND
	ld hl, MadeWhirlwindText
	jr z, .asm_3f8f8
	cp SOLARBEAM
	ld hl, TookInSunlightText
	jr z, .asm_3f8f8
	cp SKULL_BASH
	ld hl, LoweredItsHeadText
	jr z, .asm_3f8f8
	cp SKY_ATTACK
	ld hl, SkyAttackGlowingText
	jr z, .asm_3f8f8
	cp FLY
	ld hl, FlewUpHighText
	jr z, .asm_3f8f8
	cp DIG
	ld hl, DugAHoleText
	jr z, .asm_3f8f8
	ld hl, DoveUnderwaterText
.asm_3f8f8
	place_string_end_asm_text
	done

MadeWhirlwindText: ; 3f8f9 (f:78f9)
	far_text _MadeWhirlwindText
	done

TookInSunlightText: ; 3f8fe (f:78fe)
	far_text _TookInSunlightText
	done

LoweredItsHeadText: ; 3f903 (f:7903)
	far_text _LoweredItsHeadText
	done

SkyAttackGlowingText: ; 3f908 (f:7908)
	far_text _SkyAttackGlowingText
	done

FlewUpHighText: ; 3f90d (f:790d)
	far_text _FlewUpHighText
	done

DugAHoleText: ; 3f912 (f:7912)
	far_text _DugAHoleText
	done
	
DoveUnderwaterText: ; 3f912 (f:7912)
	far_text _DoveUnderwaterText
	done

TrappingEffect: ; 3f917 (f:7917)
	ld hl, wPlayerBattleStatus1
	ld de, wPlayerNumAttacksLeft
	ld a, [H_WHOSETURN]
	and a
	jr z, .trappingEffect
	ld hl, wEnemyBattleStatus1
	ld de, wEnemyNumAttacksLeft
.trappingEffect
	bit UsingTrappingMove, [hl]
	ret nz
	call ClearHyperBeam ; since this effect is called before testing whether the move will hit,
                        ; the target won't need to recharge even if the trapping move missed
	set UsingTrappingMove, [hl] ; mon is now using a trapping move
	call BattleRandom ; 3/8 chance for 2 and 3 attacks, and 1/8 chance for 4 and 5 attacks
	and $3
	cp $2
	jr c, .setTrappingCounter
	call BattleRandom
	and $3
.setTrappingCounter
	inc a
	ld [de], a
	ret

MistEffect: ; 3f941 (f:7941)
	jpab MistEffect_

FocusEnergyEffect: ; 3f949 (f:7949)
	jpab FocusEnergyEffect_

RecoilEffect: ; 3f951 (f:7951)
	jpab RecoilEffect_

ConfusionSideEffect: ; 3f959 (f:7959)
	call BattleRandom
	cp $19
	ret nc
	jr ConfusionSideEffectSuccess

ConfusionEffect: ; 3f961 (f:7961)
	call CheckTargetSubstitute
	jr nz, ConfusionEffectFailed
	call MoveHitTest
	ld a, [wMoveMissed]
	and a
	jr nz, ConfusionEffectFailed

ConfusionSideEffectSuccess: ; 3f96f (f:796f)
	ld a, [H_WHOSETURN]
	and a
	ld de, wEnemyMonType
	ld hl, wEnemyBattleStatus1
	ld bc, wEnemyConfusedCounter
	ld a, [wPlayerMoveEffect]
	jr z, .confuseTarget
	ld de, wBattleMonType
	ld hl, wPlayerBattleStatus1
	ld bc, wPlayerConfusedCounter
	ld a, [wEnemyMoveEffect]
.confuseTarget
	push af
	ld a,[de]
	cp a,MIND	;mind type?
	jr z,.failForMind	;then fail
	inc de
	ld a,[de]
	cp a,MIND	;second type is mind?
	jr nz,.notMind	;then dont fail
.failForMind
	pop af
	jr ConfusionEffectFailed
.notMind
	pop af
	bit Confused, [hl] ; is mon confused?
	jr nz, ConfusionEffectFailed
	set Confused, [hl] ; mon is now confused
	push af
	call BattleRandom
	and $3
	inc a
	inc a
	ld [bc], a ; confusion status will last 2-5 turns
	pop af
	cp CONFUSION_SIDE_EFFECT
	call nz, PlayCurrentMoveAnimation2
	ld hl, BecameConfusedText
	jp PrintText

BecameConfusedText: ; 3f9a1 (f:79a1)
	far_text _BecameConfusedText
	done

ConfusionEffectFailed: ; 3f9a6 (f:79a6)
	cp CONFUSION_SIDE_EFFECT
	ret z
	ld c, 50
	call DelayFrames
	jp ConditionalPrintButItFailed

ParalyzeEffect: ; 3f9b1 (f:79b1)
	jpab ParalyzeEffect_

SubstituteEffect: ; 3f9b9 (f:79b9)
	jpab SubstituteEffect_

HyperBeamEffect: ; 3f9c1 (f:79c1)
	ld hl, wPlayerBattleStatus2
	ld a, [H_WHOSETURN]
	and a
	jr z, .hyperBeamEffect
	ld hl, wEnemyBattleStatus2
.hyperBeamEffect
	set NeedsToRecharge, [hl] ; mon now needs to recharge
	ret

ClearHyperBeam: ; 3f9cf (f:79cf)
	push hl
	ld hl, wEnemyBattleStatus2
	ld a, [H_WHOSETURN]
	and a
	jr z, .asm_3f9db
	ld hl, wPlayerBattleStatus2
.asm_3f9db
	res NeedsToRecharge, [hl] ; mon no longer needs to recharge
	pop hl
	ret

RageEffect: ; 3f9df (f:79df)
	ld hl, wPlayerBattleStatus2
	ld a, [H_WHOSETURN]
	and a
	jr z, .player
	ld hl, wEnemyBattleStatus2
.player
	set UsingRage, [hl] ; mon is now in "rage" mode
	ret

MimicEffect: ; 3f9ed (f:79ed)
	ld c, 50
	call DelayFrames
	call MoveHitTest
	ld a, [wMoveMissed]
	and a
	jr nz, .asm_3fa74
	ld a, [H_WHOSETURN]
	and a
	ld hl, wBattleMonMoves
	ld a, [wPlayerBattleStatus1]
	jr nz, .asm_3fa13
	ld a, [wLinkState]
	cp LINK_STATE_BATTLING
	jr nz, .asm_3fa3a
	ld hl, wEnemyMonMoves
	ld a, [wEnemyBattleStatus1]
.asm_3fa13
	bit Invulnerable, a
	jr nz, .asm_3fa74
	call PickRandomNonZeroMove
	ld d, a
	ld a, [H_WHOSETURN]
	and a
	ld hl, wBattleMonMoves
	ld a, [wPlayerMoveListIndex]
	jr z, .asm_3fa5f
	ld hl, wEnemyMonMoves
	ld a, [wEnemyMoveListIndex]
	jr .asm_3fa5f
.asm_3fa3a
	ld a, [wEnemyBattleStatus1]
	bit Invulnerable, a
	jr nz, .asm_3fa74
	ld a, [wCurrentMenuItem]
	push af
	ld a, $1
	ld [wMoveMenuType], a
	call MoveSelectionMenu
	call LoadScreenTilesFromBuffer1
	ld hl, wEnemyMonMoves
	ld a, [wCurrentMenuItem]
	ld c, a
	ld b, $0
	add hl, bc
	ld d, [hl]
	pop af
	ld hl, wBattleMonMoves
.asm_3fa5f
	ld c, a
	ld b, $0
	add hl, bc
	ld a, d
	ld [hl], a
	ld [wd11e], a
	call GetMoveName
	call PlayCurrentMoveAnimation
	ld hl, MimicLearnedMoveText
	jp PrintText
.asm_3fa74
	jp PrintButItFailedText_

MimicLearnedMoveText: ; 3fa77 (f:7a77)
	far_text _MimicLearnedMoveText
	done

LeechSeedEffect: ; 3fa7c (f:7a7c)
	jpab LeechSeedEffect_

SplashEffect: ; 3fa84 (f:7a84)
	call PlayCurrentMoveAnimation
	jp PrintNoEffectText

ChangeWeatherEffect:
ChangeTimeEffect:
EarthquakeEffect:
TrapAndSlowEffect:
ChangeLandscapeEffect:
FearEffect:
TwiceWithFlinchEffect:
NightAndHealEffect:
ChangeEnvironmentEffect:
RadioactiveEffect:
InvisibilityEffect:
FlinchAndBoneEffect:
DecayEffect:
FlytrapEffect:
OcclumencyEffect:
WallEffect:
HeatTreatEffect:
CurseEffect:
FairyDustEffect:
AdaptabilityEffect:
StickyBombEffect:
CloneEffect:
MoltEffect:
TripleAttackEffect:
TornadoEffect:
MultiAftershocksEffect:
DisableEffect: ; 3fa8a (f:7a8a)
	call MoveHitTest
	ld a, [wMoveMissed]
	and a
	jr nz, .moveMissed
	ld de, wEnemyDisabledMove
	ld hl, wEnemyMonMoves
	ld a, [H_WHOSETURN]
	and a
	jr z, .disableEffect
	ld de, wPlayerDisabledMove
	ld hl, wBattleMonMoves
.disableEffect
; no effect if target already has a move disabled
	ld a, [de]
	and a
	jr nz, .moveMissed
.pickMoveToDisable
	call PickRandomNonZeroMove
	ld [wd11e], a ; store move number
	push hl
	ld a, [H_WHOSETURN]
	and a
	ld hl, wBattleMonPP
	jr nz, .enemyTurn
	ld a, [wLinkState]
	cp LINK_STATE_BATTLING
	pop hl ; wEnemyMonMoves
	jr nz, .playerTurnNotLinkBattle
; .playerTurnLinkBattle
	push hl
	ld hl, wEnemyMonPP
.enemyTurn
	push hl
	ld a, [hli]
	or [hl]
	inc hl
	or [hl]
	inc hl
	or [hl]
	and $3f
	pop hl ; wBattleMonPP or wEnemyMonPP
	jr z, .moveMissedPopHL ; nothing to do if all moves have no PP left
	add hl, bc
	ld a, [hl]
	pop hl
	and a
	jr z, .pickMoveToDisable ; pick another move if this one had 0 PP
.playerTurnNotLinkBattle
; non-link battle enemies have unlimited PP so the previous checks aren't needed
	call BattleRandom
	and $7
	inc a ; 1-8 turns disabled
	inc c ; move 1-4 will be disabled
	swap c
	add c ; map disabled move to high nibble of wEnemyDisabledMove / wPlayerDisabledMove
	ld [de], a
	call PlayCurrentMoveAnimation2
	ld hl, wPlayerDisabledMoveNumber
	ld a, [H_WHOSETURN]
	and a
	jr nz, .printDisableText
	inc hl ; wEnemyDisabledMoveNumber
.printDisableText
	ld a, [wd11e] ; move number
	ld [hl], a
	call GetMoveName
	ld hl, MoveWasDisabledText
	jp PrintText
.moveMissedPopHL
	pop hl
.moveMissed
	jp PrintButItFailedText_

MoveWasDisabledText: ; 3fb09 (f:7b09)
	far_text _MoveWasDisabledText
	done

PayDayEffect: ; 3fb0e (f:7b0e)
	jpab PayDayEffect_

ConversionEffect: ; 3fb16 (f:7b16)
	jpab ConversionEffect_

HazeEffect: ; 3fb1e (f:7b1e)
	jpab HazeEffect_

HealEffect: ; 3fb26 (f:7b26)
	jpab HealEffect_

TransformEffect: ; 3fb2e (f:7b2e)
	jpab TransformEffect_

ReflectLightScreenEffect: ; 3fb36 (f:7b36)
	jpab ReflectLightScreenEffect_

NothingHappenedText: ; 3fb3e (f:7b3e)
	far_text _NothingHappenedText
	done

PrintNoEffectText: ; 3fb43 (f:7b43)
	ld hl, NoEffectText
	jp PrintText

NoEffectText: ; 3fb49 (f:7b49)
	far_text _NoEffectText
	done

ConditionalPrintButItFailed: ; 3fb4e (f:7b4e)
	ld a, [wMoveDidntMiss]
	and a
	ret nz ; return if the side effect failed, yet the attack was successful

PrintButItFailedText_: ; 3fb53 (f:7b53)
	ld hl, ButItFailedText
	jp PrintText

ButItFailedText: ; 3fb59 (f:7b59)
	far_text _ButItFailedText
	done

PrintDidntAffectText: ; 3fb5e (f:7b5e)
	ld hl, DidntAffectText
	jp PrintText

DidntAffectText: ; 3fb64 (f:7b64)
	far_text _DidntAffectText
	done

IsUnaffectedText: ; 3fb69 (f:7b69)
	far_text _IsUnaffectedText
	done

PrintMayNotAttackText: ; 3fb6e (f:7b6e)
	ld hl, ParalyzedMayNotAttackText
	jp PrintText

ParalyzedMayNotAttackText: ; 3fb74 (f:7b74)
	far_text _ParalyzedMayNotAttackText
	done

CheckTargetSubstitute: ; 3fb79 (f:7b79)
	push hl
	ld hl, wEnemyBattleStatus2
	ld a, [H_WHOSETURN]
	and a
	jr z, .next1
	ld hl, wPlayerBattleStatus2
.next1
	bit HasSubstituteUp, [hl]
	pop hl
	ret

PlayCurrentMoveAnimation2: ; 3fb89 (f:7b89)
; animation at MOVENUM will be played unless MOVENUM is 0
; plays wAnimationType 3 or 6
	ld a, [H_WHOSETURN]
	and a
	ld a, [wPlayerMoveNum]
	jr z, .notEnemyTurn
	ld a, [wEnemyMoveNum]
.notEnemyTurn
	and a
	ret z
	ld [wAnimationID], a
	ld a, [H_WHOSETURN]
	and a
	ld a, $6
	jr z, .asm_3fba2
	ld a, $3
.asm_3fba2
	ld [wAnimationType], a
	jr PlayMoveAnimationSkip

PlayBattleAnimation2: ; 3fb96 (f:7b96)
; play animation ID at a and animation type 6 or 3
	ld [wAnimationID], a
	ld a, [H_WHOSETURN]
	and a
	ld a, $6
	jr z, .storeAnimationType
	ld a, $3
.storeAnimationType
	ld [wAnimationType], a
	jp PlayBattleAnimationGotID

PlayCurrentMoveAnimation: ; 3fba8 (f:7ba8)
; animation at MOVENUM will be played unless MOVENUM is 0
; resets wAnimationType
	xor a
	ld [wAnimationType], a
	ld a, [H_WHOSETURN]
	and a
	ld a, [wPlayerMoveNum]
	jr z, .notEnemyTurn
	ld a, [wEnemyMoveNum]
.notEnemyTurn
	and a
	ret z
	jr PlayMoveAnimation3

PlayBattleAnimation: ; 3fbb9 (f:7bb9)
; play animation ID at a and predefined animation type
	ld [wAnimationID], a

PlayBattleAnimationGotID: ; 3fbbc (f:7bbc)
; play animation at wAnimationID
	push hl
	push de
	push bc
	predef NonMoveAnimation
	pop bc
	pop de
	pop hl
	ret
	
PlayMoveAnimation3:
	ld [wAnimationID], a
PlayMoveAnimationSkip:
	push hl
	push de
	push bc
	predef MoveAnimation
	pop bc
	pop de
	pop hl
	ret

;to adjust the damage for the move type (which was moved to a different bank)
AdjustDamageForMoveType:
	callab _AdjustDamageForMoveType
	ret
	
;to add the damage to the player pokemon instead of subtracting:
AddDamageToPlayerPokemon:
	ld hl,wBattleMonHP			;pointer to Player Pokemon cur HP
	ld de,wBattleMonMaxHP		;pointer to Player Pokemon max HP
	call AddDamageCommon		;add damage
	coord hl, 10, 9
	ld a,1	;print hp bar numbers
	jp AddDamageCommonFinish
	
;to add the damage to the enemy pokemon instead of subtracting:
AddDamageToEnemyPokemon:
	ld hl,wEnemyMonHP			;pointer to Enemy Pokemon cur HP
	ld de,wEnemyMonMaxHP		;pointer to Enemy Pokemon max HP
	call AddDamageCommon		;add damage
	coord hl, 2, 2
	ld a,0	;dont print hp bar numbers
	jp AddDamageCommonFinish
	
AddDamageCommon:
	push hl		;store the pointer to the max hp
	;store the old hp to the wHPBarOldHP and into hl
	ld a,[hli]
	ld [wHPBarOldHP + 1],a
	ld b,a
	ld a,[hl]
	ld [wHPBarOldHP],a
	ld l,a
	ld h,b
	
	;add the damage to the pokemon
	ld a,[wDamage]
	ld b,a
	ld a,[wDamage + 1]
	ld c,a			;bc = damage
	add hl,bc		;hl = new HP
	
	;store the max hp into de
	ld a,[de]
	inc de
	ld b,a
	ld [wHPBarMaxHP+1],a
	ld a,[de]
	ld e,a
	ld [wHPBarMaxHP],a
	ld d,b
	
	;compare hl to de
	ld a,d
	cp h
	jr c,.setHPToMax	;if the new hp high byte exceed the max, then set hp to max
	ld a,e
	cp l
	jr nc,.storeNewHP		;if the new hp low byte does not exceed the max, then store the new hp
	
	;set the hp to the max hp
.setHPToMax
	push de
	pop hl	;hl = max hp
	
;store the new hp (in hl) to the ram
.storeNewHP
	pop bc	; bc = pointer to current hp
	ld a,h
	ld [bc],a
	ld [wHPBarNewHP+1],a
	inc bc
	ld a,l
	ld [bc],a
	ld [wHPBarNewHP],a
	ret
	
AddDamageCommonFinish:
	ld [wHPBarType],a
	predef UpdateHPBar2 ; animate the HP bar shortening
	jp DrawHUDsAndHPBars
	
	
;to get a replay value from the location pointed to in the WRAM
GetReplayValue:
	ld de,wReplayDataPointer
	ld a,[de]
	ld l,a
	inc de
	ld a,[de]
	ld h,a	;hl = pointer that was stored
	inc hl
	ld a,h
	ld [de],a
	dec de
	ld a,l
	ld [de],a	;increase the pointer to point to the next location
	dec hl	;hl = pointer to original location
	ld a,[wReplayBank]
	bit 7,a		;is the data stored in the SRAM
	jr z,.SRAM		;then read from sram
	res 7,a	;turn off the bit (already contains the bank)
	ld bc,1		;1 byte
	ld de,wBattleRandom		;copy into battle random
	jp FarCopyData	;a already contains the bank
.SRAM
	push af
	ld a, SRAM_ENABLE
	ld [MBC1SRamEnable], a
	ld a, $1
	ld [MBC1SRamBankingMode], a
	pop af	;get the appropriate bank
	ld [MBC1SRamBank], a
	ld a,[hl]	;load the value into a
	ld [wBattleRandom],a	;store into battle random
	xor a
	ld [MBC1SRamBankingMode], a
	ld [MBC1SRamEnable], a
	ret
	
;to save a replay value to the SRAM:
SaveReplayValue:
	ld de,wReplayDataPointer
	ld a,[de]
	ld l,a
	inc de
	ld a,[de]
	ld h,a	;hl = pointer that was stored
	inc hl
	ld a,h
	ld [de],a
	dec de
	ld a,l
	ld [de],a	;increase the pointer to point to the next location
	dec hl	;hl = pointer to original location
	ld a, SRAM_ENABLE
	ld [MBC1SRamEnable], a
	ld a, $1
	ld [MBC1SRamBankingMode], a
	ld a,[wReplayBank]	;get the appropriate bank
	ld [MBC1SRamBank], a
	ld a,[wBattleRandom]	;store battle random in a
	ld [hl],a	;store into HL
	xor a
	ld [MBC1SRamBankingMode], a
	ld [MBC1SRamEnable], a
	ret

;to check the defenders abilities to see if the value a matches
;returns zero if no match, 1 if ability 1 and 2 if ability 2
DoesDefenderHaveAbility:
	push bc
	push hl
	push af
; values for player turn
	ld hl,wEnemyMonAbility1
	ld a,[H_WHOSETURN]
	and a
	jr z,.next
;values for enemy turn
	ld hl,wBattleMonAbility1
.next
	jr CheckAbilityMatchCommon

;to check the attackers abilities to see if the value in a matches
DoesAttackerHaveAbility:
	push bc
	push hl
	push af
; values for enemy turn
	ld hl,wEnemyMonAbility1
	ld a,[H_WHOSETURN]
	and a
	jr nz,CheckAbilityMatchCommon
;values for player turn
	ld hl,wBattleMonAbility1
	;fall through	
;to check if a matches b or c
CheckAbilityMatchCommon:
	pop af
	ld b,[hl]; b = ability 1 of defender
	inc hl  
	ld c,[hl] ; b = ability 2 of defender
	ld h,1
	cp b	;does the ability match the pokemons first ability?
	jr z,.match
	inc h
	cp c	;does the ability match the pokemons second ability?
	jr z,.match
	xor a	;otherwise, set return value to 0
	jr .finish	
.match
	ld a,h	;set the index into a
.finish
	pop hl
	pop bc
	ret
	
;to pick a random move from the players list (only if its non-zero)
PickRandomNonZeroMove:
	push hl
	inc hl
	ld a,[hli]	;get the second attack
	and a
	jr nz,.checkAttack3	;skip down if not zero
	xor a	;otherwise, load the first attack
	jr .attackFound
.checkAttack3
	ld a,[hli]	;get the third attack
	and a
	jr nz,.checkAttack4	;skip down if not zero
	call BattleRandom
	and $1		;only keep the first bit
	jr .attackFound
.checkAttack4
	ld a,[hl]	;get the fourth attack
	and a
	jr nz,.allFourAttacks	;if all four attacks are options, then skip down
	call BattleRandom
	cp $55
	jr c,.notFirst	;skip down if $55 or greater
	xor a	;load first attack
	jr .attackFound
.notFirst
	cp $aa
	jr c,.notSecond	;skip down if $aa or greater
	ld a,1	;load 2nd attack
	jr .attackFound
.notSecond
	ld a,2	;load 3rd attack
	jr.attackFound	
.allFourAttacks
	call BattleRandom
	and $3
	;fall through
.attackFound
	pop hl
	push hl	;reset hl
	ld c, a
	ld b, $0
	add hl, bc
	ld a, [hl]
	pop hl
	ret
	
InsomniaText2:
	far_text _InsomniaText
	done
	
EarlyBirdText2:
	far_text _EarlyBirdText
	done

;this is only for wild pokemon
DetermineWildHeldItem:
	xor a
	ret
	
;this is only for wild pokemon
DetermineNewTraits2:
	ld a, [wEnemyBattleStatus3]
	bit Transformed, a ; is enemy mon transformed?
	jr z,.notTransformed
	ld a,[wEnemyMonTraits]		;just load the same traits that were already loaded
	ret
.notTransformed
	push hl
	push bc
	xor a		;set the value to zero
	ld hl,wMonHGenderEggGroup
	bit 7,[hl]		;can this pokemon be female?
	jr z,.cantBeFemale	;skip down if not
	bit 6,[hl]		;can this pokemon be male
	jr nz,.randomlyChooseGender	;if this pokemon can also be male, then randomly choose
	set FemaleTrait,a	;otherwise, set the female bit
	jr .afterGender
.cantBeFemale
	bit 6,[hl]		;can this pokemon be male?
	jr nz,.afterGender	;if so, then dont get any bits
	set GenderlessTrait,a	;otherwise, set the genderless bit
	jr .afterGender
.randomlyChooseGender
	call BattleRandom	;get a random value
	and $1	;only keep the first bit (male or female)
.afterGender
	;check the pre-set trait bits to see if this pokemon should be forced holo or shadow
	ld hl,wPresetTraits
	bit PresetHolo,[hl]	;is it holo?
	jr nz,.setHolo
	bit PresetShadow,[hl]	;is it shadow?
	jr nz,.setShadow
	
	ld b,a	;store the traits byte
	
	ld hl,wActiveCheats
	;otherwise, randomly set holo
	call BattleRandom	;get random value
	dec a
	jr nz,.notHolo	;if it didnt return 01, then skip the rest of the holo check
	bit LuckyCharmCheat,[hl]	;is the Lucky Charm cheat active?
	jr nz,.skipSecondHoloCheck	;then skip the second holo check
	
	call BattleRandom	;get another random value
	cp $20		;compare to $20 (1/8 chance, 1/2000 overall)
	jr nc,.notHolo	;if its $20 or greater, then its not holo
.skipSecondHoloCheck
	ld a,b	;recover the traits byte
	jr .setHolo	;and set the holo bit	
	
.notHolo
	;if not holo, see if randomly set shadow
	dec a	;was the first random byte 2 or the second random byte 1?
	jr nz,.notShadow	;skip down to not shadow if not
	push hl
	ld hl,wMajorCheckpoints	;load the major checkpoints
	bit SummonedGhosts,[hl]	;have we summon ghosts?
	pop hl
	jr z,.notShadow	;if not, then skip the shadow check
	
	call GetTimeOfDay		;get the time of day
	jr z,.notShadow		;if day time, then skip the shadow check
	
	bit LuckyCharmCheat,[hl]	;is the lucky charm cheat active?
	jr nz,.skipSecondShadowCheck	;skip the second shadow check if so
	
	call BattleRandom
	bit 0,a		;was bit 0 set? (50% chance)
	jr z,.notShadow	;if not, then its not shadow
	
.skipSecondShadowCheck
	ld a,b	;recover the traits byte
	jr .setShadow
	
.notShadow
	ld a,b
	jr .finish

.setHolo
	set HoloTrait,a
	jr .finish
.setShadow
	set ShadowTrait,a
	
.finish
	pop bc
	pop hl
	ret
	
	
DecrementPlayerOrEnemyPP:
	ld b,BANK(DecrementPP)
	ld hl,DecrementPP
	ld a, [H_WHOSETURN]
	and a
	jr z,.playersTurn
	ld hl,DecrementEnemyPP
.playersTurn
	jp Bankswitch
	
RegainWakeupEnergy:
	ld hl,wBattleMonPP
	ld a, [H_WHOSETURN]
	and a
	jr z,.playersTurn
	ld hl,wEnemyMonPP
.playersTurn
	ld a,[hli]
	and a
	ret nz	;dont inc if high byte is non zero
	ld a,[hl]
	cp 35		;compare to 35
	ret nc	;if 51 or greater, then dont adjust
	call BattleRandom
	and a,$0F
	add 35
	ld [hl],a	;update the pp to random between 35-51
	ld hl,RegainedEnergy
	jp PrintText