VileplumeBaseStats: ; 388ae (e:48ae)
db DEX_VILEPLUME ; pokedex id
db 75 ; base hp
db 80 ; base attack
db 85 ; base defense
db 50 ; base speed
db $64 ; base special
db PLANT ; species type 1
db POISON ; species type 2
db 45 ; catch rate
db 184 ; base exp yield
INCBIN "pic/bmon/vileplume.pic",0,1 ; 77, sprite dimensions
dw VileplumePicFront
dw VileplumePicBack
; attacks known at lvl 0
db STUN_SPORE
db SLEEP_POWDER
db ACID
db PETAL_DANCE
db 3 ; growth rate
db AB_PHOTOSYNTHESIS	;ability 1
db 00	;ability 2
db $5A	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(VileplumePicFront) ; sprite bank