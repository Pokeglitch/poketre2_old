GloomBaseStats: ; 38892 (e:4892)
db DEX_GLOOM ; pokedex id
db 60 ; base hp
db 65 ; base attack
db 70 ; base defense
db 40 ; base speed
db $55 ; base special
db PLANT ; species type 1
db POISON ; species type 2
db 120 ; catch rate
db 132 ; base exp yield
INCBIN "pic/bmon/gloom.pic",0,1 ; 66, sprite dimensions
dw GloomPicFront
dw GloomPicBack
; attacks known at lvl 0
db ABSORB
db POISONPOWDER
db STUN_SPORE
db 0
db 3 ; growth rate
db AB_PHOTOSYNTHESIS	;ability 1
db 00	;ability 2
db $4B	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(GloomPicFront) ; sprite bank