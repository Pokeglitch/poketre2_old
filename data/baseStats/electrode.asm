ElectrodeBaseStats: ; 38ece (e:4ece)
db DEX_ELECTRODE ; pokedex id
db 60 ; base hp
db 50 ; base attack
db 70 ; base defense
db 140 ; base speed
db $50 ; base special
db ELECTRIC ; species type 1
db METAL ; species type 2
db 60 ; catch rate
db 150 ; base exp yield
INCBIN "pic/bmon/electrode.pic",0,1 ; 55, sprite dimensions
dw ElectrodePicFront
dw ElectrodePicBack
; attacks known at lvl 0
db TACKLE
db SCREECH
db SONICBOOM
db 0
db 0 ; growth rate
db AB_RECHARGE	;ability 1
db 00	;ability 2
db $50	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(ElectrodePicFront) ; sprite bank