BaseStats: ; 38aa6 (e:4aa6)
db DEX_ ; pokedex id
db  ; base hp
db  ; base attack
db  ; base defense
db  ; base speed
db  ; base special attack
db  ; species type 1
db  ; species type 2
db  ; catch rate
db  ; base exp yield
INCBIN "pic/bmon/.pic",0,1 ; 55, sprite dimensions
dw PicFront
dw PicBack
; attacks known at lvl 0
db 0
db 0
db 0
db 0
db  ; growth rate
db AB_	;ability 1
db 00	;ability 2
db 	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(PicFront) ; sprite bank
