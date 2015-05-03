SIZE_OF_GAMESAVE EQU $1000
NUM_OF_GAMESAVE_CHECKSUMS EQU 7

SIZE_OF_PLAYER_NAME_SAVE_DATA EQU 11


sGameSaveStart EQU $A000
sBackupGameSaveStart EQU $B000

sGameSaveChecksum1Offset EQU SIZE_OF_GAMESAVE - NUM_OF_GAMESAVE_CHECKSUMS - 1
sGameSaveChecksum2Offset EQU sGameSaveChecksum1Offset + 1
sGameSaveChecksum3Offset EQU sGameSaveChecksum1Offset + 2
sGameSaveChecksum4Offset EQU sGameSaveChecksum1Offset + 3
sGameSaveChecksum5Offset EQU sGameSaveChecksum1Offset + 4
sGameSaveChecksum6Offset EQU sGameSaveChecksum1Offset + 5
sGameSaveTotalChecksumOffset EQU sGameSaveChecksum1Offset + 6
sGameSaveInBattleByteOffset EQU sGameSaveChecksum1Offset + 7
	
	
box_struct_length EQU 25 + NUM_MOVES * 2 + 11
SIZE_OF_PC_BOX EQU (box_struct_length + 22) * MONS_PER_BOX
NUM_OF_PC_BOXES EQU 10