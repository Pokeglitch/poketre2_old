GrowlitheBaseStats: ; 38a1a (e:4a1a)
db DEX_GROWLITHE ; pokedex id
db 55 ; base hp
db 70 ; base attack
db 45 ; base defense
db 60 ; base speed
db $46 ; base special
db FIRE ; species type 1
db FANG ; species type 2
db 190 ; catch rate
db 91 ; base exp yield
INCBIN "pic/bmon/growlithe.pic",0,1 ; 55, sprite dimensions
dw GrowlithePicFront
dw GrowlithePicBack
; attacks known at lvl 0
db BITE
db ROAR
db 0
db 0
db 5 ; growth rate
db AB_FLUFFY	;ability 1
db 00	;ability 2
db $32	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(GrowlithePicFront) ; sprite bank