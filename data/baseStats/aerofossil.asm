AerofossilBaseStats: ; 38aa6 (e:4aa6)
db DEX_AEROFOSSIL ; pokedex id
db $50 ; base hp
db $7D ; base attack
db $55 ; base defense
db $82 ; base speed
db $58 ; base special attack
db BONE ; species type 1
db EARTH ; species type 2
db $2D ; catch rate
db $D0 ; base exp yield
INCBIN "pic/bmon/aerofossil.pic",0,1 ; 55, sprite dimensions
dw AerofossilPicFront
dw AerofossilPicBack
; attacks known at lvl 0
db 0
db 0
db 0
db 0
db 5 ; growth rate
db AB_FLYING_DRAGON	;ability 1
db AB_TOUGH_SKIN	;ability 2
db $60	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(AerofossilPicFront) ; sprite bank
