AbsentidBaseStats: ; 38aa6 (e:4aa6)
db DEX_ABSENTID ; pokedex id
db $59 ; base hp
db $A4 ; base attack
db $5C ; base defense
db $4D ; base speed
db $68 ; base special attack
db CYBER ; species type 1
db POISON ; species type 2
db $03 ; catch rate
db $D5 ; base exp yield
INCBIN "pic/bmon/absentid.pic",0,1 ; 55, sprite dimensions
dw AbsentidPicFront
dw AbsentidPicBack
; attacks known at lvl 0
db 0
db 0
db 0
db 0
db 5 ; growth rate
db AB_GLITCH	;ability 1
db AB_REGENERATIVE	;ability 2
db $54	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(AbsentidPicFront) ; sprite bank
