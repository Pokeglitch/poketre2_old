Route11GateUpstairsScript: ; 49454 (12:5454)
	jp DisableAutoTextBoxDrawing

Route11GateUpstairsTextPointers: ; 49457 (12:5457)
	dw Route11GateUpstairsText1
	dw Route11GateUpstairsText2
	dw Route11GateUpstairsText3
	dw Route11GateUpstairsText4

Route11GateUpstairsText1: ; 4945f (12:545f)
	TX_ASM
	xor a
	ld [wWhichTrade], a
	predef DoInGameTradeDialogue
Route11GateUpstairsScriptEnd: ; 49469 (12:5469)
	jp TextScriptEnd

Route11GateUpstairsText2: ; 4946c (12:546c)
	TX_ASM
	CheckEvent EVENT_GOT_ITEMFINDER, 1
	jr c, .asm_4949b
	ld a, 30 ; pokemon needed
	ld [hOaksAideRequirement], a
	ld a, ITEMFINDER ; oak's aide reward
	ld [hOaksAideRewardItem], a
	call GetItemName
	ld h, d
	ld l, e
	ld de, wOaksAideRewardItemName
	ld bc, ITEM_NAME_LENGTH
	call CopyData
	predef OaksAideScript
	ld a, [hOaksAideResult]
	dec a
	jr nz, .asm_494a1
	SetEvent EVENT_GOT_ITEMFINDER
.asm_4949b
	ld hl, Route11GateUpstairsText_494a3
	call PrintText
.asm_494a1
	jr Route11GateUpstairsScriptEnd

Route11GateUpstairsText_494a3: ; 494a3 (12:54a3)
	TX_FAR _Route11GateUpstairsText_494a3
	db "@"

Route11GateUpstairsText3: ; 494a8 (12:54a8)
	TX_ASM
	ld a, [wSpriteStateData1 + 9]
	cp SPRITE_FACING_UP
	jp nz, GateUpstairsScript_PrintIfFacingUp
	CheckEvent EVENT_BEAT_ROUTE12_SNORLAX
	ld hl, BinocularsSnorlaxText
	jr z, .print
	ld hl, BinocularsNoSnorlaxText
.print
	call PrintText
	jp TextScriptEnd

BinocularsSnorlaxText:
	TX_FAR _BinocularsSnorlaxText
	db "@"

BinocularsNoSnorlaxText:
	TX_FAR _BinocularsNoSnorlaxText
	db "@"

Route11GateUpstairsText4: ; 494ce (12:54ce)
	TX_ASM
	ld hl, Route11GateUpstairsText_494d5
	jp GateUpstairsScript_PrintIfFacingUp

Route11GateUpstairsText_494d5: ; 494d5 (12:54d5)
	TX_FAR _Route11GateUpstairsText_494d5
	db "@"
