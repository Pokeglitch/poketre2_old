DratiniBaseStats: ; 393d6 (e:53d6)
db DEX_DRATINI ; pokedex id
db 41 ; base hp
db 64 ; base attack
db 45 ; base defense
db 50 ; base speed
db $32 ; base special
db DRAGON ; species type 1
db DRAGON ; species type 2
db 45 ; catch rate
db 67 ; base exp yield
INCBIN "pic/bmon/dratini.pic",0,1 ; 55, sprite dimensions
dw DratiniPicFront
dw DratiniPicBack
; attacks known at lvl 0
db WRAP
db LEER
db 0
db 0
db 5 ; growth rate
db AB_STRONG_SCALE	;ability 1
db AB_SWIMMER	;ability 2
db $32	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(DratiniPicFront) ; sprite bank