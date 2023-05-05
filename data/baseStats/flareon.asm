FlareonBaseStats: ; 392a2 (e:52a2)
db DEX_FLAREON ; pokedex id
db 65 ; base hp
db 130 ; base attack
db 60 ; base defense
db 65 ; base speed
db $5F ; base special
db FIRE ; species type 1
db TALON ; species type 2
db 45 ; catch rate
db 198 ; base exp yield
INCBIN "pic/bmon/flareon.pic",0,1 ; 66, sprite dimensions
dw FlareonPicFront
dw FlareonPicBack
; attacks known at lvl 0
db TACKLE
IF DEF(_YELLOW)
	db TAIL_WHIP
ELSE
	db SAND_ATTACK
ENDC
db QUICK_ATTACK
db EMBER
db 0 ; growth rate
db AB_PREDATOR	;ability 1
db 00	;ability 2
db $6E	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(FlareonPicFront) ; sprite bank