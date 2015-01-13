BellossomBaseStats: ; 38aa6 (e:4aa6)
db DEX_BELLOSSOM ; pokedex id
db 75 ; base hp
db 80 ; base attack
db 85 ; base defense
db 50 ; base speed
db 90 ; base special attack
db PLANT ; species type 1
db PLANT ; species type 2
db 45 ; catch rate
db 184 ; base exp yield
INCBIN "pic/bmon/bellossom.pic",0,1 ; 55, sprite dimensions
dw BellossomPicFront
dw BellossomPicBack
; attacks known at lvl 0
db 0
db 0
db 0
db 0
db 3 ; growth rate
db AB_PHOTOSYNTHESIS	;ability 1
db 00	;ability 2
db 100	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(BellossomPicFront) ; sprite bank
