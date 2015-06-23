_AddPartyMon: ; f2e5 (3:72e5)
	ld de, wPartyCount ; wPartyCount
	ld a,[wMaxPartyMons]		;get the max party size
	ld b,a		;store into b
	ld a, [wcc49]
	and $f
	jr z, .start	;adding to players party
	ld a,[wTotems]
	bit IronTotem,a		;is the iron totem set?
	jr z,.notIronTotem	;then dont double
	ld a,[W_CURENEMYLVL]
	add a		;double
	ld [W_CURENEMYLVL],a
.notIronTotem
	ld de, wEnemyPartyCount ; wEnemyPartyCount
	ld b,6	;party size for enemy
.start
	inc b
	ld a, [de]
	inc a
	cp b	;	PARTY_LENGTH + 1
	ret nc
	ld [de], a
	ld a, [de]
	ld [$ffe4], a
	add e
	ld e, a
	jr nc, .asm_f300
	inc d
.asm_f300
	ld a, [wcf91]
	ld [de], a
	inc de
	ld a, $ff
	ld [de], a
	ld hl, wPartyMonOT ; wd273
	ld a, [wcc49]
	and $f
	jr z, .asm_f315
	ld hl, wEnemyMonOT
.asm_f315
	ld a, [$ffe4]
	dec a
	call SkipFixedLengthTextEntries	;hl points to the OT name
	ld b, $b
	xor a
.clearOTNameLoop
	ld [hli],a
	dec b
	jr nz,.clearOTNameLoop	;erase the 11 OT name bytes
	
	;to set the morale:
	ld bc,wPartyMon1Morale - wPartyMon2OT
	add hl,bc		;hl points to the morale
	call DetermineNewMorale
	
	ld [hld],a		;store morale and decrease hl to point to traits
	call DetermineNewTraits	;randomly set the bits for 'holo' or 'shadow' pokemon
	ld [hl],a
	
	;done adding traits, add in learned traits
	ld bc,wPartyMon1LearnedTraits - wPartyMon1Traits
	add hl,bc		;hl = learned traits
	
	ld a, [wcc49]
	and $f
	jr nz, .trainerLearnedTraits		;skip down if its the trainers party
	ld a, [W_ISINBATTLE] ; W_ISINBATTLE
	and a
	jr z, .saveLearnedTraits	;if not in battle, then we set to 0
	ld a,[wEnemyMonLearnedTraits]		;otherwise, copy from the enemy data	
	jr .saveLearnedTraits	
.trainerLearnedTraits
	call DetermineTrainerLearnedTraits
.saveLearnedTraits
	ld [hli],a		;store learned traits
	ld a, [wcc49]
	and $f
	jr nz, .trainerHeldItem		;skip down if its the trainers party
	ld a, [W_ISINBATTLE] ; W_ISINBATTLE
	and a
	jr z, .saveHeldItem	;if not in battle, then we set to 0
	ld a,[wEnemyMonHeldItem]		;otherwise, copy from the enemy data	
	jr .saveHeldItem	
.trainerHeldItem
	call DetermineTrainerHeldItem
.saveHeldItem
	ld a,[hl]
	
	ld a, [W_ISINBATTLE] ; W_ISINBATTLE
	and a
	jr z, .doneWithOTBytes	;if not in battle, then we don't copy additional data from the enemy
	
	;to copy secondary status
	ld bc,wPartyMon1SecondaryStatus - wPartyMon1HeldItem
	add hl,bc		;bc now points to secondary status
	xor a
	ld [hl],a		;zero the byte
	ld a,[W_ENEMYBATTSTATUS3]
	bit 0,a		;toxic bit set?
	jr z,.skipToxic
	set Toxic2,[hl]		;set toxic bit
.skipToxic
	bit 5,a		;delayed damage bit set?
	jr z,.skipDelayedDamage
	set DelayedDamage2,[hl]		;set delayed damage bit
.skipDelayedDamage
	
	;to copy delayed damage info
	inc hl
	inc hl
	inc hl
	ld a,[wEnemyMonDelayedDamage]
	ld [hli],a
	ld a,[wEnemyMonDelayedDamage+1]
	ld [hli],a
	ld a,[wEnemyMonDelayedDamageCounter]
	ld [hl],a	;copy delayed damage info
	
