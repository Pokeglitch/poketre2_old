ArticunoBaseStats: ; 39382 (e:5382)
db DEX_ARTICUNO ; pokedex id
db 90 ; base hp
db 85 ; base attack
db 100 ; base defense
db 85 ; base speed
db $5F ; base special
db AERO ; species type 1
db ICE ; species type 2
db 3 ; catch rate
db 215 ; base exp yield
INCBIN "pic/bmon/articuno.pic",0,1 ; 77, sprite dimensions
dw ArticunoPicFront
dw ArticunoPicBack
; attacks known at lvl 0
db PECK
db ICE_BEAM
db 0
db 0
db 5 ; growth rate
db AB_HAIL_STORM	;ability 1
db AB_COLD_BLOODED	;ability 2
db $7D	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(ArticunoPicFront) ; sprite bank