Route2GateScript: ; 5d5d4 (17:55d4)
	jp EnableAutoTextBoxDrawing

Route2GateTextPointers: ; 5d5d7 (17:55d7)
	dw Route2GateText1
	dw Route2GateText2

Route2GateText1: ; 5d5db (17:55db)
	TX_ASM
	CheckEvent EVENT_GOT_HM05
	jr nz, .asm_5d60d
	ld a, 10 ; pokemon needed
	ld [hOaksAideRequirement], a
	ld a, HM_05 ; oak's aide reward
	ld [hOaksAideRewardItem], a
	call GetItemName
	ld h,d
	ld l,e
	ld de, wOaksAideRewardItemName
	ld bc, ITEM_NAME_LENGTH
	call CopyData
	predef OaksAideScript
	ld a, [hOaksAideResult]
	cp $1
	jr nz, .asm_5d613
	SetEvent EVENT_GOT_HM05
.asm_5d60d
	ld hl, Route2GateText_5d616
	call PrintText
.asm_5d613
	jp TextScriptEnd

Route2GateText_5d616: ; 5d616 (17:5616)
	TX_FAR _Route2GateText_5d616
	db "@"

Route2GateText2: ; 5d61b (17:561b)
	TX_FAR _Route2GateText2
	db "@"
