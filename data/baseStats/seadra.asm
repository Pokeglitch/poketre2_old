SeadraBaseStats: ; 3908e (e:508e)
db DEX_SEADRA ; pokedex id
db 55 ; base hp
db 65 ; base attack
db 95 ; base defense
db 85 ; base speed
db $5F ; base special
db WATER ; species type 1
db WATER ; species type 2
db 75 ; catch rate
db 155 ; base exp yield
INCBIN "pic/bmon/seadra.pic",0,1 ; 66, sprite dimensions
dw SeadraPicFront
dw SeadraPicBack
; attacks known at lvl 0
db BUBBLE
db SMOKESCREEN
db 0
db 0
db 0 ; growth rate
db AB_POROUS	;ability 1
db 00	;ability 2
db $2D	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(SeadraPicFront) ; sprite bank