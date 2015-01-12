MachopBaseStats: ; 38afa (e:4afa)
db DEX_MACHOP ; pokedex id
db 70 ; base hp
db 80 ; base attack
db 50 ; base defense
db 35 ; base speed
db $23 ; base special
db FIGHTING ; species type 1
db FIGHTING ; species type 2
db 180 ; catch rate
db 88 ; base exp yield
INCBIN "pic/bmon/machop.pic",0,1 ; 55, sprite dimensions
dw MachopPicFront
dw MachopPicBack
; attacks known at lvl 0
db KARATE_CHOP
db 0
db 0
db 0
db 3 ; growth rate
db AB_ILL_TEMPERED	;ability 1
db 00	;ability 2
db $23	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(MachopPicFront) ; sprite bank