CharmeleonBaseStats: ; 3844e (e:444e)
db DEX_CHARMELEON ; pokedex id
db 58 ; base hp
db 64 ; base attack
db 58 ; base defense
db 80 ; base speed
db $50 ; base special
db FIRE ; species type 1
db FIRE ; species type 2
db 45 ; catch rate
db 142 ; base exp yield
INCBIN "pic/bmon/charmeleon.pic",0,1 ; 66, sprite dimensions
dw CharmeleonPicFront
dw CharmeleonPicBack
; attacks known at lvl 0
db SCRATCH
db GROWL
db EMBER
db 0
db 3 ; growth rate
db AB_FLAME_BODY	;ability 1
db 00	;ability 2
db $41	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(CharmeleonPicFront) ; sprite bank