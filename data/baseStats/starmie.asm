StarmieBaseStats: ; 390fe (e:50fe)
db DEX_STARMIE ; pokedex id
db 60 ; base hp
db 75 ; base attack
db 85 ; base defense
db 115 ; base speed
db $64 ; base special
db WATER ; species type 1
db COSMIC ; species type 2
db 60 ; catch rate
db 207 ; base exp yield
INCBIN "pic/bmon/starmie.pic",0,1 ; 66, sprite dimensions
dw StarmiePicFront
dw StarmiePicBack
; attacks known at lvl 0
db TACKLE
db WATER_GUN
db HARDEN
db 0
db 5 ; growth rate
db AB_REGENERATIVE	;ability 1
db 00	;ability 2
db $55	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(StarmiePicFront) ; sprite bank