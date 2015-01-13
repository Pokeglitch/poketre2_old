SkebutopsBaseStats: ; 38aa6 (e:4aa6)
db DEX_SKEBUTOPS ; pokedex id
db $3C ; base hp
db $88 ; base attack
db $7C ; base defense
db $50 ; base speed
db $55 ; base special attack
db BONE ; species type 1
db TALON ; species type 2
db $2D ; catch rate
db $D0 ; base exp yield
INCBIN "pic/bmon/skebutops.pic",0,1 ; 55, sprite dimensions
dw SkebutopsPicFront
dw SkebutopsPicBack
; attacks known at lvl 0
db 0
db 0
db 0
db 0
db 0 ; growth rate
db AB_SLICER	;ability 1
db AB_TOUGH_SKIN	;ability 2
db $5A	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(SkebutopsPicFront) ; sprite bank
