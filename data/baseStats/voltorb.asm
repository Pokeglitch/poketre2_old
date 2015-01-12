VoltorbBaseStats: ; 38eb2 (e:4eb2)
db DEX_VOLTORB ; pokedex id
db 40 ; base hp
db 30 ; base attack
db 50 ; base defense
db 100 ; base speed
db $37 ; base special
db ELECTRIC ; species type 1
db METAL ; species type 2
db 190 ; catch rate
db 103 ; base exp yield
INCBIN "pic/bmon/voltorb.pic",0,1 ; 55, sprite dimensions
dw VoltorbPicFront
dw VoltorbPicBack
; attacks known at lvl 0
db TACKLE
db SCREECH
db 0
db 0
db 0 ; growth rate
db AB_RECHARGE	;ability 1
db 00	;ability 2
db $37	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(VoltorbPicFront) ; sprite bank
