LickilickyBaseStats: ; 38aa6 (e:4aa6)
db DEX_LICKILICKY ; pokedex id
db 110 ; base hp
db 85 ; base attack
db 95 ; base defense
db 50 ; base speed
db 80 ; base special attack
db SOUND ; species type 1
db GOO ; species type 2
db 30 ; catch rate
db 193 ; base exp yield
INCBIN "pic/bmon/lickilicky.pic",0,1 ; 55, sprite dimensions
dw LickilickyPicFront
dw LickilickyPicBack
; attacks known at lvl 0
db 0
db 0
db 0
db 0
db 0 ; growth rate
db AB_FLUFFY	;ability 1
db 00	;ability 2
db 95	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(LickilickyPicFront) ; sprite bank
