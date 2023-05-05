MoltresBaseStats: ; 393ba (e:53ba)
db DEX_MOLTRES ; pokedex id
db 90 ; base hp
db 100 ; base attack
db 90 ; base defense
db 90 ; base speed
db $7D ; base special
db AERO ; species type 1
db FIRE ; species type 2
db 3 ; catch rate
db 217 ; base exp yield
INCBIN "pic/bmon/moltres.pic",0,1 ; 77, sprite dimensions
dw MoltresPicFront
dw MoltresPicBack
; attacks known at lvl 0
db PECK
db FIRE_SPIN
db 0
db 0
db 5 ; growth rate
db AB_FIRE_STORM	;ability 1
db AB_FLAME_BODY	;ability 2
db $55	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(MoltresPicFront) ; sprite bank