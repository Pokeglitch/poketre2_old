MeowthBaseStats: ; 38972 (e:4972)
db DEX_MEOWTH ; pokedex id
db 40 ; base hp
db 45 ; base attack
db 35 ; base defense
db 90 ; base speed
db $30 ; base special
db TALON ; species type 1
db TALON ; species type 2
db 255 ; catch rate
db 69 ; base exp yield
INCBIN "pic/bmon/meowth.pic",0,1 ; 55, sprite dimensions
dw MeowthPicFront
dw MeowthPicBack
; attacks known at lvl 0
db SCRATCH
db GROWL
db 0
db 0
db 0 ; growth rate
db AB_PICKPOCKET	;ability 1
db 00	;ability 2
db $30	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(MeowthPicFront) ; sprite bank