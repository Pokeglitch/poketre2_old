PoliwagBaseStats: ; 38a52 (e:4a52)
db DEX_POLIWAG ; pokedex id
db 40 ; base hp
db 50 ; base attack
db 40 ; base defense
db 90 ; base speed
db $28 ; base special
db WATER ; species type 1
db WATER ; species type 2
db 255 ; catch rate
db 77 ; base exp yield
INCBIN "pic/bmon/poliwag.pic",0,1 ; 55, sprite dimensions
dw PoliwagPicFront
dw PoliwagPicBack
; attacks known at lvl 0
db BUBBLE
db 0
db 0
db 0
db 3 ; growth rate
db AB_SWIMMER	;ability 1
db 00	;ability 2
db $28	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(PoliwagPicFront) ; sprite bank
