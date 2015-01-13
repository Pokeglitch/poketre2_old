TrifernoBaseStats: ; 38aa6 (e:4aa6)
db DEX_TRIFERNO ; pokedex id
db $5A ; base hp
db $78 ; base attack
db $70 ; base defense
db $5A ; base speed
db $90 ; base special attack
db AERO ; species type 1
db FIRE ; species type 2
db $03 ; catch rate
db $DD ; base exp yield
INCBIN "pic/bmon/triferno.pic",0,1 ; 55, sprite dimensions
dw TrifernoPicFront
dw TrifernoPicBack
; attacks known at lvl 0
db 0
db 0
db 0
db 0
db 5 ; growth rate
db AB_FLAME_BODY	;ability 1
db AB_FIRE_STORM	;ability 2
db $68	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(TrifernoPicFront) ; sprite bank
