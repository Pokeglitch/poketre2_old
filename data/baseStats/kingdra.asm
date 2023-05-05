KingdraBaseStats: ; 38aa6 (e:4aa6)
db DEX_KINGDRA ; pokedex id
db 75 ; base hp
db 95 ; base attack
db 95 ; base defense
db 85 ; base speed
db 95 ; base special attack
db WATER ; species type 1
db DRAGON ; species type 2
db 45 ; catch rate
db 207 ; base exp yield
INCBIN "pic/bmon/kingdra.pic",0,1 ; 55, sprite dimensions
dw KingdraPicFront
dw KingdraPicBack
; attacks known at lvl 0
db 0
db 0
db 0
db 0
db 0 ; growth rate
db AB_POROUS	;ability 1
db 00	;ability 2
db 95	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(KingdraPicFront) ; sprite bank
