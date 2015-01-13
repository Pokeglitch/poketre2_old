GymnotusBaseStats: ; 38aa6 (e:4aa6)
db DEX_GYMNOTUS ; pokedex id
db $5F ; base hp
db $90 ; base attack
db $60 ; base defense
db $51 ; base speed
db $55 ; base special attack
db WATER ; species type 1
db DRAGON ; species type 2
db $2D ; catch rate
db $E0 ; base exp yield
INCBIN "pic/bmon/gymnotus.pic",0,1 ; 55, sprite dimensions
dw GymnotusPicFront
dw GymnotusPicBack
; attacks known at lvl 0
db 0
db 0
db 0
db 0
db  ; growth rate
db AB_SWIMMER	;ability 1
db AB_POROUS	;ability 2
db $78	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(GymnotusPicFront) ; sprite bank
