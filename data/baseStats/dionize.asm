DionizeBaseStats: ; 38aa6 (e:4aa6)
db DEX_DIONIZE ; pokedex id
db $5A ; base hp
db $70 ; base attack
db $68 ; base defense
db $64 ; base speed
db $90 ; base special attack
db AERO ; species type 1
db ELECTRIC ; species type 2
db $03 ; catch rate
db $E0 ; base exp yield
INCBIN "pic/bmon/dionize.pic",0,1 ; 55, sprite dimensions
dw DionizePicFront
dw DionizePicBack
; attacks known at lvl 0
db 0
db 0
db 0
db 0
db 5 ; growth rate
db AB_THUNDER_STORM	;ability 1
db AB_RECHARGE	;ability 2
db $74	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(DionizePicFront) ; sprite bank
