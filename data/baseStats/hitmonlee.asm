HitmonleeBaseStats: ; 38f5a (e:4f5a)
db DEX_HITMONLEE ; pokedex id
db 50 ; base hp
db 120 ; base attack
db 53 ; base defense
db 87 ; base speed
db $23 ; base special
db FIGHTING ; species type 1
db FIGHTING ; species type 2
db 45 ; catch rate
db 139 ; base exp yield
INCBIN "pic/bmon/hitmonlee.pic",0,1 ; 77, sprite dimensions
dw HitmonleePicFront
dw HitmonleePicBack
; attacks known at lvl 0
db DOUBLE_KICK
db MEDITATE
db 0
db 0
db 0 ; growth rate
db AB_ILL_TEMPERED	;ability 1
db 00	;ability 2
db $6E	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(HitmonleePicFront) ; sprite bank
