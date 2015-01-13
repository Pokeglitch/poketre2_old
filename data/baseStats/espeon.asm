EspeonBaseStats: ; 38aa6 (e:4aa6)
db DEX_ESPEON ; pokedex id
db 65 ; base hp
db 65 ; base attack
db 60 ; base defense
db 110 ; base speed
db 130 ; base special attack
db MIND ; species type 1
db TALON ; species type 2
db 45 ; catch rate
db 197 ; base exp yield
INCBIN "pic/bmon/espeon.pic",0,1 ; 55, sprite dimensions
dw EspeonPicFront
dw EspeonPicBack
; attacks known at lvl 0
db 0
db 0
db 0
db 0
db 0 ; growth rate
db AB_PREDATOR	;ability 1
db 00	;ability 2
db 95	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(EspeonPicFront) ; sprite bank
