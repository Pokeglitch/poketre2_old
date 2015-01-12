KabutopsBaseStats: ; 3932e (e:532e)
db DEX_KABUTOPS ; pokedex id
db 60 ; base hp
db 115 ; base attack
db 105 ; base defense
db 80 ; base speed
db $41 ; base special
db TALON ; species type 1
db WATER ; species type 2
db 45 ; catch rate
db 201 ; base exp yield
INCBIN "pic/bmon/kabutops.pic",0,1 ; 66, sprite dimensions
dw KabutopsPicFront
dw KabutopsPicBack
; attacks known at lvl 0
db SCRATCH
db HARDEN
db ABSORB
db 0
db 0 ; growth rate
db AB_SLICER	;ability 1
db 00	;ability 2
db $46	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(KabutopsPicFront) ; sprite bank