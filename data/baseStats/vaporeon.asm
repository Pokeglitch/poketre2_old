VaporeonBaseStats: ; 3926a (e:526a)
db DEX_VAPOREON ; pokedex id
db 130 ; base hp
db 65 ; base attack
db 60 ; base defense
db 65 ; base speed
db $6E ; base special
db WATER ; species type 1
db TALON ; species type 2
db 45 ; catch rate
db 196 ; base exp yield
INCBIN "pic/bmon/vaporeon.pic",0,1 ; 66, sprite dimensions
dw VaporeonPicFront
dw VaporeonPicBack
; attacks known at lvl 0
db TACKLE
IF DEF(_YELLOW)
	db TAIL_WHIP
ELSE
	db SAND_ATTACK
ENDC
db QUICK_ATTACK
db WATER_GUN
db 0 ; growth rate
db AB_PREDATOR	;ability 1
db 00	;ability 2
db $5F	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(VaporeonPicFront) ; sprite bank