MachampBaseStats: ; 38b32 (e:4b32)
db DEX_MACHAMP ; pokedex id
db 90 ; base hp
db 130 ; base attack
db 80 ; base defense
db 55 ; base speed
db $41 ; base special
db FIGHTING ; species type 1
db FIGHTING ; species type 2
db 45 ; catch rate
db 193 ; base exp yield
INCBIN "pic/bmon/machamp.pic",0,1 ; 77, sprite dimensions
dw MachampPicFront
dw MachampPicBack
; attacks known at lvl 0
db KARATE_CHOP
db LOW_KICK
db LEER
db 0
db 3 ; growth rate
db AB_ILL_TEMPERED	;ability 1
db 00	;ability 2
db $55	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(MachampPicFront) ; sprite bank