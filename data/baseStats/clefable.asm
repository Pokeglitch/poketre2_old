ClefableBaseStats: ; 387b2 (e:47b2)
db DEX_CLEFABLE ; pokedex id
db 95 ; base hp
db 70 ; base attack
db 73 ; base defense
db 60 ; base speed
db $55 ; base special
db MAGIC ; species type 1
db COSMIC ; species type 2
db 25 ; catch rate
db 129 ; base exp yield
INCBIN "pic/bmon/clefable.pic",0,1 ; 66, sprite dimensions
dw ClefablePicFront
dw ClefablePicBack
; attacks known at lvl 0
db SING
db DOUBLESLAP
db MINIMIZE
db METRONOME
db 4 ; growth rate
db AB_FLUFFY	;ability 1
db 00	;ability 2
db $5A	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(ClefablePicFront) ; sprite bank