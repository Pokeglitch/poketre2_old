HitmonchanBaseStats: ; 38f76 (e:4f76)
db DEX_HITMONCHAN ; pokedex id
db 50 ; base hp
db 105 ; base attack
db 79 ; base defense
db 76 ; base speed
db $23 ; base special
db FIGHTING ; species type 1
db FIGHTING ; species type 2
db 45 ; catch rate
db 140 ; base exp yield
INCBIN "pic/bmon/hitmonchan.pic",0,1 ; 66, sprite dimensions
dw HitmonchanPicFront
dw HitmonchanPicBack
; attacks known at lvl 0
db COMET_PUNCH
db AGILITY
db 0
db 0
db 0 ; growth rate
db AB_ILL_TEMPERED	;ability 1
db 00	;ability 2
db $6E	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(HitmonchanPicFront) ; sprite bank