ChanseyBaseStats: ; 3901e (e:501e)
db DEX_CHANSEY ; pokedex id
db 250 ; base hp
db 5 ; base attack
db 5 ; base defense
db 50 ; base speed
db $23 ; base special
db SOUND ; species type 1
db MAGIC ; species type 2
db 30 ; catch rate
db 255 ; base exp yield
INCBIN "pic/bmon/chansey.pic",0,1 ; 66, sprite dimensions
dw ChanseyPicFront
dw ChanseyPicBack
; attacks known at lvl 0
db POUND
IF DEF(_YELLOW)
	db TAIL_WHIP
ELSE
	db DOUBLESLAP
ENDC
db 0
db 0
db 4 ; growth rate
db AB_FLUFFY	;ability 1
db 00	;ability 2
db $69	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(ChanseyPicFront) ; sprite bank