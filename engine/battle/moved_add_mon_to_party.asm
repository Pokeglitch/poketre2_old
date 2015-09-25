_AddPartyMon: ; f2e5 (3:72e5)
	ld a, [wMonDataLocation]
	and $f
	ld a, [wIsInBattle]
	jr z, .playersParty	;adding to players party
	;otherwise, its the enemy party
	and a	;in battle?
	jp nz,AddCapturedMonToEnemyParty	;if we are in battle, then add the captured mon data
	jp AddNewMonToEnemyParty	;otherwise, add new mon data
.playersParty
	and a ;in battle?
	jp nz,AddCapturedMonToPlayerParty	;if we are in battle, then add the captured mon data
	jp AddNewMonToPlayerParty	;otherwise, add new mon data
	

AddNewMonToPlayerParty:
	call TryAddMonToPlayerParty
	ret nc		;return if we cant
	call SetDexSeenAndOwned
	
	call ClearPlayerMonOT
	ld bc,wPartyMon1DelayedDamage - wPartyMon1OT
	add hl,bc		;skip up to delayed damage / egg walk counter
	call SetEggWalkCounter
	call NewPlayerTraits
	call NewPlayerMorale
	
	call GoToPartyNickname
	call StoreDefaultName	;store the default nickname
	
	ld a,[wPresetTraits]
	bit PresetEgg,a	;is it an egg?
	call z,NewPlayerNickname	;ask nickname if not
	
	call GoToPartyMonData
	call NewPlayerDVs
	call NewLevelStatus	;move to level
	call NewPlayerMonMoves
	inc hl
	inc hl		;skip the special defense
	call GenerateNewExp
	call GenerateNewEnergy
	call GenerateNewStats
	
	call IsOffspringEgg		;is this a daycare egg?
	call nc,SetCurrentHPToMax		;set current hp to max if so
	
	scf
	ret
	
AddCapturedMonToPlayerParty:
	call TryAddMonToPlayerParty
	ret nc		;return if we cant
	call SetDexSeenAndOwned
	
	call ClearPlayerMonOT
	call CopyEnemySpDefEV
	call CopyEnemySecondaryStatus
	call CopyEnemyLearnedTraits
	call CopyEnemyHeldItem
	inc hl
	inc hl
	inc hl	;skip the delayed damage
	call CopyEnemyTraits
	call NewPlayerMorale
	call CopyEnemyRadioDamage
	call GoToPartyNickname
	
	call CopyEnemyNickname
	ld a,[wIsInBattle]
	dec a
	jr z,.notTrainerBattleNickname
	ld a,[wActiveCheats]
	bit IWHBYDCheat,a		;is the IWHBYD cheat on?
.notTrainerBattleNickname
	call z,NewPlayerNickname	;ask nickname if wild battle or IWHBYD is off
	
	call GoToPartyMonData
	call CopyEnemyDVs
	call CopyEnemyHPLevelStatus
	call CopyEnemyTypesMoves
	call CopyEnemySpecialDefense
	call CopyEnemyExp
	call CopyEnemyEnergy
	call CopyEnemyStats
	
	scf
	ret

AddNewMonToEnemyParty:
	call TryAddMonToEnemyParty
	ret nc		;return if we cant
	
	;apply the Iron Totem
	ld a,[wTotems]
	bit IronTotem,a		;is the iron totem set?
	jr z,.notIronTotem	;then dont double
	ld a,[wCurEnemyLVL]
	add a		;double
	ld [wCurEnemyLVL],a
	
.notIronTotem
	call ClearEnemyMonOT
	ld bc,wPartyMon1LearnedTraits - wPartyMon1OT
	add hl,bc		;skip up to learned traits
	call NewTrainerLearnedTraits
	call NewTrainerHeldItem
	inc hl
	inc hl
	inc hl	;skip the delayed damage
	call NewTrainerTraits
	call NewTrainerMorale
	
	call GoToEnemyNickname
	call NewTrainerNickname
	
	call GoToEnemyMonData
	call NewTrainerDVs
	call NewLevelStatus
	call NewTrainerMonMoves
	inc hl
	inc hl		;skip the special defense
	call GenerateNewExp
	call GenerateNewEnergy
	call GenerateNewStats
	call SetCurrentHPToMax
	
	scf
	ret

