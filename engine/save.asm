;add in additional 'calc checksum' and store them at the end of the gamesave data
;compare as we load each set of data
;then, include these bytes when calculating the final checksum


;to get the PC bank based on Game Mode
GetPCBank:
	ld a, 2		;Hard Mode PC Bank
	call IsHardMode
	ret nz	;return if hard mode
	ld a, 3		;Normal Mode PC Bank
	ret
	
;to get the save bank based on Game Mode
GetSaveBank:
	xor a		;Normal Mode Save Bank (0)
	call IsHardMode
	ret z	;return if normal mode
	ld a, 1		;Hard Mode Save Bank
	ret



LoadSAV: ; 735e8 (1c:75e8)
;(if carry -> write
;"the file data is destroyed")
	call ClearScreen
	call LoadFontTilePatterns
	call LoadTextBoxTilePatterns
	ld hl, sGameSaveStart		;location in bank to read from
	call LoadSAVCheckSum
	jr c, .badsum
	
	;the game save data was loaded correctly:
	call IsHardMode
	jr z,.skipBackup	;don't update the backup if we are in normal mode
	
	ld hl, sGameSaveStart
	ld de, sBackupGameSaveStart
	call BackupData	;make sure the backup is up to date
	and a
	call nz,RestoreBattleData	;if the byte is not 0, then we should try to load the party data saved in battle
.skipBackup
	ld a, $2 ; good checksum
	jr .goodsum
.badsum
	call IsHardMode
	jr z,.badBackupSum	;if normal mode, there is no backup
	
	ld hl, sBackupGameSaveStart		;location in bank to read from
	call LoadSAVCheckSum
	jr c, .badBackupSum
	
	;copy the backup data to the original data
	ld hl, sBackupGameSaveStart
	ld de, sGameSaveStart
	call BackupData	;restore the backup
	and a
	call nz,RestoreBattleData	;if the byte is not 0, then we should try to load the party data saved in battle
	
	ld a, $2 ; good checksum
	jr .goodsum

.badBackupSum
	ld hl, wd730
	push hl
	set 6, [hl]
	ld hl, FileDataDestroyedText
	call PrintText
	ld c, $64
	call DelayFrames
	pop hl
	res 6, [hl]
	ld a, $1 ; bad checksum
.goodsum
	ld [wd088], a ; checksum flag
	ret

	
;to compare the checksum data to see if they match:
CompareChecksums:
	;Check the Player Name checksum data
	;hl is already at the start of the name data ($a000 or $b000)

	push hl
	ld de,sGameSaveChecksum1Offset	;offset for the first checksum
	add hl,de
	push hl
	pop de	;de = first offset location
	
	pop hl
	push hl
	
	ld bc, SIZE_OF_PLAYER_NAME_SAVE_DATA	 ; size of player name data
	call CompareChecksum
	jr nz,.finish		;return if they do not match
	
	inc de
	ld bc, wStorylineDataEnd - wStoryLineData	 ; size of Storyline data
	call CompareChecksum
	jr nz,.finish		;return if they do not match
	
	
	;Check the Sprite Data checksum data
	inc de
	ld bc, wSpriteStateDataEnd - wSpriteStateData1	 ; size of Sprite data
	call CompareChecksum
	jr nz,.finish		;return if they do not match
	
	;Check the Party Data checksum data
	inc de
	ld bc, wPartyMonNicksEnd - wPartyCount	 ; size of Party data
	call CompareChecksum
	jr nz,.finish		;return if they do not match
	
	
	;check the PC Box checkum data
	inc de
	ld bc, wBoxMonNicksEnd - wPCBoxData	 ; size of PC Box data
	call CompareChecksum
	jr nz,.finish 	;return if they do not match
	
	
	;check the additional data checkum data
	inc de
	ld bc, wEndOfAdditionalData - wAdditionalData	 ; size of additional data
	call CompareChecksum
	jr nz,.finish 	;return if they do not match
	
	;check the total data checkum data
	inc de
	pop hl
	push hl		;hl = start of data
	ld bc, SIZE_OF_GAMESAVE - 2	 ; size of total data (including all checksums except this)
	call CompareChecksum
.finish
	pop hl
	ret
	
;to compare the checksum in hl of size bc with byte stored in de
CompareChecksum:
	push de
	call SAVCheckSum
	pop de
	ld c, a
	ld a, [de] ; compare the stored byte to the calculated byte
	cp c
	ret
	

