SpearowBaseStats: ; 3860e (e:460e)
db DEX_SPEAROW ; pokedex id
db 40 ; base hp
db 60 ; base attack
db 30 ; base defense
db 70 ; base speed
db $1F ; base special
db AERO ; species type 1
db AERO ; species type 2
db 255 ; catch rate
db 58 ; base exp yield
INCBIN "pic/bmon/spearow.pic",0,1 ; 55, sprite dimensions
dw SpearowPicFront
dw SpearowPicBack
; attacks known at lvl 0
db PECK
db GROWL
db 0
db 0
db 0 ; growth rate
db AB_PREDATOR	;ability 1
db 00	;ability 2
db $1F	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(SpearowPicFront) ; sprite bank