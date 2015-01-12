NidorinoBaseStats: ; 3875e (e:475e)
db DEX_NIDORINO ; pokedex id
db 61 ; base hp
db 72 ; base attack
db 57 ; base defense
db 65 ; base speed
db $37 ; base special
db POISON ; species type 1
db ICE ; species type 2
db 120 ; catch rate
db 118 ; base exp yield
INCBIN "pic/bmon/nidorino.pic",0,1 ; 66, sprite dimensions
dw NidorinoPicFront
dw NidorinoPicBack
; attacks known at lvl 0
db LEER
db TACKLE
db HORN_ATTACK
db 0
db 3 ; growth rate
db AB_HEADPIECE	;ability 1
db 00	;ability 2
db $37	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(NidorinoPicFront) ; sprite bank