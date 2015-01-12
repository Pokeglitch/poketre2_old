PersianBaseStats: ; 3898e (e:498e)
db DEX_PERSIAN ; pokedex id
db 65 ; base hp
db 70 ; base attack
db 60 ; base defense
db 115 ; base speed
db $49 ; base special
db TALON ; species type 1
db TALON ; species type 2
db 90 ; catch rate
db 148 ; base exp yield
INCBIN "pic/bmon/persian.pic",0,1 ; 77, sprite dimensions
dw PersianPicFront
dw PersianPicBack
; attacks known at lvl 0
db SCRATCH
db GROWL
db BITE
db SCREECH
db 0 ; growth rate
db AB_PICKPOCKET	;ability 1
db 00	;ability 2
db $49	;special defense
db 00	;base selling price
db 00	;evolution shed item
db 00	;extra byte 1
db 00	;extra byte 2
db BANK(PersianPicFront) ; sprite bank
