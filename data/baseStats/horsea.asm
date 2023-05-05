HorseaBaseStats: ; 39072 (e:5072)
db DEX_HORSEA ; pokedex id
db 30 ; base hp
db 40 ; base attack
db 70 ; base defense
db 60 ; base speed
db $46 ; base special
db WATER ; species type 1
db WATER ; species type 2
db 225 ; catch rate
db 83 ; base exp yield
INCBIN "pic/bmon/horsea.pic",0,1 ; 55, sprite dimensions
dw HorseaPicFront
dw HorseaPicBack
; attacks known at lvl 0
db BUBBLE
db 0
db 0
db 0
db 0 ; growth rate
db AB_POROUS	;ability 1
db 00	;ability 2
db $19	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(HorseaPicFront) ; sprite bank