;hl = where to look for the data ($a000 or $b000)
LoadSAVCheckSum: ; 73623 (1c:7623)
	ld a, SRAM_ENABLE
	ld [MBC1SRamEnable], a
	ld a, $1
	ld [MBC1SRamBankingMode], a
	call GetSaveBank	;get the appropriate bank
	ld [MBC1SRamBank], a
	
	call CompareChecksums	;check to see if the checksum data matches
	jp nz, SAVBadCheckSum	;if no match, then return bad checksum

	push hl		;hl = $a000 or $b000
	ld de, wPlayerName ; wd158
	ld bc, SIZE_OF_PLAYER_NAME_SAVE_DATA
	call CopyData
	
	ld de, wStoryLineData
	ld bc, wStorylineDataEnd - wStoryLineData
	call CopyData
	
	ld de, wSpriteStateData1
	ld bc, wSpriteStateDataEnd - wSpriteStateData1
	call CopyData
	
	ld de, wPartyCount
	ld bc, wPartyMonNicksEnd - wPartyCount
	call CopyData
	
	ld de, wPCBoxData
	ld bc, wBoxMonNicksEnd - wPCBoxData
	call CopyData
	
	ld de, wAdditionalData
	ld bc, wEndOfAdditionalData - wAdditionalData
	call CopyData

	ld a,[hl]	;load the tileset type
	ld [hTilesetType],a
	
	ld hl, W_CURMAPTILESET
	set 7, [hl]
	
	pop hl
	and a
	jp SAVGoodChecksum

SAVBadCheckSum: ; 736f7 (1c:76f7)
	scf

SAVGoodChecksum: ; 736f8 (1c:76f8)
	ld a, $0
	ld [MBC1SRamBankingMode], a
	ld [MBC1SRamEnable], a
	ret
	

;also returns the $affd or $bffd to see if we should load party mon data or not
BackupData:
	ld a, SRAM_ENABLE
	ld [MBC1SRamEnable], a
	ld a, $1
	ld [MBC1SRamBankingMode], a
	call GetSaveBank	;get the appropriate bank
	ld [MBC1SRamBank], a
	
	ld bc, SIZE_OF_GAMESAVE
	call CopyData		;restore the backup
	
	ld de,sGameSaveInBattleByteOffset - SIZE_OF_GAMESAVE
	add hl,de	;hl points to the 'Load Battle Party Data?'
	ld a,[hl]
	push af
	
	xor a
	ld [MBC1SRamBankingMode], a
	ld [MBC1SRamEnable], a
	
	pop af
	ret
	
;to load the battle party/item data
RestoreBattleData:
	ld hl,sBattlePartyItemData		;location of first set of party/item data
	ld a,2		;save into the Hard Mode PC bank
	call LoadPartyAndItems
	ret z		;if the checksum matches, then return
	;otherwise, load from the backup
	ld hl,sBackupBattlePartyItemData	;backup location
	ld a,2		;save into the Hard Mode PC bank
	call LoadPartyAndItems
	ret
	
;to compare the checksums for the party item data
ComparePartyItemDataChecksums:
	push hl
	ld de,sBattlePartyItemDataChecksum1 - sBattlePartyItemData
	add hl,de
	push hl
	pop de	;de = checksum location
	pop hl	;hl = start of data
	push hl
	
	;check the party data
	ld bc, wPartyMonNicksEnd - wPartyCount	;size of party data to checksum
	call CompareChecksum
	jr nz,.finish		;return if no match
	
	;check the item data
	inc de	;de = next checksum location
	ld bc, wBagItemsEnd - wNumBagItems	;size of bag data to checksum
	call CompareChecksum
	jr nz,.finish		;return if no match
	
	;check the additional data
	inc de	;de = next checksum location
	ld bc, wAdditionalInBattleDataEnd - wAdditionalInBattleData	;size of additional data to checksum
	call CompareChecksum
	jr nz,.finish		;return if no match	
	
	;check the total data
	inc de	;de = next (total) checksum location
	pop hl	;hl = start of data
	push hl
	ld bc, sBattlePartyItemDataTotalChecksum - sBattlePartyItemData	;size of data to checksum
	call CompareChecksum
.finish
	pop hl
	ret
	
;to Load the battle party/item data
LoadPartyAndItems:
	push hl
	push af
	ld a, SRAM_ENABLE
	ld [MBC1SRamEnable], a
	ld a, $1
	ld [MBC1SRamBankingMode], a
	pop af	
	ld [MBC1SRamBank], a
	
	call ComparePartyItemDataChecksums
	pop hl
	jr nz,.finish	;return with no zero flag if doesnt match
	
	push hl
	ld de, wPartyCount
	ld bc, wPartyMonNicksEnd - wPartyCount	;total size of party
	call CopyData
	
	ld de, wNumBagItems
	ld bc, wBagItemsEnd - wNumBagItems	;total size to copy
	call CopyData
	
	ld de, wAdditionalInBattleData
	ld bc, wAdditionalInBattleDataEnd - wAdditionalInBattleData	;total size to copy
	call CopyData
	
	callab RemovePartyPokemonCaughtInBattle	;remove all party pokemon that were caught in the current battle
	
	pop hl
	xor a	;set zero flag
.finish
	push af
	xor a
	ld [MBC1SRamBankingMode], a
	ld [MBC1SRamEnable], a
	pop af
	ret	;return with zero flag

FileDataDestroyedText: ; 7361e (1c:761e)
	TX_FAR _FileDataDestroyedText
	db "@"
	
	
	
;Saving Functions
	
