JolteonBaseStats: ; 39286 (e:5286)
db DEX_JOLTEON ; pokedex id
db 65 ; base hp
db 65 ; base attack
db 60 ; base defense
db 130 ; base speed
db $6E ; base special
db ELECTRIC ; species type 1
db TALON ; species type 2
db 45 ; catch rate
db 197 ; base exp yield
INCBIN "pic/bmon/jolteon.pic",0,1 ; 66, sprite dimensions
dw JolteonPicFront
dw JolteonPicBack
; attacks known at lvl 0
db TACKLE
IF DEF(_YELLOW)
	db TAIL_WHIP
ELSE
	db SAND_ATTACK
ENDC
db QUICK_ATTACK
db THUNDERSHOCK
db 0 ; growth rate
db AB_PREDATOR	;ability 1
db 00	;ability 2
db $5F	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(JolteonPicFront) ; sprite bank