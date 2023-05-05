MagmortarBaseStats: ; 38aa6 (e:4aa6)
db DEX_MAGMORTAR ; pokedex id
db 75 ; base hp
db 95 ; base attack
db 67 ; base defense
db 83 ; base speed
db 125 ; base special attack
db FIRE ; species type 1
db EARTH ; species type 2
db 30 ; catch rate
db 199 ; base exp yield
INCBIN "pic/bmon/magmortar.pic",0,1 ; 55, sprite dimensions
dw MagmortarPicFront
dw MagmortarPicBack
; attacks known at lvl 0
db 0
db 0
db 0
db 0
db 0 ; growth rate
db AB_FLAME_BODY	;ability 1
db 00	;ability 2
db 95	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(MagmortarPicFront) ; sprite bank
