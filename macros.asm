
text   EQUS "db " ; Start writing text.
next   EQUS "db $4e," ; Move a line down.
line   EQUS "db $4f," ; Start writing at the bottom line.
para   EQUS "db $51," ; Start a new paragraph.
para_then   EQUS "db $51" ; Start a new paragraph.
cont   EQUS "db $4B," ; Scroll to the next line.
done   EQUS "db $00"  ; End a text box.
prompt EQUS "db $58"  ; Prompt the player to end a text box (initiating some other event).

sfx_pointer: MACRO
\1_Pointer::
	db BANK(\1_Data)
	dw \1
ENDM

asm_text: MACRO
	db $43
	ENDM
	
end_asm_text:	MACRO
	call TextScriptEnd
	ENDM

place_string_end_asm_text:	MACRO
	call PlaceStringFromASM_HL
	call TextScriptEnd
	ENDM
	
ram_text: MACRO
; prints the string in the textbox
; \1: RAM address to read from
	db $47
	dw \1
	ENDM
	
far_text:  MACRO
; prints the string in the textbox
; \1: address to read from
	db $44
	dw \1
	db BANK(\1)
	ENDM
	
hex_number: MACRO
; prints a hex number in decimal
; \1: RAM address to read from
; \2: length of number in bytes
; \3: amount of digits to display
	db $46
	dw \1
	db \2 << 4 | \3
	ENDM
	
dec_number: MACRO
; prints a hex number in decimal
; \1: RAM address to read from
; \2: flags
; \3: length of number in bytes
	db $45
	dw \1
	db \2 << 5 | \3
	ENDM

page   EQUS "db $49,"     ; Start a new Pokedex page.
dex    EQUS "db $5f, $00" ; End a Pokedex entry.


percent EQUS "* $ff / 100"

lb: MACRO ; r, hi, lo
	ld \1, (\2) << 8 + ((\3) & $ff)
	ENDM


; Constant enumeration is useful for monsters, items, moves, etc.
const_def: MACRO
const_value = 0
ENDM

const: MACRO
\1 EQU const_value
const_value = const_value + 1
ENDM

add_tm: MACRO
\1_TM::
db \1
ENDM

;to initialize the key item bitfield
initKeyItems: MACRO
;to initalize learnset variables 
Bitfield1 = 0
Bitfield2 = 0
Bitfield3 = 0
Bitfield4 = 0
Bitfield5 = 0
Bitfield6 = 0
Bitfield7 = 0
Bitfield8 = 0
Bitfield9 = 0
Bitfield10 = 0
Bitfield11 = 0
Bitfield12 = 0
Bitfield13 = 0
ENDM

;to add an item to this bitfield
;The input is the item id
addKeyItem: MACRO
IF \1/8 == 0
Bitfield1 = Bitfield1 + (1 << \1%8)
ENDC
IF \1/8 == 1
Bitfield2 = Bitfield2 + (1 << \1%8)
ENDC
IF \1/8 == 2
Bitfield3 = Bitfield3 + (1 << \1%8)
ENDC
IF \1/8 == 3
Bitfield4 = Bitfield4 + (1 << \1%8)
ENDC
IF \1/8 == 4
Bitfield5 = Bitfield5 + (1 << \1%8)
ENDC
IF \1/8 == 5
Bitfield6 = Bitfield6 + (1 << \1%8)
ENDC
IF \1/8 == 6
Bitfield7 = Bitfield7 + (1 << \1%8)
ENDC
IF \1/8 == 7
Bitfield8 = Bitfield8 + (1 << \1%8)
ENDC
IF \1/8 == 8
Bitfield9 = Bitfield9 + (1 << \1%8)
ENDC
IF \1/8 == 9
Bitfield10 = Bitfield10 + (1 << \1%8)
ENDC
IF \1/8 == 10
Bitfield11 = Bitfield11 + (1 << \1%8)
ENDC
IF \1/8 == 11
Bitfield12 = Bitfield12 + (1 << \1%8)
ENDC
IF \1/8 == 12
Bitfield1 = Bitfield1 + (1 << \1%8)
ENDC
ENDM

;to save the key item bitfield
saveKeyItems: MACRO
db Bitfield1
db Bitfield2
db Bitfield3
db Bitfield4
db Bitfield5
db Bitfield6
db Bitfield7
db Bitfield8
db Bitfield9
db Bitfield10
db Bitfield11
db Bitfield12
db Bitfield13
ENDM

