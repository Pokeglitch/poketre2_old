OmastarBaseStats: ; 392f6 (e:52f6)
db DEX_OMASTAR ; pokedex id
db 70 ; base hp
db 60 ; base attack
db 125 ; base defense
db 55 ; base speed
db $73 ; base special
db WATER ; species type 1
db GOO ; species type 2
db 45 ; catch rate
db 199 ; base exp yield
INCBIN "pic/bmon/omastar.pic",0,1 ; 66, sprite dimensions
dw OmastarPicFront
dw OmastarPicBack
; attacks known at lvl 0
db WATER_GUN
db WITHDRAW
db HORN_ATTACK
db 0
db 0 ; growth rate
db AB_TOUGH_SKIN	;ability 1
db 00	;ability 2
db $46	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(OmastarPicFront) ; sprite bank