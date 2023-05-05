HitmontopBaseStats: ; 38aa6 (e:4aa6)
db DEX_HITMONTOP ; pokedex id
db 50 ; base hp
db 95 ; base attack
db 95 ; base defense
db 70 ; base speed
db 35 ; base special attack
db FIGHTING ; species type 1
db FIGHTING ; species type 2
db 45 ; catch rate
db 138 ; base exp yield
INCBIN "pic/bmon/hitmontop.pic",0,1 ; 55, sprite dimensions
dw HitmontopPicFront
dw HitmontopPicBack
; attacks known at lvl 0
db 0
db 0
db 0
db 0
db 0 ; growth rate
db AB_ILL_TEMPERED	;ability 1
db 00	;ability 2
db 110	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(HitmontopPicFront) ; sprite bank
