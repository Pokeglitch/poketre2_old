MagnemiteBaseStats: ; 38c9e (e:4c9e)
db DEX_MAGNEMITE ; pokedex id
db 25 ; base hp
db 35 ; base attack
db 70 ; base defense
db 45 ; base speed
db $5F ; base special
db METAL ; species type 1
db RADIO ; species type 2
db 190 ; catch rate
db 89 ; base exp yield
INCBIN "pic/bmon/magnemite.pic",0,1 ; 55, sprite dimensions
dw MagnemitePicFront
dw MagnemitePicBack
; attacks known at lvl 0
db TACKLE
db 0
db 0
db 0
db 0 ; growth rate
db AB_RECHARGE	;ability 1
db 00	;ability 2
db $37	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(MagnemitePicFront) ; sprite bank