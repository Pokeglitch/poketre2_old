DecrementPP: ; 68000 (1a:4000)

	;get the PP required for this move
	ld a, [wPlayerMonNumber]
	ld [wWhichPokemon], a
	ld a, $4
	ld [wcc49], a
	callab GetMaxPP


; after using a move, decrement pp in battle and (if not transformed?) in party
	ld hl, W_PLAYERBATTSTATUS1
	ld a, [hli]          ; load the W_PLAYERBATTSTATUS1 pokemon status flags and increment hl to load the
	                     ; W_PLAYERBATTSTATUS2 status flags later
	and a, (1 << StoringEnergy) | (1 << ThrashingAbout) | (1 << AttackingMultipleTimes)
	ret nz               ; if any of these statuses are true, don't decrement PP
	bit UsingRage, [hl]         
	ret nz               ; don't decrement PP either if Pokemon is using Rage
	ld hl, wBattleMonPP  ; PP of first move (in battle)
	
; decrement PP in the battle struct	
	call .DecrementPP    
	
; decrement PP in the party struct	
	ld a, [W_PLAYERBATTSTATUS3]        
	bit Transformed, a
	ret nz               ; Return if transformed. Pokemon Red stores the "current pokemon's" PP
	                     ; separately from the "Pokemon in your party's" PP.  This is
	                     ; duplication -- in all cases *other* than Pokemon with Transform.
	                     ; Normally, this means we have to go on and make the same
	                     ; modification to the "party's pokemon" PP that we made to the
	                     ; "current pokemon's" PP.  But, if we're dealing with a Transformed
	                     ; Pokemon, it has separate PP for the move set that it copied from
	                     ; its opponent, which is *not* the same as its real PP as part of your
	                     ; party.  So we return, and don't do that part.

	ld hl, wPartyMon1PP  ; PP of first move (in party)
	ld a, [wPlayerMonNumber] ; which mon in party is active
	ld bc, wPartyMon2 - wPartyMon1 
	call AddNTimes       ; calculate address of the mon to modify
.DecrementPP	
	
	ld a,[wd11e]
	cpl
	inc a
	ld c,a
	ld b,-1		;bc = negative max pp
	
	push hl
	ld a,[hli]
	ld l,[hl]
	ld h,a		;hl = current pp
	
	add hl,bc		;substract the pp of the attack from the current pp
	
	pop bc	;bc = pointer to pp
	ld a,h
	ld [bc],a
	inc bc
	ld a,l
	ld [bc],a	
	ret
