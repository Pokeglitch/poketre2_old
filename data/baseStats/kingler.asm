KinglerBaseStats: ; 38e96 (e:4e96)
db DEX_KINGLER ; pokedex id
db 55 ; base hp
db 130 ; base attack
db 115 ; base defense
db 75 ; base speed
db $32 ; base special
db WATER ; species type 1
db WATER ; species type 2
db 60 ; catch rate
db 206 ; base exp yield
INCBIN "pic/bmon/kingler.pic",0,1 ; 77, sprite dimensions
dw KinglerPicFront
dw KinglerPicBack
; attacks known at lvl 0
db BUBBLE
db LEER
db VICEGRIP
db 0
db 0 ; growth rate
db AB_TOUGH_SKIN	;ability 1
db 00	;ability 2
db $32	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(KinglerPicFront) ; sprite bank