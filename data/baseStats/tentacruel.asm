TentacruelBaseStats: ; 38bbe (e:4bbe)
db DEX_TENTACRUEL ; pokedex id
db 80 ; base hp
db 70 ; base attack
db 65 ; base defense
db 100 ; base speed
db $50 ; base special
db WATER ; species type 1
db POISON ; species type 2
db 60 ; catch rate
db 205 ; base exp yield
INCBIN "pic/bmon/tentacruel.pic",0,1 ; 66, sprite dimensions
dw TentacruelPicFront
dw TentacruelPicBack
; attacks known at lvl 0
db ACID
db SUPERSONIC
db WRAP
db 0
db 5 ; growth rate
db AB_POROUS	;ability 1
db 00	;ability 2
db $78	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(TentacruelPicFront) ; sprite bank
