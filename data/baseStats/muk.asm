MukBaseStats: ; 38d7e (e:4d7e)
db DEX_MUK ; pokedex id
db 105 ; base hp
db 105 ; base attack
db 75 ; base defense
db 50 ; base speed
db $41 ; base special
db RADIO ; species type 1
db GOO ; species type 2
db 75 ; catch rate
db 157 ; base exp yield
INCBIN "pic/bmon/muk.pic",0,1 ; 77, sprite dimensions
dw MukPicFront
dw MukPicBack
; attacks known at lvl 0
db POUND
db DISABLE
db POISON_GAS
db 0
db 0 ; growth rate
db AB_STENCH	;ability 1
db 00	;ability 2
db $64	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(MukPicFront) ; sprite bank