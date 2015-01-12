ScytherBaseStats: ; 39136 (e:5136)
db DEX_SCYTHER ; pokedex id
db 70 ; base hp
db 110 ; base attack
db 80 ; base defense
db 105 ; base speed
db $37 ; base special
db BUG ; species type 1
db TALON ; species type 2
db 45 ; catch rate
db 187 ; base exp yield
INCBIN "pic/bmon/scyther.pic",0,1 ; 77, sprite dimensions
dw ScytherPicFront
dw ScytherPicBack
; attacks known at lvl 0
db QUICK_ATTACK
db 0
db 0
db 0
db 0 ; growth rate
db AB_SLICER	;ability 1
db 00	;ability 2
db $50	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(ScytherPicFront) ; sprite bank