AudioCryEndchannel:: ; 0x9b16
	endchannel
	
GetNextMusicByte:: ; 0x9825
	push bc
	ld d, 0
	ld e, c
	ld a,[H_LOADEDROMBANK]
	push af
	
	ld hl,wChannelBanks
	add hl,de
	ld a,[hl]
	call BankswitchCommon
	
	ld hl, wChannelCommandPointers
	ld a, e
	add a
	ld e, a
	add hl, de
	
	ld a, [hli]
	ld e, a
	ld a, [hld]
	ld d, a
	
	ld a, [de] ; get next music command
	ld b,a
	inc de
	ld [hl], e ; store address of next command
	inc hl
	ld [hl], d
	
	pop af
	call BankswitchCommon
	
	ld a,b
	pop bc
	ret

PlayDefaultMusic:: ; 2307 (0:2307)
	call WaitForSoundToFinish
	xor a
	ld c, a
	ld d, a
	ld [wLastMusicSoundID], a
	jr PlayDefaultMusicCommon

PlayDefaultMusicFadeOutCurrent:: ; 2312 (0:2312)
; Fade out the current music and then play the default music.
	ld c, 10
	ld d, 0
	ld a, [wd72e]
	bit 5, a ; has a battle just ended?
	jr z, PlayDefaultMusicCommon
	xor a
	ld [wLastMusicSoundID], a
	ld c, 8
	ld d, c

PlayDefaultMusicCommon:: ; 2324 (0:2324)
	ld a, [wWalkBikeSurfState]
	and a
	jr z, .walking
	cp $2
	jr z, .surfing
	ld a, MUSIC_BIKE_RIDING
	jr .next

.surfing
	ld a, MUSIC_SURFING

.next
	ld b, a
	ld a, d
	and a ; should current music be faded out first?
	ld a, BANK(Music_BikeRiding)
	jr nz, .next2

; Only change the audio ROM bank if the current music isn't going to be faded
; out before the default music begins.
	ld [wAudioROMBank], a

.next2
; [wAudioSavedROMBank] will be copied to [wAudioROMBank] after fading out the
; current music (if the current music is faded out).
	ld [wAudioSavedROMBank], a
	jr .next3

.walking
	ld a, [wMapMusicSoundID]
	ld b, a
	call CompareMapMusicBankWithCurrentBank
	jr c, .next4

.next3
	ld a, [wLastMusicSoundID]
	cp b ; is the default music already playing?
	ret z ; if so, do nothing

.next4
	ld a, c
	ld [wAudioFadeOutControl], a
	ld a, b
	ld [wLastMusicSoundID], a
	ld [wNewSoundID], a
	jp PlaySound

UpdateMusic6Times:: ; 235f (0:235f)
; This is called when entering a map, before fading out the current music and
; playing the default music (i.e. the map's music or biking/surfing music).
	lb bc, AUDIO_1, 6
	ld hl, Audio_UpdateMusic
.loop
	push bc
	push hl
	call Bankswitch
	pop hl
	pop bc
	dec c
	jr nz, .loop
	ret

CompareMapMusicBankWithCurrentBank:: ; 2385 (0:2385)
; Compares the map music's audio ROM bank with the current audio ROM bank
; and updates the audio ROM bank variables.
; Returns whether the banks are different in carry.
	ld a, [wMapMusicROMBank]
	ld e, a
	ld a, [wAudioROMBank]
	cp e
	jr nz, .differentBanks
	ld [wAudioSavedROMBank], a
	and a
	ret
.differentBanks
	ld a, c ; this is a fade-out counter value and it's always non-zero
	and a
	ld a, e
	jr nz, .next
; If the fade-counter is non-zero, we don't change the audio ROM bank because
; it's needed to keep playing the music as it fades out. The FadeOutAudio
; routine will take care of copying [wAudioSavedROMBank] to [wAudioROMBank]
; when the music has faded out.
	ld [wAudioROMBank], a
.next
	ld [wAudioSavedROMBank], a
	scf
	ret

PlayMusic:: ; 23a1 (0:23a1)
	ld b, a
	ld [wNewSoundID], a
	xor a
	ld [wAudioFadeOutControl], a
	ld a, c
	ld [wAudioROMBank], a
	ld [wAudioSavedROMBank], a
	ld a, b

; plays music specified by a. If value is $ff, music is stopped
PlaySound:: ; 23b1 (0:23b1)
	push hl
	push de
	push bc
	ld b, a
	ld a, [wNewSoundID]
	and a
	jr z, .next
	xor a
	ld [wChannelSoundIDs + CH4], a
	ld [wChannelSoundIDs + CH5], a
	ld [wChannelSoundIDs + CH6], a
	ld [wChannelSoundIDs + CH7], a
.next
	ld a, [wAudioFadeOutControl]
	and a ; has a fade-out length been specified?
	jr z, .noFadeOut
	ld a, [wNewSoundID]
	and a ; is the new sound ID 0?
	jr z, .done ; if so, do nothing
	xor a
	ld [wNewSoundID], a
	ld a, [wLastMusicSoundID]
	cp $ff ; has the music been stopped?
	jr nz, .fadeOut ; if not, fade out the current music
; If it has been stopped, start playing the new music immediately.
	xor a
	ld [wAudioFadeOutControl], a
.noFadeOut
	xor a
	ld [wNewSoundID], a
	ld a, [H_LOADEDROMBANK]
	ld [hSavedROMBank], a
	ld a, AUDIO_1
	ld [H_LOADEDROMBANK], a
	ld [MBC1RomBank], a
	ld a,b
	call Audio_PlaySound
	ld a, [hSavedROMBank]
	ld [H_LOADEDROMBANK], a
	ld [MBC1RomBank], a
	jr .done

.fadeOut
	ld a, b
	ld [wLastMusicSoundID], a
	ld a, [wAudioFadeOutControl]
	ld [wAudioFadeOutCounterReloadValue], a
	ld [wAudioFadeOutCounter], a
	ld a, b
	ld [wAudioFadeOutControl], a

.done
	pop bc
	pop de
	pop hl
	ret
