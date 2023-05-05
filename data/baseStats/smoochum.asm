SmoochumBaseStats: ; 38aa6 (e:4aa6)
db DEX_SMOOCHUM ; pokedex id
db 45 ; base hp
db 30 ; base attack
db 15 ; base defense
db 65 ; base speed
db 85 ; base special attack
db ICE ; species type 1
db MAGIC ; species type 2
db 45 ; catch rate
db 87 ; base exp yield
INCBIN "pic/bmon/smoochum.pic",0,1 ; 55, sprite dimensions
dw SmoochumPicFront
dw SmoochumPicBack
; attacks known at lvl 0
db 0
db 0
db 0
db 0
db 0 ; growth rate
db AB_COLD_BLOODED	;ability 1
db 00	;ability 2
db 65	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(SmoochumPicFront) ; sprite bank
