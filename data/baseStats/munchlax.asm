MunchlaxBaseStats: ; 38aa6 (e:4aa6)
db DEX_MUNCHLAX ; pokedex id
db 135 ; base hp
db 85 ; base attack
db 40 ; base defense
db 5 ; base speed
db 40 ; base special attack
db MIND ; species type 1
db MIND ; species type 2
db 50 ; catch rate
db 94 ; base exp yield
INCBIN "pic/bmon/munchlax.pic",0,1 ; 55, sprite dimensions
dw MunchlaxPicFront
dw MunchlaxPicBack
; attacks known at lvl 0
db 0
db 0
db 0
db 0
db 5 ; growth rate
db AB_FLUFFY	;ability 1
db 00	;ability 2
db 85	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(MunchlaxPicFront) ; sprite bank
