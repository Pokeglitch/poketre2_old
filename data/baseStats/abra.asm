AbraBaseStats: ; 38aa6 (e:4aa6)
db DEX_ABRA ; pokedex id
db 25 ; base hp
db 20 ; base attack
db 15 ; base defense
db 90 ; base speed
db $69 ; base special attack
db MIND ; species type 1
db MAGIC ; species type 2
db 200 ; catch rate
db 73 ; base exp yield
INCBIN "pic/bmon/abra.pic",0,1 ; 55, sprite dimensions
dw AbraPicFront
dw AbraPicBack
; attacks known at lvl 0
db TELEPORT
db 0
db 0
db 0
db 3 ; growth rate
db AB_INSOMNIA	;ability 1
db 00	;ability 2
db $37	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(AbraPicFront) ; sprite bank
