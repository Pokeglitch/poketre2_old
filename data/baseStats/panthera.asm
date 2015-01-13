PantheraBaseStats: ; 38aa6 (e:4aa6)
db DEX_PANTHERA ; pokedex id
db $49 ; base hp
db $68 ; base attack
db $60 ; base defense
db $7B ; base speed
db $68 ; base special attack
db TALON ; species type 1
db FANG ; species type 2
db $5A ; catch rate
db $A8 ; base exp yield
INCBIN "pic/bmon/panthera.pic",0,1 ; 55, sprite dimensions
dw PantheraPicFront
dw PantheraPicBack
; attacks known at lvl 0
db 0
db 0
db 0
db 0
db 0 ; growth rate
db AB_PICKPOCKET	;ability 1
db AB_FLUFFY	;ability 2
db $68	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(PantheraPicFront) ; sprite bank
