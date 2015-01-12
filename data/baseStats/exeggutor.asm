ExeggutorBaseStats: ; 38f06 (e:4f06)
db DEX_EXEGGUTOR ; pokedex id
db 95 ; base hp
db 95 ; base attack
db 85 ; base defense
db 55 ; base speed
db $7D ; base special
db PLANT ; species type 1
db MIND ; species type 2
db 45 ; catch rate
db 212 ; base exp yield
INCBIN "pic/bmon/exeggutor.pic",0,1 ; 77, sprite dimensions
dw ExeggutorPicFront
dw ExeggutorPicBack
; attacks known at lvl 0
db BARRAGE
db HYPNOSIS
db 0
db 0
db 5 ; growth rate
db AB_PHOTOSYNTHESIS	;ability 1
db 00	;ability 2
db $41	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(ExeggutorPicFront) ; sprite bank