;To initialize a learnset, by zeroing the 10 bytes (but storing as variables)
initLearnset: MACRO
;to initalize learnset variables 
Learnset0 = 0
Learnset1 = 0
Learnset2 = 0
Learnset3 = 0
Learnset4 = 0
Learnset5 = 0
Learnset6 = 0
Learnset7 = 0
Learnset8 = 0
Learnset9 = 0
ENDM

;to add a TM to this learnset
;The input is the Move name
learnTM: MACRO
IF ((\1_TM - TechnicalMachines)/8) == 0
Learnset0 = Learnset0 + (1 << (\1_TM - TechnicalMachines)%8)
ENDC
IF ((\1_TM - TechnicalMachines)/8) == 1
Learnset1 = Learnset1 + (1 << (\1_TM - TechnicalMachines)%8)
ENDC
IF ((\1_TM - TechnicalMachines)/8) == 2
Learnset2 = Learnset2 + (1 << (\1_TM - TechnicalMachines)%8)
ENDC
IF ((\1_TM - TechnicalMachines)/8) == 3
Learnset3 = Learnset3 + (1 << (\1_TM - TechnicalMachines)%8)
ENDC
IF ((\1_TM - TechnicalMachines)/8) == 4
Learnset4 = Learnset4 + (1 << (\1_TM - TechnicalMachines)%8)
ENDC
IF ((\1_TM - TechnicalMachines)/8) == 5
Learnset5 = Learnset5 + (1 << (\1_TM - TechnicalMachines)%8)
ENDC
IF ((\1_TM - TechnicalMachines)/8) == 6
Learnset6 = Learnset6 + (1 << (\1_TM - TechnicalMachines)%8)
ENDC
IF ((\1_TM - TechnicalMachines)/8) == 7
Learnset7 = Learnset7 + (1 << (\1_TM - TechnicalMachines)%8)
ENDC
IF ((\1_TM - TechnicalMachines)/8) == 8
Learnset8 = Learnset8 + (1 << (\1_TM - TechnicalMachines)%8)
ENDC
IF ((\1_TM - TechnicalMachines)/8) == 9
Learnset9 = Learnset9 + (1 << (\1_TM - TechnicalMachines)%8)
ENDC
ENDM

;to save bytes to the game
endLearnset: MACRO
db Learnset0
db Learnset1
db Learnset2
db Learnset3
db Learnset4
db Learnset5
db Learnset6
db Learnset7
db Learnset8
db Learnset9
ENDM


homecall: MACRO
	ld a, [H_LOADEDROMBANK]
	push af
	ld a, BANK(\1)
	ld [H_LOADEDROMBANK], a
	ld [MBC1RomBank], a
	call \1
	pop af
	ld [H_LOADEDROMBANK], a
	ld [MBC1RomBank], a
	ENDM

callba: MACRO
	ld b, BANK(\1)
	ld hl, \1
	call Bankswitch
	ENDM

callab: MACRO
	ld hl, \1
	ld b, BANK(\1)
	call Bankswitch
	ENDM

jpba: MACRO
	ld b, BANK(\1)
	ld hl, \1
	jp Bankswitch
	ENDM

jpab: MACRO
	ld hl, \1
	ld b, BANK(\1)
	jp Bankswitch
	ENDM

bcd2: MACRO
	dn ((\1) / 1000) % 10, ((\1) / 100) % 10
	dn ((\1) / 10) % 10, (\1) % 10
	ENDM

bcd3: MACRO
	dn ((\1) / 100000) % 10, ((\1) / 10000) % 10
	dn ((\1) / 1000) % 10, ((\1) / 100) % 10
	dn ((\1) / 10) % 10, (\1) % 10
	ENDM

coins equs "bcd2"
money equs "bcd3"

;\1 = r
;\2 = X
;\3 = Y
coord: MACRO
	ld \1, wTileMap + 20 * \3 + \2
	ENDM

;\1 = X
;\2 = Y
aCoord: MACRO
	ld a, [wTileMap + 20 * \2 + \1]
	ENDM

;\1 = X
;\2 = Y
Coorda: MACRO
	ld [wTileMap + 20 * \2 + \1], a
	ENDM

;\1 = X
;\2 = Y
dwCoord: MACRO
	dw wTileMap + 20 * \2 + \1
	ENDM

;\1 = r
;\2 = X
;\3 = Y
;\4 = map width
overworldMapCoord: MACRO
	ld \1, wOverworldMap + ((\2) + 3) + (((\3) + 3) * ((\4) + (3 * 2)))
	ENDM

;\1 = Map Width
;\2 = Rows above (Y-blocks)
;\3 = X movement (X-blocks)
EVENT_DISP: MACRO
	dw (wOverworldMap + 7 + (\1) + ((\1) + 6) * ((\2) >> 1) + ((\3) >> 1)) ; Ev.Disp
	db \2,\3	;Y,X
	ENDM

