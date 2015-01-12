VenonatBaseStats: ; 38902 (e:4902)
db DEX_VENONAT ; pokedex id
db 60 ; base hp
db 55 ; base attack
db 50 ; base defense
db 45 ; base speed
db $28 ; base special
db BUG ; species type 1
db POISON ; species type 2
db 190 ; catch rate
db 75 ; base exp yield
INCBIN "pic/bmon/venonat.pic",0,1 ; 55, sprite dimensions
dw VenonatPicFront
dw VenonatPicBack
; attacks known at lvl 0
db TACKLE
db DISABLE
db 0
db 0
db 0 ; growth rate
db AB_NOCTURNAL	;ability 1
db 00	;ability 2
db $37	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(VenonatPicFront) ; sprite bank