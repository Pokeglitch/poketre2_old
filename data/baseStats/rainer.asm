RainerBaseStats: ; 38aa6 (e:4aa6)
db DEX_RAINER ; pokedex id
db $4F ; base hp
db $67 ; base attack
db $78 ; base defense
db $4E ; base speed
db $87 ; base special attack
db WATER ; species type 1
db WATER ; species type 2
db $2D ; catch rate
db $D8 ; base exp yield
INCBIN "pic/bmon/rainer.pic",0,1 ; 55, sprite dimensions
dw RainerPicFront
dw RainerPicBack
; attacks known at lvl 0
db 0
db 0
db 0
db 0
db 3 ; growth rate
db AB_POROUS	;ability 1
db AB_TOUGH_SKIN	;ability 2
db $73	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(RainerPicFront) ; sprite bank
