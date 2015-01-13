GolbatBaseStats: ; 3885a (e:485a)
db DEX_GOLBAT ; pokedex id
db 75 ; base hp
db 80 ; base attack
db 70 ; base defense
db 90 ; base speed
db $41 ; base special
db SOUND ; species type 1
db AERO ; species type 2
db 90 ; catch rate
db 171 ; base exp yield
INCBIN "pic/bmon/golbat.pic",0,1 ; 77, sprite dimensions
dw GolbatPicFront
dw GolbatPicBack
; attacks known at lvl 0
db LEECH_LIFE
db SCREECH
db BITE
db 0
db 0 ; growth rate
db AB_VENOMOUS	;ability 1
db 00	;ability 2
db $4B	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(GolbatPicFront) ; sprite bank