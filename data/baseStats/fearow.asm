FearowBaseStats: ; 3862a (e:462a)
db DEX_FEAROW ; pokedex id
db 65 ; base hp
db 90 ; base attack
db 65 ; base defense
db 100 ; base speed
db $3D ; base special
db AERO ; species type 1
db TALON ; species type 2
db 90 ; catch rate
db 162 ; base exp yield
INCBIN "pic/bmon/fearow.pic",0,1 ; 77, sprite dimensions
dw FearowPicFront
dw FearowPicBack
; attacks known at lvl 0
db PECK
db GROWL
db LEER
db 0
db 0 ; growth rate
db AB_PREDATOR	;ability 1
db 00	;ability 2
db $3D	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(FearowPicFront) ; sprite bank