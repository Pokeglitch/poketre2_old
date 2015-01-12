ElectabuzzBaseStats: ; 3916e (e:516e)
db DEX_ELECTABUZZ ; pokedex id
db 65 ; base hp
db 83 ; base attack
db 57 ; base defense
db 105 ; base speed
db $5F ; base special
db ELECTRIC ; species type 1
db RADIO ; species type 2
db 45 ; catch rate
db 156 ; base exp yield
INCBIN "pic/bmon/electabuzz.pic",0,1 ; 66, sprite dimensions
dw ElectabuzzPicFront
dw ElectabuzzPicBack
; attacks known at lvl 0
db QUICK_ATTACK
db LEER
db 0
db 0
db 0 ; growth rate
db AB_RECHARGE	;ability 1
db 00	;ability 2
db $55	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(ElectabuzzPicFront) ; sprite bank