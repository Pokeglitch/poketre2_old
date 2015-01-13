IgglybuffBaseStats: ; 38aa6 (e:4aa6)
db DEX_IGGLYBUFF ; pokedex id
db 90 ; base hp
db 30 ; base attack
db 15 ; base defense
db 15 ; base speed
db 40 ; base special attack
db SOUND ; species type 1
db COSMIC ; species type 2
db 170 ; catch rate
db 39 ; base exp yield
INCBIN "pic/bmon/igglybuff.pic",0,1 ; 55, sprite dimensions
dw IgglybuffPicFront
dw IgglybuffPicBack
; attacks known at lvl 0
db 0
db 0
db 0
db 0
db 4 ; growth rate
db AB_FLUFFY	;ability 1
db 00	;ability 2
db 20	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(IgglybuffPicFront) ; sprite bank
