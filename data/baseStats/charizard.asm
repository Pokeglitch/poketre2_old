CharizardBaseStats: ; 3846a (e:446a)
db DEX_CHARIZARD ; pokedex id
db 78 ; base hp
db 84 ; base attack
db 78 ; base defense
db 100 ; base speed
db $6D ; base special
db FIRE ; species type 1
db DRAGON ; species type 2
db 45 ; catch rate
db 209 ; base exp yield
INCBIN "pic/bmon/charizard.pic",0,1 ; 77, sprite dimensions
dw CharizardPicFront
dw CharizardPicBack
; attacks known at lvl 0
db SCRATCH
db GROWL
db EMBER
db LEER
db 3 ; growth rate
db AB_FLYING_DRAGON	;ability 1
db AB_FLAME_BODY	;ability 2
db $55	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(CharizardPicFront) ; sprite bank