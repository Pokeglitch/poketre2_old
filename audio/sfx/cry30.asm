SFX_Cry30_Data::

SFX_Cry30_Ch1:
	dutycycle 1
	callchannel Cry_30_branch_1
	endchannel
	
SFX_Cry30_Ch2:
	dutycycle $41
Cry_30_branch_1: ; f31af
	sound 4, $61, $58, 7
	sound 2, $e1, $60, 7
	sound 2, $e1, $67, 7
	sound 2, $e1, $6c, 7
	sound 7, $f1, $67, 7
	endchannel

SFX_Cry30_Ch3:
	noise 4, $21, 0
	noise 2, $31, 1
	noise 2, $41, 2
	noise 2, $51, 1
	noise 7, $41, 0
	endchannel