.doneWithOTBytes
	
	ld a, [wcc49]
	and a
	jr nz, .asm_f33f
	ld hl, wPartyMonNicks ; wPartyMonNicks
	ld a, [$ffe4]
	dec a
	call SkipFixedLengthTextEntries
	ld a,[wPresetTraits]
	bit PresetEgg,a	;is it an egg?
	jr z,.askNickname		;ask nickname if not
	ld a, [wcf91]
	ld [wd11e], a
	push hl
	call GetMonName
	pop de
	ld hl, wcd6d
	ld bc, 11
	call CopyData		;store the pokemons name
	jr .asm_f33f
.askNickname
	ld a, $2
	ld [wd07d], a
	predef AskName
.asm_f33f
	ld hl, wPartyMons
	ld a, [wcc49]
	and $f
	jr z, .asm_f34c
	ld hl, wEnemyMons
.asm_f34c
	ld a, [$ffe4]
	dec a
	ld bc, wPartyMon2 - wPartyMon1
	call AddNTimes
	ld e, l
	ld d, h
	push hl
	ld a, [wcf91]
	ld [wd0b5], a
	call GetMonHeader
	ld hl, W_MONHEADER
	ld a, [hli]
	ld [de], a
	inc de
	pop hl
	push hl
	ld a, [wcc49]
	and $f
	jr z, .playerPokemonDVs	;skip down if player party
	call BattleRandomFar2
	ld c,a
	call BattleRandomFar2
	ld b,a
	call BattleRandomFar2
	jr .writeFreshMonData
.playerPokemonDVs
	ld a, [wcf91]
	ld [wd11e], a
	push de
	predef IndexToPokedex
	pop de
	ld a, [wd11e]
	dec a
	ld c, a
	ld b, $2
	ld hl, wPokedexOwned ; wPokedexOwned
	call FlagAction
	ld a, c
	ld [wd153], a
	ld a, [wd11e]
	dec a
	ld c, a
	ld b, $1
	push bc
	call FlagAction
	pop bc
	ld hl, wPokedexSeen ; wd30a
	call FlagAction
	pop hl
	push hl
	ld a, [W_ISINBATTLE] ; W_ISINBATTLE
	and a
	jr nz, .copyEnemyMonData
	call Random ; generate random IVs
	ld c,a
	call Random
	ld b, a
	call Random
.writeFreshMonData ; f3b3
	push bc
	ld bc, wPartyMon1HPSpDefDV - wPartyMon1
	add hl, bc	;hl = hp/sp def dev
	ld [hl], a
	ld bc, wPartyMon1DVs - wPartyMon1HPSpDefDV	;hl = dvs
	add hl,bc
	pop bc
	ld [hl], c
	inc hl
	ld [hl], b         ; write IVs
	
	;done with IVs
	ld bc, $fff4
	add hl, bc
	ld a, $1
	ld c, a
	xor a
	ld b, a
	call CalcStat      ; calc HP stat (set cur Hp to max HP)
	ld a, [H_MULTIPLICAND+1]
	ld [de], a
	inc de
	ld a, [H_MULTIPLICAND+2]
	ld [de], a
	inc de
	xor a
	ld [de], a         ; level (?)
	inc de
	ld [de], a         ; status ailments
	inc de
	jr .copyMonTypesAndMoves
.copyEnemyMonData
	ld bc, wPartyMon1HPSpDefDV - wPartyMon1
	add hl, bc	;hl = hp/sp def dev
	ld a, [wEnemyMonHPSpDefDV]
	ld [hl], a
	ld bc, wPartyMon1DVs - wPartyMon1HPSpDefDV	;hl = dvs
	add hl,bc
	ld a, [wEnemyMonDVs] ; copy IVs from cur enemy mon
	ld [hli], a
	ld a, [wEnemyMonDVs + 1]
	ld [hl], a
	ld a, [wEnemyMonHP]    ; copy HP from cur enemy mon
	ld [de], a
	inc de
	ld a, [wEnemyMonHP+1]
	ld [de], a
	inc de
	xor a
	ld [de], a                 ; level (?)
	inc de
	ld a, [wEnemyMonStatus]   ; copy status ailments from cur enemy mon
	ld [de], a
	inc de
