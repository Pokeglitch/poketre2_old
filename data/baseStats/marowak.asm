MarowakBaseStats: ; 38f3e (e:4f3e)
db DEX_MAROWAK ; pokedex id
db 60 ; base hp
db 80 ; base attack
db 110 ; base defense
db 45 ; base speed
db $32 ; base special
db EARTH ; species type 1
db BONE ; species type 2
db 75 ; catch rate
db 124 ; base exp yield
INCBIN "pic/bmon/marowak.pic",0,1 ; 66, sprite dimensions
dw MarowakPicFront
dw MarowakPicBack
; attacks known at lvl 0
db BONE_CLUB
IF DEF(_YELLOW)
	db TAIL_WHIP
	db 0
	db 0
ELSE
	db GROWL
	db LEER
	db FOCUS_ENERGY
ENDC
db 0 ; growth rate
db AB_HEADPIECE	;ability 1
db 00	;ability 2
db $50	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(MarowakPicFront) ; sprite bank