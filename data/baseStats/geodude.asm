GeodudeBaseStats: ; 38bda (e:4bda)
db DEX_GEODUDE ; pokedex id
db 40 ; base hp
db 80 ; base attack
db 100 ; base defense
db 20 ; base speed
db $1E ; base special
db EARTH ; species type 1
db EARTH ; species type 2
db 255 ; catch rate
db 86 ; base exp yield
INCBIN "pic/bmon/geodude.pic",0,1 ; 55, sprite dimensions
dw GeodudePicFront
dw GeodudePicBack
; attacks known at lvl 0
db TACKLE
db 0
db 0
db 0
db 3 ; growth rate
db AB_TOUGH_SKIN	;ability 1
db 00	;ability 2
db $1E	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(GeodudePicFront) ; sprite bank