AddCapturedMonToEnemyParty:
	call TryAddMonToEnemyParty
	ret nc		;return if we cant
	
	call ClearEnemyMonOT
	call CopyPlayerSpDefEV
	call CopyPlayerSecondaryStatus
	call CopyPlayerLearnedTraits
	call CopyPlayerHeldItem
	inc hl
	inc hl
	inc hl	;skip the delayed damage
	call CopyPlayerTraits
	call CopyPlayerMorale
	call CopyPlayerRadioDamage
	
	call GoToEnemyNickname
	call CopyPlayerNickname
	
	call GoToEnemyMonData
	call CopyPlayerDVs
	call CopyPlayerHPLevelStatus
	call CopyPlayerTypesMoves
	call CopyPlayerSpecialDefense
	call CopyPlayerExp
	call CopyPlayerEnergy
	call CopyPlayerStats
	
	scf
	ret
	
AddNewMonToPC:
	call TryAddMonToPC
	ret nc		;return if we cant
	call SetDexSeenAndOwned
	
	call ClearPCMonOT
	ld bc,wPartyMon1DelayedDamage - wPartyMon1OT
	add hl,bc		;skip up to delayed damage / egg walk counter
	call SetEggWalkCounter
	call NewPlayerTraits
	call NewPlayerMorale
	
	call GoToPCNickname
	call StoreDefaultName	;store the default nickname
	ld a,[wPresetTraits]
	bit PresetEgg,a	;is it an egg?
	call z,NewPlayerNickname	;ask nickname if not
	
	call GoToPCMonData
	call NewPlayerDVs
	call NewLevelStatus
	call NewPlayerMonMoves
	inc hl
	inc hl		;skip the special defense
	call GenerateNewExp
	call GenerateNewEnergy
	call GenerateNewStats
	
	call IsOffspringEgg		;is this a daycare egg?
	call nc,SetCurrentHPToMax		;set current hp to max if so
	
	scf
	ret

AddCapturedMonToPC:
	call TryAddMonToPC
	ret nc		;return if we cant
	call SetDexSeenAndOwned
	
	call ClearPCMonOT
	call CopyEnemySpDefEV
	call CopyEnemySecondaryStatus
	call CopyEnemyLearnedTraits
	call CopyEnemyHeldItem
	inc hl
	inc hl
	inc hl	;skip the delayed damage
	call CopyEnemyTraits
	call NewPlayerMorale
	call CopyEnemyRadioDamage
	
	call GoToPCNickname
	call CopyEnemyNickname
	ld a,[wActiveCheats]
	bit IWHBYDCheat,a		;is the IWHBYD cheat on?
	call z,NewPlayerNickname	;ask nickname if not
	
	call GoToPCMonData
	call CopyEnemyDVs
	call CopyEnemyHPLevelStatus
	call CopyEnemyTypesMoves
	call CopyEnemySpecialDefense
	call CopyEnemyExp
	call CopyEnemyEnergy
	call CopyEnemyStats
	
	scf
	ret

;to see if the new pokemon being added is an egg that was created by two daycare pokemon
;returns carry if true
IsOffspringEgg:
	ld a,[wPresetTraits]
	bit PresetEgg,a	;is it an egg?
	jr z,.notOffspringEgg
	ld a,[W_CURMAP]		;get the map
	cp DAYCAREM		;is it the daycare?
	jr nz,.notOffspringEgg
	scf
	ret
.notOffspringEgg
	xor a		;unset the carry
	ret

	
;to see if the pokemon can be added to the players party and add if so
TryAddMonToPlayerParty:
	ld de, wPartyCount ; wPartyCount
	ld a,[wMaxPartyMons]		;get the max party size
	ld b,a		;store into b
	jr FinishTryAddMon

;to see if the pokemon can be added to the enemy's party and add if so
TryAddMonToEnemyParty:
	ld de, wEnemyPartyCount ; wEnemyPartyCount
	ld b,6	;party size for enemy
	jr FinishTryAddMon
	
;to see if the pokemon can be added to the pc and add if so
TryAddMonToPC:
	ld de, wNumInBox
	ld b, MONS_PER_BOX
	;fall through
	
