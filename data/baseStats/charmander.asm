CharmanderBaseStats: ; 38432 (e:4432)
db DEX_CHARMANDER ; pokedex id
db 39 ; base hp
db 52 ; base attack
db 43 ; base defense
db 65 ; base speed
db $3C ; base special attack
db FIRE ; species type 1
db FIRE ; species type 2
db 45 ; catch rate
db 65 ; base exp yield
INCBIN "pic/bmon/charmander.pic",0,1 ; 55, sprite dimensions
dw CharmanderPicFront
dw CharmanderPicBack
; attacks known at lvl 0
db SCRATCH
db GROWL
db 0
db 0
db 3 ; growth rate
db AB_FLAME_BODY	;ability 1
db 00	;ability 2
db $32	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(CharmanderPicFront) ; sprite bank
