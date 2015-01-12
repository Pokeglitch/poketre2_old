ArbokBaseStats: ; 38662 (e:4662)
db DEX_ARBOK ; pokedex id
db 60 ; base hp
db 85 ; base attack
db 69 ; base defense
db 80 ; base speed
db $49 ; base special
db POISON ; species type 1
db FANG ; species type 2
db 90 ; catch rate
db 147 ; base exp yield
INCBIN "pic/bmon/arbok.pic",0,1 ; 77, sprite dimensions
dw ArbokPicFront
dw ArbokPicBack
; attacks known at lvl 0
db WRAP
db LEER
db POISON_STING
db 0
db 0 ; growth rate
db AB_VENOMOUS	;ability 1
db 00	;ability 2
db $57	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(ArbokPicFront) ; sprite bank