.copyMonTypesAndMoves
	ld hl, W_MONHTYPES
	ld a, [hli]       ; type 1
	ld [de], a
	inc de
	ld a, [hli]       ; type 2
	ld [de], a
	inc de				;removed 'Catch Rate'
	ld hl, W_MONHMOVES
	ld a, [hli]
	inc de
	push de
	ld [de], a
	ld a, [hli]
	inc de
	ld [de], a
	ld a, [hli]
	inc de
	ld [de], a
	ld a, [hli]
	inc de
	ld [de], a
	push de
	dec de
	dec de
	dec de
	xor a
	ld [wHPBarMaxHP], a
	predef WriteMonMoves
	pop de
	ld a, [W_ISINBATTLE] ; W_ISINBATTLE
	and a
	jr z, .skipCopyEnemySpecialDefense	;if not in battle, then don't copy the enemy pokemons special defense
	ld a,[wEnemyMonSpecialDefense]
	ld [de],a
	inc de
	ld a,[wEnemyMonSpecialDefense + 1]
	ld [de],a
	jr .finishSpecialDefense
	
.skipCopyEnemySpecialDefense
	inc de
.finishSpecialDefense
	inc de
	push de
	ld a, [W_CURENEMYLVL]
	ld d, a
	callab CalcExperience
	pop de
	inc de
	ld a, [H_MULTIPLICAND] ; write experience
	ld [de], a
	inc de
	ld a, [H_MULTIPLICAND+1]
	ld [de], a
	inc de
	ld a, [H_MULTIPLICAND+2]
	ld [de], a
	xor a
	ld b, $a
.writeEVsLoop              ; set all EVs to 0
	inc de
	ld [de], a
	dec b
	jr nz, .writeEVsLoop
	inc de
	inc de
	pop hl
	call AddPartyMon_WriteMovePP
	inc de
	ld a, [W_CURENEMYLVL] ; W_CURENEMYLVL
	ld [de], a
	inc de
	ld a, [W_ISINBATTLE] ; W_ISINBATTLE
	dec a
	jr nz, .calcFreshStats
	ld hl, wEnemyMonMaxHP ; wEnemyMonMaxHP
	ld bc, $a
	call CopyData          ; copy stats of cur enemy mon
	pop hl
	jr .done
.calcFreshStats
	pop hl
	ld bc, $10
	add hl, bc
	ld b, $0
	call CalcStats         ; calculate fresh set of stats
.done
	ld hl,wPresetTraits
	bit PresetEgg,[hl]	;is it an egg?
	jr z,.notEgg
	res PresetEgg,[hl]		;reset the bit
	ld hl,wPartyMon1HP
	ld bc,wPartyMon2-wPartyMon1
	ld a,[$ffe4]
	dec a
	call AddNTimes		;get to the pokemons HP
	xor a
	ld [hli],a
	ld [hl],a		;zero the hp
	ld hl,wPartyMon1DelayedDamage
	ld a,[$ffe4]
	dec a
	call SkipFixedLengthTextEntries
	push hl	;save the delayed damage pointer
	ld hl,W_MONHBASESTATS
	xor a
	ld b,0
	ld c,5	;5 stats
.loop
	add [hl]
	jr nc,.dontInc		;if we didnt wrap around, then dont increase b
	inc b
.dontInc
	inc hl
	dec c
	jr nz,.loop
	
	ld c,a
	ld a,[W_MONHBASESPECIALD]
	add c
	jr nc,.dontInc2
	inc b
.dontInc2
	ld c,a
	ld a,[W_MONHBASEPRICE]
	add c
	jr nc,.dontInc3
	inc b
.dontInc3
	ld c,a		;bc = sum of base stats and base price
	
	;to multiply by 16
	ld l,4		;counter
