TyrogueBaseStats: ; 38aa6 (e:4aa6)
db DEX_TYROGUE ; pokedex id
db 35 ; base hp
db 35 ; base attack
db 35 ; base defense
db 35 ; base speed
db 35 ; base special attack
db FIGHTING ; species type 1
db FIGHTING ; species type 2
db 75 ; catch rate
db 91 ; base exp yield
INCBIN "pic/bmon/tyrogue.pic",0,1 ; 55, sprite dimensions
dw TyroguePicFront
dw TyroguePicBack
; attacks known at lvl 0
db 0
db 0
db 0
db 0
db 0 ; growth rate
db AB_ILL_TEMPERED	;ability 1
db 00	;ability 2
db 35	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(TyroguePicFront) ; sprite bank
