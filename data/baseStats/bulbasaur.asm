BulbasaurBaseStats: ; 383de (e:43de)
db DEX_BULBASAUR ; pokedex id
db 45 ; base hp
db 49 ; base attack
db 49 ; base defense
db 45 ; base speed
db 65 ; base special
db PLANT ; species type 1
db POISON ; species type 2
db 45 ; catch rate
db 64 ; base exp yield
INCBIN "pic/bmon/bulbasaur.pic",0,1 ; 55, sprite dimensions
dw BulbasaurPicFront
dw BulbasaurPicBack
; attacks known at lvl 0
db TACKLE
db GROWL
db 0
db 0
db 3 ; growth rate
db AB_PHOTOSYNTHESIS	;ability 1
db 00	;ability 2
db 65	;special defense
db 250	;base selling price
db 00	;evolution shed item
db CAN_BE_MALE + CAN_BE_FEMALE + EG_FROG	;possible genders and egg group
db 70	;base morale
db BANK(BulbasaurPicFront) ; sprite bank
