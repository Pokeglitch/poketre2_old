LickitungBaseStats: ; 38f92 (e:4f92)
db DEX_LICKITUNG ; pokedex id
db 90 ; base hp
db 55 ; base attack
db 75 ; base defense
db 30 ; base speed
db $3C ; base special
db SOUND ; species type 1
db GOO ; species type 2
db 45 ; catch rate
db 127 ; base exp yield
INCBIN "pic/bmon/lickitung.pic",0,1 ; 77, sprite dimensions
dw LickitungPicFront
dw LickitungPicBack
; attacks known at lvl 0
db WRAP
db SUPERSONIC
db 0
db 0
db 0 ; growth rate
db AB_FLUFFY	;ability 1
db 00	;ability 2
db $4B	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(LickitungPicFront) ; sprite bank