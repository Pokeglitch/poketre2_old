MankeyBaseStats: ; 389e2 (e:49e2)
db DEX_MANKEY ; pokedex id
db 40 ; base hp
db 80 ; base attack
db 35 ; base defense
db 70 ; base speed
db $23 ; base special
db FIGHTING ; species type 1
db FIGHTING ; species type 2
db 190 ; catch rate
db 74 ; base exp yield
INCBIN "pic/bmon/mankey.pic",0,1 ; 55, sprite dimensions
dw MankeyPicFront
dw MankeyPicBack
; attacks known at lvl 0
db SCRATCH
db LEER
db 0
db 0
db 0 ; growth rate
db AB_ILL_TEMPERED	;ability 1
db 00	;ability 2
db $2D	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(MankeyPicFront) ; sprite bank