PidgeyBaseStats: ; 38582 (e:4582)
db DEX_PIDGEY ; pokedex id
db 40 ; base hp
db 45 ; base attack
db 40 ; base defense
db 56 ; base speed
db $23 ; base special
db AERO ; species type 1
db AERO ; species type 2
db 255 ; catch rate
db 55 ; base exp yield
INCBIN "pic/bmon/pidgey.pic",0,1 ; 55, sprite dimensions
dw PidgeyPicFront
dw PidgeyPicBack
; attacks known at lvl 0
db GUST
db 0
db 0
db 0
db 3 ; growth rate
db AB_PREDATOR	;ability 1
db 00	;ability 2
db $23	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(PidgeyPicFront) ; sprite bank