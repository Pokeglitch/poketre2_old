JigglypuffBaseStats: ; 38806 (e:4806)
db DEX_JIGGLYPUFF ; pokedex id
db 115 ; base hp
db 45 ; base attack
db 20 ; base defense
db 20 ; base speed
db $2D ; base special
db SOUND ; species type 1
db COSMIC ; species type 2
db 170 ; catch rate
db 76 ; base exp yield
INCBIN "pic/bmon/jigglypuff.pic",0,1 ; 55, sprite dimensions
dw JigglypuffPicFront
dw JigglypuffPicBack
; attacks known at lvl 0
db SING
db 0
db 0
db 0
db 4 ; growth rate
db AB_FLUFFY	;ability 1
db 00	;ability 2
db $19	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(JigglypuffPicFront) ; sprite bank