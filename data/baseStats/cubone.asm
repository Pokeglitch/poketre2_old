CuboneBaseStats: ; 38f22 (e:4f22)
db DEX_CUBONE ; pokedex id
db 50 ; base hp
db 50 ; base attack
db 95 ; base defense
db 35 ; base speed
db $28 ; base special attack
db EARTH ; species type 1
db BONE ; species type 2
db 190 ; catch rate
db 87 ; base exp yield
INCBIN "pic/bmon/cubone.pic",0,1 ; 55, sprite dimensions
dw CubonePicFront
dw CubonePicBack
; attacks known at lvl 0
db BONE_CLUB
db GROWL
db 0
db 0
db 0 ; growth rate
db AB_HEADPIECE	;ability 1
db 00	;ability 2
db $32	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(CubonePicFront) ; sprite bank