MimeoBaseStats: ; 38aa6 (e:4aa6)
db DEX_MIMEO ; pokedex id
db $30 ; base hp
db $60 ; base attack
db $60 ; base defense
db $30 ; base speed
db $60 ; base special attack
db GOO ; species type 1
db GOO ; species type 2
db $23 ; catch rate
db $78 ; base exp yield
INCBIN "pic/bmon/mimeo.pic",0,1 ; 55, sprite dimensions
dw MimeoPicFront
dw MimeoPicBack
; attacks known at lvl 0
db 0
db 0
db 0
db 0
db 0 ; growth rate
db AB_REGENERATIVE	;ability 1
db AB_FLUFFY	;ability 2
db $60	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(MimeoPicFront) ; sprite bank
