ObsideonBaseStats: ; 38aa6 (e:4aa6)
db DEX_OBSIDEON ; pokedex id
db $37 ; base hp
db $60 ; base attack
db $5A ; base defense
db $37 ; base speed
db $60 ; base special attack
db TALON ; species type 1
db TALON ; species type 2
db $2D ; catch rate
db $A0 ; base exp yield
INCBIN "pic/bmon/obsideon.pic",0,1 ; 55, sprite dimensions
dw ObsideonPicFront
dw ObsideonPicBack
; attacks known at lvl 0
db 0
db 0
db 0
db 0
db 0 ; growth rate
db AB_PREDATOR	;ability 1
db AB_FLUFFY	;ability 2
db $70	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(ObsideonPicFront) ; sprite bank
