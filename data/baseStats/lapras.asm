LaprasBaseStats: ; 39216 (e:5216)
db DEX_LAPRAS ; pokedex id
db 130 ; base hp
db 85 ; base attack
db 80 ; base defense
db 60 ; base speed
db $55 ; base special
db WATER ; species type 1
db ICE ; species type 2
db 45 ; catch rate
db 219 ; base exp yield
INCBIN "pic/bmon/lapras.pic",0,1 ; 77, sprite dimensions
dw LaprasPicFront
dw LaprasPicBack
; attacks known at lvl 0
db WATER_GUN
db GROWL
db 0
db 0
db 5 ; growth rate
db AB_COLD_BLOODED	;ability 1
db 00	;ability 2
db $5F	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(LaprasPicFront) ; sprite bank