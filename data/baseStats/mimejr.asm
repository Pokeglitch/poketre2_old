MimeJrBaseStats: ; 38aa6 (e:4aa6)
db DEX_MIME_JR ; pokedex id
db 20 ; base hp
db 25 ; base attack
db 45 ; base defense
db 60 ; base speed
db 70 ; base special attack
db MAGIC ; species type 1
db MAGIC ; species type 2
db 145 ; catch rate
db 78 ; base exp yield
INCBIN "pic/bmon/mimejr.pic",0,1 ; 55, sprite dimensions
dw MimeJrPicFront
dw MimeJrPicBack
; attacks known at lvl 0
db 0
db 0
db 0
db 0
db 0 ; growth rate
db AB_INVISIBLE_WALL	;ability 1
db 00	;ability 2
db 90	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(MimeJrPicFront) ; sprite bank
