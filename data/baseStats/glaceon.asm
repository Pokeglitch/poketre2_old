GlaceonBaseStats: ; 38aa6 (e:4aa6)
db DEX_GLACEON ; pokedex id
db 65 ; base hp
db 60 ; base attack
db 110 ; base defense
db 65 ; base speed
db 130 ; base special attack
db ICE ; species type 1
db TALON ; species type 2
db 45 ; catch rate
db 196 ; base exp yield
INCBIN "pic/bmon/glaceon.pic",0,1 ; 55, sprite dimensions
dw GlaceonPicFront
dw GlaceonPicBack
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
db BANK(GlaceonPicFront) ; sprite bank
