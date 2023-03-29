INCLUDE "constants.asm"

SECTION "Audio Engine", ROMX, BANK[AUDIO_1]
INCLUDE "audio/sfx_pointers.asm"
INCLUDE "audio/headers/sfx_headers.asm"
INCLUDE "audio/headers/musicheaders.asm"

PlayBattleMusic:: ; 0x90c6
	xor a
	ld [wAudioFadeOutControl], a
	ld [wLowHealthAlarm], a
	dec a
	ld [wNewSoundID], a
	call PlaySound ; stop music
	call DelayFrame
	ld c, BANK(Music_GymLeaderBattle)
	ld a, [wGymLeaderNo]
	and a
	jr z, .notGymLeaderBattle
	ld a, MUSIC_GYM_LEADER_BATTLE
	jr .playSong
.notGymLeaderBattle
	ld a, [wCurOpponent]
	cp 200
	jr c, .wildBattle
	cp OPP_SONY3
	jr z, .finalBattle
	cp OPP_LANCE
	jr nz, .normalTrainerBattle
	ld a, MUSIC_GYM_LEADER_BATTLE ; lance also plays gym leader theme
	jr .playSong
.normalTrainerBattle
	ld a, MUSIC_TRAINER_BATTLE
	jr .playSong
.finalBattle
	ld a, MUSIC_FINAL_BATTLE
	jr .playSong
.wildBattle
	ld a, MUSIC_WILD_BATTLE
.playSong
	jp PlayMusic

INCLUDE "audio/engine.asm"

; an alternate start for MeetRival which has a different first measure
Music_RivalAlternateStart:: ; 0x9b47
	ld c, BANK(Music_MeetRival)
	ld a, MUSIC_MEET_RIVAL
	call PlayMusic
	ld hl, wChannelCommandPointers
	ld de, Music_MeetRival_branch_b1a2
	call Audio_OverwriteChannelPointer
	ld de, Music_MeetRival_branch_b21d
	call Audio_OverwriteChannelPointer
	ld de, Music_MeetRival_branch_b2b5

Audio_OverwriteChannelPointer: ; 0x9b60
	ld a, e
	ld [hli], a
	ld a, d
	ld [hli], a
	ret

; an alternate tempo for MeetRival which is slightly slower
Music_RivalAlternateTempo:: ; 0x9b65
	ld c, BANK(Music_MeetRival)
	ld a, MUSIC_MEET_RIVAL
	call PlayMusic
	ld hl, wChannelCommandPointers
	ld de, Music_MeetRival_branch_b119
	jp Audio_OverwriteChannelPointer

; applies both the alternate start and alternate tempo
Music_RivalAlternateStartAndTempo:: ; 0x9b75
	call Music_RivalAlternateStart
	ld hl, wChannelCommandPointers
	ld de, Music_MeetRival_branch_b19b
	jp Audio_OverwriteChannelPointer

; an alternate tempo for Cities1 which is used for the Hall of Fame room
Music_Cities1AlternateTempo:: ; 0x9b81
	ld a, 10
	ld [wAudioFadeOutCounterReloadValue], a
	ld [wAudioFadeOutCounter], a
	ld a, $ff ; stop playing music after the fade-out is finished
	ld [wAudioFadeOutControl], a
	ld c, 100
	call DelayFrames ; wait for the fade-out to finish
	ld c, BANK(Music_Cities1)
	ld a, MUSIC_CITIES1
	call PlayMusic
	ld hl, wChannelCommandPointers
	ld de, Music_Cities1_branch_aa6f
	jp Audio_OverwriteChannelPointer
	

Music_DoLowHealthAlarm:: ; 2136e (8:536e)
	ld a, [wLowHealthAlarm]
	cp $ff
	jr z, .disableAlarm

	bit 7, a  ;alarm enabled?
	ret z     ;nope

	and $7f   ;low 7 bits are the timer.
	jr nz, .asm_21383 ;if timer > 0, play low tone.

	call .playToneHi
	ld a, 30 ;keep this tone for 30 frames.
	jr .asm_21395 ;reset the timer.

