LoadPlayerMonData:
	call LoadPlayerMonNickname
	call LoadPlayerMonHeader
	
	call GetPointerToPlayerMonPartyData	
	call LoadPlayerMonDVs
	call LoadPlayerHPLevelStatus
	call LoadPlayerMonMoves
	call LoadPlayerMonEnergy
	call LoadPlayerMonExp
	call LoadPlayerMonStats
	call BackupPlayerMonUnmodifiedStats
	
	call LoadPlayerMonOTData
	
	call LoadPlayerMonStatMods
	call LoadPlayerTemporarySecondaryStatus
	call LoadPlayerMonConfusedStatus
	call LoadPlayerMonCursedFearStatus
	call LoadPlayerMonDisabledStatus
	call LoadPlayerMonToxicStatus
	
	callab ApplyBurnAndParalysisPenaltiesToPlayer
	call ApplyPlayerPotionStatBoost
	call ApplyPlayerHeldItemStatBoost
	callab CalcPlayerModStatsSavewD11E
	ret
	
LoadPlayerLastStandData:
	res PresetLastStand,[hl]
	
	;store the species
	ld a,HUMAN
	ld [wBattleMonSpecies2],a
	
	call LoadPlayerLastStandNickname
	call LoadPlayerMonHeader
	
	call LoadPlayerLastStandTraits
	call LoadPlayerLastStandDVs
	call LoadPlayerLastStandHPLevelStatus
	call LoadPlayerLastStandMoves
	call LoadPlayerLastStandEnergy
	call LoadPlayerLastStandExp
	call LoadPlayerLastStandStats
	call BackupPlayerMonUnmodifiedStats
	
	ld hl,wBattleMonSpDefenseEV
	call LoadWildMonSpDefenseEV
	call LoadPlayerLastStandSecondaryStatus
	call LoadPlayerLastStandLearnedTraits
	call LoadPlayerLastStandHeldItem
	call LoadPlayerLastStandDelayedDamage
	call FinishLoadingMonTraits
	call LoadPlayerLastStandMorale
	
	call LoadLastStandStatMods
	call LoadPlayerTemporarySecondaryStatus
	call LoadLastStandConfusedStatus
	call LoadLastStandCursedFearStatus
	call LoadLastStandDisabledStatus
	call LoadLastStandToxicStatus
	
	callab ApplyBurnAndParalysisPenaltiesToPlayer
	call ApplyPlayerPotionStatBoost
	call ApplyPlayerHeldItemStatBoost
	callab CalcPlayerModStatsSavewD11E
	ret
	
	

LoadHordeMonData:
LoadEnemyTrainerMonData:
	call SetPokedexSeen
	call LoadEnemyTrainerMonNickname
	call LoadEnemyMonHeader
	
	call GetPointerToEnemyMonPartyData	
	call LoadEnemyTrainerMonDVs
	call LoadEnemyTrainerHPLevelStatus
	call LoadEnemyTrainerMonMoves
	call LoadEnemyTrainerMonEnergy
	call LoadEnemyTrainerMonExp
	call LoadEnemyTrainerMonStats
	call BackupEnemyMonUnmodifiedStats
	
	call LoadEnemyTrainerMonOTData
	
	call LoadEnemyTrainerMonStatMods
	call LoadEnemyTemporarySecondaryStatus
	call LoadEnemyTrainerMonConfusedStatus
	call LoadEnemyTrainerMonCursedFearStatus
	call LoadEnemyTrainerMonDisabledStatus
	call LoadEnemyTrainerMonToxicStatus
	
	callab ApplyBurnAndParalysisPenaltiesToEnemy
	call ApplyEnemyPotionStatBoost
	call ApplyEnemyHeldItemStatBoost
	callab CalcEnemyModStatsSavewD11E
	ret
		
