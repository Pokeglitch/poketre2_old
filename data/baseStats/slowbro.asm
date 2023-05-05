SlowbroBaseStats: ; 38c82 (e:4c82)
db DEX_SLOWBRO ; pokedex id
db 95 ; base hp
db 75 ; base attack
db 110 ; base defense
db 30 ; base speed
db $64 ; base special
db WATER ; species type 1
db MIND ; species type 2
db 75 ; catch rate
db 164 ; base exp yield
INCBIN "pic/bmon/slowbro.pic",0,1 ; 77, sprite dimensions
dw SlowbroPicFront
dw SlowbroPicBack
; attacks known at lvl 0
db CONFUSION
db DISABLE
db HEADBUTT
db 0
db 0 ; growth rate
db AB_INSOMNIA	;ability 1
db 00	;ability 2
db $50	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(SlowbroPicFront) ; sprite bank