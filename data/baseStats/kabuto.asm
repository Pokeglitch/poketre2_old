KabutoBaseStats: ; 39312 (e:5312)
db DEX_KABUTO ; pokedex id
db 30 ; base hp
db 80 ; base attack
db 90 ; base defense
db 55 ; base speed
db $37 ; base special
db WATER ; species type 1
db WATER ; species type 2
db 45 ; catch rate
db 119 ; base exp yield
INCBIN "pic/bmon/kabuto.pic",0,1 ; 55, sprite dimensions
dw KabutoPicFront
dw KabutoPicBack
; attacks known at lvl 0
db SCRATCH
db HARDEN
db 0
db 0
db 0 ; growth rate
db AB_TOUGH_SKIN	;ability 1
db 00	;ability 2
db $2D	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(KabutoPicFront) ; sprite bank