;if it returns nc, then it failed
FinishTryAddMon:
	inc b
	ld a, [de]
	inc a
	cp b	;	PARTY_LENGTH + 1
	ret nc	;return if there is no space
	ld [de], a
	ld [$ffe4], a
	add e
	ld e, a
	jr nc, .noCarry
	inc d
.noCarry
	ld a, [wcf91]
	ld [de], a
	inc de
	ld a, $ff
	ld [de], a
	
	;get the mon header
	ld a, [wcf91]
	ld [wd0b5], a
	call GetMonHeader
	
	scf	;set the carry flag to show that we succeeded
	ret
	

	
SetDexSeenAndOwned:
	;to first set the 'pokemon owned' and 'pokemon seen' flags
	ld a, [wcf91]
	ld [wd11e], a
	predef IndexToPokedex
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
	jp FlagAction

	
	
	
;to clear the OT data
ClearPlayerMonOT:
	ld hl, wPartyMonOT
	jr ClearMonOT

ClearEnemyMonOT:
	ld hl, wEnemyMonOT
	jr ClearMonOT
	
ClearPCMonOT:
	ld hl, wBoxMonOT
	;fall through
	
ClearMonOT:
	ld a, [$ffe4]
	dec a
	call SkipFixedLengthTextEntries	;hl points to the OT name
	push hl
	ld b, 11
	xor a
.clearOTNameLoop
	ld [hli],a
	dec b
	jr nz,.clearOTNameLoop	;erase the 11 OT name bytes
	pop hl	;set hl back to start
	ret
		
	
;to copy the special defense EV
CopyEnemySpDefEV:
	ld de, wEnemyMonSpDefenseEV
	jr CopySpDefEV

CopyPlayerSpDefEV:
	ld de, wBattleMonSpDefenseEV
	;fall through

;de is where to copy from
;hl is where to copy to
CopySpDefEV:
	ld a,[de]
	ld [hli],a
	inc de
	ld a,[de]
	ld [hli],a
	ret
	

;to copy the secondary status and delayed damage
CopyEnemySecondaryStatus:
	ld a,[wEnemyBattleStatus3]
	ld de,wEnemyMonDelayedDamage
	jr FinishCopySecondaryStatus
	
;to copy the delayed damage
CopyPlayerSecondaryStatus:
	ld a,[wPlayerBattleStatus3]
	ld de,wBattleMonDelayedDamage
	;fall through

FinishCopySecondaryStatus:
	bit 0,a		;toxic bit set?
	jr z,.skipToxic
	set Toxic2,[hl]		;set toxic bit
.skipToxic
	bit 5,a		;delayed damage bit set?
	jr z,.afterDelayedDamage
	set DelayedDamage2,[hl]		;set delayed damage bit
	
	push hl	;store the current hl position
	
	;to copy delayed damage info
	inc hl
	inc hl
	inc hl
	ld a,[de]
	ld [hli],a
	inc de
	ld a,[de]
	ld [hli],a
	inc de
	ld a,[de]
	ld [hl],a	;copy delayed damage info
	
	pop hl	;recover the previous hl position
	;fall through
	
.afterDelayedDamage
	inc hl
	ret
	
	
;To get the learned traits
CopyEnemyLearnedTraits:
	ld a, [wEnemyMonLearnedTraits]
	jr FinishCopyLearnedTraits

CopyPlayerLearnedTraits:
	ld a, [wBattleMonLearnedTraits]
	;fall through

FinishCopyLearnedTraits:
	ld [hli],a
	ret
	
	
	
;To get the held item	
CopyEnemyHeldItem:
	ld a, [wEnemyMonHeldItem]
	jr FinishCopyHeldItem

CopyPlayerHeldItem:
	ld a, [wBattleMonHeldItem]
	;fall through

FinishCopyHeldItem:
	ld [hli],a
	ret
	
GetNewMonGender:
	xor a		;set the value to zero
	ld hl,wMonHGenderEggGroup
	bit 7,[hl]		;can this pokemon be female?
	jr z,.cantBeFemale	;skip down if not
	bit 6,[hl]		;can this pokemon be male
	jr nz,.randomlyChooseGender	;if this pokemon can also be male, then randomly choose
	set FemaleTrait,a	;otherwise, set the female bit
	ret
.cantBeFemale
	bit 6,[hl]		;can this pokemon be male?
	ret nz		;if so, then dont set any bits
	set GenderlessTrait,a	;otherwise, set the genderless bit
	ret
