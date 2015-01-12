RhydonBaseStats: ; 39002 (e:5002)
db DEX_RHYDON ; pokedex id
db 105 ; base hp
db 130 ; base attack
db 120 ; base defense
db 40 ; base speed
db $2D ; base special
db EARTH ; species type 1
db HOOF ; species type 2
db 60 ; catch rate
db 204 ; base exp yield
INCBIN "pic/bmon/rhydon.pic",0,1 ; 77, sprite dimensions
dw RhydonPicFront
dw RhydonPicBack
; attacks known at lvl 0
db HORN_ATTACK
db STOMP
db TAIL_WHIP
db FURY_ATTACK
db 5 ; growth rate
db AB_TOUGH_SKIN	;ability 1
db 00	;ability 2
db $2D	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(RhydonPicFront) ; sprite bank