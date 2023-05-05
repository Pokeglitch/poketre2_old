PersianBaseStats: ; 3898e (e:498e)
db DEX_PERSIAN ; pokedex id
db 75 ; base hp
db 80 ; base attack
db 70 ; base defense
db 125 ; base speed
db 75 ; base special
db TALON ; species type 1
db FANG ; species type 2
db 90 ; catch rate
db 148 ; base exp yield
INCBIN "pic/bmon/persian.pic",0,1 ; 77, sprite dimensions
dw PersianPicFront
dw PersianPicBack
; attacks known at lvl 0
db SCRATCH
db GROWL
db BITE
db SCREECH
db 0 ; growth rate
db AB_PICKPOCKET	;ability 1
db 00	;ability 2
db 75	;special defense
db 250	;base selling price
db WHISKERS	;evolution shed item
db CAN_BE_MALE + CAN_BE_FEMALE + EG_CAT	;possible genders and egg group
db 70	;base morale
db BANK(PersianPicFront) ; sprite bank
