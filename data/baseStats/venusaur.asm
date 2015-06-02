VenusaurBaseStats: ; 38416 (e:4416)
db DEX_VENUSAUR ; pokedex id
db 80 ; base hp
db 82 ; base attack
db 83 ; base defense
db 80 ; base speed
db 100 ; base special
db PLANT ; species type 1
db POISON ; species type 2
db 45 ; catch rate
db 208 ; base exp yield
INCBIN "pic/bmon/venusaur.pic",0,1 ; 77, sprite dimensions
dw VenusaurPicFront
dw VenusaurPicBack
; attacks known at lvl 0
db TACKLE
db GROWL
db LEECH_SEED
db VINE_WHIP
db 3 ; growth rate
db AB_PHOTOSYNTHESIS	;ability 1
db AB_POISON_SKIN	;ability 2
db 100	;special defense
db 250	;base selling price
db 00	;evolution shed item
db CAN_BE_MALE + CAN_BE_FEMALE + EG_FROG	;possible genders and egg group
db 70	;base morale
db BANK(VenusaurPicFront) ; sprite bank