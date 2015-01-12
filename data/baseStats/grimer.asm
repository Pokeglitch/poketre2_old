GrimerBaseStats: ; 38d62 (e:4d62)
db DEX_GRIMER ; pokedex id
db 80 ; base hp
db 80 ; base attack
db 50 ; base defense
db 25 ; base speed
db $28 ; base special
db RADIO ; species type 1
db GOO ; species type 2
db 190 ; catch rate
db 90 ; base exp yield
INCBIN "pic/bmon/grimer.pic",0,1 ; 55, sprite dimensions
dw GrimerPicFront
dw GrimerPicBack
; attacks known at lvl 0
db POUND
db DISABLE
db 0
db 0
db 0 ; growth rate
db AB_STENCH	;ability 1
db 00	;ability 2
db $32	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(GrimerPicFront) ; sprite bank