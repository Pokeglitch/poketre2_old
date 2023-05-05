DodrioBaseStats: ; 38d0e (e:4d0e)
db DEX_DODRIO ; pokedex id
db 60 ; base hp
db 110 ; base attack
db 70 ; base defense
db 100 ; base speed
db $3C ; base special
db AERO ; species type 1
db TALON ; species type 2
db 45 ; catch rate
db 158 ; base exp yield
INCBIN "pic/bmon/dodrio.pic",0,1 ; 77, sprite dimensions
dw DodrioPicFront
dw DodrioPicBack
; attacks known at lvl 0
db PECK
db GROWL
db FURY_ATTACK
db 0
db 0 ; growth rate
db AB_EARLY_BIRD	;ability 1
db 00	;ability 2
db $3C	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(DodrioPicFront) ; sprite bank