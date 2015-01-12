TangelaBaseStats: ; 3903a (e:503a)
db DEX_TANGELA ; pokedex id
db 65 ; base hp
db 55 ; base attack
db 115 ; base defense
db 60 ; base speed
db $64 ; base special
db PLANT ; species type 1
db PLANT ; species type 2
db 45 ; catch rate
db 166 ; base exp yield
INCBIN "pic/bmon/tangela.pic",0,1 ; 66, sprite dimensions
dw TangelaPicFront
dw TangelaPicBack
; attacks known at lvl 0
db CONSTRICT
db BIND
db 0
db 0
db 0 ; growth rate
db AB_PHOTOSYNTHESIS	;ability 1
db 00	;ability 2
db $28	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(TangelaPicFront) ; sprite bank