LoadEnemyLastStandData:
	ld hl,W_MONHFRONTSPRITE
	ld a,[wTrainerPicPointer]
	ld [hli],a
	ld a,[wTrainerPicPointer + 1]
	ld [hl],a		;set the pokemon front pic pointer to the enemy front pic pointer
	ld a,$13
	ld [W_MONHSPRITEBANK],a		;set the pokemon pic bank to the enemy trainer pic bank (all trainers are in bank $13
	
	call LoadWildMonData
	call LoadEnemyLastStandMoves
	ret
	
LoadWildMonDataCheckMrMime:
	;first see if we should actually be battling Mr. Mime
	ld a,[wMrMimeFlags]
	bit MrMimeCaughtOrFainted,a
	jr nz,LoadWildMonData		;if mr mime is not roaming anymore, then skip down
	bit MrMimeRoaming,a
	jr z,LoadWildMonData		;if mr mime still isnt roaming, then skip down
	ld hl,wMrMimeMap
	ld a,[W_CURMAP]
	cp [hl]		;is mr mime in the current map?
	jr nz,LoadWildMonData	;skip down if not
	call BattleRandom	;otherwise, call battle random
	cp 5
	jp c,LoadMrMimeBattleData	;if under 5, then its Mr. Mime
	;fall through
	
LoadWildMonData:
	call SetPokedexSeen
	call LoadWildMonNickname
	call LoadEnemyMonHeader
	
	call LoadWildMonTraits
	call LoadWildMonDVs
	call LoadWildHPLevelStatus
	
FinishLoadWildMonData:	;used for loading rest of mr mime data
	call LoadWildMonMoves
	call LoadWildMonEnergy
	call LoadWildMonExp
	call LoadWildMonStats
	call BackupEnemyMonUnmodifiedStats
	
	ld hl,wEnemyMonSpDefenseEV
	call LoadWildMonSpDefenseEV
	call LoadWildMonSecondaryStatus
	call LoadWildMonLearnedTraits
	call LoadWildMonHeldItem
	call LoadWildMonDelayedDamage
	call FinishLoadingMonTraits
	call LoadWildMonMorale
	
	call LoadWildMonStatMods
	call LoadEnemyTemporarySecondaryStatus
	call LoadWildMonConfusedStatus
	call LoadWildMonCursedFearStatus
	call LoadWildMonDisabledStatus
	call LoadWildMonToxicStatus
	
	call ApplyEnemyHeldItemStatBoost
	callab CalcEnemyModStatsSavewD11E
	ret

LoadMrMimeBattleData:
	ld a,MR_MIME
	ld [wEnemyMonSpecies2],a
	ld a,30		;level 30
	ld [W_CURENEMYLVL],a
	
	ld hl,wMrMimeFlags
	bit MrMimeEncountered,[hl]		;have we encountered mr mime?
	jr nz,.alreadyEncounteredMrMime	;load the data if we have
	
	call LoadWildMonData	;load it is a normal wild mon
	call SaveMrMimeData		;otherwise, save the data
	ret
	
.alreadyEncounteredMrMime
	call SetPokedexSeen
	call LoadWildMonNickname
	call LoadEnemyMonHeader
	
	call LoadMrMimeTraits
	call LoadMrMimeDVs
	call LoadMrMimeHPLevelStatus
	
	call FinishLoadWildMonData		;load rest of wild pokemon data
	
	;restore the backed up OT bytes
	ld hl,wEnemyMonSecondaryStatus
	call LoadMrMimeSecondaryStatus
	inc hl		;skip learned traits
	call LoadMrMimeHeldItem
	ret
	
	
	
	
	
LoadEnemyMonData: ; 3eb01 (f:6b01)
	ld a, [wLinkState]
	cp LINK_STATE_BATTLING
	jp z, LoadEnemyTrainerMonData	;if in link battle, load from enemy trainer party
	call GetHordeIsInBattle
	dec a
	jp z,LoadWildMonDataCheckMrMime		;wild pokemon
	jp LoadEnemyTrainerMonData	;horde or trainer


	
SetPokedexSeen:
	ld a, [wEnemyMonSpecies2]
	ld [wd11e], a
	predef IndexToPokedex
	ld a, [wd11e]
	dec a
	ld c, a
	ld b, $1
	ld hl, wPokedexSeen
	predef FlagActionPredef ; mark this mon as seen in the pokedex
	ret

GetPointerToPlayerMonPartyData:
	ld hl, wPartyMon1
	ld a, [wWhichPokemon]
	jr FinishGetPointerToPartyData
	
GetPointerToEnemyMonPartyData:
	ld hl, wEnemyMon1
	ld a, [wWhichPokemon]
	ld [wEnemyMonPartyPos], a
	;fall through
	
FinishGetPointerToPartyData:
	ld bc, wEnemyMon2 - wEnemyMon1
	call AddNTimes
	push hl
	pop de
	ret
	
LoadPlayerMonHeader:
	ld bc, wBattleMonAbility1
	ld de, wBattleMonType
	ld hl, wBattleMonBaseStats
	ld a, [wBattleMonSpecies2]
	ld [wBattleMonSpecies], a
	ld [wPlayerOriginalTransformedSpecies],a
	jr FinishLoadBattleMonHeader
	
	
LoadEnemyMonHeader:
	ld bc, wEnemyMonAbility1
	ld de, wEnemyMonType
	ld hl, wEnemyMonBaseStats
	ld a, [wEnemyMonSpecies2]
	ld [wEnemyMonSpecies], a
	ld [wEnemyOriginalTransformedSpecies],a
	;fall through
	
FinishLoadBattleMonHeader:
	ld [wd0b5], a
	push bc
	push de
	push hl
	call GetMonHeader
	pop hl
	
	;copy the base stats
	ld de, W_MONHBASESTATS
	ld b, 5
.copyBaseStatsLoop
	ld a, [de]
	ld [hli], a
	inc de
	dec b
	jr nz, .copyBaseStatsLoop
	
	ld de, W_MONHCATCHRATE
	ld a, [de]
	ld [hli], a	;catch rate
	inc de
	ld a, [de]
	ld [hl], a ; base exp
	
	
	pop de
	ld hl, W_MONHTYPES
	ld a, [hli]            ; copy type 1
	ld [de], a
	inc de
	ld a, [hli]            ; copy type 2
	ld [de], a
	inc de
	ld a,[hli]		;copy catch rate
	ld [de],a
	
	pop bc
	ld hl,W_MONHABILITY1
	ld a,[hli]
	ld [bc],a
	inc bc
	ld a,[hli]
	ld [bc],a		;copy abilities
	inc bc
	ld a,[hl]
	ld [bc],a		;copy base special defense
	
	ret
	
	
LoadMrMimeDVs:
	ld hl,wMrMimeDVs
	ld a,[hli]
	ld b,[hl]
	inc hl
	ld c,[hl]
	jr StoreEnemyBattleDVs
	
LoadPlayerMonDVs:
	push de
	call LoadDVsFromParty
	call StorePlayerBattleDVs
	pop de		;recover DE
	ret

;zero the dvs
LoadPlayerLastStandDVs:
	xor a
	ld b,a
	ld c,a
	;fall through
	
StorePlayerBattleDVs:
	ld de, wBattleMonHPSpDefDV
	ld hl, wBattleMonDVs
	jr StoreBattleDVs
	
	
LoadEnemyTrainerMonDVs:
	push de
	call LoadDVsFromParty
	call StoreEnemyBattleDVs
	pop de		;recover DE
	ret

LoadDVsFromParty:
	ld hl,wEnemyMon1HPSpDefDV-wEnemyMon1
	add hl,de		;hl points to wEnemyMon1HPSpDefDV
	ld a, [hl]
	ld bc, wEnemyMon1DVs - wEnemyMon1HPSpDefDV
	add hl,bc	;hl now points to the original DVs
	ld b, [hl]
	inc hl
	ld c,[hl]
	ret
	
LoadWildMonDVs:
	call BattleRandomFar2
	ld b, a
	call BattleRandomFar2
	ld c, a
	call BattleRandomFar2
	call AdjustDVsBasedOnGender
	;fall through
	
StoreEnemyBattleDVs:
	ld de, wEnemyMonHPSpDefDV
	ld hl, wEnemyMonDVs
	
StoreBattleDVs:
	ld [de],a
	ld a,b
	ld [hli], a
	ld [hl], c
	ret
	
	

LoadWildHPLevelStatus:
	ld de, wEnemyMonLevel
	ld a, [W_CURENEMYLVL]	
	ld [de], a
	inc de
	ld b, $0
	ld hl, wEnemyMonHP
	push hl
	call CalcStats
	pop hl
	ld a, [wEnemyMonMaxHP]
	ld [hli], a
	ld a, [wEnemyMonMaxHP+1]
	ld [hli], a		;set hp to max hp
	xor a
	inc hl
	ld [hl], a ; init status to 0
	ret
	
LoadPlayerLastStandHPLevelStatus:
	ld a,[W_CURENEMYLVL]
	push af		;store the enemy mon level
	
	;store the level
	call GetPlayerLevel
	srl a	;divide by 2
	bit MasterTrainerTotem,[hl]	;is the Master Trainer totem set?
	jr nz,.saveLevel		;then save level regardless of value
	cp a,100				;compare to level 100
	jr c,.saveLevel			;if under 100, then just save level
	ld a,100				;otherwise, load to 100
.saveLevel
	ld [wBattleMonLevel],a
	ld [W_CURENEMYLVL],a		;temporarily store into enemy mon level (for calculating stats)
	
	;calc the stats
	ld hl,wBattleMonDVs - 11	;when calculating stat using DVs, it adds 11 to HL
	ld de, wBattleMonMaxHP
	ld b,0	;do not use 'stat experience' in the calcs
	call CalcStats
	
	pop af
	ld [W_CURENEMYLVL],a		;restore the enemy mon level
	
	;see if the max hp changed, if so apply difference to current hp
	ld a,[wLastStandMaxHP]
	cpl
	ld d,a
	ld a,[wLastStandMaxHP + 1]
	cpl
	ld e,a
	inc de	;de = 0-previous max hp
	
	ld a,[wBattleMonMaxHP]
	ld h,a
	ld [wLastStandMaxHP],a
	ld a,[wBattleMonMaxHP + 1]
	ld l,a		;hl = new max hp
	ld [wLastStandMaxHP + 1],a
	add hl,de	;hl will now equal how much the max hp was increased
	
	ld a,[wLastStandHP]
	ld d,a
	ld a,[wLastStandHP + 1]
	ld e,a		;hl = previous last stand hp
	add hl,de		;raise the previous hp with the same amount the max hp increased
	ld a,h
	ld [wLastStandHP],a
	ld a,l
	ld [wLastStandHP + 1],a
	
	;copy the current hp and status
	ld bc,wBattleMonHP
	ld hl,wLastStandHP
	jr FinishStoredHPStatus
	
LoadPlayerHPLevelStatus:
	ld bc,wBattleMonHP
	call FinishLoadTrainerHPLevelStatus
	dec bc
	ld a,[bc]
	ld [hl],a		;store the level
	ret
	
LoadEnemyTrainerHPLevelStatus:
	ld bc,wEnemyMonHP
	;fall through
	
FinishLoadTrainerHPLevelStatus:
	ld hl,wEnemyMon1HP - wEnemyMon1
	add hl,de	;hl points to hp in party
	ld a,[hli]
	ld [bc],a
	inc bc
	ld a,[hli]
	ld [bc],a		;copy HP
	inc bc
	inc hl
	inc bc			;skip the "level"
	ld a,[hld]
	ld [bc],a		;copy status
	ret
	
LoadMrMimeHPLevelStatus:
	ld a,30
	ld [wEnemyMonLevel],a		;store the level
	ld hl,wMrMimeHP		;start of mr mime data
	ld bc,wEnemyMonHP
FinishStoredHPStatus:
	ld a,[hli]
	ld [bc],a
	inc bc
	ld a,[hli]
	ld [bc],a		;copy HP
	inc bc
	ld a,[hl]
	ld [bc],a		;copy status
	ret

	
	
LoadPlayerLastStandMoves:
	ret
	
LoadPlayerMonMoves:
	ld bc,wBattleMonMoves
	jr FinishLoadPartyMonMoves
	
LoadEnemyTrainerMonMoves:
	ld bc,wEnemyMonMoves
	;fall through
	
FinishLoadPartyMonMoves:
	push de
	ld hl,wEnemyMon1Moves - wEnemyMon1
	add hl,de	;hl points to moves in party
	push bc
	pop de
	ld bc, NUM_MOVES
	call CopyData
		
	pop de
	ret

LoadWildMonMoves:
	ld de,wEnemyMonMoves
	ld hl, W_MONHMOVES
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a
	dec de
	dec de
	dec de
	xor a
	ld [wHPBarMaxHP], a
	predef WriteMonMoves ; get moves based on current level
	ret
	
LoadEnemyLastStandMoves:
	ret
	
	
	
LoadPlayerLastStandEnergy:
	ld de,wBattleMonPP
	ld hl,wLastStandPP
	ld bc,4
	jp CopyData
	
LoadPlayerMonEnergy:
	ld bc,wBattleMonPP
	jr FinishLoadPartyMonEnergy

LoadEnemyTrainerMonEnergy:
	ld bc,wEnemyMonPP
	;fall through
	
FinishLoadPartyMonEnergy:
	push de
	
	ld hl,wEnemyMon1PP - wEnemyMon1
	add hl,de	;hl points to PP in party
	push bc
	pop de
	ld bc, 4
	call CopyData
		
	pop de
	ret
	
LoadWildMonEnergy:
	ld hl,wEnemyMonPP
	call GenerateNewEnergy
	ret


	
LoadWildMonNickname:
	ld a, [wEnemyMonSpecies2]
	ld [wd11e], a
	call GetMonName
	ld hl, wcd6d
	jr FinishCopyMonNickname

LoadPlayerLastStandNickname:
	ld hl, wPlayerName
	ld de, wBattleMonNick
	jr FinishCopyMonNickname

	
LoadPlayerMonNickname:
	ld hl, wPartyMonNicks
	ld de, wBattleMonNick
	jr FinishCopyPartyMonNickname

	
LoadEnemyTrainerMonNickname:
	ld hl, wEnemyMonNicks
	ld de, wEnemyMonNick
	;fall through
	
FinishCopyPartyMonNickname:
	ld a, [wWhichPokemon]
	call SkipFixedLengthTextEntries	;hl points to the party nickname
	
FinishCopyMonNickname:
	ld bc, 11
	jp CopyData

LoadPlayerLastStandStats:
LoadWildMonStats:
	ret
	
LoadPlayerMonStats:
	ld hl, wBattleMonLevel
	ld bc, wBattleMonSpecialDefense
	jr FinishLoadTrainerStats
	
LoadEnemyTrainerMonStats:
	ld hl,wEnemyMonLevel
	ld bc,wEnemyMonSpecialDefense
	;fall through

FinishLoadTrainerStats:
	push de
	push bc
	
	push hl
	ld hl,wEnemyMon1Level - wEnemyMon1
	add hl,de	;hl points to the Exp of the party data
	pop de
	
	ld bc,wPartyMon2 - wPartyMon1Level	;size to copy
	call CopyData
	
	pop bc
	pop de
	
	ld hl,wEnemyMon1SpDefense - wEnemyMon1
	add hl,de	;hl pints to special defense
	
	ld a,[hli]
	ld [bc],a
	inc bc
	ld a,[hli]
	ld [bc],a	;copy the special defense
	
	ret
	
BackupPlayerMonUnmodifiedStats:
	push de
	ld hl,wBattleMonSpecialDefense
	ld de,wPlayerMonUnmodifiedSpecialDefense
	push hl
	push de
	ld hl, wBattleMonLevel
	ld de, wPlayerMonUnmodifiedLevel
	jr FinishTrainerMonUnmodifiedStats
	
BackupEnemyMonUnmodifiedStats:
	push de
	ld hl,wEnemyMonSpecialDefense
	ld de,wEnemyMonUnmodifiedSpecialDefense
	push hl
	push de
	ld hl, wEnemyMonLevel
	ld de, wEnemyMonUnmodifiedLevel
	;fall through
	
FinishTrainerMonUnmodifiedStats:
	ld bc, $b
	call CopyData
	pop de
	pop hl
	ld a,[hli]
	ld [de],a
	inc de
	ld a,[hl]
	ld [de],a	;copy the calculated special defense stat and store as unmodified special defense
	pop de
	ret

LoadPlayerMonOTData:	
	ld hl,wPartyMon1SpDefenseEV	;start of additional bytes pointer
	ld de,wBattleMonSpDefenseEV	;where to save to
	jr FinishLoadTrainerMonOTData
	
LoadEnemyTrainerMonOTData:
	ld hl,wEnemyMon1SpDefenseEV	;start of additional bytes pointer
	ld de,wEnemyMonSpDefenseEV	;where to save to
	;fall through
	
FinishLoadTrainerMonOTData:
	ld a,[wWhichPokemon]	;get the index of the pokemon we are copying from
	call SkipFixedLengthTextEntries	;go to the data of the corresponding pokemon
	
	ld bc,10		;copy 10 bytes for enemy
	jp CopyData	;copy the data from hl to de



LoadPlayerTemporarySecondaryStatus:
	ld hl,wBattleMonSecondaryStatus
	ld bc,W_PLAYERBATTSTATUS1	;temporary battle bits
	jr FinishLoadTemporarySecondaryStatus
	
LoadEnemyTemporarySecondaryStatus:
	ld hl,wEnemyMonSecondaryStatus
	ld bc,W_ENEMYBATTSTATUS1	;temporary battle bits
	;fall through
	
FinishLoadTemporarySecondaryStatus:
	xor a	;initialize to 0
	;copy over the secondary status bits to the corresponding in-battle status bits
	bit Confused2,[hl]		;confused bit set?
	jr z,.skipConfused
	set 7,a		;otherwise, set the bit
.skipConfused
	ld [bc],a
	inc bc
	xor a	;initialize to 0
	ld [bc],a
	inc bc	;move to the third temp status byte (a is already 0)
	bit Toxic2,[hl]	;toxic bit set?
	jr z,.skipToxic
	set 0,a		;set toxic bit
.skipToxic
	bit Fear2,[hl]	;fear bit set?
	jr z,.skipFear
	set 4,a		;set fear bit
.skipFear
	bit DelayedDamage2,[hl]	;delayed damage bit set?
	jr z,.skipDelayedDamage
	set 5,a		;set delayed damage bit
.skipDelayedDamage
	bit Cursed2,[hl]	;cursed bit set?
	jr z,.skipCursed
	set 6,a		;set cursed bit
.skipCursed
	ld [bc],a	;save the temp status byte
	ret

	
;Wild Mon OT values	
LoadWildMonSpDefenseEV:
	xor a
	ld [hli],a
	ld [hli],a
	ret
	
	
LoadPlayerLastStandSecondaryStatus:
	ld a,[wLastStandSecondaryStatus]
	jr FinishEnemyMonSecondaryStatus
	
LoadWildMonSecondaryStatus:
	xor a
	jr FinishEnemyMonSecondaryStatus
	
LoadMrMimeSecondaryStatus:
	ld a,[wMrMimeSecondaryStatus]
	;fall through
	
FinishEnemyMonSecondaryStatus:
	ld [hli],a	;store the secondary status
	ret
	

LoadPlayerLastStandLearnedTraits:
	xor a
	jr FinishLoadLearnedTraits
	
LoadWildMonLearnedTraits:
	xor a
	;fall through
	
FinishLoadLearnedTraits:
	ld [hli],a		;store the learned traits
	ret

DeterminePlayerLastStandHeldItem:
	ret

LoadPlayerLastStandHeldItem:
	call DeterminePlayerLastStandHeldItem
	jr FinishEnemyHeldItem
	
LoadWildMonHeldItem:
	call DetermineWildHeldItem
	jr FinishEnemyHeldItem
	
LoadMrMimeHeldItem:
	xor a
	;fall through
	
FinishEnemyHeldItem:
	ld [hli],a		;store the held item
	ret
	
	

LoadPlayerLastStandDelayedDamage
	ld de,wLastStandDelayedDamage
	ld a,[de]
	inc de
	ld [hli],a
	ld a,[de]
	inc de
	ld [hli],a
	ld a,[de]
	ld [hli],a
	ret
	
LoadWildMonDelayedDamage:
	xor a
	ld [hli],a
	ld [hli],a
	ld [hli],a
	ret
	
DeterminePlayerLastStandTraits:
	ret

LoadPlayerLastStandTraits:
	call DeterminePlayerLastStandTraits
	jr FinishEnemyMonTraits
	
LoadWildMonTraits:
	call DetermineNewTraits2
	jr FinishEnemyMonTraits

LoadMrMimeTraits:
	ld a,[wMrMimeTraits]
	;fall through
	
FinishEnemyMonTraits:
	ld [wSavedPokemonTraits],a		;back it up to this byte
	ret
	
FinishLoadingMonTraits:
	ld a,[wSavedPokemonTraits]	;load from the saved byte
	ld [hli],a
	ret
	
LoadPlayerLastStandMorale:
	ld a,$FF		;max out morale
	jr FinishLoadingMonMorale
	
LoadWildMonMorale:
	ld a,[W_MONHBASEMORALE]
	;fall through
	
FinishLoadingMonMorale:
	ld [hl],a	;set the enemy mon moral to the base morale
	ret

	
	
LoadLastStandStatMods:
	ld hl, wPlayerMonStatMods
	jr FinishLoadMonStatMods
	
LoadWildMonStatMods:
	ld hl, wEnemyMonStatMods
	;fall through
	
FinishLoadMonStatMods:
	ld a, $7 ; default stat mod
	ld b, $8 ; number of stat mods
.statModLoop
	ld [hli], a
	dec b
	jr nz, .statModLoop
	ret
	
LoadPlayerMonStatMods:
	ld hl,wPlayerPartyMon1AttackMod	;start of stored attack mods
	ld de,wPlayerMonStatMods	;where to save to
	jr FinishLoadingStatMods
	
LoadEnemyTrainerMonStatMods:
	ld hl,wEnemyPartyMon1AttackMod	;start of stored attack mods
	ld de,wEnemyMonStatMods	;where to save to
	;fall through
	
FinishLoadingStatMods:
	ld a,[wWhichPokemon]
	push af
	srl a	;divide by two, since they are grouped together by 2
	ld bc,wEnemyPartyMon3AttackMod - wEnemyPartyMon1AttackMod		;distance between each set of data
.findStoredStatsLoop
	and a
	jr z,.loadStats
	add hl,bc
	dec a
	jr .findStoredStatsLoop
.loadStats
	pop af	;restore wWhichPokemon
	bit 0,a	;is it odd numbers? (if so, we will swap the bits)
	push af	;store the flag
	ld b,7	;number of stats to restore
.loadStatsLoop
	pop af	;restore the 'is odd?' flag
	push af	;save again
	ld a,[hli]	;load stat
	jr z,.dontSwap	;don't swap if its an even number pokemon index
	swap a
.dontSwap
	and a,$0F	;only keep the lower 4 bits
	jr nz,.notZero	;if not zero, then skip
	ld a,7	;otherwise, set to the default (7)
.notZero
	ld [de],a	;store to the in battle bytes
	inc de
	dec b
	jr nz,.loadStatsLoop	;if haven't done this for all 7 stats, then loop
	;finish
	pop af
	ret
	
	
	
GoToTemporaryBattleDataIndex:
	ld a,[wWhichPokemon]	;which pokemon to load
	ld c,a
	ld b,00
	add hl,bc	;hl points to the corresponding pokemon
	ret
	
	

LoadPlayerMonConfusedStatus:
	ld hl,wPlayerPartyMon1ConfusedCounter	;start of stored confused counter
	ld de,W_PLAYERCONFUSEDCOUNTER
	jr FinishLoadPartyMonConfusedStatus
	
LoadEnemyTrainerMonConfusedStatus:
	ld hl,wEnemyPartyMon1ConfusedCounter	;start of stored confused counter
	ld de,W_ENEMYCONFUSEDCOUNTER
	;fall through
	
FinishLoadPartyMonConfusedStatus:
	call GoToTemporaryBattleDataIndex
	ld a,[hl]
	jr FinishLoadEnemyMonConfusedStatus

LoadLastStandConfusedStatus:
	ld de,W_PLAYERCONFUSEDCOUNTER
	jr FinishLoadEmptyConfusedStatus
	
LoadWildMonConfusedStatus:
	ld de,W_ENEMYCONFUSEDCOUNTER
	;fall through
	
FinishLoadEmptyConfusedStatus:
	xor a
	;fall through

FinishLoadEnemyMonConfusedStatus:
	ld [de],a
	ret
	
	
LoadPlayerMonCursedFearStatus:
	ld hl,wPlayerPartyMon1CursedFearCounter	;start of stored cursed/fear counter
	ld de,wBattleMonCursedFearCounter
	jr FinishLoadTrainerMonCursedFearStatus
	
LoadEnemyTrainerMonCursedFearStatus:
	ld hl,wEnemyPartyMon1CursedFearCounter	;start of stored cursed/fear counter
	ld de,wEnemyMonCursedFearCounter
	;fall through
	
FinishLoadTrainerMonCursedFearStatus:
	call GoToTemporaryBattleDataIndex
	ld a,[hl]
	jr FinishLoadEnemyMonCursedFearStatus

LoadLastStandCursedFearStatus:
	ld de,wBattleMonCursedFearCounter
	jr FinishLoadEmptyCursedFearStatus
	
LoadWildMonCursedFearStatus:
	ld de,wEnemyMonCursedFearCounter
	;fall through
	
FinishLoadEmptyCursedFearStatus:
	xor a
	;fall through
	
FinishLoadEnemyMonCursedFearStatus:
	ld [de],a	
	ret
	

LoadPlayerMonDisabledStatus:
	ld hl,wPlayerDisabledMoveNumber
	push hl
	ld hl,wPlayerPartyMon1DisabledMove	;start of stored disabled byte
	ld de,wBattleMonMoves	;battle mon  move list
	ld bc,W_ENEMYDISABLEDMOVE
	jr FinishLoadTrainerMonDisabledStatus
	
LoadEnemyTrainerMonDisabledStatus:
	ld hl,wEnemyDisabledMoveNumber
	push hl
	ld hl,wEnemyPartyMon1DisabledMove	;start of stored disabled byte
	ld de,wEnemyMonMoves	;enemy mon  move list
	ld bc,W_ENEMYDISABLEDMOVE
	;fall through
	
FinishLoadTrainerMonDisabledStatus:
	push bc
	call GoToTemporaryBattleDataIndex
	ld a,[hl]
	push de
	pop hl
	pop bc
	
	jr FinishLoadEnemyMonDisabledStatus

LoadLastStandDisabledStatus:
	ld hl,wPlayerDisabledMoveNumber
	ld bc,W_ENEMYDISABLEDMOVE
	jr FinishLoadEmptyDisabledStatus
	
LoadWildMonDisabledStatus:
	ld hl,wEnemyDisabledMoveNumber
	ld bc,W_ENEMYDISABLEDMOVE
	;fall through
	
FinishLoadEmptyDisabledStatus:
	push hl
	xor a
	;fall through

FinishLoadEnemyMonDisabledStatus:
	ld [bc],a	;save the disabled move
	and a
	jr z,.saveDisabledMoveNumber	;then save the move number to 0
	
	and a,$F0
	swap a		;a = the move index in the pokemon move list
	dec a		;starts at 1
	ld d,0
	ld e,a
	add hl,de	;hl = pointer to correct move
	ld a,[hl]	;load the move ID	
	;fall through
	
.saveDisabledMoveNumber
	pop hl
	ld [hl],a	;attack ID
	ret
	
	
LoadPlayerMonToxicStatus:
	ld hl,wPlayerPartyMon1ToxicCounter
	ld de,W_PLAYERTOXICCOUNTER
	jr FinishLoadTrainerMonToxicStatus
	
LoadEnemyTrainerMonToxicStatus:
	ld hl,wEnemyPartyMon1ToxicCounter
	ld de,W_ENEMYTOXICCOUNTER
	;fall through
	
FinishLoadTrainerMonToxicStatus:
	call GoToTemporaryBattleDataIndex
	ld a,[hl]
	jr FinishLoadEnemyMonToxicStatus

LoadLastStandToxicStatus:
	ld de,W_PLAYERTOXICCOUNTER
	jr FinishLoadEmptyToxicStatus
	
LoadWildMonToxicStatus:
	ld de,W_ENEMYTOXICCOUNTER
	;fall through
	
FinishLoadEmptyToxicStatus:
	xor a
	;fall through

FinishLoadEnemyMonToxicStatus:
	ld [de],a
	ret
	
	

LoadPlayerLastStandExp:
	ld hl,wBattleMonExp
	jr FinishLoadEmptyExp
	
LoadWildMonExp:
	ld hl,wEnemyMonExp
	;fall through
	
FinishLoadEmptyExp:
	xor a
	ld b,wPartyMon1DVs - wPartyMon1Exp		;total size to copy (DVs come after the last Exp)
.loop
	ld [hli],a
	dec b
	jr nz,.loop
	ret
	
LoadPlayerMonExp:
	ld hl,wBattleMonExp
	jr FinishLoadTrainerMonExp
	
LoadEnemyTrainerMonExp:
	ld hl,wEnemyMonExp
	;fall through
	
FinishLoadTrainerMonExp:
	push de
	
	push hl
	ld hl,wEnemyMon1Exp - wEnemyMon1
	add hl,de	;hl points to the Exp of the party data
	pop de
	
	ld bc,wPartyMon1DVs - wPartyMon1Exp	;size to copy
	call CopyData
	pop de
	ret
	
	
	
SaveMrMimeData:
	ld hl,wMrMimeFlags
	set MrMimeEncountered,[hl]	;set the 'encountered' flag
	ld hl,wMrMimeHP		;start of mr mime data
	ld de,wEnemyMonHP
	ld a,[de]
	ld [hli],a
	inc de
	ld a,[de]
	ld [hli],a		;store the HP
	inc hl		;skip the "status"
	ld a,[wEnemyMonHPSpDefDV]
	ld [hli],a
	ld a,[wEnemyMonDVs]
	ld [hli],a
	ld a,[wEnemyMonDVs + 1]
	ld [hli],a		;store the DVs
	ld a,[wEnemyMonTraits]
	ld [hl],a		;store the traits
	ret