SFX_Cry2F_Data::

SFX_Cry2F_Ch1:
	dutycycle $12
SFX_Cry2F_branch_1:
	sound 3, $c1, $91, 7
	loopchannel 3, SFX_Cry2F_branch_1
SFX_Cry2F_branch_2:
	sound 3, $d1, $b1, 4
	loopchannel 6, SFX_Cry2F_branch_2
SFX_Cry2F_branch_3:
	sound 1, $d1, $91, 4
	sound 1, $b1, $51, 4
	loopchannel 6, SFX_Cry2F_branch_3
SFX_Cry2F_branch_4:
	sound 1, $a1, $71, 4
	sound 1, $81, $41, 4
	loopchannel 6, SFX_Cry2F_branch_4
SFX_Cry2F_branch_5:
	sound 1, $41, $21, 4
	sound 1, $21, $01, 4
	loopchannel 4, SFX_Cry2F_branch_5
	endchannel
	
SFX_Cry2F_Ch2:
	dutycycle $78
	sound 8, $91, $40, 7
	sound 8, $71, $46, 7
	sound 16, $f1, $8d, 7
	sound 8, $f1, $91, 7
	sound 8, $f1, $8d, 7
	sound 8, $f1, $87, 7
	sound 24, $e1, $83, 7
	endchannel

SFX_Cry2F_Ch3:
	noise 8, $a1, $3a
	noise 8, $a1, $5a
	endchannel