FLYWARP_DATA: MACRO
	EVENT_DISP \1,\2,\3
	db ((\2) & $01)	;sub-block Y
	db ((\3) & $01)	;sub-block X
	ENDM

; external map entry macro
EMAP: MACRO ; emap x-coordinate,y-coordinate,textpointer
; the appearance of towns and routes in the town map, indexed by map id
	; nybble: y-coordinate
	; nybble: x-coordinate
	; word  : pointer to map name
	db (\1 + (\2 << 4))
	dw \3
	ENDM

; internal map entry macro
IMAP: MACRO ; imap mapid_less_than,x-coordinate,y-coordinate,textpointer
; the appearance of buildings and dungeons in the town map
	; byte  : maximum map id subject to this rule
	; nybble: y-coordinate
	; nybble: x-coordinate
	; word  : pointer to map name
	db \1 + 1
	db \2 + \3 << 4
	dw \4
	ENDM

; tilesets' headers macro
tileset: MACRO
	db BANK(\2)   ; BANK(GFX)
	dw \1, \2, \3 ; Block, GFX, Coll
	db \4, \5, \6 ; counter tiles
	db \7         ; grass tile
	db \8         ; permission (indoor, cave, outdoor)
	ENDM

INDOOR  EQU 0
CAVE    EQU 1
OUTDOOR EQU 2

; macro for two nibbles
dn: MACRO
	db (\1 << 4 | \2)
	ENDM

; macro for putting a byte then a word
dbw: MACRO
	db \1
	dw \2
	ENDM

; data format macros
RGB: MACRO
	dw (\3 << 10 | \2 << 5 | \1)
	ENDM

; text macros
TX_NUM: MACRO
; print a big-endian decimal number.
; \1: address to read from
; \2: number of bytes to read
; \3: number of digits to display
	db $46
	dw \1
	db \2 << 4 | \3
	ENDM

TX_FAR: MACRO
	db $44
	dw \1
	db BANK(\1)
	ENDM

; text engine command $1
TX_RAM: MACRO
; prints text to screen
; \1: RAM address to read from
	db $47
	dw \1
	ENDM

TX_BCD: MACRO
	db $45
	dw \1
	db \2
	ENDM
	
;new overworld text macro
add_overworld_text: MACRO
\1OverworldText::
	dw \1
	ENDM

overworld_text_id: MACRO
	ld a, (\1OverworldText - NewOverworldTextPointersTable) / 2
	ENDM

show_overworld_text: MACRO
	overworld_text_id \1
	ld [wNewOverworldTextID],a
	call DisplayNewOverworldText
	ENDM

TX_ASM: MACRO
	db $08
	ENDM

; Predef macro.
add_predef: MACRO
\1Predef::
	db BANK(\1)
	dw \1
	ENDM

predef_id: MACRO
	ld a, (\1Predef - PredefPointers) / 3
	ENDM

predef: MACRO
	predef_id \1
	call Predef
	ENDM

predef_jump: MACRO
	predef_id \1
	jp Predef
	ENDM


add_tx_pre: MACRO
\1_id:: dw \1
ENDM

tx_pre_id: MACRO
	ld a, (\1_id - TextPredefs) / 2 + 1
ENDM

tx_pre: MACRO
	tx_pre_id \1
	call PrintPredefTextID
ENDM

tx_pre_jump: MACRO
	tx_pre_id \1
	jp PrintPredefTextID
ENDM

WALK EQU $FE
STAY EQU $FF

DOWN  EQU $D0
UP    EQU $D1
LEFT  EQU $D2
RIGHT EQU $D3
NONE  EQU $FF

;\1 sprite id
;\2 x position
;\3 y position
;\4 movement (WALK/STAY)
;\5 range or direction
;\6 text id
;\7 items only: item id
;\7 trainers only: trainer class/pokemon id
;\8 trainers only: trainer number/pokemon level
object: MACRO
	db \1
	db \3 + 4
	db \2 + 4
	db \4
	db \5
	IF (_NARG > 7)
		db TRAINER | \6
		db \7
		db \8
	ELSE
		IF (_NARG > 6)
			db ITEM | \6
			db \7
		ELSE
			db \6
		ENDC
	ENDC
ENDM


;1_channel	EQU $00
;2_channels	EQU $40
;3_channels	EQU $80
;4_channels	EQU $C0

CH0		EQU 0
CH1		EQU 1
CH2		EQU 2
CH3		EQU 3
CH4		EQU 4
CH5		EQU 5
CH6		EQU 6
CH7		EQU 7

