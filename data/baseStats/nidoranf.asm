NidoranFBaseStats: ; 386ee (e:46ee)
db DEX_NIDORAN_F ; pokedex id
db 55 ; base hp
db 47 ; base attack
db 52 ; base defense
db 41 ; base speed
db $28 ; base special
db POISON ; species type 1
db ICE ; species type 2
db 235 ; catch rate
db 59 ; base exp yield
INCBIN "pic/bmon/nidoranf.pic",0,1 ; 55, sprite dimensions
dw NidoranFPicFront
dw NidoranFPicBack
; attacks known at lvl 0
db GROWL
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
db BANK(NidoranFPicFront) ; sprite bank