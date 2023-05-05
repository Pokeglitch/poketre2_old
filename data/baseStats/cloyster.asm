CloysterBaseStats: ; 38db6 (e:4db6)
db DEX_CLOYSTER ; pokedex id
db 50 ; base hp
db 95 ; base attack
db 180 ; base defense
db 70 ; base speed
db $55 ; base special
db WATER ; species type 1
db ICE ; species type 2
db 60 ; catch rate
db 203 ; base exp yield
INCBIN "pic/bmon/cloyster.pic",0,1 ; 77, sprite dimensions
dw CloysterPicFront
dw CloysterPicBack
; attacks known at lvl 0
db WITHDRAW
db SUPERSONIC
db CLAMP
db AURORA_BEAM
db 5 ; growth rate
db AB_TOUGH_SKIN	;ability 1
db 00	;ability 2
db $2D	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(CloysterPicFront) ; sprite bank