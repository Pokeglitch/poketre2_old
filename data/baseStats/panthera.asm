PantheraBaseStats: ; 38aa6 (e:4aa6)
db DEX_PANTHERA ; pokedex id
db 73 ; base hp
db 104 ; base attack
db 96 ; base defense
db 123 ; base speed
db 104 ; base special attack
db TALON ; species type 1
db FANG ; species type 2
db 90 ; catch rate
db 168 ; base exp yield
INCBIN "pic/bmon/panthera.pic",0,1 ; 55, sprite dimensions
dw PantheraPicFront
dw PantheraPicBack
; attacks known at lvl 0
db SCRATCH
db GROWL
db BITE
db SCREECH
db 0 ; growth rate
db AB_PICKPOCKET	;ability 1
db AB_FLUFFY	;ability 2
db 104	;special defense
db 250	;base selling price
db WHISKERS	;evolution shed item
db CAN_BE_MALE + CAN_BE_FEMALE + EG_CAT	;possible genders and egg group
db 70	;base morale
db BANK(PantheraPicFront) ; sprite bank
