MeowthBaseStats: ; 38972 (e:4972)
db DEX_MEOWTH ; pokedex id
db 50 ; base hp
db 55 ; base attack
db 45 ; base defense
db 100 ; base speed
db 50 ; base special
db TALON ; species type 1
db FANG ; species type 2
db 255 ; catch rate
db 69 ; base exp yield
INCBIN "pic/bmon/meowth.pic",0,1 ; 55, sprite dimensions
dw MeowthPicFront
dw MeowthPicBack
; attacks known at lvl 0
db SCRATCH
db GROWL
db 0
db 0
db 0 ; growth rate
db AB_PICKPOCKET	;ability 1
db 00	;ability 2
db 50	;special defense
db 250	;base selling price
db WHISKERS	;evolution shed item
db CAN_BE_MALE + CAN_BE_FEMALE + EG_CAT	;possible genders and egg group
db 70	;base morale
db BANK(MeowthPicFront) ; sprite bank