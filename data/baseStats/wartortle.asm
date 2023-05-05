WartortleBaseStats: ; 384a2 (e:44a2)
db DEX_WARTORTLE ; pokedex id
db 59 ; base hp
db 63 ; base attack
db 80 ; base defense
db 58 ; base speed
db 65 ; base special
db WATER ; species type 1
db WATER ; species type 2
db 45 ; catch rate
db 143 ; base exp yield
INCBIN "pic/bmon/wartortle.pic",0,1 ; 66, sprite dimensions
dw WartortlePicFront
dw WartortlePicBack
; attacks known at lvl 0
db TACKLE
db LEER
db SPLASH
db RIPTIDE
db 3 ; growth rate
db AB_TOUGH_SKIN	;ability 1
db 00	;ability 2
db 80	;special defense
db 250	;base selling price
db 00	;evolution shed item
db CAN_BE_MALE + CAN_BE_FEMALE + EG_TURTLE	;possible genders and egg group
db 70	;base morale
db BANK(WartortlePicFront) ; sprite bank