SaveSAV: ;$770a
	callba PrintSaveScreenText
	ld hl,WouldYouLikeToSaveText
	call SaveSAVConfirm
	and a   ;|0 = Yes|1 = No|
	ret nz
	ld a,[wd088]
	dec a
	jr z,.save
	call SAVCheckRandomID
	jr z,.save
	ld hl,OlderFileWillBeErasedText
	call SaveSAVConfirm
	and a
	ret nz
.save        ;$772d
	call SaveSAVtoSRAM      ;$7848
	hlCoord 1, 13
	ld bc,$0412
	call ClearScreenArea ; clear area 4x12 starting at 13,1
	hlCoord 1, 14
	ld de,NowSavingString
	call PlaceString
	ld c,$78
	call DelayFrames
	ld hl,GameSavedText
	call PrintText
	ld a, (SFX_02_5d - SFX_Headers_02) / 3 ;sound for saved game
	call PlaySoundWaitForCurrent
	call WaitForSoundToFinish
	ld c,$1e
	jp DelayFrames

NowSavingString:
	db "Now saving...@"

SaveSAVConfirm: ; 73768 (1c:7768)
	call PrintText
	hlCoord 0, 7
	ld bc,$0801
	ld a,TWO_OPTION_MENU
	ld [wTextBoxID],a
	call DisplayTextBoxID ; yes/no menu
	ld a,[wCurrentMenuItem]
	ret

WouldYouLikeToSaveText: ; 0x7377d
	TX_FAR _WouldYouLikeToSaveText
	db "@"

GameSavedText: ; 73782 (1c:7782)
	TX_FAR _GameSavedText
	db "@"

OlderFileWillBeErasedText: ; 73787 (1c:7787)
	TX_FAR _OlderFileWillBeErasedText
	db "@"
	
;to copy data and return a checksum:
CopyDataAndChecksum:
	xor a
	push af
.loop
	pop af
	add [hl]		;increase the checksum
	push af
	ld a, [hli]
	ld [de], a
	inc de
	dec bc
	ld a, c
	or b
	jr nz, .loop
	pop af	
	cpl		;complement a
	ret
	
SaveSAVtoSRAM0: ; 7378c (1c:778c)
	ld a, SRAM_ENABLE
	ld [MBC1SRamEnable], a
	ld a, $1
	ld [MBC1SRamBankingMode], a
	call GetSaveBank	;get the appropriate bank
	ld [MBC1SRamBank], a
		
	ld hl, wPlayerName
	ld de, sGameSaveStart
	ld bc, SIZE_OF_PLAYER_NAME_SAVE_DATA
	call CopyDataAndChecksum
	ld [sGameSaveStart + sGameSaveChecksum1Offset],a	;save the checksum
	
	ld hl, wStoryLineData
	ld bc, wStorylineDataEnd - wStoryLineData
	call CopyDataAndChecksum
	ld [sGameSaveStart + sGameSaveChecksum2Offset],a	;save the checksum
	
	ld hl, wSpriteStateData1
	ld bc, wSpriteStateDataEnd - wSpriteStateData1
	call CopyDataAndChecksum
	ld [sGameSaveStart + sGameSaveChecksum3Offset],a	;save the checksum
	
	ld hl, wPartyCount
	ld bc, wPartyMonNicksEnd - wPartyCount
	call CopyDataAndChecksum
	ld [sGameSaveStart + sGameSaveChecksum4Offset],a	;save the checksum
	
	ld hl, wPCBoxData
	ld bc, wBoxMonNicksEnd - wPCBoxData
	call CopyDataAndChecksum
	ld [sGameSaveStart + sGameSaveChecksum5Offset],a	;save the checksum
	
	ld hl, wAdditionalData
	ld bc, wEndOfAdditionalData - wAdditionalData
	call CopyDataAndChecksum
	ld [sGameSaveStart + sGameSaveChecksum6Offset],a	;save the checksum
	
	ld a, [hTilesetType]
	ld [de], a		;save the tileset type
	push af
	xor a
	ld [sGameSaveStart + sGameSaveInBattleByteOffset],a	;this byte holds whether or not we use the in-battle party bytes
	
	ld hl, sGameSaveStart + sGameSaveChecksum1Offset	;start of data
	ld b, NUM_OF_GAMESAVE_CHECKSUMS - 1	;number of checksums
	pop af
.loop
	add [hl]
	ld c,a
	ld a,[hli]
	cpl
	add c
	dec b
	jr nz,.loop	;quick way to generate the final checksum
	cpl
	ld [hl],a	;save the checksum
	
	xor a
	ld [MBC1SRamBankingMode], a
	ld [MBC1SRamEnable], a
	ret

;determines whether we can autosave or not
CanAutosave:
	call IsHardMode	;hard mode?
	jr z,.cantSave
	ld a,[wAutosaveBits]
	bit 7,a	;is this a brand new gamesave?
	jr nz,.cantSave
	ld a,[wd736]
	bit 7,a
	jr nz,.cantSave ;dont autosave if spinning
	bit 6,a
	jr nz,.cantSave ;dont autosave if jumping a ledge
	ld a,[wd730]
	bit 7, a
	jr nz,.cantSave		;dont autosave if simulated button pressed
