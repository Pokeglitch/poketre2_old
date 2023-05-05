DragiliskBaseStats: ; 38aa6 (e:4aa6)
db DEX_DRAGILISK ; pokedex id
db $5B ; base hp
db $98 ; base attack
db $70 ; base defense
db $50 ; base speed
db $78 ; base special attack
db DRAGON ; species type 1
db AERO ; species type 2
db $2D ; catch rate
db $E2 ; base exp yield
INCBIN "pic/bmon/dragilisk.pic",0,1 ; 55, sprite dimensions
dw DragiliskPicFront
dw DragiliskPicBack
; attacks known at lvl 0
db 0
db 0
db 0
db 0
db 5 ; growth rate
db AB_STRONG_SCALE	;ability 1
db AB_FLYING_DRAGON	;ability 2
db $78	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(DragiliskPicFront) ; sprite bank
