PoliwhirlBaseStats: ; 38a6e (e:4a6e)
db DEX_POLIWHIRL ; pokedex id
db 65 ; base hp
db 65 ; base attack
db 65 ; base defense
db 90 ; base speed
db $32 ; base special
db WATER ; species type 1
db WATER ; species type 2
db 120 ; catch rate
db 131 ; base exp yield
INCBIN "pic/bmon/poliwhirl.pic",0,1 ; 66, sprite dimensions
dw PoliwhirlPicFront
dw PoliwhirlPicBack
; attacks known at lvl 0
db BUBBLE
db HYPNOSIS
db WATER_GUN
db 0
db 3 ; growth rate
db AB_SWIMMER	;ability 1
db 00	;ability 2
db $32	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(PoliwhirlPicFront) ; sprite bank