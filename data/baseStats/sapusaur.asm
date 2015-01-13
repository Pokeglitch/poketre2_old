SapusaurBaseStats: ; 38aa6 (e:4aa6)
db DEX_SAPUSAUR ; pokedex id
db $50 ; base hp
db $64 ; base attack
db $7B ; base defense
db $50 ; base speed
db $7A ; base special attack
db PLANT ; species type 1
db POISON ; species type 2
db $2D ; catch rate
db $D8 ; base exp yield
INCBIN "pic/bmon/sapusaur.pic",0,1 ; 55, sprite dimensions
dw SapusaurPicFront
dw SapusaurPicBack
; attacks known at lvl 0
db 0
db 0
db 0
db 0
db 3 ; growth rate
db AB_PHOTOSYNTHESIS	;ability 1
db AB_POISON_SKIN	;ability 2
db $78	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(SapusaurPicFront) ; sprite bank
