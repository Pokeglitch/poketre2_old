MimeSrBaseStats: ; 38aa6 (e:4aa6)
db DEX_MIME_SR ; pokedex id
db $28 ; base hp
db $50 ; base attack
db $55 ; base defense
db $5A ; base speed
db $78 ; base special attack
db MAGIC ; species type 1
db MAGIC ; species type 2
db $2D ; catch rate
db $C0 ; base exp yield
INCBIN "pic/bmon/mimesr.pic",0,1 ; 55, sprite dimensions
dw MimeSrPicFront
dw MimeSrPicBack
; attacks known at lvl 0
db 0
db 0
db 0
db 0
db 0 ; growth rate
db AB_INVISIBLE_WALL	;ability 1
db AB_INSOMNIA	;ability 2
db $8B	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(MimeSrPicFront) ; sprite bank
