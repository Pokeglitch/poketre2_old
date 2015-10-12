; this function temporarily makes the starters (and Ivysaur) seen
; so that the full Pokedex information gets displayed in Oak's lab
StarterDex: ; 5c0dc (17:40dc)
	ld hl,wPokedexOwned
	ld a, %10010000 ; set starter flags
	ld [hli], a
	ld a, %00000100 ; set starter flags
	ld [hl], a
	push hl
	xor a
	ld [wTextCharCount],a	;turn off word wrap
	predef ShowPokedexData
	ld a,%10000000
	ld [wTextCharCount],a	;turn on word wrap
	xor a ; unset starter flags
	pop hl
	ld [hld], a
	ld [hl],a
	ret
