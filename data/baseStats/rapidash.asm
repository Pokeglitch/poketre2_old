RapidashBaseStats: ; 38c4a (e:4c4a)
db DEX_RAPIDASH ; pokedex id
db 65 ; base hp
db 100 ; base attack
db 70 ; base defense
db 105 ; base speed
db $50 ; base special
db FIRE ; species type 1
db HOOF ; species type 2
db 60 ; catch rate
db 192 ; base exp yield
INCBIN "pic/bmon/rapidash.pic",0,1 ; 77, sprite dimensions
dw RapidashPicFront
dw RapidashPicBack
; attacks known at lvl 0
db EMBER
db TAIL_WHIP
db STOMP
db GROWL
db 0 ; growth rate
db AB_FLAME_BODY	;ability 1
db 00	;ability 2
db $50	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(RapidashPicFront) ; sprite bank