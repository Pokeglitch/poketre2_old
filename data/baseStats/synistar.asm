SynistarBaseStats: ; 38aa6 (e:4aa6)
db DEX_SYNISTAR ; pokedex id
db $5A ; base hp
db $74 ; base attack
db $64 ; base defense
db $60 ; base speed
db $88 ; base special attack
db GHOST ; species type 1
db GHOST ; species type 2
db $19 ; catch rate
db $C8 ; base exp yield
INCBIN "pic/bmon/synistar.pic",0,1 ; 55, sprite dimensions
dw SynistarPicFront
dw SynistarPicBack
; attacks known at lvl 0
db 0
db 0
db 0
db 0
db 5 ; growth rate
db AB_CURSED_BODY	;ability 1
db AB_SEE_THROUGH	;ability 2
db $84	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(SynistarPicFront) ; sprite bank
