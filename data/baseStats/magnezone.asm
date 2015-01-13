MagnezoneBaseStats: ; 38aa6 (e:4aa6)
db DEX_MAGNEZONE ; pokedex id
db 70 ; base hp
db 70 ; base attack
db 115 ; base defense
db 60 ; base speed
db 130 ; base special attack
db METAL ; species type 1
db RADIO ; species type 2
db 30 ; catch rate
db 211 ; base exp yield
INCBIN "pic/bmon/magnezone.pic",0,1 ; 55, sprite dimensions
dw MagnezonePicFront
dw MagnezonePicBack
; attacks known at lvl 0
db 0
db 0
db 0
db 0
db 0 ; growth rate
db AB_RECHARGE	;ability 1
db 00	;ability 2
db 90	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(MagnezonePicFront) ; sprite bank
