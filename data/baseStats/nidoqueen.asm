NidoqueenBaseStats: ; 38726 (e:4726)
db DEX_NIDOQUEEN ; pokedex id
db 90 ; base hp
db 82 ; base attack
db 87 ; base defense
db 76 ; base speed
db $4B ; base special
db POISON ; species type 1
db ICE ; species type 2
db 45 ; catch rate
db 194 ; base exp yield
INCBIN "pic/bmon/nidoqueen.pic",0,1 ; 77, sprite dimensions
dw NidoqueenPicFront
dw NidoqueenPicBack
; attacks known at lvl 0
db TACKLE
db SCRATCH
db TAIL_WHIP
db BODY_SLAM
db 3 ; growth rate
db AB_HEADPIECE	;ability 1
db 00	;ability 2
db $55	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(NidoqueenPicFront) ; sprite bank