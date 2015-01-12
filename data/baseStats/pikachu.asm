PikachuBaseStats: ; 3867e (e:467e)
db DEX_PIKACHU ; pokedex id
db 35 ; base hp
db 55 ; base attack
db 30 ; base defense
db 90 ; base speed
db $32 ; base special
db ELECTRIC ; species type 1
db ELECTRIC ; species type 2
db 190 ; catch rate
db 82 ; base exp yield
INCBIN "pic/bmon/pikachu.pic",0,1 ; 55, sprite dimensions
dw PikachuPicFront
dw PikachuPicBack
; attacks known at lvl 0
db THUNDERSHOCK
db GROWL
db 0
db 0
db 0 ; growth rate
db AB_RECHARGE	;ability 1
db 00	;ability 2
db $28	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(PikachuPicFront) ; sprite bank