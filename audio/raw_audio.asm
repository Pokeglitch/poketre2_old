RawCryTable:
	db SYLVEON, BANK(SylveonCry)
	dw SylveonCry
	
	db ELECTIVIRE, BANK(ElectivireCry)
	dw ElectivireCry
	
	db GLACEON, BANK(GlaceonCry)
	dw GlaceonCry
	
	db HAPPINY, BANK(HappinyCry)
	dw HappinyCry
	
	db LEAFEON, BANK(LeafeonCry)
	dw LeafeonCry
	
	db LICKILICKY, BANK(LickilickyCry)
	dw LickilickyCry
	
	db MAGMORTAR, BANK(MagmortarCry)
	dw MagmortarCry
	
	db MAGNEZONE, BANK(MagnezoneCry)
	dw MagnezoneCry
	
	db MIME_JR, BANK(MimeJrCry)
	dw MimeJrCry
	
	db MUNCHLAX, BANK(MunchlaxCry)
	dw MunchlaxCry
	
	db PORYGON_Z, BANK(PorygonZCry)
	dw PorygonZCry
	
	db RHYPERIOR, BANK(RhyperiorCry)
	dw RhyperiorCry
	
	db TANGROWTH, BANK(TangrowthCry)
	dw TangrowthCry
	
	db PIKACHU, BANK(PikachuCry)
	dw PikachuCry
	
	db MEOWTH, BANK(MeowthCry)
	dw MeowthCry
	
	db PERSIAN, BANK(PersianCry)
	dw PersianCry
	
	db ARCANINE, BANK(ArcanineCry)
	dw ArcanineCry
	
	db GROWLITHE, BANK(GrowlitheCry)
	dw GrowlitheCry
	
	db $FF

RawTrainerTable:
	db ASH, BANK(AshCry)
	dw AshCry
	
	db GIOVANNI, BANK(GiovanniCry)
	dw GiovanniCry
	
	db PROF_OAK, BANK(ProfOakCry)
	dw ProfOakCry
	
	db POKEGLITCH, BANK(PokeglitchCry)
	dw PokeglitchCry
	db $FF
	
JamesCryHeader:
	db BANK(JamesCry)
	dw JamesCry

JessieCryHeader:
	db BANK(JessieCry)
	dw JessieCry
	
RawCry:
	ld a,[wd0b5]
	cp HUMAN
	jr nz,.notHuman
	ld a,[wActiveCheats]
	bit IWHBYDCheat,a
	jr z,.noCry		;return with no cry if iwhbyd is off
	ld a,[wTrainerClass]
	cp RIVAL
	jr nz,.notRival
	ld a,[wTotems]
	ld hl,JessieCryHeader
	bit RoleReversalTotem,a
	jr z,.readHeaderNoInc		;read jessie header if role reversal is off
	ld hl,JamesCryHeader
	jr .readHeaderNoInc
	
.notRival
	ld hl,RawTrainerTable
	ld de,4
	call IsInArray
	jr c,.readHeader
.noCry
	scf
	ret
	
.notHuman
	ld hl,RawCryTable
	ld de,4		;size of row
	call IsInArray
	ret nc		;return if not
	
.readHeader
	inc hl
.readHeaderNoInc
	ld a,[hli]
	ld b,a		;bank
	ld a,[hli]
	ld h,[hl]	;pointer high
	ld l,a		;pointer low
	
	di
	push bc
	push hl
	ld a, $80
	ld [rNR52], a
	ld a, $77
	ld [rNR50], a
	xor a
	ld [rNR30], a
	ld hl, $ff30 ; wave data
	ld de, wRedrawRowOrColumnSrcTiles
.saveWaveDataLoop
	ld a, [hl]
	ld [de], a
	inc de
	ld a, $ff
	ld [hli], a
	ld a, l
	cp $40 ; end of wave data
	jr nz, .saveWaveDataLoop
	ld a, $80
	ld [rNR30], a
	ld a, [rNR51]
	or $44
	ld [rNR51], a
	ld a, $ff
	ld [rNR31], a
	ld a, $20
	ld [rNR32], a
	ld a, $ff
	ld [rNR33], a
	ld a, $87
	ld [rNR34], a
	pop hl
	pop bc
	call Play1BitPCM
	xor a
	ld [wc0f3], a
	ld [wc0f4], a
	ld a, $80
	ld [rNR52], a
	xor a
	ld [rNR30], a
	ld hl, $ff30
	ld de, wRedrawRowOrColumnSrcTiles
.reloadWaveDataLoop
	ld a, [de]
	inc de
	ld [hli], a
	ld a, l
	cp $40 ; end of wave data
	jr nz, .reloadWaveDataLoop
	ld a, $80
	ld [rNR30], a
	ld a, [rNR51]
	and $bb
	ld [rNR51], a
	xor a
	ld [wChannelSoundIDs+CH4], a
	ld [wChannelSoundIDs+CH5], a
	ld [wChannelSoundIDs+CH6], a
	ld [wChannelSoundIDs+CH7], a
	ld a, [H_LOADEDROMBANK]
	ei
	scf
	ret