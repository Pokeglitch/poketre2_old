DiglettBaseStats: ; 3893a (e:493a)
db DEX_DIGLETT ; pokedex id
db 10 ; base hp
db 55 ; base attack
db 25 ; base defense
db 95 ; base speed
db $23 ; base special
db EARTH ; species type 1
db EARTH ; species type 2
db 255 ; catch rate
db 81 ; base exp yield
INCBIN "pic/bmon/diglett.pic",0,1 ; 55, sprite dimensions
dw DiglettPicFront
dw DiglettPicBack
; attacks known at lvl 0
db SCRATCH
db 0
db 0
db 0
db 0 ; growth rate
db AB_NOCTURNAL	;ability 1
db 00	;ability 2
db $2D	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(DiglettPicFront) ; sprite bank