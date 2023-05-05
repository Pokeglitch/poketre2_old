ExeggcuteBaseStats: ; 38eea (e:4eea)
db DEX_EXEGGCUTE ; pokedex id
db 60 ; base hp
db 40 ; base attack
db 80 ; base defense
db 40 ; base speed
db $3C ; base special
db PLANT ; species type 1
db MIND ; species type 2
db 90 ; catch rate
db 98 ; base exp yield
INCBIN "pic/bmon/exeggcute.pic",0,1 ; 77, sprite dimensions
dw ExeggcutePicFront
dw ExeggcutePicBack
; attacks known at lvl 0
db BARRAGE
db HYPNOSIS
db 0
db 0
db 5 ; growth rate
db AB_PHOTOSYNTHESIS	;ability 1
db 00	;ability 2
db $2D	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(ExeggcutePicFront) ; sprite bank