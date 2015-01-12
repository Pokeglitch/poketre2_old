WeepinbellBaseStats: ; 38b6a (e:4b6a)
db DEX_WEEPINBELL ; pokedex id
db 65 ; base hp
db 90 ; base attack
db 50 ; base defense
db 55 ; base speed
db $55 ; base special
db PLANT ; species type 1
db POISON ; species type 2
db 120 ; catch rate
db 151 ; base exp yield
INCBIN "pic/bmon/weepinbell.pic",0,1 ; 66, sprite dimensions
dw WeepinbellPicFront
dw WeepinbellPicBack
; attacks known at lvl 0
db VINE_WHIP
db GROWTH
db WRAP
db 0
db 3 ; growth rate
db AB_PHOTOSYNTHESIS	;ability 1
db 00	;ability 2
db $2D	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(WeepinbellPicFront) ; sprite bank
