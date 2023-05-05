KoffingBaseStats: ; 38fae (e:4fae)
db DEX_KOFFING ; pokedex id
db 40 ; base hp
db 65 ; base attack
db 95 ; base defense
db 35 ; base speed
db $3C ; base special
db POISON ; species type 1
db COSMIC ; species type 2
db 190 ; catch rate
db 114 ; base exp yield
INCBIN "pic/bmon/koffing.pic",0,1 ; 66, sprite dimensions
dw KoffingPicFront
dw KoffingPicBack
; attacks known at lvl 0
db TACKLE
db SMOG
db 0
db 0
db 0 ; growth rate
db AB_POISON_SKIN	;ability 1
db 00	;ability 2
db $2D	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(KoffingPicFront) ; sprite bank