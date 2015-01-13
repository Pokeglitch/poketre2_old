DragoniteBaseStats: ; 3940e (e:540e)
db DEX_DRAGONITE ; pokedex id
db 91 ; base hp
db 134 ; base attack
db 95 ; base defense
db 80 ; base speed
db $64 ; base special
db DRAGON ; species type 1
db AERO ; species type 2
db 45 ; catch rate
db 218 ; base exp yield
INCBIN "pic/bmon/dragonite.pic",0,1 ; 77, sprite dimensions
dw DragonitePicFront
dw DragonitePicBack
; attacks known at lvl 0
db WRAP
db LEER
db THUNDER_WAVE
db AGILITY
db 5 ; growth rate
db AB_STRONG_SCALE	;ability 1
db AB_SWIMMER	;ability 2
db $64	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(DragonitePicFront) ; sprite bank