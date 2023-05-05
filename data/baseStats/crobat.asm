CrobatBaseStats: ; 38aa6 (e:4aa6)
db DEX_CROBAT ; pokedex id
db 85 ; base hp
db 90 ; base attack
db 80 ; base defense
db 130 ; base speed
db 70 ; base special attack
db SOUND ; species type 1
db AERO ; species type 2
db 90 ; catch rate
db 204 ; base exp yield
INCBIN "pic/bmon/crobat.pic",0,1 ; 55, sprite dimensions
dw CrobatPicFront
dw CrobatPicBack
; attacks known at lvl 0
db 0
db 0
db 0
db 0
db 0 ; growth rate
db AB_VENOMOUS	;ability 1
db 00	;ability 2
db 80	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(CrobatPicFront) ; sprite bank
