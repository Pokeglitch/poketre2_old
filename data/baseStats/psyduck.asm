PsyduckBaseStats: ; 389aa (e:49aa)
db DEX_PSYDUCK ; pokedex id
db 50 ; base hp
db 52 ; base attack
db 48 ; base defense
db 55 ; base speed
db $41 ; base special
db WATER ; species type 1
db AERO ; species type 2
db 190 ; catch rate
db 80 ; base exp yield
INCBIN "pic/bmon/psyduck.pic",0,1 ; 55, sprite dimensions
dw PsyduckPicFront
dw PsyduckPicBack
; attacks known at lvl 0
db SCRATCH
db 0
db 0
db 0
db 0 ; growth rate
db AB_EARLY_BIRD	;ability 1
db 00	;ability 2
db $32	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(PsyduckPicFront) ; sprite bank