CleffaBaseStats: ; 38aa6 (e:4aa6)
db DEX_CLEFFA ; pokedex id
db 50 ; base hp
db 25 ; base attack
db 28 ; base defense
db 15 ; base speed
db 45 ; base special attack
db MAGIC ; species type 1
db COSMIC ; species type 2
db 150 ; catch rate
db 37 ; base exp yield
INCBIN "pic/bmon/cleffa.pic",0,1 ; 55, sprite dimensions
dw CleffaPicFront
dw CleffaPicBack
; attacks known at lvl 0
db 0
db 0
db 0
db 0
db 4 ; growth rate
db AB_FLUFFY	;ability 1
db 00	;ability 2
db 55	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(CleffaPicFront) ; sprite bank
