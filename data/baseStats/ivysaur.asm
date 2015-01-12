IvysaurBaseStats: ; 383fa (e:43fa)
db DEX_IVYSAUR ; pokedex id
db 60 ; base hp
db 62 ; base attack
db 63 ; base defense
db 60 ; base speed
db $50 ; base special
db PLANT ; species type 1
db POISON ; species type 2
db 45 ; catch rate
db 141 ; base exp yield
INCBIN "pic/bmon/ivysaur.pic",0,1 ; 66, sprite dimensions
dw IvysaurPicFront
dw IvysaurPicBack
; attacks known at lvl 0
db TACKLE
db GROWL
db LEECH_SEED
db 0
db 3 ; growth rate
db AB_PHOTOSYNTHESIS	;ability 1
db 00	;ability 2
db $50	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(IvysaurPicFront) ; sprite bank
