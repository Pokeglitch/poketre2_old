;to get the correct pointers for the textbox pattern and font tiles based upon the current screen
_LoadTextBoxTilePatterns:
	ld a, [rLCDC]
	bit 7, a ; is the LCD enabled?
	jr nz, .on
.off
	ld hl, TextBoxPointerAndSizeTable
	ld de,3
	ld a,[wWhichScreen]
	call IsInArray
	ret nc		;return if there are no textbox borders for this screen
	inc hl
	ld bc,$90		;set bc to be the size to copy
	ld a,[hli]
	ld h,[hl]
	ld l,a		;set hl to be the pointer
	ld de, vChars1 + $400
	ld a, BANK(_LoadTextBoxTilePatterns)
	jp FarCopyData2 ; if LCD is off, transfer all at once
.on
	ld hl, TextBoxPointerAndSizeTable
	ld de,3
	ld a,[wWhichScreen]
	call IsInArray
	ret nc		;return if there are no textbox borders for this screen
	inc hl
	ld a,[hli]
	ld d,[hl]
	ld e,a		;set de to be the pointer
	ld hl, vChars1 + $400
	ld b, BANK(_LoadTextBoxTilePatterns)
	ld c,9
	jp CopyVideoData ; if LCD is on, transfer during V-blank
	
;text box patterns and size table
TextBoxPointerAndSizeTable:
	db OverworldScreen
	dw OverworldTextBoxGraphics
	
	db ItemMenuScreen
	dw ItemMenuTextBoxGraphics
	
	db TradeScreen
	dw OverworldTextBoxGraphics
	
	db PCScreen
	dw PCTextBoxGraphics
	
	db TaskMenuScreen
	dw TaskMenuTextBoxGraphics
	
	db StatsScreen
	dw StatsScreenTextBoxGraphics
	
	db GameOverScreen
	dw TaskMenuTextBoxGraphics
	
	db $FF
	
OverworldTextBoxGraphics:		INCBIN "gfx/overworld_text_box.2bpp"
ItemMenuTextBoxGraphics:		INCBIN "gfx/item_menu_text_box.2bpp"
TaskMenuTextBoxGraphics:		INCBIN "gfx/task_menu_text_box.2bpp"
PCTextBoxGraphics:				INCBIN "gfx/pc_text_box.2bpp"
StatsScreenTextBoxGraphics:		INCBIN "gfx/stats_screen_text_box.2bpp"

_LoadFontTilePatterns::

	ld a, [rLCDC]
	bit 7, a ; is the LCD enabled?
	jr nz, .on
.off
	ld hl, FontPointerTable
	ld a,[wWhichScreen]
	add a
	ld b,0
	ld c,a
	add hl,bc		;hl now points to the correct font in the list
	ld bc,$400		;set bc to be the size to copy
	ld a,[hli]
	ld h,[hl]
	ld l,a		;set hl to be the pointer
	ld de, vFont
	ld a, BANK(_LoadTextBoxTilePatterns)
	push hl
	call FarCopyData2 ; if LCD is off, transfer all at once
	pop hl
	ld de,$400
	add hl,de
	ld bc,$200
	ld de, vFont + $6000
	jp FarCopyData2
.on
	ld hl, FontPointerTable
	ld a,[wWhichScreen]
	add a
	ld b,0
	ld c,a
	add hl,bc		;hl now points to the correct font in the list
	ld a,[hli]
	ld d,[hl]
	ld e,a		;set de to be the pointer
	ld hl, vFont
	ld b, BANK(_LoadTextBoxTilePatterns)
	ld c,$40
	push de
	call CopyVideoData ; if LCD is on, transfer during V-blank
	pop de
	ld hl,$400
	add hl,de
	push hl
	pop de
	ld hl, vFont + $600
	ld c,$20
	jp CopyVideoData

FontPointerTable:
	dw BlackOnLightGrayFont		;overworld
	dw WhiteOnBlackFont			;start menu
	dw WhiteOnBlackFont			;battle screen
	dw BlackOnWhiteFont			;item menu screen
	dw WhiteOnBlackFont			;party menu screen
	dw BlackOnLightGrayFont		;trade screen
	dw WhiteOnBlackFont			;pc screen
	dw WhiteOnBlackFont			;evolution screen
	dw BlackOnWhiteFont			;task menu screen
	dw BlackOnLightGrayFont		;stats screen
	dw TextInputFont			;text input screen
	dw BlackOnWhiteFont			;trainer card screen
	dw BlackOnWhiteFont			;game over screen
	
TextInputFont:
BlackOnLightGrayFont:			INCBIN "gfx/black_on_light_gray_text.2bpp"
WhiteOnBlackFont:				INCBIN "gfx/white_on_black_text.2bpp"
GrayOnBlackFont: 				INCBIN "gfx/light_gray_on_black_text.2bpp"
BlackOnWhiteFont:				INCBIN "gfx/black_on_white_text.2bpp"

FontGraphics:                   INCBIN "gfx/font.1bpp"