.canSave
	xor a
	inc a
	ret
.cantSave
	xor a
	ret
	
AutoSaveWhenWalking:
	call CanAutosave
	ret z
	ld a,[wWalkCounter]
	cp 8
	ret z ;return if 8
	push af
	
	ld a, SRAM_ENABLE
	ld [MBC1SRamEnable], a
	ld a, $1
	ld [MBC1SRamBankingMode], a
	call GetSaveBank	;get the appropriate bank
	ld [MBC1SRamBank], a
	
	pop af
	ld b,0
	ld c,a
	ld hl,WalkingAutosaveRoutineTable
	add hl,bc
	add hl,bc
	ld a,[hli]
	ld h,[hl]
	ld l,a		;load the corresponding function from the table
	ld de,.return
	push de		;push the return point
	jp [hl]		;run the associated save function
.return
	xor a
	ld [MBC1SRamBankingMode], a
	ld [MBC1SRamEnable], a
	ret
	
WalkingAutosaveRoutineTable:
	dw WalkAutosave7
	dw WalkAutosave6
	dw WalkAutosave5
	dw WalkAutosave4
	dw WalkAutosave3
	dw WalkAutosave2
	dw WalkAutosave1
	dw WalkAutosave0
	
;nothing
WalkAutosave0:
	ret

;backup part 1
WalkAutosave1:
	ld hl,wAutosaveBits
	bit 1,[hl]	;should we backup?
	ret z		;dont backup if not set
	
	ld hl, sGameSaveStart
	ld de, sBackupGameSaveStart
	ld bc, SIZE_OF_GAMESAVE/4
	call CopyData		;restore the backup
	ret
	
;backup part 2
WalkAutosave2:
	ld hl,wAutosaveBits
	bit 1,[hl]	;should we backup?
	ret z		;dont backup if not set
	
	ld hl, sGameSaveStart + (SIZE_OF_GAMESAVE/4)
	ld de, sBackupGameSaveStart + (SIZE_OF_GAMESAVE/4)
	ld bc, SIZE_OF_GAMESAVE/4
	call CopyData		;restore the backup
	ret

;backup part 3
WalkAutosave3:
	ld hl,wAutosaveBits
	bit 1,[hl]	;should we backup?
	ret z		;dont backup if not set
	
	ld hl, sGameSaveStart + 2*(SIZE_OF_GAMESAVE/4)
	ld de, sBackupGameSaveStart + 2*(SIZE_OF_GAMESAVE/4)
	ld bc, SIZE_OF_GAMESAVE/4
	call CopyData		;restore the backup
	ret
	
;backup part 4
WalkAutosave4:
	ld hl,wAutosaveBits
	bit 1,[hl]	;should we backup?
	ret z		;dont backup if not set
	res 1,[hl]		;reset the bit
	
	ld hl, sGameSaveStart + 3*(SIZE_OF_GAMESAVE/4)
	ld de, sBackupGameSaveStart + 3*(SIZE_OF_GAMESAVE/4)
	ld bc, SIZE_OF_GAMESAVE/4
	call CopyData		;restore the backup
	ret
	
;players name
WalkAutosave5:
	ld hl, wPlayerName
	ld de, sGameSaveStart
	ld bc, SIZE_OF_PLAYER_NAME_SAVE_DATA
	call CopyDataAndChecksum
	ld [sGameSaveStart + sGameSaveChecksum1Offset],a	;save the checksum
	ret
	
;pc part 1
WalkAutosave6:
	ld de,sGameSaveStart + SIZE_OF_PLAYER_NAME_SAVE_DATA + (wStorylineDataEnd - wStoryLineData) + (wSpriteStateDataEnd - wSpriteStateData1) + (wPartyMonNicksEnd - wPartyCount)
	ld hl, wPCBoxData
	ld bc, wBoxMonNicks - wPCBoxData
	call CopyDataAndChecksum
	cpl
	ld [sGameSaveStart + sGameSaveChecksum5Offset],a	;save the partial checksum
	ret
	
;pc part 2
WalkAutosave7:
	ld de,sGameSaveStart + SIZE_OF_PLAYER_NAME_SAVE_DATA + (wStorylineDataEnd - wStoryLineData) + (wSpriteStateDataEnd - wSpriteStateData1) + (wPartyMonNicksEnd - wPartyCount) + (wBoxMonNicks - wPCBoxData)
	ld hl, wBoxMonNicks
	ld bc, wBoxMonNicksEnd - wBoxMonNicks
	call CopyDataAndChecksum
	cpl 
	ld hl,sGameSaveStart + sGameSaveChecksum5Offset
	add [hl]
	cpl
	ld [sGameSaveStart + sGameSaveChecksum5Offset],a	;save the checksum
	
	
	ld hl,wAutosaveBits
	set 0,[hl]		;set bit announcing we should finish autosaving
	
	ret
	
