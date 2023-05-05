DoduoBaseStats: ; 38cf2 (e:4cf2)
db DEX_DODUO ; pokedex id
db 35 ; base hp
db 85 ; base attack
db 45 ; base defense
db 75 ; base speed
db $23 ; base special
db AERO ; species type 1
db AERO ; species type 2
db 190 ; catch rate
db 96 ; base exp yield
INCBIN "pic/bmon/doduo.pic",0,1 ; 55, sprite dimensions
dw DoduoPicFront
dw DoduoPicBack
; attacks known at lvl 0
db PECK
db 0
db 0
db 0
db 0 ; growth rate
db AB_EARLY_BIRD	;ability 1
db 00	;ability 2
db $23	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(DoduoPicFront) ; sprite bank