.asm_21383
	cp 20
	jr nz, .asm_2138a ;if timer == 20,
	call .playToneLo  ;actually set the sound registers.

.asm_2138a
	ld a, $86
	ld [wChannelSoundIDs + CH4], a ;disable sound channel?
	ld a, [wLowHealthAlarm]
	and $7f ;decrement alarm timer.
	dec a

.asm_21395
	; reset the timer and enable flag.
	set 7, a
	ld [wLowHealthAlarm], a
	ret

.disableAlarm
	xor a
	ld [wLowHealthAlarm], a  ;disable alarm
	ld [wChannelSoundIDs + CH4], a  ;re-enable sound channel?
	ld de, .toneDataSilence
	jr .playTone

;update the sound registers to change the frequency.
;the tone set here stays until we change it.
.playToneHi
	ld de, .toneDataHi
	jr .playTone

.playToneLo
	ld de, .toneDataLo

;update sound channel 1 to play the alarm, overriding all other sounds.
.playTone
	ld hl, rNR10 ;channel 1 sound register
	ld c, $5
	xor a

.copyLoop
	ld [hli], a
	ld a, [de]
	inc de
	dec c
	jr nz, .copyLoop
	ret

;bytes to write to sound channel 1 registers for health alarm.
;starting at FF11 (FF10 is always zeroed), so these bytes are:
;length, envelope, freq lo, freq hi
.toneDataHi
	db $A0,$E2,$50,$87

.toneDataLo
	db $B0,$E2,$EE,$86

;written to stop the alarm
.toneDataSilence
	db $00,$00,$00,$80


INCLUDE "engine/menu/bills_pc.asm"

Music_PokeFluteInBattle:: ; 22306 (8:6306)
	; begin playing the "caught mon" sound effect
	ld a, SFX_CAUGHT_MON
	call PlaySoundWaitForCurrent
	; then immediately overwrtie the channel pointers
	ld hl, wChannelCommandPointers + CH4 * 2
	ld de, SFX_PokeFlute2_Ch1
	call Audio2_OverwriteChannelPointer
	ld de, SFX_PokeFlute2_Ch2
	call Audio2_OverwriteChannelPointer
	ld de, SFX_PokeFlute2_Ch3
	
Audio2_OverwriteChannelPointer: ; 2231d (8:631d)
	ld a, e
	ld [hli], a
	ld a, d
	ld [hli], a
	ret


PlayPokedexRatingSfx:: ; 7d13b (1f:513b)
	ld a, [$ffdc]
	ld c, $0
	ld hl, OwnedMonValues
.getSfxPointer
	cp [hl]
	jr c, .gotSfxPointer
	inc c
	inc hl
	jr .getSfxPointer
.gotSfxPointer
	push bc
	ld a, $ff
	ld [wNewSoundID], a
	call PlaySoundWaitForCurrent
	pop bc
	ld b, $0
	ld hl, PokedexRatingSfxPointers
	add hl, bc
	ld a, [hli]
	call PlayMusic
	jp PlayDefaultMusic

PokedexRatingSfxPointers: ; 7d162 (1f:5162)
	db SFX_DENIED
	db SFX_POKEDEX_RATING
	db SFX_GET_ITEM_1
	db SFX_CAUGHT_MON
	db SFX_LEVEL_UP
	db SFX_GET_KEY_ITEM
	db SFX_GET_ITEM_2

OwnedMonValues: ; 7d170 (1f:5170)
	db 20, 44, 80, 112, 148, 185, 255

INCLUDE "audio/sfx/snare1.asm"
INCLUDE "audio/sfx/snare2.asm"
INCLUDE "audio/sfx/snare3.asm"
INCLUDE "audio/sfx/snare4.asm"
INCLUDE "audio/sfx/snare5.asm"
INCLUDE "audio/sfx/triangle1.asm"
INCLUDE "audio/sfx/triangle2.asm"
INCLUDE "audio/sfx/snare6.asm"
INCLUDE "audio/sfx/snare7.asm"
INCLUDE "audio/sfx/snare8.asm"
INCLUDE "audio/sfx/snare9.asm"
INCLUDE "audio/sfx/cymbal1.asm"
INCLUDE "audio/sfx/cymbal2.asm"
INCLUDE "audio/sfx/cymbal3.asm"
INCLUDE "audio/sfx/muted_snare1.asm"
INCLUDE "audio/sfx/triangle3.asm"
INCLUDE "audio/sfx/muted_snare2.asm"
INCLUDE "audio/sfx/muted_snare3.asm"
INCLUDE "audio/sfx/muted_snare4.asm"

