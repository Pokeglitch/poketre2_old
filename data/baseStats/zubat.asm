ZubatBaseStats: ; 3883e (e:483e)
db DEX_ZUBAT ; pokedex id
db 40 ; base hp
db 45 ; base attack
db 35 ; base defense
db 55 ; base speed
db $1E ; base special
db SOUND ; species type 1
db AERO ; species type 2
db 255 ; catch rate
db 54 ; base exp yield
INCBIN "pic/bmon/zubat.pic",0,1 ; 55, sprite dimensions
dw ZubatPicFront
dw ZubatPicBack
; attacks known at lvl 0
db LEECH_LIFE
db 0
db 0
db 0
db 0 ; growth rate
db AB_VENOMOUS	;ability 1
db 00	;ability 2
db $28	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(ZubatPicFront) ; sprite bank