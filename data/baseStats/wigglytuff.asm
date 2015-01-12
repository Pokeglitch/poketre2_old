WigglytuffBaseStats: ; 38822 (e:4822)
db DEX_WIGGLYTUFF ; pokedex id
db 140 ; base hp
db 70 ; base attack
db 45 ; base defense
db 45 ; base speed
db $4B ; base special
db SOUND ; species type 1
db COSMIC ; species type 2
db 50 ; catch rate
db 109 ; base exp yield
INCBIN "pic/bmon/wigglytuff.pic",0,1 ; 66, sprite dimensions
dw WigglytuffPicFront
dw WigglytuffPicBack
; attacks known at lvl 0
db SING
db DISABLE
db DEFENSE_CURL
db DOUBLESLAP
db 4 ; growth rate
db AB_FLUFFY	;ability 1
db 00	;ability 2
db $32	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(WigglytuffPicFront) ; sprite bank