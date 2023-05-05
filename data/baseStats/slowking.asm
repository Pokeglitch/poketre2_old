SlowkingBaseStats: ; 38aa6 (e:4aa6)
db DEX_SLOWKING ; pokedex id
db 95 ; base hp
db 75 ; base attack
db 80 ; base defense
db 30 ; base speed
db 100 ; base special attack
db WATER ; species type 1
db MIND ; species type 2
db 70 ; catch rate
db 164 ; base exp yield
INCBIN "pic/bmon/slowking.pic",0,1 ; 55, sprite dimensions
dw SlowkingPicFront
dw SlowkingPicBack
; attacks known at lvl 0
db 0
db 0
db 0
db 0
db 0 ; growth rate
db AB_INSOMNIA	;ability 1
db 00	;ability 2
db 110	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(SlowkingPicFront) ; sprite bank
