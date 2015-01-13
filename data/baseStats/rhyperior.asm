RhyperiorBaseStats: ; 38aa6 (e:4aa6)
db DEX_RHYPERIOR ; pokedex id
db 115 ; base hp
db 140 ; base attack
db 130 ; base defense
db 40 ; base speed
db 55 ; base special attack
db EARTH ; species type 1
db HOOF ; species type 2
db 30 ; catch rate
db 217 ; base exp yield
INCBIN "pic/bmon/rhyperior.pic",0,1 ; 55, sprite dimensions
dw RhyperiorPicFront
dw RhyperiorPicBack
; attacks known at lvl 0
db 0
db 0
db 0
db 0
db 5 ; growth rate
db AB_TOUGH_SKIN	;ability 1
db 00	;ability 2
db 55	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(RhyperiorPicFront) ; sprite bank
