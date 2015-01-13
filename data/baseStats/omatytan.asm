OmatytanBaseStats: ; 38aa6 (e:4aa6)
db DEX_OMATYTAN ; pokedex id
db $46 ; base hp
db $51 ; base attack
db $90 ; base defense
db $37 ; base speed
db $87 ; base special attack
db WATER ; species type 1
db GOO ; species type 2
db $2D ; catch rate
db $D2 ; base exp yield
INCBIN "pic/bmon/omatytan.pic",0,1 ; 55, sprite dimensions
dw OmatytanPicFront
dw OmatytanPicBack
; attacks known at lvl 0
db 0
db 0
db 0
db 0
db 0 ; growth rate
db AB_TOUGH_SKIN	;ability 1
db AB_POROUS	;ability 2
db $5A	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(OmatytanPicFront) ; sprite bank
