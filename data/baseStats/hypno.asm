HypnoBaseStats: ; 38e5e (e:4e5e)
db DEX_HYPNO ; pokedex id
db 85 ; base hp
db 73 ; base attack
db 70 ; base defense
db 67 ; base speed
db $49 ; base special
db MIND ; species type 1
db MAGIC ; species type 2
db 75 ; catch rate
db 165 ; base exp yield
INCBIN "pic/bmon/hypno.pic",0,1 ; 77, sprite dimensions
dw HypnoPicFront
dw HypnoPicBack
; attacks known at lvl 0
db POUND
db HYPNOSIS
db DISABLE
db CONFUSION
db 0 ; growth rate
db AB_FLUFFY	;ability 1
db 00	;ability 2
db $73	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(HypnoPicFront) ; sprite bank