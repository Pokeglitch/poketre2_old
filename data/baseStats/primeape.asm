PrimeapeBaseStats: ; 389fe (e:49fe)
db DEX_PRIMEAPE ; pokedex id
db 65 ; base hp
db 105 ; base attack
db 60 ; base defense
db 95 ; base speed
db $3C ; base special
db FIGHTING ; species type 1
db FIGHTING ; species type 2
db 75 ; catch rate
db 149 ; base exp yield
INCBIN "pic/bmon/primeape.pic",0,1 ; 77, sprite dimensions
dw PrimeapePicFront
dw PrimeapePicBack
; attacks known at lvl 0
db SCRATCH
IF !DEF(_YELLOW)
	db LEER
ENDC
db KARATE_CHOP
db FURY_SWIPES
IF DEF(_YELLOW)
	db LOW_KICK
ENDC
db 0 ; growth rate
db AB_ILL_TEMPERED	;ability 1
db 00	;ability 2
db $46	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(PrimeapePicFront) ; sprite bank