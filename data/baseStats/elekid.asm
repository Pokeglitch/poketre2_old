ElekidBaseStats: ; 38aa6 (e:4aa6)
db DEX_ELEKID ; pokedex id
db 45 ; base hp
db 63 ; base attack
db 37 ; base defense
db 95 ; base speed
db 65 ; base special attack
db ELECTRIC ; species type 1
db RADIO ; species type 2
db 45 ; catch rate
db 106 ; base exp yield
INCBIN "pic/bmon/elekid.pic",0,1 ; 55, sprite dimensions
dw ElekidPicFront
dw ElekidPicBack
; attacks known at lvl 0
db 0
db 0
db 0
db 0
db 0 ; growth rate
db AB_RECHARGE	;ability 1
db 00	;ability 2
db 55	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(ElekidPicFront) ; sprite bank
