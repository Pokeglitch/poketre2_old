DugtrioBaseStats: ; 38956 (e:4956)
db DEX_DUGTRIO ; pokedex id
db 35 ; base hp
db 80 ; base attack
db 50 ; base defense
db 120 ; base speed
db $32 ; base special
db EARTH ; species type 1
db EARTH ; species type 2
db 50 ; catch rate
db 153 ; base exp yield
INCBIN "pic/bmon/dugtrio.pic",0,1 ; 66, sprite dimensions
dw DugtrioPicFront
dw DugtrioPicBack
; attacks known at lvl 0
db SCRATCH
db GROWL
db DIG
db 0
db 0 ; growth rate
db AB_NOCTURNAL	;ability 1
db 00	;ability 2
db $46	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(DugtrioPicFront) ; sprite bank