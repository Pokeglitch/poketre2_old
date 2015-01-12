JynxBaseStats: ; 39152 (e:5152)
db DEX_JYNX ; pokedex id
db 65 ; base hp
db 50 ; base attack
db 35 ; base defense
db 95 ; base speed
db $73 ; base special
db ICE ; species type 1
db MAGIC ; species type 2
db 45 ; catch rate
db 137 ; base exp yield
INCBIN "pic/bmon/jynx.pic",0,1 ; 66, sprite dimensions
dw JynxPicFront
dw JynxPicBack
; attacks known at lvl 0
db POUND
db LOVELY_KISS
db 0
db 0
db 0 ; growth rate
db AB_COLD_BLOODED	;ability 1
db 00	;ability 2
db $5F	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(JynxPicFront) ; sprite bank