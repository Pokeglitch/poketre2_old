SFX_Cry2A_Data::

SFX_Cry2A_Ch1: 
	dutycycle $d2
	sound 3, $f1, $b0, 6
	sound 1, $f1, $a5, 6
	sound 1, $f1, $9d, 6
	sound 7, $f1, $8a, 6
	sound 3, $f1, $36, 7
	sound 3, $f1, $20, 7
	sound 20, $f1, $0e, 7
	endchannel

SFX_Cry2A_Ch2: 
	dutycycle $27
SFX_Cry2A_branch_1: ; f3443
	sound 1, $f1, $b4, 7
	loopchannel 8, SFX_Cry2A_branch_1
SFX_Cry2A_branch_2: ; f344b
	sound 1, $c1, $90, 7
	loopchannel 3, SFX_Cry2A_branch_2
SFX_Cry2A_branch_3: ; f3453
	sound 1, $b1, $8d, 7
	loopchannel 2, SFX_Cry2A_branch_3
	sound 16, $91, $95, 7
	endchannel

SFX_Cry2A_Ch3:
	noise 0, $f1, $28
	loopchannel 4, SFX_Cry2A_Ch3
	noise 0, $91, $49
	noise 1, $a1, $4a
	noise 0, $e1, $4b
	noise 5, $d1, $4f
	noise 3, $c1, $4e
	noise 3, $b1, $4d
	noise 20, $a1, $4c
	endchannel