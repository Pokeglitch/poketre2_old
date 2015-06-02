BlastoiseBaseStats: ; 384be (e:44be)
db DEX_BLASTOISE ; pokedex id
db 79 ; base hp
db 83 ; base attack
db 100 ; base defense
db 78 ; base speed
db 85 ; base special attack
db WATER ; species type 1
db WATER ; species type 2
db 45 ; catch rate
db 210 ; base exp yield
INCBIN "pic/bmon/blastoise.pic",0,1 ; 77, sprite dimensions
dw BlastoisePicFront
dw BlastoisePicBack
; attacks known at lvl 0
db TACKLE
db LEER
db SPLASH
db RIPTIDE
db 3 ; growth rate
db AB_POROUS	;ability 1
db AB_TOUGH_SKIN	;ability 2
db 105	;special defense
db 250	;base selling price
db 00	;evolution shed item
db CAN_BE_MALE + CAN_BE_FEMALE + EG_TURTLE	;possible genders and egg group
db 70	;base morale
db BANK(BlastoisePicFront) ; sprite bank