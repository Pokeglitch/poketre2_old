LakanessBaseStats: ; 38aa6 (e:4aa6)
db DEX_LAKANESS ; pokedex id
db $82 ; base hp
db $68 ; base attack
db $64 ; base defense
db $3C ; base speed
db $6C ; base special attack
db WATER ; species type 1
db ICE ; species type 2
db $2D ; catch rate
db $E0 ; base exp yield
INCBIN "pic/bmon/lakaness.pic",0,1 ; 55, sprite dimensions
dw LakanessPicFront
dw LakanessPicBack
; attacks known at lvl 0
db 0
db 0
db 0
db 0
db 5 ; growth rate
db AB_COLD_BLOODED	;ability 1
db AB_POROUS	;ability 2
db $72	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(LakanessPicFront) ; sprite bank
