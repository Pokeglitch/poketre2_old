SnorlaxBaseStats: ; 39366 (e:5366)
db DEX_SNORLAX ; pokedex id
db 160 ; base hp
db 110 ; base attack
db 65 ; base defense
db 30 ; base speed
db $41 ; base special
db MIND ; species type 1
db MIND ; species type 2
db 25 ; catch rate
db 154 ; base exp yield
INCBIN "pic/bmon/snorlax.pic",0,1 ; 77, sprite dimensions
dw SnorlaxPicFront
dw SnorlaxPicBack
; attacks known at lvl 0
db HEADBUTT
db AMNESIA
db REST
db 0
db 5 ; growth rate
db AB_SLEEPWALK	;ability 1
db AB_FLUFFY	;ability 2
db $6E	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(SnorlaxPicFront) ; sprite bank