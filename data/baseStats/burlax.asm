BurlaxBaseStats: ; 38aa6 (e:4aa6)
db DEX_BURLAX ; pokedex id
db $A0 ; base hp
db $82 ; base attack
db $55 ; base defense
db $1E ; base speed
db $60 ; base special attack
db MIND ; species type 1
db MIND ; species type 2
db $19 ; catch rate
db $C8 ; base exp yield
INCBIN "pic/bmon/burlax.pic",0,1 ; 55, sprite dimensions
dw BurlaxPicFront
dw BurlaxPicBack
; attacks known at lvl 0
db 0
db 0
db 0
db 0
db 5 ; growth rate
db AB_SLEEPWALK	;ability 1
db AB_FLUFFY	;ability 2
db $80	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(BurlaxPicFront) ; sprite bank
