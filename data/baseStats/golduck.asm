GolduckBaseStats: ; 389c6 (e:49c6)
db DEX_GOLDUCK ; pokedex id
db 80 ; base hp
db 82 ; base attack
db 78 ; base defense
db 85 ; base speed
db $5F ; base special
db WATER ; species type 1
db AERO ; species type 2
db 75 ; catch rate
db 174 ; base exp yield
INCBIN "pic/bmon/golduck.pic",0,1 ; 77, sprite dimensions
dw GolduckPicFront
dw GolduckPicBack
; attacks known at lvl 0
db SCRATCH
db TAIL_WHIP
db DISABLE
db 0
db 0 ; growth rate
db AB_EARLY_BIRD	;ability 1
db 00	;ability 2
db $50	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(GolduckPicFront) ; sprite bank