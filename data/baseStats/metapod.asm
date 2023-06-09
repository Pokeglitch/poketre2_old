MetapodBaseStats: ; 384f6 (e:44f6)
db DEX_METAPOD ; pokedex id
db 50 ; base hp
db 20 ; base attack
db 55 ; base defense
db 30 ; base speed
db 25 ; base special
db BUG ; species type 1
db BUG ; species type 2
db 120 ; catch rate
db 72 ; base exp yield
INCBIN "pic/bmon/metapod.pic",0,1 ; 55, sprite dimensions
dw MetapodPicFront
dw MetapodPicBack
; attacks known at lvl 0
db HARDEN
db 0
db 0
db 0
db 0 ; growth rate
db AB_STENCH	;ability 1
db 00	;ability 2
db 25 ;special defense
db 02	;base selling price
db 00	;evolution shed item
db CAN_BE_MALE + CAN_BE_FEMALE + EG_BUG	;possible genders and egg group
db 70	;base morale
db BANK(MetapodPicFront) ; sprite bank