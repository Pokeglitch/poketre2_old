ParasectBaseStats: ; 388e6 (e:48e6)
db DEX_PARASECT ; pokedex id
db 60 ; base hp
db 95 ; base attack
db 80 ; base defense
db 30 ; base speed
db $3C ; base special
db BUG ; species type 1
db PLANT ; species type 2
db 75 ; catch rate
db 128 ; base exp yield
INCBIN "pic/bmon/parasect.pic",0,1 ; 77, sprite dimensions
dw ParasectPicFront
dw ParasectPicBack
; attacks known at lvl 0
db SCRATCH
db STUN_SPORE
db LEECH_LIFE
db 0
db 0 ; growth rate
db AB_POISON_SKIN	;ability 1
db 00	;ability 2
db $50	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(ParasectPicFront) ; sprite bank