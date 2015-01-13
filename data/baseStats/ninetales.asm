NinetalesBaseStats: ; 387ea (e:47ea)
db DEX_NINETALES ; pokedex id
db 73 ; base hp
db 76 ; base attack
db 75 ; base defense
db 100 ; base speed
db $51 ; base special
db FIRE ; species type 1
db FIRE ; species type 2
db 75 ; catch rate
db 178 ; base exp yield
INCBIN "pic/bmon/ninetales.pic",0,1 ; 77, sprite dimensions
dw NinetalesPicFront
dw NinetalesPicBack
; attacks known at lvl 0
db EMBER
db TAIL_WHIP
db QUICK_ATTACK
db ROAR
db 0 ; growth rate
db AB_PREDATOR	;ability 1
db 00	;ability 2
db $64	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(NinetalesPicFront) ; sprite bank