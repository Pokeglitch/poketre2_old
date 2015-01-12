PonytaBaseStats: ; 38c2e (e:4c2e)
db DEX_PONYTA ; pokedex id
db 50 ; base hp
db 85 ; base attack
db 55 ; base defense
db 90 ; base speed
db $41 ; base special
db FIRE ; species type 1
db HOOF ; species type 2
db 190 ; catch rate
db 152 ; base exp yield
INCBIN "pic/bmon/ponyta.pic",0,1 ; 66, sprite dimensions
dw PonytaPicFront
dw PonytaPicBack
; attacks known at lvl 0
db EMBER
db 0
db 0
db 0
db 0 ; growth rate
db AB_FLAME_BODY	;ability 1
db 00	;ability 2
db $41	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(PonytaPicFront) ; sprite bank