.randomlyChooseGender
	call RandomOrBattleRandom	;get a random value
	and $1	;only keep the first bit (male or female)
	ret
	
NewPlayerTraits:
	push hl
	call GetNewMonGender
	
	ld c,1		;default value to compare when checking for holo
	ld b,a	;backup the gender byte
	call IsOffspringEgg		;is this a daycare egg?
	jr nc,FinishNewMonTraits		;then dont check the parents
	
	ld a,[wDayCareMonTraits]		;check if parent 1 is holo
	bit HoloTrait,a		;is it holo?
	jr z,.nextParent		;skip to next parent if not
	
	sla c		;otherwise, double the compare value
	
.nextParent
	ld a,[wDayCareMon2Traits]		;check parent 2
	bit HoloTrait,a		;holo?
	jr z,FinishNewMonTraits		;skip down if not
	
	sla c		;otherwise, double the compare value
	
FinishNewMonTraits:
	;randomly see if it should be Holographic
	call Random	;get random value
	dec a
	cp c		;compare the random value to the default value
	ld a,b	;restore the traits byte
	jr nc,.finish	;if the compare value is not greater, then skip the rest of the holo check
	
	ld hl,wActiveCheats
	bit LuckyCharmCheat,[hl]	;is the Lucky Charm cheat active?
	jr nz,.setHolo	;if so, then set the bit

	call Random	;otherwise, get another random value
	cp $20		;compare to $20 (1/8 chance, 1/2000 overall)
	ld a,b		;restore the traits byte
	jr nc,.finish	;if its not under $20 then finish
	;otherwise, fall through and set the bit
	
.setHolo
	set HoloTrait,a
	;fall through	
	
.finish
	jr FinishCopyTraits
	
CopyEnemyTraits:
	push hl
	ld a, [wEnemyMonTraits]
	bit CaughtInCurrentBattleTrait,a		;was this pokemon stolen from the player already?
	res CaughtInCurrentBattleTrait,a		;reset the bit
	jr nz,.afterSet		;if so, then dont set
	set CaughtInCurrentBattleTrait,a	;otherwise, set the bit
.afterSet
	jr FinishCopyTraits

CopyPlayerTraits:
	push hl
	ld a, [wBattleMonTraits]
	set CaughtInCurrentBattleTrait,a
	;fall through
	
FinishCopyTraits:
	;check the pre-set trait bits to see if this pokemon should be forced holo or shadow
	ld hl,wPresetTraits
	bit PresetHolo,[hl]	;is it holo?
	jr z,.afterHolo
	set HoloTrait,a
	
.afterHolo
	bit PresetShadow,[hl]	;is it shadow?
	jr z,.afterShadow
	set ShadowTrait,a

.afterShadow
	bit PresetEgg,[hl]	;egg?
	jr z,.afterEgg
	set EggTrait,a

.afterEgg
	bit PresetHealBall,[hl]	;heal ball?
	jr z,.afterHealBall	;skip heal ball if not
	set HealBallTrait,a	;otherwise, set the heal ball trait

.afterHealBall
	pop hl			;recover the location we save to
	ld [hli],a
	ld [wSavedPokemonTraits],a	;also save it to the wSavedPokemonTraits for when it comes time to adjusting the DVs
	ret
	

;To get the morale	
NewPlayerMorale:
	ld a,[wIsInBattle]
	cp 2		;is it trainer battle?
	ld a, [W_MONHBASEMORALE]
	jr nz,.afterTrainerBattle
	
	;if trainer battle, divide the morale by 4
	srl a
	srl a
	
.afterTrainerBattle
	jr FinishCopyMorale

CopyPlayerMorale:
	ld a, [wBattleMonMorale]
	;fall through

FinishCopyMorale:
	ld [hli],a
	ret	
	
	

CopyEnemyRadioDamage:
	ld a, [wEnemyMonRadioDamage]
	jr FinishCopyRadioDamage

CopyPlayerRadioDamage:
	ld a, [wBattleMonRadioDamage]
	;fall through

FinishCopyRadioDamage:
	ld [hl],a
	ret	
	

GoToPartyNickname:
	ld hl, wPartyMonNicks
	jr FinishGoToNickname

GoToEnemyNickname:
	ld hl, wEnemyMonNicks
	jr FinishGoToNickname