;to finish the walking autosave (by saving the party data, map & sprite data)
FinishWalkingAutosave:
	call CanAutosave
	ret z
	ld a,[wWalkCounter]
	and a
	ret nz		;return if walk counter is not zero
	
	ld hl,wAutosaveBits
	bit 0,[hl]		;should we finish autosaving?
	ret z		;return if not
	res 0,[hl]		;reset that bit
	
	ld a, SRAM_ENABLE
	ld [MBC1SRamEnable], a
	ld a, $1
	ld [MBC1SRamBankingMode], a
	call GetSaveBank	;get the appropriate bank
	ld [MBC1SRamBank], a
	
	ld de,sGameSaveStart + SIZE_OF_PLAYER_NAME_SAVE_DATA
	ld hl, wStoryLineData
	ld bc, wStorylineDataEnd - wStoryLineData
	call CopyDataAndChecksum
	ld [sGameSaveStart + sGameSaveChecksum2Offset],a	;save the total checksum

	ld hl, wSpriteStateData1
	ld bc, wSpriteStateDataEnd - wSpriteStateData1
	call CopyDataAndChecksum
	ld [sGameSaveStart + sGameSaveChecksum3Offset],a	;save the checksum
	
	ld hl, wPartyCount
	ld bc, wPartyMonNicksEnd - wPartyCount
	call CopyDataAndChecksum
	ld [sGameSaveStart + sGameSaveChecksum4Offset],a	;save the checksum
	
	ld de,sGameSaveStart + SIZE_OF_PLAYER_NAME_SAVE_DATA + (wStorylineDataEnd - wStoryLineData) + (wSpriteStateDataEnd - wSpriteStateData1) + (wPartyMonNicksEnd - wPartyCount) + (wBoxMonNicksEnd - wPCBoxData)
	ld hl, wAdditionalData
	ld bc, wEndOfAdditionalData - wAdditionalData
	call CopyDataAndChecksum
	ld [sGameSaveStart + sGameSaveChecksum6Offset],a	;save the checksum
	
	ld a, [hTilesetType]
	ld [de], a		;save the tileset type
	push af
	xor a
	ld [sGameSaveStart + sGameSaveInBattleByteOffset],a	;this byte holds whether or not we use the in-battle party bytes
	
	ld hl, sGameSaveStart + sGameSaveChecksum1Offset	;start of checksum data
	ld b, NUM_OF_GAMESAVE_CHECKSUMS - 1	;number of checksums
	pop af
.loop
	add [hl]
	ld c,a
	ld a,[hli]
	cpl
	add c
	dec b
	jr nz,.loop	;quick way to generate the total checksum
	cpl
	ld [hl],a	;save the checksum
	
	ld hl,wAutosaveBits
	set 1,[hl]	;set the bit so the auto save knows that it can backup
	
	xor a
	ld [MBC1SRamBankingMode], a
	ld [MBC1SRamEnable], a
	
	ret
	
AutoSaveHardMode:
	call CanAutosave	;hard mode?
	ret z		;return if not
	;fall through
	
SaveSAVtoSRAM: ; 73848 (1c:7848)
	ld a, $2
	ld [wd088], a
	call SaveSAVtoSRAM0
	call IsHardMode	;hard mode?
	ret z		;return if not
	ld hl, sGameSaveStart
	ld de, sBackupGameSaveStart
	call BackupData		;back-up the save
	xor a
	ld [wAutosaveBits],a	;reset the bit announcing we should finish autosaving or backup
	ret

	

SAVCheckSum: ; 73856 (1c:7856)
;Check Sum (result[1 byte] is complemented)
	ld d, $0
.loop
	ld a, [hli]
	add d
	ld d, a
	dec bc
	ld a, b
	or c
	jr nz, .loop
	ld a, d
	cpl
	ret
	
	
	
	
	
	
	
;this is the save function that is run before switching to flashback mode.  It saves the players items and party to b498 in SRAM0:
SaveForFlashback:
	ld de, sHardFlashbackBackupPartyItemData	;where to save the party and items for hard mode
	call IsHardMode
	jr nz,.skipNormalMode	;dont load normal mode pointer if hard mode
	ld de, sNormalFlashbackBackupPartyItemData	;where to save the party and items to for normal mode
.skipNormalMode
	ld a,3		;save flashback in bank 3 (normal mode pc bank)
	call SavePartyAndItems
	ret

