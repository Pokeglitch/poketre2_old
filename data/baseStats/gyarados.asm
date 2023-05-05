GyaradosBaseStats: ; 391fa (e:51fa)
db DEX_GYARADOS ; pokedex id
db 95 ; base hp
db 125 ; base attack
db 79 ; base defense
db 81 ; base speed
db $3C ; base special
db WATER ; species type 1
db DRAGON ; species type 2
db 45 ; catch rate
db 214 ; base exp yield
INCBIN "pic/bmon/gyarados.pic",0,1 ; 77, sprite dimensions
dw GyaradosPicFront
dw GyaradosPicBack
; attacks known at lvl 0
IF DEF(_YELLOW)
db TACKLE
db 0
db 0
db 0
ELSE
db BITE
db DRAGON_RAGE
db LEER
db HYDRO_PUMP
ENDC
db 5 ; growth rate
db AB_SWIMMER	;ability 1
db 00	;ability 2
db $64	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(GyaradosPicFront) ; sprite bank