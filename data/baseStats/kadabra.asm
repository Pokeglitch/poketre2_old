KadabraBaseStats: ; 38ac2 (e:4ac2)
db DEX_KADABRA ; pokedex id
db 40 ; base hp
db 35 ; base attack
db 30 ; base defense
db 105 ; base speed
db $78 ; base special
db MIND ; species type 1
db MAGIC ; species type 2
db 100 ; catch rate
db 145 ; base exp yield
INCBIN "pic/bmon/kadabra.pic",0,1 ; 66, sprite dimensions
dw KadabraPicFront
dw KadabraPicBack
; attacks known at lvl 0
db TELEPORT
IF DEF(_YELLOW)
	DB KINESIS
	db 0
ELSE
	db CONFUSION
	db DISABLE
ENDC
db 0
db 3 ; growth rate
db AB_INSOMNIA	;ability 1
db 00	;ability 2
db $46	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(KadabraPicFront) ; sprite bank