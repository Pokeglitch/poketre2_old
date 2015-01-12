ClefairyBaseStats: ; 38796 (e:4796)
db DEX_CLEFAIRY ; pokedex id
db 70 ; base hp
db 45 ; base attack
db 48 ; base defense
db 35 ; base speed
db $3C ; base special
db MAGIC ; species type 1
db COSMIC ; species type 2
db 150 ; catch rate
db 68 ; base exp yield
INCBIN "pic/bmon/clefairy.pic",0,1 ; 55, sprite dimensions
dw ClefairyPicFront
dw ClefairyPicBack
; attacks known at lvl 0
db POUND
db GROWL
db 0
db 0
db 4 ; growth rate
db AB_FLUFFY	;ability 1
db 00	;ability 2
db $41	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(ClefairyPicFront) ; sprite bank