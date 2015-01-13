UmbreonBaseStats: ; 38aa6 (e:4aa6)
db DEX_UMBREON ; pokedex id
db 95 ; base hp
db 65 ; base attack
db 110 ; base defense
db 65 ; base speed
db 60 ; base special attack
db COSMIC ; species type 1
db TALON ; species type 2
db 45 ; catch rate
db 197 ; base exp yield
INCBIN "pic/bmon/umbreon.pic",0,1 ; 55, sprite dimensions
dw UmbreonPicFront
dw UmbreonPicBack
; attacks known at lvl 0
db 0
db 0
db 0
db 0
db 0 ; growth rate
db AB_PREDATOR	;ability 1
db 00	;ability 2
db 130	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(UmbreonPicFront) ; sprite bank
