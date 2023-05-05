PichuBaseStats: ; 38aa6 (e:4aa6)
db DEX_PICHU ; pokedex id
db 20 ; base hp
db 40 ; base attack
db 15 ; base defense
db 60 ; base speed
db 35 ; base special attack
db ELECTRIC ; species type 1
db ELECTRIC ; species type 2
db 190 ; catch rate
db 42 ; base exp yield
INCBIN "pic/bmon/pichu.pic",0,1 ; 55, sprite dimensions
dw PichuPicFront
dw PichuPicBack
; attacks known at lvl 0
db 0
db 0
db 0
db 0
db 0 ; growth rate
db AB_RECHARGE	;ability 1
db 00	;ability 2
db 35	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(PichuPicFront) ; sprite bank
