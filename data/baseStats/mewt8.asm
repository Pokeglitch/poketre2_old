Mewt8BaseStats: ; 38aa6 (e:4aa6)
db DEX_MEWT8 ; pokedex id
db $64 ; base hp
db $78 ; base attack
db $78 ; base defense
db $64 ; base speed
db $78 ; base special attack
db MIND ; species type 1
db COSMIC ; species type 2
db $2D ; catch rate
db $80 ; base exp yield
INCBIN "pic/bmon/mewt8.pic",0,1 ; 55, sprite dimensions
dw Mewt8PicFront
dw Mewt8PicBack
; attacks known at lvl 0
db 0
db 0
db 0
db 0
db 3 ; growth rate
db AB_INVISIBLE	;ability 1
db AB_REGENERATIVE	;ability 2
db $78	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(Mewt8PicFront) ; sprite bank
