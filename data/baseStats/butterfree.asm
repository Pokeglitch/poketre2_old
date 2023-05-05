ButterfreeBaseStats: ; 38512 (e:4512)
db DEX_BUTTERFREE ; pokedex id
db 60 ; base hp
db 45 ; base attack
db 50 ; base defense
db 70 ; base speed
db 80 ; base special
db BUG ; species type 1
db AERO ; species type 2
db 45 ; catch rate
db 160 ; base exp yield
INCBIN "pic/bmon/butterfree.pic",0,1 ; 77, sprite dimensions
dw ButterfreePicFront
dw ButterfreePicBack
; attacks known at lvl 0
db BUG_BITE
db HARDEN
db 0
db 0
db 0 ; growth rate
db AB_STENCH	;ability 1
db 00	;ability 2
db 80	;special defense
db 10	;base selling price
db 00	;evolution shed item
db CAN_BE_MALE + CAN_BE_FEMALE + EG_BUG	;possible genders and egg group
db 70	;base morale
db BANK(ButterfreePicFront) ; sprite bank