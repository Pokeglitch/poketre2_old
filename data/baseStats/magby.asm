MagbyBaseStats: ; 38aa6 (e:4aa6)
db DEX_MAGBY ; pokedex id
db 45 ; base hp
db 75 ; base attack
db 37 ; base defense
db 83 ; base speed
db 70 ; base special attack
db FIRE ; species type 1
db FIRE ; species type 2
db 45 ; catch rate
db 117 ; base exp yield
INCBIN "pic/bmon/magby.pic",0,1 ; 55, sprite dimensions
dw MagbyPicFront
dw MagbyPicBack
; attacks known at lvl 0
db 0
db 0
db 0
db 0
db 0 ; growth rate
db AB_FLAME_BODY	;ability 1
db 00	;ability 2
db 55	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(MagbyPicFront) ; sprite bank
