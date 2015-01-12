MrMimeBaseStats: ; 3911a (e:511a)
db DEX_MR_MIME ; pokedex id
db 40 ; base hp
db 45 ; base attack
db 65 ; base defense
db 90 ; base speed
db $64 ; base special
db MAGIC ; species type 1
db MAGIC ; species type 2
db 45 ; catch rate
db 136 ; base exp yield
INCBIN "pic/bmon/mr.mime.pic",0,1 ; 66, sprite dimensions
dw MrMimePicFront
dw MrMimePicBack
; attacks known at lvl 0
db CONFUSION
db BARRIER
db 0
db 0
db 0 ; growth rate
db AB_INVISIBLE_WALL	;ability 1
db 00	;ability 2
db $78	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(MrMimePicFront) ; sprite bank