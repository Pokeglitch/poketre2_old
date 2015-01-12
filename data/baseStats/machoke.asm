MachokeBaseStats: ; 38b16 (e:4b16)
db DEX_MACHOKE ; pokedex id
db 80 ; base hp
db 100 ; base attack
db 70 ; base defense
db 45 ; base speed
db $32 ; base special
db FIGHTING ; species type 1
db FIGHTING ; species type 2
db 90 ; catch rate
db 146 ; base exp yield
INCBIN "pic/bmon/machoke.pic",0,1 ; 77, sprite dimensions
dw MachokePicFront
dw MachokePicBack
; attacks known at lvl 0
db KARATE_CHOP
db LOW_KICK
db LEER
db 0
db 3 ; growth rate
db AB_ILL_TEMPERED	;ability 1
db 00	;ability 2
db $3C	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(MachokePicFront) ; sprite bank