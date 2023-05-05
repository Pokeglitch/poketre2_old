MagikarpBaseStats: ; 391de (e:51de)
db DEX_MAGIKARP ; pokedex id
db 20 ; base hp
db 10 ; base attack
db 55 ; base defense
db 80 ; base speed
db $0F ; base special
db WATER ; species type 1
db WATER ; species type 2
db 255 ; catch rate
db 20 ; base exp yield
INCBIN "pic/bmon/magikarp.pic",0,1 ; 66, sprite dimensions
dw MagikarpPicFront
dw MagikarpPicBack
; attacks known at lvl 0
db SPLASH
db 0
db 0
db 0
db 5 ; growth rate
db AB_SWIMMER	;ability 1
db 00	;ability 2
db $14	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(MagikarpPicFront) ; sprite bank