SapusaurBaseStats: ; 38aa6 (e:4aa6)
db DEX_SAPUSAUR ; pokedex id
db 80 ; base hp
db 100 ; base attack
db 123 ; base defense
db 80 ; base speed
db 122 ; base special attack
db PLANT ; species type 1
db POISON ; species type 2
db 45 ; catch rate
db 216 ; base exp yield
INCBIN "pic/bmon/sapusaur.pic",0,1 ; 55, sprite dimensions
dw SapusaurPicFront
dw SapusaurPicBack
; attacks known at lvl 0
db TACKLE
db GROWL
db LEECH_SEED
db VINE_WHIP
db 3 ; growth rate
db AB_PHOTOSYNTHESIS	;ability 1
db AB_POISON_SKIN	;ability 2
db 120	;special defense
db 250	;base selling price
db 00	;evolution shed item
db CAN_BE_MALE + CAN_BE_FEMALE + EG_FROG	;possible genders and egg group
db 70	;base morale
db BANK(SapusaurPicFront) ; sprite bank
