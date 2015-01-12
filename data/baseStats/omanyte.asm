OmanyteBaseStats: ; 392da (e:52da)
db DEX_OMANYTE ; pokedex id
db 35 ; base hp
db 40 ; base attack
db 100 ; base defense
db 35 ; base speed
db $5A ; base special
db WATER ; species type 1
db GOO ; species type 2
db 45 ; catch rate
db 120 ; base exp yield
INCBIN "pic/bmon/omanyte.pic",0,1 ; 55, sprite dimensions
dw OmanytePicFront
dw OmanytePicBack
; attacks known at lvl 0
db WATER_GUN
db WITHDRAW
db 0
db 0
db 0 ; growth rate
db AB_TOUGH_SKIN	;ability 1
db 00	;ability 2
db $37	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(OmanytePicFront) ; sprite bank
