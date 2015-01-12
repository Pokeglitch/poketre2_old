VictreebelBaseStats: ; 38b86 (e:4b86)
db DEX_VICTREEBEL	 ; pokedex id
db 80 ; base hp
db 105 ; base attack
db 65 ; base defense
db 70 ; base speed
db $64 ; base special
db PLANT ; species type 1
db POISON ; species type 2
db 45 ; catch rate
db 191 ; base exp yield
INCBIN "pic/bmon/victreebel.pic",0,1 ; 77, sprite dimensions
dw VictreebelPicFront
dw VictreebelPicBack
; attacks known at lvl 0
db SLEEP_POWDER
db STUN_SPORE
db ACID
db RAZOR_LEAF
db 3 ; growth rate
db AB_PHOTOSYNTHESIS	;ability 1
db 00	;ability 2
db $3C	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(VictreebelPicFront) ; sprite bank
