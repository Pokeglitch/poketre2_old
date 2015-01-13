HumanBaseStats: ; 38aa6 (e:4aa6)
db DEX_HUMAN ; pokedex id
db 50 ; base hp
db 50 ; base attack
db 50 ; base defense
db 50 ; base speed
db 50 ; base special attack
db WATER ; species type 1
db DRAGON ; species type 2
db 03 ; catch rate
db 50 ; base exp yield
INCBIN "pic/trainer/james.pic",0,1 ; 55, sprite dimensions
dw JamesPicFront
dw JamesPicBack
; attacks known at lvl 0
db 0
db 0
db 0
db 0
db 0 ; growth rate
db 00	;ability 1
db 00	;ability 2
db 50	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(JamesPicFront) ; sprite bank
