NidoranMBaseStats: ; 38742 (e:4742)
db DEX_NIDORAN_M ; pokedex id
db 46 ; base hp
db 57 ; base attack
db 40 ; base defense
db 50 ; base speed
db $28 ; base special
db POISON ; species type 1
db ICE ; species type 2
db 235 ; catch rate
db 60 ; base exp yield
INCBIN "pic/bmon/nidoranm.pic",0,1 ; 55, sprite dimensions
dw NidoranMPicFront
dw NidoranMPicBack
; attacks known at lvl 0
db LEER
db TACKLE
db 0
db 0
db 3 ; growth rate
db AB_HEADPIECE	;ability 1
db 00	;ability 2
db $28	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(NidoranMPicFront) ; sprite bank