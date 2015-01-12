NidokingBaseStats: ; 3877a (e:477a)
db DEX_NIDOKING ; pokedex id
db 81 ; base hp
db 92 ; base attack
db 77 ; base defense
db 85 ; base speed
db $55 ; base special
db POISON ; species type 1
db ICE ; species type 2
db 45 ; catch rate
db 195 ; base exp yield
INCBIN "pic/bmon/nidoking.pic",0,1 ; 77, sprite dimensions
dw NidokingPicFront
dw NidokingPicBack
; attacks known at lvl 0
db TACKLE
db HORN_ATTACK
db POISON_STING
db THRASH
db 3 ; growth rate
db AB_HEADPIECE	;ability 1
db 00	;ability 2
db $4B	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(NidokingPicFront) ; sprite bank