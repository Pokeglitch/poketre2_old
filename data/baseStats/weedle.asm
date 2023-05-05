WeedleBaseStats: ; 3852e (e:452e)
db DEX_WEEDLE ; pokedex id
db 40 ; base hp
db 35 ; base attack
db 30 ; base defense
db 50 ; base speed
db 20 ; base special
db BUG ; species type 1
db POISON ; species type 2
db 255 ; catch rate
db 52 ; base exp yield
INCBIN "pic/bmon/weedle.pic",0,1 ; 55, sprite dimensions
dw WeedlePicFront
dw WeedlePicBack
; attacks known at lvl 0
db POISON_STING
db STRING_SHOT
db 0
db 0
db 0 ; growth rate
db AB_HEADPIECE	;ability 1
db 00	;ability 2
db 20	;special defense
db 02	;base selling price
db 00	;evolution shed item
db CAN_BE_MALE + CAN_BE_FEMALE + EG_BUG	;possible genders and egg group
db 70	;base morale
db BANK(WeedlePicFront) ; sprite bank