;this saves the party and items to the location in de
SavePartyAndItems:
	push de
	push af
	ld a, SRAM_ENABLE
	ld [MBC1SRamEnable], a
	ld a, $1
	ld [MBC1SRamBankingMode], a
	pop af
	ld [MBC1SRamBank], a
	
	ld hl, wPartyCount
	ld bc, wPartyMonNicksEnd - wPartyCount	;total size of party
	call CopyDataAndChecksum
	
	pop hl
	push hl
	ld bc,sNormalFlashbackBackupPartyItemDataChecksum1 - sNormalFlashbackBackupPartyItemData	;offset to the first checksum
	add hl,bc	;hl = pointer to first checksum
	ld [hl],a	;store the checksum
	
	ld hl, wNumBagItems
	ld bc, wBagItemsEnd - wNumBagItems	;total size to copy
	call CopyDataAndChecksum
	
	pop hl
	push hl
	ld bc,sNormalFlashbackBackupPartyItemDataChecksum2 - sNormalFlashbackBackupPartyItemData	;offset to the first checksum
	add hl,bc	;hl = pointer to 2nd checksum
	ld [hl],a	;store the checksum
	
	ld hl, wAdditionalInBattleData
	ld bc, wAdditionalInBattleDataEnd - wAdditionalInBattleData	;total size to copy
	call CopyDataAndChecksum
	
	pop hl
	push hl
	ld bc,sNormalFlashbackBackupPartyItemDataChecksum3 - sNormalFlashbackBackupPartyItemData	;offset to the first checksum
	add hl,bc	;hl = pointer to 3rd checksum
	ld [hl],a	;store the checksum
	
	pop hl	;hl = start point
	ld bc, sNormalFlashbackBackupPartyItemDataTotalChecksum - sNormalFlashbackBackupPartyItemData	;size of data to checksum
	call SAVCheckSum
	ld [hl],a	;store the checksum
	xor a
	ld [MBC1SRamBankingMode], a
	ld [MBC1SRamEnable], a
	ret
	
	
;this is the save function that is run to save the in-battle parties:
SaveInBattle:
	call IsHardMode
	ret z		;dont save if not hard mode
	ld de,sBattlePartyItemData		;location of first set of party/item data
	ld a,2		;save into the Hard Mode PC bank
	call SavePartyAndItems
	
	ld a, SRAM_ENABLE
	ld [MBC1SRamEnable], a
	ld a, $1
	ld [MBC1SRamBankingMode], a
	ld a,2		;save into the hard mode pc bank
	ld [MBC1SRamBank], a
	
	ld bc,sBackupBattlePartyItemData - sBattlePartyItemData	;size of data to copy
	ld de,sBackupBattlePartyItemData	;where to copy to
	ld hl,sBattlePartyItemData		;where to copy from
	call CopyData
	
	call GetSaveBank	;get the save bank for the current mode (it should only ever be hard mode)
	ld [MBC1SRamBank], a
	
	ld a,1
	ld [sGameSaveStart + sGameSaveInBattleByteOffset],a	;this byte holds whether or not we use the in-battle party bytes
	ld [sBackupGameSaveStart + sGameSaveInBattleByteOffset],a
	
	xor a
	ld [MBC1SRamBankingMode], a
	ld [MBC1SRamEnable], a
	ret
	
	
	
	
;PC Functions
	
	

;save the CheckSums for each PC box in the current bank
Func_73863: ; 73863 (1c:7863)
	ld hl, $a000
	ld de, $ba41	;was $ba4d
	ld b, 10	;10 boxes
.asm_7386b
	push bc
	push de
	ld bc, wBoxMonNicksEnd - W_NUMINBOX	;size of data to copy
	call SAVCheckSum
	pop de
	ld [de], a
	inc de
	pop bc
	dec b
	jr nz, .asm_7386b
	ret

;get the pointer to the start of the box data
;get the bank in b
Func_7387b: ; 7387b (1c:787b)
	ld hl, PointerTable_73895 ; $7895
	ld a, [wd5a0]
	and $7f
	ld e, a
	ld d, $0
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call GetPCBank
	ld b,a
	ret
	
;starting locations for each PC box
PointerTable_73895: ; 73895 (1c:7895)
	dw $A000
	dw $A2A0
	dw $A540
	dw $A7E0
	dw $AA80
	dw $AD20
	dw $AFC0
	dw $B260
	dw $B500
	dw $B7A0

ChangeBox:: ; 738a1 (1c:78a1)
	ld hl, WhenYouChangeBoxText
	call PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	ret nz ; return if No was chosen
	ld hl, wd5a0
	bit 7, [hl]
	call z, Func_73a29	;new game? (maybe)
	call Func_7393f
	call UpdateSprites
	ld hl, hFlags_0xFFF6
	set 1, [hl]
	call HandleMenuInput
	ld hl, hFlags_0xFFF6
	res 1, [hl]
	bit 1, a
	ret nz
	call Func_7387b
	ld e, l
	ld d, h
	ld hl, W_NUMINBOX
	call Func_7390e
	ld a, [wCurrentMenuItem]
	set 7, a
	ld [wd5a0], a
	call Func_7387b
	ld de, W_NUMINBOX
	call Func_7390e
	ld hl, W_MAPTEXTPTR
	ld de, wChangeBoxSavedMapTextPointer
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a
	call RestoreMapTextPointer
	call SaveSAVtoSRAM
	ld hl, wChangeBoxSavedMapTextPointer
	call SetMapTextPointer
	ld a, (SFX_02_5d - SFX_Headers_02) / 3
	call PlaySoundWaitForCurrent
	call WaitForSoundToFinish
	ret