.multiplyBy16Loop
	sla c		;double c
	rl b		;double b and move the carry bit over if there was one
	dec l
	jr nz,.multiplyBy16Loop	;loop
	
	pop hl ;restore the delayed damage pointer
	ld [hl],b
	inc hl
	ld [hl],c
.notEgg
	scf
	ret
	

BattleRandomFar2:
	push de
	push hl
	push bc
	callab BattleRandom
	ld a,[wBattleRandom]
	pop bc
	pop hl
	pop de
	ret

LoadMovePPs: ; f473 (3:7473)
	call GetPredefRegisters
	; fallthrough
AddPartyMon_WriteMovePP: ; f476 (3:7476)
	ld b, $4
.pploop
	ld a, [hli]     ; read move ID
	and a
	jr z, .empty
	dec a
	push hl
	push de
	push bc
	ld hl, Moves
	ld bc, $6
	call AddNTimes
	ld de, wcd6d
	ld a, BANK(Moves)
	call FarCopyData
	pop bc
	pop de
	pop hl
	ld a, [wcd72] ; sixth move byte = pp
.empty
	inc de
	ld [de], a
	dec b
	jr nz, .pploop ; there are still moves to read
	ret


; adds enemy mon [wcf91] (at position [wWhichPokemon] in enemy list) to own party
; used in the cable club trade center
_AddEnemyMonToPlayerParty: ; f49d (3:749d)
	ld hl, wPartyCount
	ld a,[wMaxPartyMons]		;get the max party size
	ld b,a	;	store into b
	ld a, [hl]
	cp b	; PARTY_LENGTH
	scf
	ret z            ; party full, return failure
	inc a
	ld [hl], a       ; add 1 to party members
	ld c, a
	ld b, $0
	add hl, bc
	ld a, [wcf91]
	ld [hli], a      ; add mon as last list entry
	ld [hl], $ff     ; write new sentinel
	ld hl, wPartyMons
	ld a, [wPartyCount]
	dec a
	ld bc, wPartyMon2 - wPartyMon1
	call AddNTimes
	ld e, l
	ld d, h
	ld hl, wLoadedMon
	call CopyData    ; write new mon's data (from wLoadedMon)
	ld hl, wPartyMonOT
	ld a, [wPartyCount]
	dec a
	call SkipFixedLengthTextEntries
	ld d, h
	ld e, l
	ld hl, wEnemyMonOT
	ld a, [wWhichPokemon]
	call SkipFixedLengthTextEntries
	ld bc, $000b
	call CopyData    ; write new mon's OT name (from an enemy mon)
	ld hl, wPartyMonNicks
	ld a, [wPartyCount]
	dec a
	call SkipFixedLengthTextEntries
	ld d, h
	ld e, l
	ld hl, wEnemyMonNicks
	ld a, [wWhichPokemon]
	call SkipFixedLengthTextEntries
	ld bc, $000b
	call CopyData    ; write new mon's nickname (from an enemy mon)
	ld a, [wcf91]
	ld [wd11e], a
	predef IndexToPokedex
	ld a, [wd11e]
	dec a
	ld c, a
	ld b, $1
	ld hl, wPokedexOwned
	push bc
	call FlagAction ; add to owned pokemon
	pop bc
	ld hl, wPokedexSeen
	call FlagAction ; add to seen pokemon
	and a
	ret                  ; return success


Func_f51e: ; f51e (3:751e)
	ld a, [wcf95]
	and a
	jr z, .checkPartyMonSlots
	cp $2
	jr z, .checkPartyMonSlots
	cp $3
	ld hl, wDayCareMon
	jr z, .asm_f575
	ld hl, W_NUMINBOX ; wda80
	ld a, [hl]
	cp MONS_PER_BOX
	jr nz, .partyOrBoxNotFull
	jr .boxFull
.checkPartyMonSlots
	ld hl, wPartyCount ; wPartyCount
	ld a,[wMaxPartyMons]		;get the max party size
	ld b,a		;store into b
	ld a, [hl]
	cp b	; PARTY_LENGTH
	jr nz, .partyOrBoxNotFull
.boxFull
	scf
	ret
