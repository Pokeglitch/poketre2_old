ArcanineBaseStats: ; 38a36 (e:4a36)
db DEX_ARCANINE ; pokedex id
db 90 ; base hp
db 110 ; base attack
db 80 ; base defense
db 95 ; base speed
db $64 ; base special
db FIRE ; species type 1
db FANG ; species type 2
db 75 ; catch rate
db 213 ; base exp yield
INCBIN "pic/bmon/arcanine.pic",0,1 ; 77, sprite dimensions
dw ArcaninePicFront
dw ArcaninePicBack
; attacks known at lvl 0
db ROAR
db EMBER
db LEER
db TAKE_DOWN
db 5 ; growth rate
db AB_FLUFFY	;ability 1
db 00	;ability 2
db $50	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(ArcaninePicFront) ; sprite bank