WhenYouChangeBoxText: ; 73909 (1c:7909)
	TX_FAR _WhenYouChangeBoxText
	db "@"

;copy the current box to the given location in the given bank (in b)
Func_7390e: ; 7390e (1c:790e)
	push hl
	ld a, SRAM_ENABLE
	ld [MBC1SRamEnable], a
	ld a, $1
	ld [MBC1SRamBankingMode], a
	ld a, b
	ld [MBC1SRamBank], a
	ld bc, wBoxMonNicksEnd - W_NUMINBOX	;size of data to copy
	call CopyData
	pop hl
	xor a
	ld [hli], a
	dec a
	ld [hl], a
	ld hl, $a000
	ld bc, $1a40	;was $1a4c
	call SAVCheckSum
	ld [$ba40], a	;was $ba4c
	call Func_73863
	xor a
	ld [MBC1SRamBankingMode], a
	ld [MBC1SRamEnable], a
	ret

Func_7393f: ; 7393f (1c:793f)
	xor a
	ld [H_AUTOBGTRANSFERENABLED], a ; $ffba
	ld a, $3
	ld [wMenuWatchedKeys], a ; wMenuWatchedKeys
	ld a, 9		;number of boxes (starting at 0)
	ld [wMaxMenuItem], a ; wMaxMenuItem
	ld a, $1
	ld [wTopMenuItemY], a ; wTopMenuItemY
	ld a, $c
	ld [wTopMenuItemX], a ; wTopMenuItemX
	xor a
	ld [wcc37], a
	ld a, [wd5a0]
	and $7f
	ld [wCurrentMenuItem], a ; wCurrentMenuItem
	ld [wLastMenuItem], a ; wLastMenuItem
	ld hl, wTileMap
	ld b, $2
	ld c, $9
	call TextBoxBorder
	ld hl, ChooseABoxText
	call PrintText
	hlCoord 11, 0
	ld b, $c
	ld c, $7
	call TextBoxBorder
	ld hl, hFlags_0xFFF6
	set 2, [hl]
	ld de, BoxNames ; $79d9
	hlCoord 13, 1
	call PlaceString
	ld hl, hFlags_0xFFF6
	res 2, [hl]
	ld a, [wd5a0]
	and $7f
	cp 9
	jr c, .asm_739a6
	sub 9
	hlCoord 8, 2
	ld [hl], "1"
	add "0"
	jr .asm_739a8
.asm_739a6
	add "1"
.asm_739a8
	Coorda 9, 2
	hlCoord 1, 2
	ld de, BoxNoText
	call PlaceString
	call Func_73a84
	hlCoord 18, 1
	ld de, wWhichTrade ; wWhichTrade
	ld bc, $14
	ld a, 10	;only care about 10 boxes
.asm_739c2
	push af
	
	push hl
	push de
	push bc
	;print the digit from de to hl
	ld bc,$0102	;1 byte, 2 digits
	call PrintNumber
	pop bc
	pop de
	pop hl
	
	add hl, bc
	inc de
	pop af
	dec a
	jr nz, .asm_739c2
	ld a, $1
	ld [H_AUTOBGTRANSFERENABLED], a ; $ffba
	ret

ChooseABoxText: ; 739d4 (1c:79d4)
	TX_FAR _ChooseABoxText
	db "@"

BoxNames: ; 739d9 (1c:79d9)
	db   "BOX 1"
	next "BOX 2"
	next "BOX 3"
	next "BOX 4"
	next "BOX 5"
	next "BOX 6"
	next "BOX 7"
	next "BOX 8"
	next "BOX 9"
	next "BOX 10"

BoxNoText: ; 73a21 (1c:7a21)
	db "BOX No.@"

;to zero the number of pokemon in each box for the given mode
Func_73a29: ; 73a29 (1c:7a29)
	ld a, SRAM_ENABLE
	ld [MBC1SRamEnable], a
	ld a, $1
	ld [MBC1SRamBankingMode], a
	call GetPCBank
	ld [MBC1SRamBank], a
	call Func_73a4b
	xor a
	ld [MBC1SRamBankingMode], a
	ld [MBC1SRamEnable], a
	ret

;to zero the number of pokemon in each PC box in the given bank
Func_73a4b: ; 73a4b (1c:7a4b)
	ld hl, $a000
	call Func_73a7f
	ld hl, $A2A0
	call Func_73a7f
	ld hl, $A540
	call Func_73a7f
	ld hl, $A7E0
	call Func_73a7f
	ld hl, $AA80
	call Func_73a7f
	ld hl, $AD20
	call Func_73a7f
	ld hl, $AFC0
	call Func_73a7f
	ld hl, $B260
	call Func_73a7f
	ld hl, $B500
	call Func_73a7f
	ld hl, $B7A0
	call Func_73a7f
	ld hl, $a000
	ld bc, $1a40	; was $1a4c
	call SAVCheckSum
	ld [$ba40], a	; was $ba4c
	call Func_73863
	ret

