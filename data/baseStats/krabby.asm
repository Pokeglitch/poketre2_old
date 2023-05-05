KrabbyBaseStats: ; 38e7a (e:4e7a)
db DEX_KRABBY ; pokedex id
db 30 ; base hp
db 105 ; base attack
db 90 ; base defense
db 50 ; base speed
db $19 ; base special
db WATER ; species type 1
db WATER ; species type 2
db 225 ; catch rate
db 115 ; base exp yield
INCBIN "pic/bmon/krabby.pic",0,1 ; 55, sprite dimensions
dw KrabbyPicFront
dw KrabbyPicBack
; attacks known at lvl 0
db BUBBLE
db LEER
db 0
db 0
db 0 ; growth rate
db AB_TOUGH_SKIN	;ability 1
db 00	;ability 2
db $19	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(KrabbyPicFront) ; sprite bank