sweep: MACRO
	db $10
	db \1
ENDM

sound: MACRO
	db $20 | \1
	db \2
	db \3
	db \4
ENDM

noise: MACRO
	db $20 | \1
	db \2
	db \3
ENDM

;format: pitch length (in 16ths)
C_: MACRO
	db $00 | (\1 - 1)
ENDM

C#: MACRO
	db $10 | (\1 - 1)
ENDM

D_: MACRO
	db $20 | (\1 - 1)
ENDM

D#: MACRO
	db $30 | (\1 - 1)
ENDM

E_: MACRO
	db $40 | (\1 - 1)
ENDM

F_: MACRO
	db $50 | (\1 - 1)
ENDM

F#: MACRO
	db $60 | (\1 - 1)
ENDM

G_: MACRO
	db $70 | (\1 - 1)
ENDM

G#: MACRO
	db $80 | (\1 - 1)
ENDM

A_: MACRO
	db $90 | (\1 - 1)
ENDM

A#: MACRO
	db $A0 | (\1 - 1)
ENDM

B_: MACRO
	db $B0 | (\1 - 1)
ENDM

;format: instrument length (in 16ths)
snare1: MACRO
	db $B0 | (\1 - 1)
	db SFX_SNARE_1
ENDM

snare2: MACRO
	db $B0 | (\1 - 1)
	db SFX_SNARE_2
ENDM

snare3: MACRO
	db $B0 | (\1 - 1)
	db SFX_SNARE_3
ENDM

snare4: MACRO
	db $B0 | (\1 - 1)
	db SFX_SNARE_4
ENDM

snare5: MACRO
	db $B0 | (\1 - 1)
	db SFX_SNARE_5
ENDM

triangle1: MACRO
	db $B0 | (\1 - 1)
	db SFX_TRIANGLE_1
ENDM

triangle2: MACRO
	db $B0 | (\1 - 1)
	db SFX_TRIANGLE_2
ENDM

snare6: MACRO
	db $B0 | (\1 - 1)
	db SFX_SNARE_6
ENDM

snare7: MACRO
	db $B0 | (\1 - 1)
	db SFX_SNARE_7
ENDM

snare8: MACRO
	db $B0 | (\1 - 1)
	db SFX_SNARE_8
ENDM

snare9: MACRO
	db $B0 | (\1 - 1)
	db SFX_SNARE_9
ENDM

cymbal1: MACRO
	db $B0 | (\1 - 1)
	db SFX_CYMBAL_1
ENDM

cymbal2: MACRO
	db $B0 | (\1 - 1)
	db SFX_CYMBAL_2
ENDM

cymbal3: MACRO
	db $B0 | (\1 - 1)
	db SFX_CYMBAL_3
ENDM

mutedsnare1: MACRO
	db $B0 | (\1 - 1)
	db SFX_MUTED_SNARE_1
ENDM

triangle3: MACRO
	db $B0 | (\1 - 1)
	db SFX_TRIANGLE_3
ENDM

mutedsnare2: MACRO
	db $B0 | (\1 - 1)
	db SFX_MUTED_SNARE_2
ENDM

mutedsnare3: MACRO
	db $B0 | (\1 - 1)
	db SFX_MUTED_SNARE_3
ENDM

mutedsnare4: MACRO
	db $B0 | (\1 - 1)
	db SFX_MUTED_SNARE_4
ENDM

;format: rest length (in 16ths)
rest: MACRO
	db $C0 | (\1 - 1)
ENDM

; format: notetype speed, volume, fade
notetype: MACRO
	db	$D0 | \1
	db	(\2 << 4) | \3
ENDM

dspeed: MACRO
	db $D0 | \1
ENDM

octave: MACRO
	db $E8 - \1
ENDM

toggleperfectpitch: MACRO
	db $E8
ENDM

nested_sound: MACRO
	db $EF
	db \1
ENDM

;format: vibrato delay, rate, depth
vibrato: MACRO
	db $EA
	db \1
	db (\2 << 4) | \3
ENDM

pitchbend: MACRO
	db $EB
	db \1
	db \2
ENDM

duty: MACRO
	db $EC
	db \1
ENDM

tempo: MACRO
	db $ED
	db \1 / $100
	db \1 % $100
ENDM

stereopanning: MACRO
	db $EE
	db \1
ENDM

volume: MACRO
	db $F0
	db (\1 << 4) | \2
ENDM

executemusic: MACRO
	db $F8
ENDM

dutycycle: MACRO
	db $FC
	db \1
ENDM

;format: callchannel address
callchannel: MACRO
	db $FD
	dw \1
ENDM

