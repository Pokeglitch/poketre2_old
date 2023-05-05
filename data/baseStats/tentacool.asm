TentacoolBaseStats: ; 38ba2 (e:4ba2)
db DEX_TENTACOOL ; pokedex id
db 40 ; base hp
db 40 ; base attack
db 35 ; base defense
db 70 ; base speed
db $32 ; base special
db WATER ; species type 1
db POISON ; species type 2
db 190 ; catch rate
db 105 ; base exp yield
INCBIN "pic/bmon/tentacool.pic",0,1 ; 55, sprite dimensions
dw TentacoolPicFront
dw TentacoolPicBack
; attacks known at lvl 0
db ACID
db 0
db 0
db 0
db 5 ; growth rate
db AB_POROUS	;ability 1
db 00	;ability 2
db $64	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(TentacoolPicFront) ; sprite bank