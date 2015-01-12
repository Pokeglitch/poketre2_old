OnixBaseStats: ; 38e26 (e:4e26)
db DEX_ONIX ; pokedex id
db 35 ; base hp
db 45 ; base attack
db 160 ; base defense
db 70 ; base speed
db $1E ; base special
db EARTH ; species type 1
db EARTH ; species type 2
db 45 ; catch rate
db 108 ; base exp yield
INCBIN "pic/bmon/onix.pic",0,1 ; 77, sprite dimensions
dw OnixPicFront
dw OnixPicBack
; attacks known at lvl 0
db TACKLE
db SCREECH
db 0
db 0
db 0 ; growth rate
db AB_TOUGH_SKIN	;ability 1
db 00	;ability 2
db $2D	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(OnixPicFront) ; sprite bank