Porygon_iBaseStats: ; 38aa6 (e:4aa6)
db DEX_PORYGON_I ; pokedex id
db $55 ; base hp
db $64 ; base attack
db $5A ; base defense
db $5A ; base speed
db $98 ; base special attack
db CYBER ; species type 1
db CYBER ; species type 2
db $1E ; catch rate
db $BF ; base exp yield
INCBIN "pic/bmon/porygon-i.pic",0,1 ; 55, sprite dimensions
dw Porygon_iPicFront
dw Porygon_iPicBack
; attacks known at lvl 0
db 0
db 0
db 0
db 0
db 0 ; growth rate
db AB_CONVERT	;ability 1
db AB_SEE_THROUGH	;ability 2
db $60	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(Porygon_iPicFront) ; sprite bank