GoToPCNickname:
	ld hl, wBoxMonNicks
	;fall through
	
FinishGoToNickname:
	ld a, [$ffe4]
	dec a
	call SkipFixedLengthTextEntries
	ret
	
	
CopyEnemyNickname:
	ld de, wEnemyMonNick
	jr FinishCopyNickname

CopyPlayerNickname:
	ld de, wBattleMonNick
	;fall through

FinishCopyNickname:
	push hl
	
	push hl
	push de
	pop hl
	pop de
	ld bc, 11
	call CopyData		;copy the other pokemons name

	pop hl	;recover the starting position
	ret

NewTrainerNickname:
	ld a,[wActiveCheats]
	bit IWHBYDCheat,a		;is the IWHBYD cheat on?
	jr z,StoreDefaultName	;if not, then get the default name
	
	ret

NewPlayerNickname:
	ld a, NAME_MON_SCREEN
	ld [wNamingScreenType], a
	predef AskName
	ret
	
StoreDefaultName:
	ld a, [wcf91]
	ld [wd11e], a
	push hl
	call GetMonName
	pop de
	push de
	ld hl, wcd6d
	ld bc, 11
	call CopyData		;store the pokemons name
	pop hl
	ret
	

GoToPartyMonData:
	ld hl, wPartyMons
	jr FinishGoToMonData

GoToEnemyMonData:
	ld hl, wEnemyMons
	jr FinishGoToMonData

GoToPCMonData:
	ld hl, wBoxMons
	;fall through
	
FinishGoToMonData:
	ld a, [$ffe4]
	dec a
	ld bc, wPartyMon2 - wPartyMon1
	call AddNTimes	;hl now points to the start of the pokemons party data
	;store the mon ID
	ld a, [wcf91]
	ld [hl], a
	ret
	

NewPlayerDVs:
	call IsOffspringEgg		;is this pokemon a daycare egg?
	jr c,GetEggDVs	;if so, then get from parents
	call GenerateRandomDVs	;otherwise, get random
	call AdjustDVsBasedOnGender
	jr FinishCopyDVs
	
GetEggDVs:
	push hl
	ld hl,00		;hl = counter from each parent
	
	ld a,[wDayCareMonDVs]
	ld d,a
	ld a,[wDayCareMon2DVs]
	ld e,a
	call .getDVs
	ld b,a		;store into b
	
	ld a,[wDayCareMonDVs + 1]
	ld d,a
	ld a,[wDayCareMon2DVs + 1]
	ld e,a
	call .getDVs
	ld c,a		;store into c
	
	ld a,[wDayCareMonHPSpDefDV]
	ld d,a
	ld a,[wDayCareMon2HPSpDefDV]
	ld e,a
	call .getDVs
	
	jr FinishCopyDVs

;returns new DV value in a
.getDVs
	xor a
	call .getRandomFromParents
	swap a
	swap d
	swap e
	call .getRandomFromParents
	swap a
	ret
;will get the low nybble DV value from a random parent
.getRandomFromParents
	push bc
	ld b,a		;store current DV value into b
	ld a,h
	cp 3
	jr z,.getFromParent2	;if we already have 3 from parent 1, then get from parent 2
	ld a,l
	cp 3
	jr z,.getFromParent2	;if we already have 3 from parent 2, then get from parent 1
	call Random
	cp $80
	jr nc,.getFromParent2	;50% chance
	;fall through	
.getFromParent1
	ld a,d
	inc h
	jr .retFromParent
.getFromParent2
	ld a,e
	inc l
	;fall through
.retFromParent
	and a,$0F
	add b		;add to the current dv value
	pop bc		;recover BC
	ret
		
GenerateRandomDVs:
	call RandomOrBattleRandom
	ld c,a
	call RandomOrBattleRandom
	ld b,a
	jp RandomOrBattleRandom

CopyEnemyDVs:
	ld a,[wEnemyMonDVs]
	ld c,a
	ld a,[wEnemyMonDVs + 1]
	ld b,a
	ld a,[wEnemyMonHPSpDefDV]
	jr FinishCopyDVs

CopyPlayerDVs:
	ld a,[wBattleMonDVs]
	ld c,a
	ld a,[wBattleMonDVs + 1]
	ld b,a
	ld a,[wBattleMonHPSpDefDV]
	;fall through

