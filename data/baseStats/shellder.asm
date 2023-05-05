ShellderBaseStats: ; 38d9a (e:4d9a)
db DEX_SHELLDER ; pokedex id
db 30 ; base hp
db 65 ; base attack
db 100 ; base defense
db 40 ; base speed
db $2D ; base special
db WATER ; species type 1
db WATER ; species type 2
db 190 ; catch rate
db 97 ; base exp yield
INCBIN "pic/bmon/shellder.pic",0,1 ; 55, sprite dimensions
dw ShellderPicFront
dw ShellderPicBack
; attacks known at lvl 0
db TACKLE
db WITHDRAW
db 0
db 0
db 5 ; growth rate
db AB_TOUGH_SKIN	;ability 1
db 00	;ability 2
db $19	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(ShellderPicFront) ; sprite bank