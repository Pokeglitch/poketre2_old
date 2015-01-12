MewtwoBaseStats: ; 3942a (e:542a)
db DEX_MEWTWO ; pokedex id
db 106 ; base hp
db 110 ; base attack
db 90 ; base defense
db 130 ; base speed
db $9A ; base special
db MIND ; species type 1
db RADIO ; species type 2
db 3 ; catch rate
db 220 ; base exp yield
INCBIN "pic/bmon/mewtwo.pic",0,1 ; 77, sprite dimensions
dw MewtwoPicFront
dw MewtwoPicBack
; attacks known at lvl 0
db CONFUSION
db DISABLE
db SWIFT
db PSYCHIC_M
db 5 ; growth rate
db AB_TELEPATHIC	;ability 1
db AB_SHARP_MIND	;ability 2
db $5A	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(MewtwoPicFront) ; sprite bank
