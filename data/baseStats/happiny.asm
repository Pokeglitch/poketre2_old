HappinyBaseStats: ; 38aa6 (e:4aa6)
db DEX_HAPPINY ; pokedex id
db 100 ; base hp
db 5 ; base attack
db 5 ; base defense
db 30 ; base speed
db 15 ; base special attack
db SOUND ; species type 1
db MAGIC ; species type 2
db 130 ; catch rate
db 255 ; base exp yield
INCBIN "pic/bmon/happiny.pic",0,1 ; 55, sprite dimensions
dw HappinyPicFront
dw HappinyPicBack
; attacks known at lvl 0
db 0
db 0
db 0
db 0
db 4 ; growth rate
db AB_FLUFFY	;ability 1
db 00	;ability 2
db 65	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(HappinyPicFront) ; sprite bank
