VenomothBaseStats: ; 3891e (e:491e)
db DEX_VENOMOTH ; pokedex id
db 70 ; base hp
db 65 ; base attack
db 60 ; base defense
db 90 ; base speed
db $5A ; base special
db BUG ; species type 1
db POISON ; species type 2
db 75 ; catch rate
db 138 ; base exp yield
INCBIN "pic/bmon/venomoth.pic",0,1 ; 77, sprite dimensions
dw VenomothPicFront
dw VenomothPicBack
; attacks known at lvl 0
db TACKLE
db DISABLE
IF DEF(_YELLOW)
	db SUPERSONIC
	db CONFUSION
ELSE
	db POISONPOWDER
	db LEECH_LIFE
ENDC
db 0 ; growth rate
db AB_NOCTURNAL	;ability 1
db 00	;ability 2
db $4B	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(VenomothPicFront) ; sprite bank