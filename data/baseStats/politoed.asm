PolitoedBaseStats: ; 38aa6 (e:4aa6)
db DEX_POLITOED ; pokedex id
db 90 ; base hp
db 75 ; base attack
db 75 ; base defense
db 70 ; base speed
db 90 ; base special attack
db WATER ; species type 1
db WATER ; species type 2
db 45 ; catch rate
db 185 ; base exp yield
INCBIN "pic/bmon/politoed.pic",0,1 ; 55, sprite dimensions
dw PolitoedPicFront
dw PolitoedPicBack
; attacks known at lvl 0
db 0
db 0
db 0
db 0
db 3 ; growth rate
db AB_SWIMMER	;ability 1
db 00	;ability 2
db 100	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(PolitoedPicFront) ; sprite bank
