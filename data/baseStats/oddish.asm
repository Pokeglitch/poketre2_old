OddishBaseStats: ; 38876 (e:4876)
db DEX_ODDISH ; pokedex id
db 45 ; base hp
db 50 ; base attack
db 55 ; base defense
db 30 ; base speed
db $4B ; base special
db PLANT ; species type 1
db POISON ; species type 2
db 255 ; catch rate
db 78 ; base exp yield
INCBIN "pic/bmon/oddish.pic",0,1 ; 55, sprite dimensions
dw OddishPicFront
dw OddishPicBack
; attacks known at lvl 0
db ABSORB
db 0
db 0
db 0
db 3 ; growth rate
db AB_PHOTOSYNTHESIS	;ability 1
db 00	;ability 2
db $41	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(OddishPicFront) ; sprite bank
