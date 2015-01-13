MonochilBaseStats: ; 38aa6 (e:4aa6)
db DEX_MONOCHIL ; pokedex id
db $5A ; base hp
db $6A ; base attack
db $78 ; base defense
db $55 ; base speed
db $70 ; base special attack
db AERO ; species type 1
db ICE ; species type 2
db $03 ; catch rate
db $DD ; base exp yield
INCBIN "pic/bmon/monochil.pic",0,1 ; 55, sprite dimensions
dw MonochilPicFront
dw MonochilPicBack
; attacks known at lvl 0
db 0
db 0
db 0
db 0
db 5 ; growth rate
db AB_HAIL_STORM	;ability 1
db AB_COLD_BLOODED	;ability 2
db $90	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(MonochilPicFront) ; sprite bank
