GravelerBaseStats: ; 38bf6 (e:4bf6)
db DEX_GRAVELER ; pokedex id
db 55 ; base hp
db 95 ; base attack
db 115 ; base defense
db 35 ; base speed
db $2D ; base special
db EARTH ; species type 1
db EARTH ; species type 2
db 120 ; catch rate
db 134 ; base exp yield
INCBIN "pic/bmon/graveler.pic",0,1 ; 66, sprite dimensions
dw GravelerPicFront
dw GravelerPicBack
; attacks known at lvl 0
db TACKLE
db DEFENSE_CURL
db 0
db 0
db 3 ; growth rate
db AB_TOUGH_SKIN	;ability 1
db 00	;ability 2
db $2D	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(GravelerPicFront) ; sprite bank