FinishCopyDVs:
	push hl
	
	push bc
	ld bc, wPartyMon1HPSpDefDV - wPartyMon1
	add hl, bc	;hl = hp/sp def dv
	ld [hl], a
	ld bc, wPartyMon1DVs - wPartyMon1HPSpDefDV	;hl = dvs
	add hl,bc
	pop bc
	ld [hl], c
	inc hl
	ld [hl], b         ; write DVs
	
	pop hl	;recover the starting position
	ret

;to round the dvs up to the nearest odd value (based on gender)
;male will increase physical
;female will increase special
;genderless will increase hp and speed
AdjustDVsBasedOnGender:
	push hl
	ld hl,wSavedPokemonTraits	;load the saved traits
	bit GenderlessTrait,[hl]	;is the pokemon genderless?
	jr z,.notGenderless
	push af
	ld a,b
	set 4,a		;set speed IV
	ld b,a
	pop af
	set 4,a		;set HP iv
	jr .finish
.notGenderless
	bit FemaleTrait,[hl]		;is the pokemon female?
	jr z,.notFemale
	push af
	ld a,b
	set 0,a		;set special attack
	ld b,a
	pop af
	set 0,a		;set special defense
	jr .finish
.notFemale
	push af
	ld a,c
	set 0,a
	set 4,a
	ld c,a
	pop af
.finish
	pop hl
	ret	


CopyEnemyHPLevelStatus:
	ld de,wEnemyMonHP

CopyPlayerHPLevelStatus:
	ld de,wBattleMonHP

FinishCopyHPLevelStatus:
	inc hl	;hl points to hp
	ld a,[de]
	ld [hli],a
	inc de
	ld a,[de]
	ld [hli],a	;HP
	inc de
	ld a,[wCurEnemyLVL]
	ld [hli],a	;level
	inc de
	ld a,[de]
	ld [hli],a	;status ailments
	ret
		
NewLevelStatus:
	inc hl		;hl pointer to HP
	xor a
	ld [hli],a
	ld [hli],a		;set the HP to zero for now
	ld a,[wCurEnemyLVL]
	ld [hli], a         ; level
	xor a
	ld [hli], a         ; status ailments
	ret
	
	
CopyEnemyTypesMoves:
	ld de,wEnemyMonMoves

CopyPlayerTypesMoves:
	ld de,wBattleMonMoves

FinishCopyTypesMoves:
	call CopyTypes

	;copy all moves	
	ld b,NUM_MOVES
.loop
	ld a,[de]
	inc de
	ld [hli],a
	dec b
	jr nz,.loop
	ret

NewPlayerMonMoves:
	call CopyTypes
	
	push hl		;backup the starting pointer
	
	push hl
	pop de		;move the pointer into de
	call NewMonMoves
	
	pop hl		;recover the starting pointer
	
	push hl		;store starting pointer
	
	call IsOffspringEgg		;is it daycare egg?
	call c,GetEggMoves		;if so, get egg moves
	
	pop hl		;recover the starting pointer
	ld bc,NUM_MOVES
	add hl,bc	;move hl past the 'moves' section
	
	ret
	
;de is the pointer to the moves
NewMonMoves:
	;to store the pokemons base moves
	ld hl, W_MONHMOVES
	
	push de
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	pop de
	
	xor a
	ld [wHPBarMaxHP], a
	predef WriteMonMoves	;to update the moves based on the pokemons level
	ret

GetEggMoves:
	ret
	
CopyTypes:
	ld a,[W_MONHTYPES]
	ld [hli],a
	ld a,[W_MONHTYPES + 1]
	ld [hli],a	;types
	inc hl	;skip the HP/Special Defence DVs (formerly Catch Rate)
	ret
	
	
CopyEnemySpecialDefense:
	ld de,wEnemyMonUnmodifiedSpecialDefense
	jr FinishCopySpecialDefense
	
CopyPlayerSpecialDefense:
	ld de,wPlayerMonUnmodifiedSpecialDefense
	;fall through

FinishCopySpecialDefense:
	ld a,[de]
	ld [hli],a
	inc de
	ld a,[de]
	ld [hli],a
	ret
	
CopyEnemyExp:
	ld de,wEnemyMonExp
	jr FinishCopyExp

