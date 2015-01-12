RattataBaseStats: ; 385d6 (e:45d6)
db DEX_RATTATA ; pokedex id
db 30 ; base hp
db 56 ; base attack
db 35 ; base defense
db 72 ; base speed
db $19 ; base special
db FANG ; species type 1
db FANG ; species type 2
db 255 ; catch rate
db 57 ; base exp yield
INCBIN "pic/bmon/rattata.pic",0,1 ; 55, sprite dimensions
dw RattataPicFront
dw RattataPicBack
; attacks known at lvl 0
db TACKLE
db TAIL_WHIP
db 0
db 0
db 0 ; growth rate
db AB_FLUFFY	;ability 1
db 00	;ability 2
db $23	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(RattataPicFront) ; sprite bank