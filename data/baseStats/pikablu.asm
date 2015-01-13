PikabluBaseStats: ; 38aa6 (e:4aa6)
db DEX_PIKABLU ; pokedex id
db $3C ; base hp
db $70 ; base attack
db $55 ; base defense
db $64 ; base speed
db $70 ; base special attack
db ELECTRIC ; species type 1
db WATER ; species type 2
db $4B ; catch rate
db $B4 ; base exp yield
INCBIN "pic/bmon/pikablu.pic",0,1 ; 55, sprite dimensions
dw PikabluPicFront
dw PikabluPicBack
; attacks known at lvl 0
db 0
db 0
db 0
db 0
db 0 ; growth rate
db AB_RECHARGE	;ability 1
db AB_POROUS	;ability 2
db $64 ;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(PikabluPicFront) ; sprite bank