;format: loopchannel count, address
loopchannel: MACRO
	db $FE
	db \1
	dw \2
ENDM

endchannel: MACRO
	db $FF
ENDM


;\1 (byte) = current map id
;\2 (byte) = connected map id
;\3 (byte) = x movement of connection strip
;\4 (byte) = connection strip offset
;\5 (word) = connected map blocks pointer
NORTH_MAP_CONNECTION: MACRO
	db \2 ; map id
	dw \5 + (\2_WIDTH * (\2_HEIGHT - 3)) + \4; "Connection Strip" location
	dw wOverworldMap + 3 + \3 ; current map position
	IF (\1_WIDTH < \2_WIDTH)
		db \1_WIDTH - \3 + 3 ; width of connection strip
	ELSE
		db \2_WIDTH - \4 ; width of connection strip
	ENDC
	db \2_WIDTH ; map width
	db (\2_HEIGHT * 2) - 1 ; y alignment (y coordinate of player when entering map)
	db (\3 - \4) * -2 ; x alignment (x coordinate of player when entering map)
	dw wOverworldMap + 1 + (\2_HEIGHT * (\2_WIDTH + 6)) ; window (position of the upper left block after entering the map)
ENDM

;\1 (byte) = current map id
;\2 (byte) = connected map id
;\3 (byte) = x movement of connection strip
;\4 (byte) = connection strip offset
;\5 (word) = connected map blocks pointer
;\6 (flag) = add 3 to width of connection strip (why?)
SOUTH_MAP_CONNECTION: MACRO
	db \2 ; map id
	dw \5 + \4 ; "Conection Strip" location
	dw wOverworldMap + 3 + (\1_HEIGHT + 3) * (\1_WIDTH + 6) + \3 ; current map position
	IF (\1_WIDTH < \2_WIDTH)
		IF (_NARG > 5)
			db \1_WIDTH - \3 + 3 ; width of connection strip
		ELSE
			db \1_WIDTH - \3 ; width of connection strip
		ENDC
	ELSE
		db \2_WIDTH - \4 ; width of connection strip
	ENDC
	db \2_WIDTH ; map width
	db 0  ; y alignment (y coordinate of player when entering map)
	db (\3 - \4) * -2 ; x alignment (x coordinate of player when entering map)
	dw wOverworldMap + 7 + \2_WIDTH ; window (position of the upper left block after entering the map)
ENDM

;\1 (byte) = current map id
;\2 (byte) = connected map id
;\3 (byte) = y movement of connection strip
;\4 (byte) = connection strip offset
;\5 (word) = connected map blocks pointer
WEST_MAP_CONNECTION: MACRO
	db \2 ; map id
	dw \5 + (\2_WIDTH * \4) + \2_WIDTH - 3 ; "Connection Strip" location
	dw wOverworldMap + (\1_WIDTH + 6) * (\3 + 3) ; current map position
	IF (\1_HEIGHT < \2_HEIGHT)
		db \1_HEIGHT - \3 + 3 ; height of connection strip
	ELSE
		db \2_HEIGHT - \4 ; height of connection strip
	ENDC
	db \2_WIDTH ; map width
	db (\3 - \4) * -2 ; y alignment
	db (\2_WIDTH * 2) - 1 ; x alignment
	dw wOverworldMap + 6 + (2 * \2_WIDTH) ; window (position of the upper left block after entering the map)
ENDM

;\1 (byte) = current map id
;\2 (byte) = connected map id
;\3 (byte) = y movement of connection strip
;\4 (byte) = connection strip offset
;\5 (word) = connected map blocks pointer
;\6 (flag) = add 3 to height of connection strip (why?)
EAST_MAP_CONNECTION: MACRO
	db \2 ; map id
	dw \5 + (\2_WIDTH * \4) ; "Connection Strip" location
	dw wOverworldMap - 3 + (\1_WIDTH + 6) * (\3 + 4) ; current map position
	IF (\1_HEIGHT < \2_HEIGHT)
		IF (_NARG > 5)
			db \1_HEIGHT - \3 + 3 ; height of connection strip
		ELSE
			db \1_HEIGHT - \3 ; height of connection strip
		ENDC
	ELSE
		db \2_HEIGHT - \4 ; height of connection strip
	ENDC
	db \2_WIDTH ; map width
	db (\3 - \4) * -2 ; y alignment
	db 0 ; x alignment
	dw wOverworldMap + 7 + \2_WIDTH ; window (position of the upper left block after entering the map)
ENDM

tmlearn: MACRO
x = 0
	rept _NARG
if \1 != 0
x = x | (1 << ((\1 - 1) % 8))
endc
	shift
	endr
	db x
ENDM