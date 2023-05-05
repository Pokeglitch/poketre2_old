CaterpieBaseStats: ; 384da (e:44da)
db DEX_CATERPIE ; pokedex id
db 45 ; base hp
db 30 ; base attack
db 35 ; base defense
db 45 ; base speed
db 20 ; base special
db BUG ; species type 1
db BUG ; species type 2
db 255 ; catch rate
db 53 ; base exp yield
INCBIN "pic/bmon/caterpie.pic",0,1 ; 55, sprite dimensions
dw CaterpiePicFront
dw CaterpiePicBack
; attacks known at lvl 0
db BUG_BITE
db STRING_SHOT
db 0
db 0
db 0 ; growth rate
db AB_STENCH	;ability 1
db 00	;ability 2
db 20	;special defense
db 02	;base selling price
db 00	;evolution shed item
db CAN_BE_MALE + CAN_BE_FEMALE + EG_BUG	;possible genders and egg group
db 70	;base morale
db BANK(CaterpiePicFront) ; sprite bank