TangrowthBaseStats: ; 38aa6 (e:4aa6)
db DEX_TANGROWTH ; pokedex id
db 100 ; base hp
db 100 ; base attack
db 125 ; base defense
db 50 ; base speed
db 110 ; base special attack
db PLANT ; species type 1
db PLANT ; species type 2
db 30 ; catch rate
db 211 ; base exp yield
INCBIN "pic/bmon/tangrowth.pic",0,1 ; 55, sprite dimensions
dw TangrowthPicFront
dw TangrowthPicBack
; attacks known at lvl 0
db 0
db 0
db 0
db 0
db 0 ; growth rate
db AB_PHOTOSYNTHESIS	;ability 1
db 00	;ability 2
db 50	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(TangrowthPicFront) ; sprite bank
