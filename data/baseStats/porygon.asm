PorygonBaseStats: ; 392be (e:52be)
db DEX_PORYGON ; pokedex id
db 65 ; base hp
db 60 ; base attack
db 70 ; base defense
db 40 ; base speed
db $55 ; base special
db CYBER ; species type 1
db CYBER ; species type 2
db 45 ; catch rate
db 130 ; base exp yield
INCBIN "pic/bmon/porygon.pic",0,1 ; 66, sprite dimensions
dw PorygonPicFront
dw PorygonPicBack
; attacks known at lvl 0
db TACKLE
db SHARPEN
db CONVERSION
db 0
db 0 ; growth rate
db AB_CONVERT	;ability 1
db 00	;ability 2
db $4B	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(PorygonPicFront) ; sprite bank
