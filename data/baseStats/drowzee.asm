DrowzeeBaseStats: ; 38e42 (e:4e42)
db DEX_DROWZEE ; pokedex id
db 60 ; base hp
db 48 ; base attack
db 45 ; base defense
db 42 ; base speed
db $2B ; base special
db MIND ; species type 1
db MAGIC ; species type 2
db 190 ; catch rate
db 102 ; base exp yield
INCBIN "pic/bmon/drowzee.pic",0,1 ; 66, sprite dimensions
dw DrowzeePicFront
dw DrowzeePicBack
; attacks known at lvl 0
db POUND
db HYPNOSIS
db 0
db 0
db 0 ; growth rate
db AB_FLUFFY	;ability 1
db 00	;ability 2
db $5A	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(DrowzeePicFront) ; sprite bank