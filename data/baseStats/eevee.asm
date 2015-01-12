EeveeBaseStats: ; 3924e (e:524e)
db DEX_EEVEE ; pokedex id
db 55 ; base hp
db 55 ; base attack
db 50 ; base defense
db 55 ; base speed
db $2D ; base special
db TALON ; species type 1
db TALON ; species type 2
db 45 ; catch rate
db 92 ; base exp yield
INCBIN "pic/bmon/eevee.pic",0,1 ; 55, sprite dimensions
dw EeveePicFront
dw EeveePicBack
; attacks known at lvl 0
db TACKLE
IF DEF(_YELLOW)
	db TAIL_WHIP
ELSE
	db SAND_ATTACK
ENDC
db 0
db 0
db 0 ; growth rate
db AB_PREDATOR	;ability 1
db 00	;ability 2
db $41	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(EeveePicFront) ; sprite bank