AlakazamBaseStats: ; 38ade (e:4ade)
db DEX_ALAKAZAM ; pokedex id
db 55 ; base hp
db 50 ; base attack
db 45 ; base defense
db 120 ; base speed
db $87 ; base special attack
db MIND ; species type 1
db MAGIC ; species type 2
db 50 ; catch rate
db 186 ; base exp yield
INCBIN "pic/bmon/alakazam.pic",0,1 ; 77, sprite dimensions
dw AlakazamPicFront
dw AlakazamPicBack
; attacks known at lvl 0
db TELEPORT
IF DEF(_YELLOW)
	db KINESIS
	db 0
ELSE
	db CONFUSION
	db DISABLE
ENDC
db 0
db 3 ; growth rate
db AB_INSOMNIA	;ability 1
db 00	;ability 2
db $55	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(AlakazamPicFront) ; sprite bank