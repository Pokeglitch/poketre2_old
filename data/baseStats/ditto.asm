DittoBaseStats: ; 39232 (e:5232)
db DEX_DITTO ; pokedex id
db 48 ; base hp
db 48 ; base attack
db 48 ; base defense
db 48 ; base speed
db $30 ; base special attack
db GOO ; species type 1
db GOO ; species type 2
db 35 ; catch rate
db 61 ; base exp yield
INCBIN "pic/bmon/ditto.pic",0,1 ; 55, sprite dimensions
dw DittoPicFront
dw DittoPicBack
; attacks known at lvl 0
db TRANSFORM
db 0
db 0
db 0
db 0 ; growth rate
db AB_REGENERATIVE	;ability 1
db 00	;ability 2
db $30	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(DittoPicFront) ; sprite bank