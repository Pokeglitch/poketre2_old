ScizorBaseStats: ; 38aa6 (e:4aa6)
db DEX_SCIZOR ; pokedex id
db 70 ; base hp
db 130 ; base attack
db 100 ; base defense
db 65 ; base speed
db 55 ; base special attack
db BUG ; species type 1
db METAL ; species type 2
db 25 ; catch rate
db 200 ; base exp yield
INCBIN "pic/bmon/scizor.pic",0,1 ; 55, sprite dimensions
dw ScizorPicFront
dw ScizorPicBack
; attacks known at lvl 0
db 0
db 0
db 0
db 0
db 0 ; growth rate
db AB_SLICER	;ability 1
db 00	;ability 2
db 80	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(ScizorPicFront) ; sprite bank
