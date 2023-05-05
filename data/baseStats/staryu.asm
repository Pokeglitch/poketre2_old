StaryuBaseStats: ; 390e2 (e:50e2)
db DEX_STARYU ; pokedex id
db 30 ; base hp
db 45 ; base attack
db 55 ; base defense
db 85 ; base speed
db $46 ; base special
db WATER ; species type 1
db COSMIC ; species type 2
db 225 ; catch rate
db 106 ; base exp yield
INCBIN "pic/bmon/staryu.pic",0,1 ; 66, sprite dimensions
dw StaryuPicFront
dw StaryuPicBack
; attacks known at lvl 0
db TACKLE
db 0
db 0
db 0
db 5 ; growth rate
db AB_REGENERATIVE	;ability 1
db 00	;ability 2
db $37	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(StaryuPicFront) ; sprite bank