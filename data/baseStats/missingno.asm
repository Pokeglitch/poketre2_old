MissingnoBaseStats: ; 38aa6 (e:4aa6)
db DEX_MISSINGNO ; pokedex id
db $59 ; base hp
db $90 ; base attack
db $48 ; base defense
db $4D ; base speed
db $55 ; base special attack
db CYBER ; species type 1
db POISON ; species type 2
db $03 ; catch rate
db $C8 ; base exp yield
INCBIN "pic/bmon/missingno.pic",0,1 ; 55, sprite dimensions
dw MissingnoPicFront
dw MissingnoPicBack
; attacks known at lvl 0
db 0
db 0
db 0
db 0
db 5 ; growth rate
db AB_GLITCH	;ability 1
db AB_REGENERATIVE	;ability 2
db $40	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(MissingnoPicFront) ; sprite bank
