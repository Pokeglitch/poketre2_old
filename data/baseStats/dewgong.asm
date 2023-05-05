DewgongBaseStats: ; 38d46 (e:4d46)
db DEX_DEWGONG ; pokedex id
db 90 ; base hp
db 70 ; base attack
db 80 ; base defense
db 70 ; base speed
db $46 ; base special
db WATER ; species type 1
db ICE ; species type 2
db 75 ; catch rate
db 176 ; base exp yield
INCBIN "pic/bmon/dewgong.pic",0,1 ; 66, sprite dimensions
dw DewgongPicFront
dw DewgongPicBack
; attacks known at lvl 0
db HEADBUTT
db GROWL
db AURORA_BEAM
db 0
db 0 ; growth rate
db AB_SWIMMER ;ability 1
db 00	;ability 2
db $5F	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(DewgongPicFront) ; sprite bank