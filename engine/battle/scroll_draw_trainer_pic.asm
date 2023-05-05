_ScrollTrainerPicAfterBattle: ; 396d3 (e:56d3)
; Load the enemy trainer's pic and scrolls it into
; the screen from the right.
	xor a
	ld b, SET_PAL_BATTLE
	call RunPaletteCommand
	callab _LoadTrainerPic
	coord hl, 19, 0
	ld c, $0
.scrollLoop
	inc c
	ld a, c
	cp 9
	jr z,.finish
	ld d, $0
	push bc
	push hl
.drawTrainerPicLoop
	call DrawTrainerPicColumn
	inc hl
	ld a, 7
	add d
	ld d, a
	dec c
	jr nz, .drawTrainerPicLoop
	ld c, 4
	call DelayFrames
	pop hl
	pop bc
	dec hl
	jr .scrollLoop
.finish
	ret

; write one 7-tile column of the trainer pic to the tilemap
DrawTrainerPicColumn: ; 39707 (e:5707)
	push hl
	push de
	push bc
	ld e, 7
.loop
	ld [hl], d
	ld bc, SCREEN_WIDTH
	add hl, bc
	inc d
	dec e
	jr nz, .loop
	pop bc
	pop de
	pop hl
	ret
