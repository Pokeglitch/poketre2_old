SandslashBaseStats: ; 386d2 (e:46d2)
db DEX_SANDSLASH ; pokedex id
db 75 ; base hp
db 100 ; base attack
db 110 ; base defense
db 65 ; base speed
db $2D ; base special
db EARTH ; species type 1
db TALON ; species type 2
db 90 ; catch rate
db 163 ; base exp yield
INCBIN "pic/bmon/sandslash.pic",0,1 ; 66, sprite dimensions
dw SandslashPicFront
dw SandslashPicBack
; attacks known at lvl 0
db SCRATCH
db SAND_ATTACK
db 0
db 0
db 0 ; growth rate
db AB_TOUGH_SKIN	;ability 1
db 00	;ability 2
db $37	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(SandslashPicFront) ; sprite bank
