ZapdosBaseStats: ; 3939e (e:539e)
db DEX_ZAPDOS ; pokedex id
db 90 ; base hp
db 90 ; base attack
db 85 ; base defense
db 100 ; base speed
db $7D ; base special
db AERO ; species type 1
db ELECTRIC ; species type 2
db 3 ; catch rate
db 216 ; base exp yield
INCBIN "pic/bmon/zapdos.pic",0,1 ; 77, sprite dimensions
dw ZapdosPicFront
dw ZapdosPicBack
; attacks known at lvl 0
db THUNDERSHOCK
db DRILL_PECK
db 0
db 0
db 5 ; growth rate
db AB_THUNDER_STORM	;ability 1
db AB_RECHARGE	;ability 2
db $5A	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(ZapdosPicFront) ; sprite bank