SeelBaseStats: ; 38d2a (e:4d2a)
db DEX_SEEL ; pokedex id
db 65 ; base hp
db 45 ; base attack
db 55 ; base defense
db 45 ; base speed
db $2D ; base special
db WATER ; species type 1
db WATER ; species type 2
db 190 ; catch rate
db 100 ; base exp yield
INCBIN "pic/bmon/seel.pic",0,1 ; 66, sprite dimensions
dw SeelPicFront
dw SeelPicBack
; attacks known at lvl 0
db HEADBUTT
db 0
db 0
db 0
db 0 ; growth rate
db AB_SWIMMER	;ability 1
db 00	;ability 2
db $46	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(SeelPicFront) ; sprite bank