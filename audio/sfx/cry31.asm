SFX_Cry31_Data::

SFX_Cry31_Ch1:
	dutycycle $12
Cry31_branch_1:
	sound $3, $c1, $91, 7
	loopchannel 3, Cry31_branch_1
Cry31_branch_2:
	sound $3, $d1, $b1, 4
	loopchannel 6, Cry31_branch_2
Cry31_branch_3:
	sound $1, $d1, $91, 4
	sound $1, $b1, $51, 4
	loopchannel 6, Cry31_branch_3
Cry31_branch_4:
	sound $1, $a1, $71, 4
	sound $1, $81, $41, 4
	loopchannel 6, Cry31_branch_4
Cry31_branch_5:
	sound $1, $41, $21, 4
	sound $1, $21, $01, 4
	loopchannel 4, Cry31_branch_5
	endchannel

SFX_Cry31_Ch2:
	dutycycle $78
	sound $8, $91, $40, 7
	sound $8, $71, $46, 7
	sound $10, $f1, $8d, 7
	sound $8, $f1, $91, 7
	sound $8, $f1, $8d, 7
	sound $8, $f1, $87, 7
	sound $18, $e1, $83, 7
	endchannel

SFX_Cry31_Ch3:
	noise $10, $a1, $16
	noise $18, $91, $3d
	noise $20, $91, $5c
	noise $20, $71, $5f
	endchannel