CopyPlayerExp:
	ld de,wBattleMonExp
	;fall through

FinishCopyExp:
	push hl
	push de
	pop hl
	pop de
	ld bc, wPartyMon1DVs - wPartyMon1Exp
	call CopyData		;copy the exp
	push de
	pop hl		;hl points to after the Exp
	inc hl
	inc hl		;skip the DVs
	ret

GenerateNewExp:	
	push hl
	ld a, [wCurEnemyLVL]
	ld d, a
	callab CalcExperience
	pop hl
	ld a, [H_MULTIPLICAND] ; write experience
	ld [hli], a
	ld a, [H_MULTIPLICAND+1]
	ld [hli], a
	ld a, [H_MULTIPLICAND+2]
	ld [hli], a

	xor a
	ld b,wPartyMon1DVs - wPartyMon1HPExp
.clearEVsLoop              ; set all EVs to 0
	ld [hli], a
	dec b
	jr nz, .clearEVsLoop
	inc hl
	inc hl		;skip the DVs
	ret
	
CopyEnemyEnergy:
	ld de, wEnemyMonPP
	jr FinishCopyEnergy
	
CopyPlayerEnergy:
	ld de, wBattleMonPP
	;fall through

FinishCopyEnergy:
	ld b,4
.loop
	ld a,[de]
	ld [hli],a
	inc de
	dec b
	jr nz,.loop
	ret
	
GenerateNewEnergy:
	ld a,[wCurEnemyLVL]
	push hl	;store pointer
	
	ld d,0
	ld e,a	;de = level
	
	cp 30	;compare to level 30
	jr nc,.over30
	
	;multiply by 10
	ld hl,00
	ld b,10
	jr .multiplyLoop
	
.over30
	sub 30
	cp 40
	jr nc,.over70
	
	ld hl,300
	ld b,5
	jr .multiplyLoop
	
.over70
	ld hl,500
	sub 40
	ld b,1
	;fall through
	
.multiplyLoop
	add hl,de
	dec b
	jr nz,.multiplyLoop
	
	call RandomOrBattleRandom
	and $3F	;only keep lower 6 bits
	ld e,a
	add hl,de	;add to the value
	
	;make sure its not over 999
	ld a,h
	cp 4		;high byte 4?
	jr nc,.setTo999	;set to 999 if over 3
	cp $03	;high byte 03?
	jr nz,.skipSettingTo999	;if lower than 03, then not 999
	ld a,l
	cp $E8	;low byte e8 (1000)?
	jr c,.skipSettingTo999 ;if lower than e8, then don't set to 999	
.setTo999
	ld hl,999
.skipSettingTo999	
	push hl
	pop bc	;bc = value
	pop hl	;recover pointer 
	ld [hl],b
	inc hl
	ld [hl],c
	inc hl
	ld [hl],b
	inc hl
	ld [hl],c
	inc hl
	ret
	
CopyEnemyStats:
	ld de,wEnemyMonUnmodifiedLevel
	jr FinishCopyStats

CopyPlayerStats:
	ld de,wPlayerMonUnmodifiedLevel
	;fall through

FinishCopyStats:
	push hl
	push de
	pop hl
	pop de
	ld bc, 11
	call CopyData		;copy the stats
	push de
	pop hl		;hl points to after the stats
	ret

GenerateNewStats:
	ld a, [wCurEnemyLVL]
	ld [hli], a	;level
	push hl
	pop de
	ld hl,W_MONHBASESTATS + 1
	ld b, $0
	jp CalcStats         ; calculate fresh set of stats
	
SetCurrentHPToMax:
	push de
	
	ld hl, wPartyMon1MaxHP - wPartyMon2
	add hl,de		;hl points to max hp
	
	push hl
	pop bc		;bc points to max hp
	
	pop de
	
	ld hl, wPartyMon1HP - wPartyMon2
	add hl,de		;hl points to current hp
	
	ld a,[bc]
	ld [hli],a
	inc bc
	ld a,[bc]
	ld [hli],a		;copy max hp to current hp
	
	ret
	
SetEggWalkCounter:
	ld a,[wPresetTraits]
	bit PresetEgg,a	;is it an egg?
	jr nz,.setCounter	;then set the counter
	inc hl
	inc hl
	inc hl	;otherwise, move to after delayed damage
	ret
