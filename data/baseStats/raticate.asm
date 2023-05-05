RaticateBaseStats: ; 385f2 (e:45f2)
db DEX_RATICATE ; pokedex id
db 55 ; base hp
db 81 ; base attack
db 60 ; base defense
db 97 ; base speed
db $32 ; base special
db FANG ; species type 1
db FANG ; species type 2
db 90 ; catch rate
db 116 ; base exp yield
INCBIN "pic/bmon/raticate.pic",0,1 ; 66, sprite dimensions
dw RaticatePicFront
dw RaticatePicBack
; attacks known at lvl 0
db TACKLE
db TAIL_WHIP
db QUICK_ATTACK
db 0
db 0 ; growth rate
db AB_FLUFFY	;ability 1
db 00	;ability 2
db $46	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(RaticatePicFront) ; sprite bank
