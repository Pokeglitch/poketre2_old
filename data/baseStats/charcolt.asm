CharcoltBaseStats: ; 38aa6 (e:4aa6)
db DEX_CHARCOLT ; pokedex id
db 78 ; base hp
db 110 ; base attack
db 102 ; base defense
db 100 ; base speed
db 130 ; base special attack
db FIRE ; species type 1
db DRAGON ; species type 2
db 45 ; catch rate
db 216 ; base exp yield
INCBIN "pic/bmon/charcolt.pic",0,1 ; 55, sprite dimensions
dw CharcoltPicFront
dw CharcoltPicBack
; attacks known at lvl 0
db SCRATCH
db GROWL
db EMBER
db LEER
db 3 ; growth rate
db AB_FLYING_DRAGON	;ability 1
db AB_FLAME_BODY	;ability 2
db 115	;special defense
db 250	;base selling price
db 00	;evolution shed item
db CAN_BE_MALE + CAN_BE_FEMALE + EG_DRAGON	;possible genders and egg group
db 70	;base morale
db BANK(CharcoltPicFront) ; sprite bank
