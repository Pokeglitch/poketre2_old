PidgeotBaseStats: ; 385ba (e:45ba)
db DEX_PIDGEOT ; pokedex id
db 83 ; base hp
db 80 ; base attack
db 75 ; base defense
db 91 ; base speed
db 70 ; base special
db AERO ; species type 1
db TALON ; species type 2
db 45 ; catch rate
db 172 ; base exp yield
INCBIN "pic/bmon/pidgeot.pic",0,1 ; 77, sprite dimensions
dw PidgeotPicFront
dw PidgeotPicBack
; attacks known at lvl 0
db GUST
db SAND_ATTACK
db QUICK_ATTACK
db 0
db 3 ; growth rate
db AB_PREDATOR	;ability 1
db 00	;ability 2
db $46	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(PidgeotPicFront) ; sprite bank