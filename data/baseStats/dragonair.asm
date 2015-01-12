DragonairBaseStats: ; 393f2 (e:53f2)
db DEX_DRAGONAIR ; pokedex id
db 61 ; base hp
db 84 ; base attack
db 65 ; base defense
db 70 ; base speed
db $46 ; base special
db DRAGON ; species type 1
db DRAGON ; species type 2
db 45 ; catch rate
db 144 ; base exp yield
INCBIN "pic/bmon/dragonair.pic",0,1 ; 66, sprite dimensions
dw DragonairPicFront
dw DragonairPicBack
; attacks known at lvl 0
db WRAP
db LEER
db THUNDER_WAVE
db 0
db 5 ; growth rate
db AB_STRONG_SCALE	;ability 1
db AB_FLYING_DRAGON	;ability 2
db $46	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(DragonairPicFront) ; sprite bank