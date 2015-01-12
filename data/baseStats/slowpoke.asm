SlowpokeBaseStats: ; 38c66 (e:4c66)
db DEX_SLOWPOKE ; pokedex id
db 90 ; base hp
db 65 ; base attack
db 65 ; base defense
db 15 ; base speed
db $28 ; base special
db WATER ; species type 1
db MIND ; species type 2
db 190 ; catch rate
db 99 ; base exp yield
INCBIN "pic/bmon/slowpoke.pic",0,1 ; 55, sprite dimensions
dw SlowpokePicFront
dw SlowpokePicBack
; attacks known at lvl 0
db CONFUSION
db 0
db 0
db 0
db 0 ; growth rate
db AB_INSOMNIA	;ability 1
db 00	;ability 2
db $28	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(SlowpokePicFront) ; sprite bank