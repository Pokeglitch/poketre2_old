BeedrillBaseStats: ; 38566 (e:4566)
db DEX_BEEDRILL ; pokedex id
db 65 ; base hp
db 80 ; base attack
db 40 ; base defense
db 75 ; base speed
db $2D ; base special attack
db BUG ; species type 1
db POISON ; species type 2
db 45 ; catch rate
db 159 ; base exp yield
INCBIN "pic/bmon/beedrill.pic",0,1 ; 77, sprite dimensions
dw BeedrillPicFront
dw BeedrillPicBack
; attacks known at lvl 0
db FURY_ATTACK
db 0
db 0
db 0
db 0 ; growth rate
db AB_HEADPIECE	;ability 1
db 00	;ability 2
db $50 ;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(BeedrillPicFront) ; sprite bank
