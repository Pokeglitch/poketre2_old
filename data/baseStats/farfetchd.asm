FarfetchdBaseStats: ; 38cd6 (e:4cd6)
db DEX_FARFETCH_D ; pokedex id
db 52 ; base hp
db 65 ; base attack
db 55 ; base defense
db 60 ; base speed
db $3A ; base special
db AERO ; species type 1
db AERO ; species type 2
db 45 ; catch rate
db 94 ; base exp yield
INCBIN "pic/bmon/farfetchd.pic",0,1 ; 66, sprite dimensions
dw FarfetchdPicFront
dw FarfetchdPicBack
; attacks known at lvl 0
db PECK
db SAND_ATTACK
db 0
db 0
db 0 ; growth rate
db AB_EARLY_BIRD	;ability 1
db 00	;ability 2
db $3E	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(FarfetchdPicFront) ; sprite bank