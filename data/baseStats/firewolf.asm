FirewolfBaseStats: ; 38aa6 (e:4aa6)
db DEX_FIREWOLF ; pokedex id
db 100 ; base hp
db 134 ; base attack
db 100 ; base defense
db 105 ; base speed
db 125 ; base special attack
db FIRE ; species type 1
db FANG ; species type 2
db 75 ; catch rate
db 230 ; base exp yield
INCBIN "pic/bmon/firewolf.pic",0,1 ; 55, sprite dimensions
dw FirewolfPicFront
dw FirewolfPicBack
; attacks known at lvl 0
db 0
db 0
db 0
db 0
db 5 ; growth rate
db AB_RAWHIDE	;ability 1
db AB_FLAME_BODY	;ability 2
db 105	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(FirewolfPicFront) ; sprite bank
