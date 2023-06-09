_GivePokemon: ; 4fda5 (13:7da5)
; returns success in carry
; and whether the mon was added to the party in [wAddedToParty]
	call EnableAutoTextBoxDrawing
	xor a
	ld [wAddedToParty], a
	push bc
	ld a,[wMaxPartyMons]		;get the max party size
	ld b,a		;store into b
	ld a, [wPartyCount] ; wPartyCount
	cp b	; PARTY_LENGTH
	pop bc
	jr c, .addToParty
	ld a, [wNumInBox] ; wda80
	cp MONS_PER_BOX
	jr nc, .boxFull
; add to box
	xor a
	ld [wEnemyBattleStatus3], a
	ld a, [wcf91]
	ld [wEnemyMonSpecies2], a
	callab LoadEnemyMonData
	call SetPokedexOwnedFlag
	callab SendNewMonToBox
	call AutoSaveHardModeHome		;autosave
	ld hl, wcf4b
	ld a, [wCurrentBoxNum]
	and $7f
	cp 9
	jr c, .singleDigitBoxNum
	sub 9
	ld [hl], "1"
	inc hl
	add "0"
	jr .next
.singleDigitBoxNum
	add "1"
.next
	ld [hli], a
	ld [hl], "@"
	ld hl, SetToBoxText
	call PrintText
	scf
	ret
.boxFull
	ld hl, BoxIsFullText
	call PrintText
	and a
	ret
.addToParty
	call SetPokedexOwnedFlag
	call AddPartyMon
	call AutoSaveHardModeHome		;autosave
	ld a, 1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld [wAddedToParty], a
	scf
	ret

SetPokedexOwnedFlag: ; 4fe11 (13:7e11)
	ld a, [wcf91]
	push af
	ld [wd11e], a
	dec a
	ld c, a
	ld hl, wPokedexOwned
	ld b, FLAG_SET
	predef FlagActionPredef
	pop af
	ld [wd11e], a
	call GetMonName
	ld hl, GotMonText
	jp PrintText

GotMonText: ; 4fe39 (13:7e39)
	TX_FAR _GotMonText
	db $0b
	db "@"

SetToBoxText: ; 4fe3f (13:7e3f)
	TX_FAR _SetToBoxText
	db "@"

BoxIsFullText: ; 4fe44 (13:7e44)
	TX_FAR _BoxIsFullText
	db "@"
