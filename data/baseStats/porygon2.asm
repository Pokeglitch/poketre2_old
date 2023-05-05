Porygon2BaseStats: ; 38aa6 (e:4aa6)
db DEX_PORYGON2 ; pokedex id
db 85 ; base hp
db 80 ; base attack
db 90 ; base defense
db 60 ; base speed
db 105 ; base special attack
db CYBER ; species type 1
db CYBER ; species type 2
db 45 ; catch rate
db 180 ; base exp yield
INCBIN "pic/bmon/porygon2.pic",0,1 ; 55, sprite dimensions
dw Porygon2PicFront
dw Porygon2PicBack
; attacks known at lvl 0
db 0
db 0
db 0
db 0
db 0 ; growth rate
db AB_CONVERT	;ability 1
db 00	;ability 2
db 95	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(Porygon2PicFront) ; sprite bank
