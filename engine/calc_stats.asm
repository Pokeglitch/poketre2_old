
; calculates all 6 stats of current mon and writes them to [de]
; #6 is special defense
_CalcStats:: ; 3936 (0:3936)
	ld a,c		;store c into a
	ld a,[H_MULTIPLICAND]
	ld h,a
	ld a,[H_MULTIPLICAND + 1]
	ld l,a		;restore hl
	ld c, $0
.statsLoop
	inc c
	call _CalcStat
	ld a,c
	cp 6		;special defense?
	jr nz,.notSpecialDefense
	;to see if we are saving to the enemy in battle bytes
	ld hl,wEnemyMonPP
	ld a,d
	cp h
	jr nz,.checkPlayerInBattle
	ld a,e
	cp l
	jr nz,.checkPlayerInBattle
	ld hl,wEnemyMonSpecialDefense
	jr .finish
.checkPlayerInBattle
	;to see if we are saving to the enemy in battle bytes
	ld hl,wBattleMonPP
	ld a,d
	cp h
	jr nz,.notInBattle
	ld a,e
	cp l
	jr nz,.notInBattle
	ld hl,wBattleMonSpecialDefense
	jr .finish
.notInBattle
	ld hl,wPartyMon1SpDefense - wPartyMon2
	add hl,de		;hl now points to special defense bytes
.finish
	ld a, [H_MULTIPLICAND+1]
	ld [hli], a
	ld a, [H_MULTIPLICAND+2]
	ld [hl], a
	ret
.notSpecialDefense
	ld a, [H_MULTIPLICAND+1]
	ld [de], a
	inc de
	ld a, [H_MULTIPLICAND+2]
	ld [de], a
	inc de
	jr .statsLoop

	
_CalcStatFar::
	ld a,c		;store c into a
	ld a,[H_MULTIPLICAND]
	ld h,a
	ld a,[H_MULTIPLICAND + 1]
	ld l,a		;restore hl
	ld c, $0
	;fall through
	
; calculates stat c of current mon
; c: stat to calc (HP=1,Atk=2,Def=3,Spd=4,Spc Attack=5,Spc Defense=6)
; b: consider stat exp?
; hl: base ptr to stat exp values ([hl + 2*c - 1] and [hl + 2*c])
_CalcStat:: ; 394a (0:394a)
	push hl
	push de
	push bc
	ld a, b
	ld d, a
	push hl
	ld hl, wMonHeader
	ld a,c
	cp 6		;special defense?
	jr nz,.notSpecialDefenseFromHeader
	ld hl,wMonHBaseSpecialDefense
	jr .afterSpecialDefenseFromHeader
	
.notSpecialDefenseFromHeader
	ld b, $0
	add hl, bc
.afterSpecialDefenseFromHeader
	ld a, [hl]          ; read base value of stat
	ld e, a
	pop hl
	push hl
	sla c
	ld a, d
	and a
	jr z, .statExpDone  ; consider stat exp?
	add hl, bc          ; skip to corresponding stat exp value
	ld a,c
	cp 12		;special defense?
	jr nz,.statExpLoop	;skip down if not
	push bc
	
	ld hl,wPartyMon1SpDefenseEV + 1
	ld a,[wWhichPokemon]
	call SkipFixedLengthTextEntries
	
	pop bc
.statExpLoop            ; calculates ceil(Sqrt(stat exp)) in b
	xor a
	ld [H_MULTIPLICAND], a
	ld [H_MULTIPLICAND+1], a
	inc b               ; increment current stat exp bonus
	ld a, b
	cp $ff
	jr z, .statExpDone
	ld [H_MULTIPLICAND+2], a
	ld [H_MULTIPLIER], a
	call Multiply
	ld a, [hld]
	ld d, a
	ld a, [$ff98]
	sub d
	ld a, [hli]
	ld d, a
	ld a, [$ff97]
	sbc d               ; test if (current stat exp bonus)^2 < stat exp
	jr c, .statExpLoop
.statExpDone
	srl c
	pop hl
	push bc
	ld bc, $b           ; skip to stat IV values
	add hl, bc
	pop bc
	ld a, c
	cp $2
	jr z, .getAttackIV
	cp $3
	jr z, .getDefenseIV
	cp $4
	jr z, .getSpeedIV
	cp $5
	jr z, .getSpecialIV
	;otherwise, its the special defense/hp
