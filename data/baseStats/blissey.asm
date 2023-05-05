BlisseyBaseStats: ; 38aa6 (e:4aa6)
db DEX_BLISSEY ; pokedex id
db 255 ; base hp
db 10 ; base attack
db 10 ; base defense
db 55 ; base speed
db 75 ; base special attack
db SOUND ; species type 1
db MAGIC ; species type 2
db 30 ; catch rate
db 255 ; base exp yield
INCBIN "pic/bmon/blissey.pic",0,1 ; 55, sprite dimensions
dw BlisseyPicFront
dw BlisseyPicBack
; attacks known at lvl 0
db 0
db 0
db 0
db 0
db 4 ; growth rate
db AB_FLUFFY	;ability 1
db 00	;ability 2
db 135	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(BlisseyPicFront) ; sprite bank
