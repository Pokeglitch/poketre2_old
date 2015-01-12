ButterfreeBaseStats: ; 38512 (e:4512)
db DEX_BUTTERFREE ; pokedex id
db 60 ; base hp
db 45 ; base attack
db 50 ; base defense
db 70 ; base speed
db $50 ; base special
db BUG ; species type 1
db AERO ; species type 2
db 45 ; catch rate
db 160 ; base exp yield
INCBIN "pic/bmon/butterfree.pic",0,1 ; 77, sprite dimensions
dw ButterfreePicFront
dw ButterfreePicBack
; attacks known at lvl 0
db CONFUSION
db 0
db 0
db 0
db 0 ; growth rate
db AB_STENCH	;ability 1
db 00	;ability 2
db $50	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(ButterfreePicFront) ; sprite bank