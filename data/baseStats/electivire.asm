ElectivireBaseStats: ; 38aa6 (e:4aa6)
db DEX_ELECTIVIRE ; pokedex id
db 75 ; base hp
db 123 ; base attack
db 67 ; base defense
db 95 ; base speed
db 95 ; base special attack
db ELECTRIC ; species type 1
db RADIO ; species type 2
db 30 ; catch rate
db 199 ; base exp yield
INCBIN "pic/bmon/electivire.pic",0,1 ; 55, sprite dimensions
dw ElectivirePicFront
dw ElectivirePicBack
; attacks known at lvl 0
db 0
db 0
db 0
db 0
db 0 ; growth rate
db AB_RECHARGE	;ability 1
db 00	;ability 2
db 85	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(ElectivirePicFront) ; sprite bank