.partyOrBoxNotFull
	inc a
	ld [hl], a           ; increment number of mons in party/box
	ld c, a
	ld b, $0
	add hl, bc
	ld a, [wcf95]
	cp $2
	ld a, [wDayCareMon]
	jr z, .asm_f556
	ld a, [wcf91]
.asm_f556
	ld [hli], a          ; write new mon ID
	ld [hl], $ff         ; write new sentinel
	ld a, [wcf95]
	dec a
	ld hl, wPartyMons
	ld bc, wPartyMon2 - wPartyMon1 ; $2c
	ld a, [wPartyCount] ; wPartyCount
	jr nz, .skipToNewMonEntry
	ld hl, wBoxMons
	ld bc, wBoxMon2 - wBoxMon1 ; $21
	ld a, [W_NUMINBOX] ; wda80
.skipToNewMonEntry
	dec a
	call AddNTimes
.asm_f575
	push hl
	ld e, l
	ld d, h
	ld a, [wcf95]
	and a
	ld hl, wBoxMons
	ld bc, wBoxMon2 - wBoxMon1 ; $21
	jr z, .asm_f591
	cp $2
	ld hl, wDayCareMon
	jr z, .asm_f597
	ld hl, wPartyMons
	ld bc, wPartyMon2 - wPartyMon1 ; $2c
.asm_f591
	ld a, [wWhichPokemon] ; wWhichPokemon
	call AddNTimes
.asm_f597
	push hl
	push de
	ld bc, wBoxMon2 - wBoxMon1
	call CopyData
	pop de
	pop hl
	ld a, [wcf95]
	and a
	jr z, .asm_f5b4
	cp $2
	jr z, .asm_f5b4
	ld bc, wBoxMon1Level - wBoxMon1	;to set the pokemon's boxlevel
	add hl, bc
	ld a, [hl]
	inc de
	inc de
	inc de
	ld [de], a
.asm_f5b4
	ld a, [wcf95]
	cp $3
	ld de, W_DAYCAREMONOT
	jr z, .asm_f5d3
	dec a
	ld hl, wPartyMonOT ; wd273
	ld a, [wPartyCount] ; wPartyCount
	jr nz, .asm_f5cd
	ld hl, wBoxMonOT
	ld a, [W_NUMINBOX] ; wda80
.asm_f5cd
	dec a
	call SkipFixedLengthTextEntries
	ld d, h
	ld e, l
.asm_f5d3
	ld hl, wBoxMonOT
	ld a, [wcf95]
	and a
	jr z, .asm_f5e6
	ld hl, W_DAYCAREMONOT
	cp $2
	jr z, .asm_f5ec
	ld hl, wPartyMonOT ; wd273
.asm_f5e6
	ld a, [wWhichPokemon] ; wWhichPokemon
	call SkipFixedLengthTextEntries
.asm_f5ec
	ld bc, $b
	call CopyData
	ld a, [wcf95]
	cp $3
	ld de, W_DAYCAREMONNAME
	jr z, .asm_f611
	dec a
	ld hl, wPartyMonNicks ; wPartyMonNicks
	ld a, [wPartyCount] ; wPartyCount
	jr nz, .asm_f60b
	ld hl, wBoxMonNicks
	ld a, [W_NUMINBOX] ; wda80
.asm_f60b
	dec a
	call SkipFixedLengthTextEntries
	ld d, h
	ld e, l
.asm_f611
	ld hl, wBoxMonNicks
	ld a, [wcf95]
	and a
	jr z, .asm_f624
	ld hl, W_DAYCAREMONNAME
	cp $2
	jr z, .asm_f62a
	ld hl, wPartyMonNicks ; wPartyMonNicks
.asm_f624
	ld a, [wWhichPokemon] ; wWhichPokemon
	call SkipFixedLengthTextEntries
.asm_f62a
	ld bc, $b
	call CopyData
	pop hl
	;no need to recalculate stats (unless daycare mon get a level...)
	and a
	ret

;to random if its the players turn and battle random if its the enemies turn
RandomOrBattleRandom:
	ld a, [wcc49]
	and a
	jp nz,BattleRandomFar2	;use BattleRandom if it is the enemy
	jp Random
	
