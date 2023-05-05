WeezingBaseStats: ; 38fca (e:4fca)
db DEX_WEEZING ; pokedex id
db 65 ; base hp
db 90 ; base attack
db 120 ; base defense
db 60 ; base speed
db $55 ; base special
db POISON ; species type 1
db COSMIC ; species type 2
db 60 ; catch rate
db 173 ; base exp yield
INCBIN "pic/bmon/weezing.pic",0,1 ; 77, sprite dimensions
dw WeezingPicFront
dw WeezingPicBack
; attacks known at lvl 0
db TACKLE
db SMOG
db SLUDGE
db 0
db 0 ; growth rate
db AB_POISON_SKIN;ability 1
db 00	;ability 2
db $46	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(WeezingPicFront) ; sprite bank