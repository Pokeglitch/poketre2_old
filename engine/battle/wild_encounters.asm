; try to initiate a wild pokemon encounter
; returns success in Z
TryDoWildEncounter: ; 13870 (4:7870)
	ld a, [wNPCMovementScriptPointerTableNum]
	and a
	ret nz
	ld a, [wd736]
	and a
	ret nz
	callab IsPlayerStandingOnDoorTileOrWarpTile
	jr nc, .notStandingOnDoorOrWarpTile
.CantEncounter
	ld a, $1
	and a
	ret
.notStandingOnDoorOrWarpTile
	callab IsPlayerJustOutsideMap
	jr z, .CantEncounter
	ld a, [wRepelRemainingSteps]
	and a
	jr z, .asm_1389e
	dec a
	jr z, .lastRepelStep
	ld [wRepelRemainingSteps], a
.asm_1389e
; determine if wild pokémon can appear in the half-block we’re standing in	
; is the bottom right tile (9,9) of the half-block we're standing in a grass/water tile?
	hlCoord 9, 9
	ld c, [hl]
	ld a, [W_GRASSTILE]
	cp c
	ld a, [W_GRASSRATE]
	jr z, .CanEncounter
	ld a, $14 ; in all tilesets with a water tile, this is its id
	cp c
	ld a, [W_WATERRATE]
	jr z, .CanEncounter
; even if not in grass/water, standing anywhere we can encounter pokémon
; so long as the map is “indoor” and has wild pokémon defined.
; …as long as it’s not Viridian Forest or Safari Zone.
	ld a, [W_CURMAP]
	cp REDS_HOUSE_1F ; is this an indoor map?
	jr c, .CantEncounter2
	ld a, [W_CURMAPTILESET]
	cp FOREST ; Viridian Forest/Safari Zone
	jr z, .CantEncounter2
	ld a, [W_GRASSRATE]
.CanEncounter
; compare encounter chance with a random number to determine if there will be an encounter
	ld b, a
	ld a, [hRandomAdd]
	cp b
	jr nc, .CantEncounter2
	ld a, [hRandomSub]
	ld b, a
	ld c, $FF
	ld hl, WildMonEncounterSlotChances
.determineEncounterSlot
	inc c		;increase the counter
	ld a, [hli]
	cp b
	jr c, .determineEncounterSlot	;if the random value is greater than the table value, then move to the next one
.gotEncounterSlot
; determine which wild pokémon (grass or water) can appear in the half-block we’re standing in
	ld hl, W_GRASSMONS
	aCoord 8, 9	
	cp $14 ; is the bottom left tile (8,9) of the half-block we're standing in a water tile?	
	jr nz, .gotWildEncounterType ; else, it's treated as a grass tile by default
	ld hl, W_WATERMONS
; since the bottom right tile of a "left shore" half-block is $14 but the bottom left tile is not,
; "left shore" half-blocks (such as the one in the east coast of Cinnabar) load grass encounters.	
.gotWildEncounterType
	ld b, $0
	add hl, bc		;hl points to the pokemon index in the list (0-5)
	call AdjustWildMonForTimeAndSeason
	ld a, [hl]
	call SeeIfPokemonShouldEvolve		;see if the pokemon should be evolved, based on the level
	ld [wcf91], a
	ld [wEnemyMonSpecies2], a
	callab NewWildMonLevel		;get the vary pk level and store into W_CURENEMYLVL
	ld a, [wRepelRemainingSteps]
	and a
	jr z, .willEncounter
	ld a, [wPartyMon1Level]
	ld b, a
	ld a, [W_CURENEMYLVL]
	cp b
	jr c, .CantEncounter2 ; repel prevents encounters if the leading party mon's level is higher than the wild mon
	jr .willEncounter
.lastRepelStep
	ld [wRepelRemainingSteps], a
	ld a, $d2
	ld [H_DOWNARROWBLINKCNT2], a
	call EnableAutoTextBoxDrawing
	call DisplayTextID
.CantEncounter2
	ld a, $1
	and a
	ret
.willEncounter
	xor a
	ret

WildMonEncounterSlotChances:
	db $61	;38%
	db $AB	;29%
	db $DE	;20%
	db $FA	;19%
	db $FF	;2%

;to adjust hl pointer for time and season
;adds 5 for nighttime and 10 for winter
AdjustWildMonForTimeAndSeason:
	call GetTimeOfDay
	jr z,.afterNight		;skip down if daytime

	ld bc,5
	add hl,bc		;adjust for nighttime
	
.afterNight
	call GetSeason
	ret z		;return if not winter
	
	ld bc,10
	add hl,bc		;adjust for inter
	ret
