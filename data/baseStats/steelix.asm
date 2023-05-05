SteelixBaseStats: ; 38aa6 (e:4aa6)
db DEX_STEELIX ; pokedex id
db 75 ; base hp
db 85 ; base attack
db 200 ; base defense
db 30 ; base speed
db 55 ; base special attack
db EARTH ; species type 1
db METAL ; species type 2
db 25 ; catch rate
db 196 ; base exp yield
INCBIN "pic/bmon/steelix.pic",0,1 ; 55, sprite dimensions
dw SteelixPicFront
dw SteelixPicBack
; attacks known at lvl 0
db 0
db 0
db 0
db 0
db 0 ; growth rate
db AB_TOUGH_SKIN	;ability 1
db 00	;ability 2
db 65	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(SteelixPicFront) ; sprite bank
