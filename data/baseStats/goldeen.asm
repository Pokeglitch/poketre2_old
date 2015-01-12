GoldeenBaseStats: ; 390aa (e:50aa)
db DEX_GOLDEEN ; pokedex id
db 45 ; base hp
db 67 ; base attack
db 60 ; base defense
db 63 ; base speed
db $23 ; base special
db WATER ; species type 1
db WATER ; species type 2
db 225 ; catch rate
db 111 ; base exp yield
INCBIN "pic/bmon/goldeen.pic",0,1 ; 66, sprite dimensions
dw GoldeenPicFront
dw GoldeenPicBack
; attacks known at lvl 0
db PECK
db TAIL_WHIP
db 0
db 0
db 0 ; growth rate
db AB_SWIMMER	;ability 1
db 00	;ability 2
db $32	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(GoldeenPicFront) ; sprite bank