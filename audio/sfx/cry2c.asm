SFX_Cry2C_Data::

SFX_Cry2C_Ch1:
	dutycycle $de
SFX_Cry2C_branch_1: ; f3355
	sound $1, $c1, $20, 5
	sound $1, $a1, $20, 4
	loopchannel 4, SFX_Cry2C_branch_1
	dutycycle 0
	sound $4, $71, $60, 7
	sound $4, $71, $30, 7
	sound $18, $c1, $20, 4
	endchannel

SFX_Cry2C_Ch2:
	dutycycle $32
	sound $8, $f1, $00, 7
	sound $7, $f1, $20, 7
	sound $4, $f1, $90, 7
	sound $4, $f1, $60, 7
	sound $18, $f1, $30, 7
	endchannel

SFX_Cry2C_Ch3:
	noise $4, $81, $6d
	noise $4, $d1, $68
	noise $7, $c1, $69
	noise $4, $91, $3a
	noise $4, $91, $3c
	noise $18, $d1, $5b
	endchannel