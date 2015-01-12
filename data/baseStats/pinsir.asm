PinsirBaseStats: ; 391a6 (e:51a6)
db DEX_PINSIR ; pokedex id
db 65 ; base hp
db 125 ; base attack
db 100 ; base defense
db 85 ; base speed
db $37 ; base special
db BUG ; species type 1
db FANG ; species type 2
db 45 ; catch rate
db 200 ; base exp yield
INCBIN "pic/bmon/pinsir.pic",0,1 ; 77, sprite dimensions
dw PinsirPicFront
dw PinsirPicBack
; attacks known at lvl 0
db VICEGRIP
db 0
db 0
db 0
db 5 ; growth rate
db AB_HEADPIECE	;ability 1
db 00	;ability 2
db $46	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(PinsirPicFront) ; sprite bank