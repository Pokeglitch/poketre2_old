SquirtleBaseStats: ; 38486 (e:4486)
db DEX_SQUIRTLE ; pokedex id
db 44 ; base hp
db 48 ; base attack
db 65 ; base defense
db 43 ; base speed
db 50 ; base special
db WATER ; species type 1
db WATER ; species type 2
db 45 ; catch rate
db 66 ; base exp yield
INCBIN "pic/bmon/squirtle.pic",0,1 ; 55, sprite dimensions
dw SquirtlePicFront
dw SquirtlePicBack
; attacks known at lvl 0
db TACKLE
db TAIL_WHIP
db 0
db 0
db 3 ; growth rate
db AB_TOUGH_SKIN	;ability 1
db 00	;ability 2
db 64	;special defense
db 250	;base selling price
db 00	;evolution shed item
db CAN_BE_MALE + CAN_BE_FEMALE + EG_TURTLE	;possible genders and egg group
db 70	;base morale
db BANK(SquirtlePicFront) ; sprite bank
