GastlyBaseStats: ; 38dd2 (e:4dd2)
db DEX_GASTLY ; pokedex id
db 30 ; base hp
db 35 ; base attack
db 30 ; base defense
db 80 ; base speed
db $64 ; base special
db GHOST ; species type 1
db GOO ; species type 2
db 190 ; catch rate
db 95 ; base exp yield
INCBIN "pic/bmon/gastly.pic",0,1 ; 77, sprite dimensions
dw GastlyPicFront
dw GastlyPicBack
; attacks known at lvl 0
db LICK
db CONFUSE_RAY
db NIGHT_SHADE
db 0
db 3 ; growth rate
db AB_SEE_THROUGH	;ability 1
db 00	;ability 2
db $23	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(GastlyPicFront) ; sprite bank