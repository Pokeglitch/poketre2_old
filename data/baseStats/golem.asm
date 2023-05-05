GolemBaseStats: ; 38c12 (e:4c12)
db DEX_GOLEM ; pokedex id
db 80 ; base hp
db 110 ; base attack
db 130 ; base defense
db 45 ; base speed
db $37 ; base special
db EARTH ; species type 1
db EARTH ; species type 2
db 45 ; catch rate
db 177 ; base exp yield
INCBIN "pic/bmon/golem.pic",0,1 ; 66, sprite dimensions
dw GolemPicFront
dw GolemPicBack
; attacks known at lvl 0
db TACKLE
db DEFENSE_CURL
db 0
db 0
db 3 ; growth rate
db AB_TOUGH_SKIN	;ability 1
db 00	;ability 2
db $41	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(GolemPicFront) ; sprite bank