Audio_WavePointers: INCLUDE "audio/wave_instruments.asm"


SECTION "Sound Effects", ROMX, BANK[AUDIO_2]

INCLUDE "audio/sfx/start_menu.asm"
INCLUDE "audio/sfx/pokeflute.asm"
INCLUDE "audio/sfx/pokeflute2.asm"
INCLUDE "audio/sfx/cut.asm"
INCLUDE "audio/sfx/go_inside.asm"
INCLUDE "audio/sfx/swap.asm"
INCLUDE "audio/sfx/tink.asm"
INCLUDE "audio/sfx/unused3.asm"
INCLUDE "audio/sfx/purchase.asm"
INCLUDE "audio/sfx/collision.asm"
INCLUDE "audio/sfx/go_outside.asm"
INCLUDE "audio/sfx/press_ab.asm"
INCLUDE "audio/sfx/save.asm"
INCLUDE "audio/sfx/heal_hp.asm"
INCLUDE "audio/sfx/poisoned.asm"
INCLUDE "audio/sfx/heal_ailment.asm"
INCLUDE "audio/sfx/trade_machine.asm"
INCLUDE "audio/sfx/turn_on_pc.asm"
INCLUDE "audio/sfx/turn_off_pc.asm"
INCLUDE "audio/sfx/enter_pc.asm"
INCLUDE "audio/sfx/shrink.asm"
INCLUDE "audio/sfx/switch.asm"
INCLUDE "audio/sfx/healing_machine.asm"
INCLUDE "audio/sfx/teleport_exit1.asm"
INCLUDE "audio/sfx/teleport_enter1.asm"
INCLUDE "audio/sfx/teleport_exit2.asm"
INCLUDE "audio/sfx/ledge.asm"
INCLUDE "audio/sfx/teleport_enter2.asm"
INCLUDE "audio/sfx/fly.asm"
INCLUDE "audio/sfx/denied.asm"
INCLUDE "audio/sfx/arrow_tiles.asm"
INCLUDE "audio/sfx/push_boulder.asm"
INCLUDE "audio/sfx/ss_anne_horn.asm"
INCLUDE "audio/sfx/withdraw_deposit.asm"
INCLUDE "audio/sfx/safari_zone_pa.asm"
INCLUDE "audio/sfx/unused.asm"
INCLUDE "audio/sfx/unused2.asm"
INCLUDE "audio/sfx/cry09.asm"
INCLUDE "audio/sfx/cry23.asm"
INCLUDE "audio/sfx/cry24.asm"
INCLUDE "audio/sfx/cry11.asm"
INCLUDE "audio/sfx/cry25.asm"
INCLUDE "audio/sfx/cry03.asm"
INCLUDE "audio/sfx/cry0f.asm"
INCLUDE "audio/sfx/cry10.asm"
INCLUDE "audio/sfx/cry00.asm"
INCLUDE "audio/sfx/cry0e.asm"
INCLUDE "audio/sfx/cry06.asm"
INCLUDE "audio/sfx/cry07.asm"
INCLUDE "audio/sfx/cry05.asm"
INCLUDE "audio/sfx/cry0b.asm"
INCLUDE "audio/sfx/cry0c.asm"
INCLUDE "audio/sfx/cry02.asm"
INCLUDE "audio/sfx/cry0d.asm"
INCLUDE "audio/sfx/cry01.asm"
INCLUDE "audio/sfx/cry0a.asm"
INCLUDE "audio/sfx/cry08.asm"
INCLUDE "audio/sfx/cry04.asm"
INCLUDE "audio/sfx/cry19.asm"
INCLUDE "audio/sfx/cry16.asm"
INCLUDE "audio/sfx/cry1b.asm"
INCLUDE "audio/sfx/cry12.asm"
INCLUDE "audio/sfx/cry13.asm"
INCLUDE "audio/sfx/cry14.asm"
INCLUDE "audio/sfx/cry1e.asm"
INCLUDE "audio/sfx/cry15.asm"
INCLUDE "audio/sfx/cry17.asm"
INCLUDE "audio/sfx/cry1c.asm"
INCLUDE "audio/sfx/cry1a.asm"
INCLUDE "audio/sfx/cry1d.asm"
INCLUDE "audio/sfx/cry18.asm"
INCLUDE "audio/sfx/cry1f.asm"
INCLUDE "audio/sfx/cry20.asm"
INCLUDE "audio/sfx/cry21.asm"
INCLUDE "audio/sfx/cry22.asm"
INCLUDE "audio/sfx/cry26.asm"
INCLUDE "audio/sfx/cry27.asm"
INCLUDE "audio/sfx/cry28.asm"
INCLUDE "audio/sfx/cry29.asm"
INCLUDE "audio/sfx/cry2a.asm"
INCLUDE "audio/sfx/cry2b.asm"
INCLUDE "audio/sfx/cry2c.asm"
INCLUDE "audio/sfx/cry2d.asm"
INCLUDE "audio/sfx/cry2e.asm"
INCLUDE "audio/sfx/cry2f.asm"
INCLUDE "audio/sfx/cry30.asm"
INCLUDE "audio/sfx/cry31.asm"
INCLUDE "audio/sfx/silph_scope.asm"
INCLUDE "audio/sfx/ball_toss.asm"
INCLUDE "audio/sfx/ball_poof.asm"
INCLUDE "audio/sfx/faint_thud.asm"
INCLUDE "audio/sfx/run.asm"
INCLUDE "audio/sfx/dex_page_added.asm"
INCLUDE "audio/sfx/peck.asm"
INCLUDE "audio/sfx/faint_fall.asm"
INCLUDE "audio/sfx/battle_09.asm"
INCLUDE "audio/sfx/pound.asm"
INCLUDE "audio/sfx/battle_0b.asm"
INCLUDE "audio/sfx/battle_0c.asm"
INCLUDE "audio/sfx/battle_0d.asm"
INCLUDE "audio/sfx/battle_0e.asm"
INCLUDE "audio/sfx/battle_0f.asm"
INCLUDE "audio/sfx/damage.asm"
INCLUDE "audio/sfx/not_very_effective.asm"
INCLUDE "audio/sfx/battle_12.asm"
INCLUDE "audio/sfx/battle_13.asm"
INCLUDE "audio/sfx/battle_14.asm"
INCLUDE "audio/sfx/vine_whip.asm"
INCLUDE "audio/sfx/battle_16.asm"
INCLUDE "audio/sfx/battle_17.asm"
INCLUDE "audio/sfx/battle_18.asm"
INCLUDE "audio/sfx/battle_19.asm"
INCLUDE "audio/sfx/super_effective.asm"
INCLUDE "audio/sfx/battle_1b.asm"
INCLUDE "audio/sfx/battle_1c.asm"
INCLUDE "audio/sfx/doubleslap.asm"
INCLUDE "audio/sfx/battle_1e.asm"
INCLUDE "audio/sfx/horn_drill.asm"
INCLUDE "audio/sfx/battle_20.asm"
INCLUDE "audio/sfx/battle_21.asm"
INCLUDE "audio/sfx/battle_22.asm"
INCLUDE "audio/sfx/battle_23.asm"
INCLUDE "audio/sfx/battle_24.asm"
INCLUDE "audio/sfx/battle_25.asm"
INCLUDE "audio/sfx/battle_26.asm"
INCLUDE "audio/sfx/battle_27.asm"
INCLUDE "audio/sfx/battle_28.asm"
INCLUDE "audio/sfx/battle_29.asm"
INCLUDE "audio/sfx/battle_2a.asm"
INCLUDE "audio/sfx/battle_2b.asm"
INCLUDE "audio/sfx/battle_2c.asm"
INCLUDE "audio/sfx/psybeam.asm"
INCLUDE "audio/sfx/battle_2e.asm"
INCLUDE "audio/sfx/battle_2f.asm"
INCLUDE "audio/sfx/psychic_m.asm"
INCLUDE "audio/sfx/battle_31.asm"
INCLUDE "audio/sfx/battle_32.asm"
INCLUDE "audio/sfx/battle_33.asm"
INCLUDE "audio/sfx/battle_34.asm"
INCLUDE "audio/sfx/battle_35.asm"
INCLUDE "audio/sfx/battle_36.asm"
INCLUDE "audio/sfx/intro_lunge.asm"
INCLUDE "audio/sfx/intro_hip.asm"
INCLUDE "audio/sfx/intro_hop.asm"
INCLUDE "audio/sfx/intro_raise.asm"
INCLUDE "audio/sfx/intro_crash.asm"
INCLUDE "audio/sfx/intro_whoosh.asm"
INCLUDE "audio/sfx/slots_stop_wheel.asm"
INCLUDE "audio/sfx/slots_reward.asm"
INCLUDE "audio/sfx/slots_new_spin.asm"
INCLUDE "audio/sfx/level_up.asm"
INCLUDE "audio/sfx/caught_mon.asm"
INCLUDE "audio/sfx/shooting_star.asm"
INCLUDE "audio/sfx/pokedex_rating.asm"
INCLUDE "audio/sfx/get_item1.asm"
INCLUDE "audio/sfx/get_item2.asm"
INCLUDE "audio/sfx/get_key_item.asm"

