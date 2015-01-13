CharcoltBaseStats: ; 38aa6 (e:4aa6)
db DEX_CHARCOLT ; pokedex id
db $4E ; base hp
db $6E ; base attack
db $66 ; base defense
db $64 ; base speed
db $82 ; base special attack
db FIRE ; species type 1
db DRAGON ; species type 2
db $2D ; catch rate
db $D8 ; base exp yield
INCBIN "pic/bmon/charcolt.pic",0,1 ; 55, sprite dimensions
dw CharcoltPicFront
dw CharcoltPicBack
; attacks known at lvl 0
db 0
db 0
db 0
db 0
db 3 ; growth rate
db AB_FLYING_DRAGON	;ability 1
db AB_FLAME_BODY	;ability 2
db $73	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(CharcoltPicFront) ; sprite bank
