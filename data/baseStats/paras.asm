ParasBaseStats: ; 388ca (e:48ca)
db DEX_PARAS ; pokedex id
db 35 ; base hp
db 70 ; base attack
db 55 ; base defense
db 25 ; base speed
db $2D ; base special
db BUG ; species type 1
db PLANT ; species type 2
db 190 ; catch rate
db 70 ; base exp yield
INCBIN "pic/bmon/paras.pic",0,1 ; 55, sprite dimensions
dw ParasPicFront
dw ParasPicBack
; attacks known at lvl 0
db SCRATCH
db 0
db 0
db 0
db 0 ; growth rate
db AB_POISON_SKIN	;ability 1
db 00	;ability 2
db $37	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(ParasPicFront) ; sprite bank
