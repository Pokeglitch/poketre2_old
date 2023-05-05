PoliwrathBaseStats: ; 38a8a (e:4a8a)
db DEX_POLIWRATH ; pokedex id
db 90 ; base hp
db 85 ; base attack
db 95 ; base defense
db 70 ; base speed
db $46 ; base special
db WATER ; species type 1
db FIGHTING ; species type 2
db 45 ; catch rate
db 185 ; base exp yield
INCBIN "pic/bmon/poliwrath.pic",0,1 ; 77, sprite dimensions
dw PoliwrathPicFront
dw PoliwrathPicBack
; attacks known at lvl 0
db HYPNOSIS
db WATER_GUN
db DOUBLESLAP
db BODY_SLAM
db 3 ; growth rate
db AB_SWIMMER	;ability 1
db 00	;ability 2
db $5A	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(PoliwrathPicFront) ; sprite bank