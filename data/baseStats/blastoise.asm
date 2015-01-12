BlastoiseBaseStats: ; 384be (e:44be)
db DEX_BLASTOISE ; pokedex id
db 79 ; base hp
db 83 ; base attack
db 100 ; base defense
db 78 ; base speed
db $55 ; base special attack
db WATER ; species type 1
db WATER ; species type 2
db 45 ; catch rate
db 210 ; base exp yield
INCBIN "pic/bmon/blastoise.pic",0,1 ; 77, sprite dimensions
dw BlastoisePicFront
dw BlastoisePicBack
; attacks known at lvl 0
db TACKLE
db TAIL_WHIP
db BUBBLE
db WATER_GUN
db 3 ; growth rate
db AB_POROUS	;ability 1
db AB_TOUGH_SKIN	;ability 2
db $69	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(BlastoisePicFront) ; sprite bank