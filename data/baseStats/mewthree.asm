MewthreeBaseStats: ; 38aa6 (e:4aa6)
db DEX_MEWTHREE ; pokedex id
db $6A ; base hp
db $80; base attack
db $6E ; base defense
db $82 ; base speed
db $AA ; base special attack
db MIND ; species type 1
db RADIO ; species type 2
db $03 ; catch rate
db $E8 ; base exp yield
INCBIN "pic/bmon/mewthree.pic",0,1 ; 55, sprite dimensions
dw MewthreePicFront
dw MewthreePicBack
; attacks known at lvl 0
db 0
db 0
db 0
db 0
db 5 ; growth rate
db AB_TELEPATHIC	;ability 1
db AB_SHARP_MIND	;ability 2
db $70	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(MewthreePicFront) ; sprite bank
