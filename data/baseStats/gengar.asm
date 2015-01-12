GengarBaseStats: ; 38e0a (e:4e0a)
db DEX_GENGAR ; pokedex id
db 60 ; base hp
db 65 ; base attack
db 60 ; base defense
db 110 ; base speed
db $82 ; base special
db GHOST ; species type 1
db GOO ; species type 2
db 45 ; catch rate
db 190 ; base exp yield
INCBIN "pic/bmon/gengar.pic",0,1 ; 66, sprite dimensions
dw GengarPicFront
dw GengarPicBack
; attacks known at lvl 0
db LICK
db CONFUSE_RAY
db NIGHT_SHADE
db 0
db 3 ; growth rate
db AB_SEE_THROUGH	;ability 1
db 00	;ability 2
db $4B	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(GengarPicFront) ; sprite bank
