KangaskhanBaseStats: ; 39056 (e:5056)
db DEX_KANGASKHAN ; pokedex id
db 105 ; base hp
db 95 ; base attack
db 80 ; base defense
db 90 ; base speed
db $28 ; base special
db EARTH ; species type 1
db EARTH ; species type 2
db 45 ; catch rate
db 175 ; base exp yield
INCBIN "pic/bmon/kangaskhan.pic",0,1 ; 77, sprite dimensions
dw KangaskhanPicFront
dw KangaskhanPicBack
; attacks known at lvl 0
db COMET_PUNCH
db RAGE
db 0
db 0
db 0 ; growth rate
db AB_SLEEPWALK	;ability 1
db 00	;ability 2
db $50	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(KangaskhanPicFront) ; sprite bank