.setCounter
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
	inc hl
	inc hl	;move to after delayed damage
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


_MoveMon: ; f51e (3:751e)
	ld a, [wMoveMonType]
	and a
	jr z, .checkPartyMonSlots
	cp DAYCARE_TO_PARTY
	jr z, .checkPartyMonSlots
	cp PARTY_TO_DAYCARE
	ld hl, wDayCareMon
	jr z, .asm_f575
	ld hl, wNumInBox
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
	cp DAYCARE_TO_PARTY
	ld a, [wDayCareMon]
	jr z, .asm_f556
	ld a, [wcf91]
.asm_f556
	ld [hli], a          ; write new mon ID
	ld [hl], $ff         ; write new sentinel
	ld a, [wMoveMonType]
	dec a
	ld hl, wPartyMons
	ld bc, wPartyMon2 - wPartyMon1 ; $2c
	ld a, [wPartyCount] ; wPartyCount
	jr nz, .skipToNewMonEntry
	ld hl, wBoxMons
	ld bc, wBoxMon2 - wBoxMon1 ; $21
	ld a, [wNumInBox] ; wda80
.skipToNewMonEntry
	dec a
	call AddNTimes
.asm_f575
	push hl
	ld e, l
	ld d, h
	ld a, [wMoveMonType]
	and a
	ld hl, wBoxMons
	ld bc, wBoxMon2 - wBoxMon1 ; $21
	jr z, .asm_f591
	cp DAYCARE_TO_PARTY
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
	ld a, [wMoveMonType]
	and a
	jr z, .asm_f5b4
	cp DAYCARE_TO_PARTY
	jr z, .asm_f5b4
	ld bc, wBoxMon1Level - wBoxMon1	;to set the pokemon's boxlevel
	add hl, bc
	ld a, [hl]
	inc de
	inc de
	inc de
	ld [de], a
.asm_f5b4
	ld a, [wMoveMonType]
	cp PARTY_TO_DAYCARE
	ld de, W_DAYCAREMONOT
	jr z, .asm_f5d3
	dec a
	ld hl, wPartyMonOT ; wd273
	ld a, [wPartyCount] ; wPartyCount
	jr nz, .asm_f5cd
	ld hl, wBoxMonOT
	ld a, [wNumInBox] ; wda80
.asm_f5cd
	dec a
	call SkipFixedLengthTextEntries
	ld d, h
	ld e, l
.asm_f5d3
	ld hl, wBoxMonOT
	ld a, [wMoveMonType]
	and a
	jr z, .asm_f5e6
	ld hl, W_DAYCAREMONOT
	cp DAYCARE_TO_PARTY
	jr z, .asm_f5ec
	ld hl, wPartyMonOT ; wd273
.asm_f5e6
	ld a, [wWhichPokemon] ; wWhichPokemon
	call SkipFixedLengthTextEntries
.asm_f5ec
	ld bc, NAME_LENGTH
	call CopyData
	ld a, [wMoveMonType]
	cp PARTY_TO_DAYCARE
	ld de, wDayCareMonName
	jr z, .asm_f611
	dec a
	ld hl, wPartyMonNicks ; wPartyMonNicks
	ld a, [wPartyCount] ; wPartyCount
	jr nz, .asm_f60b
	ld hl, wBoxMonNicks
	ld a, [wNumInBox] ; wda80
.asm_f60b
	dec a
	call SkipFixedLengthTextEntries
	ld d, h
	ld e, l
.asm_f611
	ld hl, wBoxMonNicks
	ld a, [wMoveMonType]
	and a
	jr z, .asm_f624
	ld hl, wDayCareMonName
	cp DAYCARE_TO_PARTY
	jr z, .asm_f62a
	ld hl, wPartyMonNicks ; wPartyMonNicks
.asm_f624
	ld a, [wWhichPokemon] ; wWhichPokemon
	call SkipFixedLengthTextEntries
.asm_f62a
	ld bc, NAME_LENGTH
	call CopyData
	pop hl
	;no need to recalculate stats (unless daycare mon get a level...)
	and a
	ret

;to random if its the players turn and battle random if its the enemies turn
RandomOrBattleRandom:
	ld a, [wMonDataLocation]
	and a
	jp nz,BattleRandomFar2	;use BattleRandom if it is the enemy
	jp Random
	
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