NidorinaBaseStats: ; 3870a (e:470a)
db DEX_NIDORINA ; pokedex id
db 70 ; base hp
db 62 ; base attack
db 67 ; base defense
db 56 ; base speed
db $37 ; base special
db POISON ; species type 1
db ICE ; species type 2
db 120 ; catch rate
db 117 ; base exp yield
INCBIN "pic/bmon/nidorina.pic",0,1 ; 66, sprite dimensions
dw NidorinaPicFront
dw NidorinaPicBack
; attacks known at lvl 0
db GROWL
db TACKLE
db SCRATCH
db 0
db 3 ; growth rate
db AB_HEADPIECE	;ability 1
db 00	;ability 2
db $37	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(NidorinaPicFront) ; sprite bank