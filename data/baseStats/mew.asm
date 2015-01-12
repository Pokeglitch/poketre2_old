MewBaseStats: ; 425b (1:425b)
db DEX_MEW ; pokedex id
db 100 ; base hp
db 100 ; base attack
db 100 ; base defense
db 100 ; base speed
db $64 ; base special
db MIND ; species type 1
db COSMIC ; species type 2
db 45 ; catch rate
db 64 ; base exp yield
INCBIN "pic/bmon/mew.pic",0,1 ; 55, sprite dimensions
dw MewPicFront
dw MewPicBack
; attacks known at lvl 0
db POUND
db 0
db 0
db 0
db 3 ; growth rate
db AB_INVISIBLE	;ability 1
db AB_REGENERATIVE	;ability 2
db $64	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(MewPicFront) ; sprite bank