;set the number of Pokemon in the box to 0
Func_73a7f: ; 73a7f (1c:7a7f)
	xor a
	ld [hli], a
	dec a
	ld [hl], a
	ret

;count the number of pokemon in each box
Func_73a84: ; 73a84 (1c:7a84)
	ld hl, wWhichTrade ; wWhichTrade
	push hl
	ld a, SRAM_ENABLE
	ld [MBC1SRamEnable], a
	ld a, $1
	ld [MBC1SRamBankingMode], a
	call GetPCBank
	ld [MBC1SRamBank], a
	call Func_73ab8
	xor a
	ld [MBC1SRamBankingMode], a
	ld [MBC1SRamEnable], a
	pop hl
	ld a, [wd5a0]
	and $7f
	ld c, a
	ld b, $0
	add hl, bc
	ld a, [W_NUMINBOX] ; wda80
	ld [hl], a
	ret

;get the number of pokemon in each box in the current bank
Func_73ab8: ; 73ab8 (1c:7ab8)
	ld a, [$a000]
	ld [hli], a
	ld a, [$A2A0]
	ld [hli], a
	ld a, [$A540]
	ld [hli], a
	ld a, [$A7E0]
	ld [hli], a
	ld a, [$AA80]
	ld [hli], a
	ld a, [$AD20]
	ld [hli], a
	ld a, [$AFC0]
	ld [hli], a
	ld a, [$B260]
	ld [hli], a
	ld a, [$B500]
	ld [hli], a
	ld a, [$B7A0]
	ld [hli], a
	ret
		

SAVCheckRandomID: ;$7ad1
;checks if Sav file is the same by checking player's name 1st letter ($a000)
; and the two random numbers generated at game beginning
;(which are stored at wPlayerID)
	ld a,$0a
	ld [$0000],a
	ld a,$01
	ld [MBC1SRamBankingMode],a
	call GetSaveBank	;get the appropriate bank
	ld [MBC1SRamBank],a
	ld a,[sGameSaveStart]
	and a
	jr z,.next
	ld hl,sGameSaveStart
	call CompareChecksums	;see if the checksums all match
	jr nz,.next
	ld hl,sGameSaveStart + SIZE_OF_PLAYER_NAME_SAVE_DATA + (wPlayerID - wStoryLineData) ;point to the wplayerid in the save game data
	ld a,[hli]
	ld h,[hl]
	ld l,a
	ld a,[wPlayerID]
	cp l
	jr nz,.next
	ld a,[wPlayerID + 1]
	cp h
.next
	ld a,$00
	ld [MBC1SRamBankingMode],a
	ld [$0000],a
	ret
	
	
	
	
	
	
	
	
	
;Obsolete Functoins
	
	
	
LoadSAVCheckSum2:

SaveHallOfFameTeams: ; 73b0d (1c:7b0d)

LoadHallOfFameTeams: ; 73b3f (1c:7b3f)

HallOfFame_Copy: ; 73b51 (1c:7b51)
	ret

;clear the save data for the appropriate banks
ClearSAV: ; 73b6a (1c:7b6a)
	ld a, SRAM_ENABLE
	ld [MBC1SRamEnable], a
	ld a, $1
	ld [MBC1SRamBankingMode], a
	call GetSaveBank
	call PadSRAM_FF
	call PadFlashbackSRAM_FF	;erase the flashback data
	call GetPCBank
	call PadSRAM_FF
	xor a
	ld [MBC1SRamBankingMode], a
	ld [MBC1SRamEnable], a
	ret
	
;size of data to clear
DataToClearSize:
	dw $1000	;normal mode save
	dw $2000	;hard mode save
	dw $1E34	;hard mode PC
	dw $1A40	;normal mode PC

PadSRAM_FF: ; 73b8f (1c:7b8f)
	push af
	ld hl,DataToClearSize
	ld b,0
	ld c,a
	add hl,bc	;points to the row holding the size to clear
	ld c,[hl]
	inc hl
	ld b,[hl]
	ld [MBC1SRamBank], a
	ld hl, $a000
	ld bc, $2000
	ld a, $ff
	call FillMemory
	pop af
	ret
	
;clear the sram data
PadFlashbackSRAM_FF:
	ld de, $ba50	;where to save the party and items to for hard mode
	and a	;is it bank 0? (normal mode)
	jr nz,.clear	;if its not bank zero, skip down
	ld de, $bc4b	;where to save the party and items to for normal mode
.clear
	xor a	;both are in bank 0 (normal save bank)
	ld [MBC1SRamBank], a	;otherwise, we need to clear some data in bank 0
	ld bc, wPartyMonNicksEnd - wPartyCount + wBagItemsEnd - wNumBagItems + wAdditionalInBattleDataEnd - wAdditionalInBattleData + 4
	ld a, $ff
	jp FillMemory
	
