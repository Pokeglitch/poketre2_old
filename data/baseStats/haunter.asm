HaunterBaseStats: ; 38dee (e:4dee)
db DEX_HAUNTER ; pokedex id
db 45 ; base hp
db 50 ; base attack
db 45 ; base defense
db 95 ; base speed
db $73 ; base special
db GHOST ; species type 1
db GOO ; species type 2
db 90 ; catch rate
db 126 ; base exp yield
INCBIN "pic/bmon/haunter.pic",0,1 ; 66, sprite dimensions
dw HaunterPicFront
dw HaunterPicBack
; attacks known at lvl 0
db LICK
db CONFUSE_RAY
db NIGHT_SHADE
db 0
db 3 ; growth rate
db AB_SEE_THROUGH	;ability 1
db 00	;ability 2
db $37	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(HaunterPicFront) ; sprite bank
