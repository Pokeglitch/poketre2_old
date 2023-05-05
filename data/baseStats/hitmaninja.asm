HitmaninjaBaseStats: ; 38aa6 (e:4aa6)
db DEX_HITMANINJA ; pokedex id
db $23 ; base hp
db $64 ; base attack
db $64 ; base defense
db $64 ; base speed
db $64 ; base special attack
db FIGHTING ; species type 1
db FIGHTING ; species type 2
db $4B ; catch rate
db $80 ; base exp yield
INCBIN "pic/bmon/hitmaninja.pic",0,1 ; 55, sprite dimensions
dw HitmaninjaPicFront
dw HitmaninjaPicBack
; attacks known at lvl 0
db 0
db 0
db 0
db 0
db 0 ; growth rate
db AB_ILL_TEMPERED	;ability 1
db AB_NOCTURNAL	;ability 2
db $64	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(HitmaninjaPicFront) ; sprite bank