SECTION "Music 1", ROMX, BANK[AUDIO_3]
INCLUDE "audio/music/ssanne.asm"
INCLUDE "audio/music/cities2.asm"
INCLUDE "audio/music/pallettown.asm"
INCLUDE "audio/music/celadon.asm"
INCLUDE "audio/music/cinnabar.asm"
INCLUDE "audio/music/vermilion.asm"
INCLUDE "audio/music/lavender.asm"
INCLUDE "audio/music/safarizone.asm"
INCLUDE "audio/music/gym.asm"
INCLUDE "audio/music/pokecenter.asm"
INCLUDE "audio/music/gymleaderbattle.asm"
INCLUDE "audio/music/trainerbattle.asm"
INCLUDE "audio/music/wildbattle.asm"
INCLUDE "audio/music/finalbattle.asm"
INCLUDE "audio/music/defeatedtrainer.asm"
INCLUDE "audio/music/defeatedwildmon.asm"
INCLUDE "audio/music/defeatedgymleader.asm"
INCLUDE "audio/music/bikeriding.asm"
INCLUDE "audio/music/dungeon1.asm"
INCLUDE "audio/music/gamecorner.asm"
INCLUDE "audio/music/titlescreen.asm"
INCLUDE "audio/music/dungeon2.asm"
INCLUDE "audio/music/dungeon3.asm"
INCLUDE "audio/music/cinnabarmansion.asm"
INCLUDE "audio/music/pkmnhealed.asm"
INCLUDE "audio/music/routes1.asm"

SECTION "Music 4", ROMX, BANK[AUDIO_4]
INCLUDE "audio/music/routes2.asm"
INCLUDE "audio/music/routes3.asm"
INCLUDE "audio/music/routes4.asm"
INCLUDE "audio/music/indigoplateau.asm"
INCLUDE "audio/music/unusedsong.asm"
INCLUDE "audio/music/cities1.asm"
INCLUDE "audio/music/museumguy.asm"
INCLUDE "audio/music/meetprofoak.asm"
INCLUDE "audio/music/meetrival.asm"
INCLUDE "audio/music/oakslab.asm"
INCLUDE "audio/music/pokemontower.asm"
INCLUDE "audio/music/silphco.asm"
INCLUDE "audio/music/meeteviltrainer.asm"
INCLUDE "audio/music/meetfemaletrainer.asm"
INCLUDE "audio/music/meetmaletrainer.asm"
INCLUDE "audio/music/surfing.asm"
INCLUDE "audio/music/jigglypuffsong.asm"
INCLUDE "audio/music/halloffame.asm"
INCLUDE "audio/music/credits.asm"
INCLUDE "audio/music/introbattle.asm"