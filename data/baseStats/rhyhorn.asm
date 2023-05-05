RhyhornBaseStats: ; 38fe6 (e:4fe6)
db DEX_RHYHORN ; pokedex id
db 80 ; base hp
db 85 ; base attack
db 95 ; base defense
db 25 ; base speed
db $1E ; base special
db EARTH ; species type 1
db HOOF ; species type 2
db 120 ; catch rate
db 135 ; base exp yield
INCBIN "pic/bmon/rhyhorn.pic",0,1 ; 77, sprite dimensions
dw RhyhornPicFront
dw RhyhornPicBack
; attacks known at lvl 0
db HORN_ATTACK
db 0
db 0
db 0
db 5 ; growth rate
db AB_TOUGH_SKIN	;ability 1
db 00	;ability 2
db $1E	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(RhyhornPicFront) ; sprite bank
