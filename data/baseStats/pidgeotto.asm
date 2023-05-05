PidgeottoBaseStats: ; 3859e (e:459e)
db DEX_PIDGEOTTO ; pokedex id
db 63 ; base hp
db 60 ; base attack
db 55 ; base defense
db 71 ; base speed
db 50 ; base special
db AERO ; species type 1
db AERO ; species type 2
db 120 ; catch rate
db 113 ; base exp yield
INCBIN "pic/bmon/pidgeotto.pic",0,1 ; 66, sprite dimensions
dw PidgeottoPicFront
dw PidgeottoPicBack
; attacks known at lvl 0
db GUST
db SAND_ATTACK
db 0
db 0
db 3 ; growth rate
db AB_PREDATOR	;ability 1
db 00	;ability 2
db $32;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(PidgeottoPicFront) ; sprite bank