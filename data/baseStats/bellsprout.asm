BellsproutBaseStats: ; 38b4e (e:4b4e)
db DEX_BELLSPROUT ; pokedex id
db 50 ; base hp
db 75 ; base attack
db 35 ; base defense
db 40 ; base speed
db $46 ; base special attack
db PLANT ; species type 1
db POISON ; species type 2
db 255 ; catch rate
db 84 ; base exp yield
INCBIN "pic/bmon/bellsprout.pic",0,1 ; 55, sprite dimensions
dw BellsproutPicFront
dw BellsproutPicBack
; attacks known at lvl 0
db VINE_WHIP
db GROWTH
db 0
db 0
db 3 ; growth rate
db AB_PHOTOSYNTHESIS	;ability 1
db 00	;ability 2
db $1E	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(BellsproutPicFront) ; sprite bank