TaurosBaseStats: ; 391c2 (e:51c2)
db DEX_TAUROS ; pokedex id
db 75 ; base hp
db 100 ; base attack
db 95 ; base defense
db 110 ; base speed
db $28 ; base special
db HOOF ; species type 1
db HOOF ; species type 2
db 45 ; catch rate
db 211 ; base exp yield
INCBIN "pic/bmon/tauros.pic",0,1 ; 77, sprite dimensions
dw TaurosPicFront
dw TaurosPicBack
; attacks known at lvl 0
db TACKLE
db 0
db 0
db 0
db 5 ; growth rate
db AB_HEADPIECE	;ability 1
db 00	;ability 2
db $46	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(TaurosPicFront) ; sprite bank