;To set pokemon traits when adding to players or enemy trainers party
DetermineNewTraits:
	push hl
	push bc
	ld a, [W_ISINBATTLE]
	and a
	jr z,.createNewTrait	;create new trait if not in battle
	ld hl,wEnemyMonTraits	;trait for player to copy
	ld a, [wcc49]
	and a
	jr z,.copyTrait	;skip down if its players turn
	ld hl,wBattleMonTraits	;trait for enemy to copy
.copyTrait
	ld a,[hl]
	set CaughtInCurrentBattleTrait,a
	jr .finish
.createNewTrait
	xor a		;set the value to zero
	ld hl,W_MONHGENDEREGGGROUP
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
	call RandomOrBattleRandom	;get a random value
	and $1	;only keep the first bit (male or female)
.afterGender
	;check the pre-set trait bits to see if this pokemon should be forced holo or shadow
	ld hl,wPresetTraits
	bit PresetHolo,[hl]	;is it holo?
	jr nz,.setHolo
	bit PresetShadow,[hl]	;is it shadow?
	jr nz,.setShadow
	bit PresetEgg,[hl]	;egg?
	jr nz,.setEgg
	bit PresetHealBall,[hl]	;heal ball?
	jr z,.skipHealBall	;skip heal ball if not
	
	set HealBallTrait,a	;otherwise, set the heal ball trait
	res PresetHealBall,[hl]	;and reset the 'preset heal ball' trait
	;fall through
.skipHealBall
	ld b,a	;store the traits byte
	ld a, [wcc49]
	and a
	ld a,b	;restore the traits byte
	jr nz,.finish	;skip down to 'caught in current battle' check if it is the enemys party (can't randomly add a holo to it)

	
	ld hl,wActiveCheats
	;otherwise, randomly set holo
	call Random	;get random value
	dec a
	ld a,b	;restore the traits byte
	jr nz,.finish	;if it didnt return 01, then skip the rest of the holo check
	bit LuckyCharmCheat,[hl]	;is the Lucky Charm cheat active?
	jr nz,.setHolo	;then skip the second holo check
	
	call Random	;get another random value
	cp $20		;compare to $20 (1/8 chance, 1/2000 overall)
	ld a,b		;restore the traits byte
	jr nc,.finish	;if its not under $20 then finish

.setHolo
	set HoloTrait,a
	jr .finish
.setEgg
	set EggTrait,a
	jr .skipHealBall	;continue randomly checking bits
.setShadow
	set ShadowTrait,a
	;fall through
.finish
	pop bc
	pop hl
	ret
	
;if in battle: copy from trainer and divide by 4.
;if wild battle or out of battle, pre-set value
;depends on the trainer if enemy
DetermineNewMorale:
	ret
	
;to determine the pokemons learned traits based on the trainer
DetermineTrainerLearnedTraits:
	ret
	
;to determine the pokemons held item based upon the trainer and pokemon type
DetermineTrainerHeldItem:
	ret
	

FlagActionPredef:
	call GetPredefRegisters

FlagAction:
; Perform action b on bit c
; in the bitfield at hl.
;  0: reset
;  1: set
;  2: read
; Return the result in c.

	push hl
	push de
	push bc

	; bit
	ld a, c
	ld d, a
	and 7
	ld e, a

	; byte
	ld a, d
	srl a
	srl a
	srl a
	add l
	ld l, a
	jr nc, .ok
	inc h
.ok

	; d = 1 << e (bitmask)
	inc e
	ld d, 1
.shift
	dec e
	jr z, .shifted
	sla d
	jr .shift
.shifted

	ld a, b
	and a
	jr z, .reset
	cp 2
	jr z, .read

.set
	ld b, [hl]
	ld a, d
	or b
	ld [hl], a
	jr .done

.reset
	ld b, [hl]
	ld a, d
	xor $ff
	and b
	ld [hl], a
	jr .done

.read
	ld b, [hl]
	ld a, d
	and b
.done
	pop bc
	pop de
	pop hl
	ld c, a
	ret
