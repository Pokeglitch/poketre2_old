EkansBaseStats: ; 38646 (e:4646)
db DEX_EKANS ; pokedex id
db 35 ; base hp
db 60 ; base attack
db 44 ; base defense
db 55 ; base speed
db $30 ; base special
db POISON ; species type 1
db FANG ; species type 2
db 255 ; catch rate
db 62 ; base exp yield
INCBIN "pic/bmon/ekans.pic",0,1 ; 55, sprite dimensions
dw EkansPicFront
dw EkansPicBack
; attacks known at lvl 0
db WRAP
db LEER
db 0
db 0
db 0 ; growth rate
db AB_VENOMOUS	;ability 1
db 00	;ability 2
db $3E	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(EkansPicFront) ; sprite bank