.getHpIV
	push de

	;to see if we are saving to the enemy in battle bytes
	ld de,wEnemyMonDVs
	ld a,d
	cp h
	jr nz,.checkPlayerInBattle
	ld a,e
	cp l
	jr nz,.checkPlayerInBattle
	ld hl,wEnemyMonHPSpDefDV
	jr .hpOrSpDef
.checkPlayerInBattle
	;to see if we are saving to the enemy in battle bytes
	ld de,wBattleMonDVs
	ld a,d
	cp h
	jr nz,.notInBattle
	ld a,e
	cp l
	jr nz,.notInBattle
	ld hl,wBattleMonHPSpDefDV
	jr .hpOrSpDef
.notInBattle
	ld de,wPartyMon1HPSpDefDV - wPartyMon1DVs
	add hl,de		;point to the hp/special defense IVs byte
.hpOrSpDef
	pop de
	ld a,c
	cp a,6		;special defense?
	jr z,.getSpecialDefense
	;otherwise, fall through
.getAttackIV
	ld a, [hl]
	swap a
	and $f
	jr .calcStatFromIV
.getSpecialDefense
.getDefenseIV
	ld a, [hl]
	and $f
	jr .calcStatFromIV
.getSpeedIV
	inc hl
	ld a, [hl]
	swap a
	and $f
	jr .calcStatFromIV
.getSpecialIV
	inc hl
	ld a, [hl]
	and $f
.calcStatFromIV
	ld d, $0
	add e
	ld e, a
	jr nc, .noCarry
	inc d                     ; de = Base + IV
.noCarry
	sla e
	rl d                      ; de = (Base + IV) * 2
	srl b
	srl b                     ; b = ceil(Sqrt(stat exp)) / 4
	ld a, b
	add e
	jr nc, .noCarry2
	inc d                     ; da = (Base + IV) * 2 + ceil(Sqrt(stat exp)) / 4
.noCarry2
	ld [H_MULTIPLICAND+2], a
	ld a, d
	ld [H_MULTIPLICAND+1], a
	xor a
	ld [H_MULTIPLICAND], a
	ld a, [wCurEnemyLVL] ; wCurEnemyLVL
	ld [H_MULTIPLIER], a
	call Multiply            ; ((Base + IV) * 2 + ceil(Sqrt(stat exp)) / 4) * Level
	ld a, [H_MULTIPLICAND]
	ld [H_DIVIDEND], a
	ld a, [H_MULTIPLICAND+1]
	ld [H_DIVIDEND+1], a
	ld a, [H_MULTIPLICAND+2]
	ld [H_DIVIDEND+2], a
	ld a, $64
	ld [H_DIVISOR], a
	ld a, $3
	ld b, a
	call Divide             ; (((Base + IV) * 2 + ceil(Sqrt(stat exp)) / 4) * Level) / 100
	ld a, c
	cp $1
	ld a, $5
	jr nz, .notHPStat
	ld a, [wCurEnemyLVL] ; wCurEnemyLVL
	ld b, a
	ld a, [H_MULTIPLICAND+2]
	add b
	ld [H_MULTIPLICAND+2], a
	jr nc, .noCarry3
	ld a, [H_MULTIPLICAND+1]
	inc a
	ld [H_MULTIPLICAND+1], a ; HP: (((Base + IV) * 2 + ceil(Sqrt(stat exp)) / 4) * Level) / 100 + Level
.noCarry3
	ld a, $a
.notHPStat
	ld b, a
	ld a, [H_MULTIPLICAND+2]
	add b
	ld [H_MULTIPLICAND+2], a
	jr nc, .noCarry4
	ld a, [H_MULTIPLICAND+1]
	inc a                    ; non-HP: (((Base + IV) * 2 + ceil(Sqrt(stat exp)) / 4) * Level) / 100 + 5
	ld [H_MULTIPLICAND+1], a ; HP: (((Base + IV) * 2 + ceil(Sqrt(stat exp)) / 4) * Level) / 100 + Level + 10
.noCarry4
	ld a, [H_MULTIPLICAND]	;check for overflow (second step)
	and a
	jr nz,.overflow		;if its not zero, then it overflowed
	ld a, [H_MULTIPLICAND+1] ; check for overflow (>999)
	cp $4
	jr nc, .overflow
	cp $3
	jr c, .noOverflow
	ld a, [H_MULTIPLICAND+2]
	cp $e8
	jr c, .noOverflow
.overflow
	ld a, $3                 ; overflow: cap at 999
	ld [H_MULTIPLICAND+1], a
	ld a, $e7
	ld [H_MULTIPLICAND+2], a
.noOverflow
	pop bc
	pop de
	pop hl
	ret