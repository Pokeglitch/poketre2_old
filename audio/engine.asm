Audio_UpdateMusic:: ; 0x9103
	ld c, CH0
.loop
	ld b, 0
	ld hl, wChannelSoundIDs
	add hl, bc
	ld a, [hl]
	and a
	jr z, .nextChannel
	ld a, c
	cp CH4
	jr nc, .applyAffects ; if sfx channel
	ld a, [wMuteAudioAndPauseMusic]
	and a
	jr z, .applyAffects
	bit 7, a
	jr nz, .nextChannel
	set 7, a
	ld [wMuteAudioAndPauseMusic], a
	xor a ; disable all channels' output
	ld [rNR51], a
	ld [rNR30], a
	ld a, $80
	ld [rNR30], a
	jr .nextChannel
.applyAffects
	call Audio_ApplyMusicAffects
.nextChannel
	ld a, c
	inc c ; inc channel number
	cp CH7
	jr nz, .loop
	ret

; this routine checks flags for music effects currently applied
; to the channel and calls certain functions based on flags.
Audio_ApplyMusicAffects: ; 0x9138
	ld b, $0
	ld hl, wChannelNoteDelayCounters ; delay until next note
	add hl, bc
	ld a, [hl]
	cp $1 ; if the delay is 1, play next note
	jp z, Audio_PlayNextNote
	dec a ; otherwise, decrease the delay timer
	ld [hl], a
	ld a, c
	cp CH4
	jr nc, .startChecks ; if a sfx channel
	ld hl, wChannelSoundIDs + CH4
	add hl, bc
	ld a, [hl]
	and a
	jr z, .startChecks
	ret
.startChecks
	ld hl, wChannelFlags1
	add hl, bc
	bit BIT_ROTATE_DUTY, [hl]
	jr z, .checkForExecuteMusic
	call Audio_ApplyDutyCycle
.checkForExecuteMusic
	ld b, 0
	ld hl, wChannelFlags2
	add hl, bc
	bit BIT_EXECUTE_MUSIC, [hl]
	jr nz, .checkForPitchBend
	ld hl, wChannelFlags1
	add hl, bc
	bit BIT_NOISE_OR_SFX, [hl]
	jr nz, .skipPitchBendVibrato
.checkForPitchBend
	ld hl, wChannelFlags1
	add hl, bc
	bit BIT_PITCH_BEND_ON, [hl]
	jr z, .checkVibratoDelay
	jp Audio_ApplyPitchBend
.checkVibratoDelay
	ld hl, wChannelVibratoDelayCounters
	add hl, bc
	ld a, [hl]
	and a ; check if delay is over
	jr z, .checkForVibrato
	dec [hl] ; otherwise, dec delay
.skipPitchBendVibrato
	ret
.checkForVibrato
	ld hl, wChannelVibratoExtents
	add hl, bc
	ld a, [hl]
	and a
	jr nz, .vibrato
	ret ; no vibrato
.vibrato
	ld d, a
	ld hl, wChannelVibratoRates
	add hl, bc
	ld a, [hl]
	and $f
	and a
	jr z, .applyVibrato
	dec [hl] ; decrement counter
	ret
.applyVibrato
	ld a, [hl]
	swap [hl]
	or [hl]
	ld [hl], a ; reload the counter
	ld hl, wChannelFrequencyLowBytes
	add hl, bc
	ld e, [hl] ; get note pitch
	ld hl, wChannelFlags1
	add hl, bc
; This is the only code that sets/resets the vibrato direction bit, so it
; continuously alternates which path it takes.
	bit BIT_VIBRATO_DIRECTION, [hl]
	jr z, .unset
	res BIT_VIBRATO_DIRECTION, [hl]
	ld a, d
	and $f
	ld d, a
	ld a, e
	sub d
	jr nc, .noCarry
	ld a, 0
.noCarry
	jr .done
.unset
	set BIT_VIBRATO_DIRECTION, [hl]
	ld a, d
	and $f0
	swap a
	add e
	jr nc, .done
	ld a, $ff
.done
	ld d, a
	ld b, REG_FREQUENCY_LO
	call Audio_GetRegisterPointer
	ld [hl], d
	ret

; this routine executes all music commands that take up no time,
; like tempo changes, duty changes etc. and doesn't return
; until the first note is reached
Audio_PlayNextNote: ; 0x91d0
; reload the vibrato delay counter
	ld hl, wChannelVibratoDelayCounterReloadValues
	add hl, bc
	ld a, [hl]
	ld hl, wChannelVibratoDelayCounters
	add hl, bc
	ld [hl], a

	ld hl, wChannelFlags1
	add hl, bc
	res BIT_PITCH_BEND_ON, [hl]
	res BIT_PITCH_BEND_DECREASING, [hl]
	call Audio_NextCommand
	ret

Audio_NextCommand: ; 0x91e6
	call GetNextMusicByte
	ld d, a
	cp $ff ; is this command an endchannel?
	jp nz, Audio_callchannel ; no
	ld b, 0
	ld hl, wChannelFlags1
	add hl, bc
	bit BIT_CHANNEL_CALL, [hl]
	jr nz, .returnFromCall
	ld a, c
	cp CH3
	jr nc, .noiseOrSfxChannel
	jr .disableChannelOutput
.noiseOrSfxChannel
	res BIT_NOISE_OR_SFX, [hl]
	ld hl, wChannelFlags2
	add hl, bc
	res BIT_EXECUTE_MUSIC, [hl]
	cp CH6
	jr nz, .skipSfxChannel3
; restart hardware channel 3 (wave channel) output
	ld a, $0
	ld [rNR30], a
	ld a, $80
	ld [rNR30], a
.skipSfxChannel3
	jr nz, .asm_9222
	ld a, [wDisableChannelOutputWhenSfxEnds]
	and a
	jr z, .asm_9222
	xor a
	ld [wDisableChannelOutputWhenSfxEnds], a
	jr .disableChannelOutput
.asm_9222
	jr .asm_9248
.returnFromCall
	res 1, [hl]
	ld d, $0
	ld a, c
	add a
	ld e, a
	ld hl, wChannelCommandPointers
	add hl, de
	push hl ; store current channel address
	ld hl, wChannelReturnAddresses
	add hl, de
	ld e, l
	ld d, h
	pop hl
	ld a, [de]
	ld [hli], a
	inc de
	ld a, [de]
	ld [hl], a ; loads channel address to return to
	jp Audio_NextCommand
.disableChannelOutput
	ld hl, Audio_HWChannelDisableMasks
	add hl, bc
	ld a, [rNR51]
	and [hl]
	ld [rNR51], a
.asm_9248
	call Audio_IsCry
	jr nc,.skipCry

	;otherwise, it is a cry
	ld a, c
	cp CH4
	jr z, .asm_9265
	call Audio_GoBackOneCommandIfCry
	ret c
.asm_9265
	ld a, [wSavedVolume]
	ld [rNR50], a
	xor a
	ld [wSavedVolume], a
.skipCry
	ld hl, wChannelSoundIDs
	add hl, bc
	ld [hl], b		;zero the sound id
	ret

Audio_callchannel: ; 0x9274
	cp $fd ; is this command a callchannel?
	jp nz, Audio_loopchannel ; no
	call GetNextMusicByte
	push af
	call GetNextMusicByte
	ld d, a
	pop af
	ld e, a
	push de ; store pointer
	ld d, $0
	ld a, c
	add a
	ld e, a
	ld hl, wChannelCommandPointers
	add hl, de
	push hl
	ld hl, wChannelReturnAddresses
	add hl, de
	ld e, l
	ld d, h
	pop hl
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hld]
	ld [de], a ; copy current channel address
	pop de
	ld [hl], e
	inc hl
	ld [hl], d ; overwrite current address with pointer
	ld b, $0
	ld hl, wChannelFlags1
	add hl, bc
	set BIT_CHANNEL_CALL, [hl] ; set the call flag
	jp Audio_NextCommand

Audio_loopchannel: ; 0x92a9
	cp $fe ; is this command a loopchannel?
	jp nz, Audio_notetype ; no
	call GetNextMusicByte
	ld e, a
	and a
	jr z, .infiniteLoop
	ld b, 0
	ld hl, wChannelLoopCounters
	add hl, bc
	ld a, [hl]
	cp e
	jr nz, .loopAgain
	ld a, $1 ; if no more loops to make,
	ld [hl], a
	call GetNextMusicByte ; skip pointer
	call GetNextMusicByte
	jp Audio_NextCommand
.loopAgain ; inc loop count
	inc a
	ld [hl], a
	; fall through
.infiniteLoop ; overwrite current address with pointer
	call GetNextMusicByte
	push af
	call GetNextMusicByte
	ld b, a
	ld d, $0
	ld a, c
	add a
	ld e, a
	ld hl, wChannelCommandPointers
	add hl, de
	pop af
	ld [hli], a
	ld [hl], b
	jp Audio_NextCommand

Audio_notetype: ; 0x92e4
	and $f0
	cp $d0 ; is this command a notetype?
	jp nz, Audio_toggleperfectpitch ; no
	ld a, d
	and $f
	ld b, $0
	ld hl, wChannelNoteSpeeds
	add hl, bc
	ld [hl], a ; store low nibble as speed
	ld a, c
	cp CH3
	jr z, .noiseChannel ; noise channel has 0 params
	call GetNextMusicByte
	ld d, a
	ld a, c
	cp CH2
	jr z, .musicChannel3
	cp CH6
	jr nz, .skipChannel3
	ld hl, wSfxWaveInstrument
	jr .channel3
.musicChannel3
	ld hl, wMusicWaveInstrument
.channel3
	ld a, d
	and $f
	ld [hl], a ; store low nibble of param as wave instrument
	ld a, d
	and $30
	sla a
	ld d, a
	; fall through

	; if channel 3, store high nibble as volume
	; else, store volume (high nibble) and fade (low nibble)
.skipChannel3
	ld b, 0
	ld hl, wChannelVolumes
	add hl, bc
	ld [hl], d
.noiseChannel
	jp Audio_NextCommand

Audio_toggleperfectpitch: ; 0x9323
	ld a, d
	cp $e8 ; is this command a toggleperfectpitch?
	jr nz, Audio_vibrato ; no
	ld b, 0
	ld hl, wChannelFlags1
	add hl, bc
	ld a, [hl]
	xor $1
	ld [hl], a ; flip bit 0 of wChannelFlags1
	jp Audio_NextCommand

Audio_vibrato: ; 0x9335
	cp $ea ; is this command a vibrato?
	jr nz, Audio_pitchbend ; no
	call GetNextMusicByte
	ld b, 0
	ld hl, wChannelVibratoDelayCounters
	add hl, bc
	ld [hl], a ; store delay
	ld hl, wChannelVibratoDelayCounterReloadValues
	add hl, bc
	ld [hl], a ; store delay
	call GetNextMusicByte
	ld d, a

; The high nybble of the command byte is the extent of the vibrato.
; Let n be the extent.
; The upper nybble of the channel's byte in the wChannelVibratoExtents
; array will store the extent above the note: (n / 2) + (n % 2).
; The lower nybble will store the extent below the note: (n / 2).
; These two values add to the total extent, n.
	and $f0
	swap a
	ld b, 0
	ld hl, wChannelVibratoExtents
	add hl, bc
	srl a
	ld e, a
	adc b
	swap a
	or e
	ld [hl], a

; The low nybble of the command byte is the rate of the vibrato.
; The high and low nybbles of the channel's byte in the wChannelVibratoRates
; array are both initialised to this value because the high nybble is the
; counter reload value and the low nybble is the counter itself, which should
; start at its value upon reload.
	ld a, d
	and $f
	ld d, a
	ld hl, wChannelVibratoRates
	add hl, bc
	swap a
	or d
	ld [hl], a

	jp Audio_NextCommand

Audio_pitchbend: ; 0x936d
	cp $eb ; is this command a pitchbend?
	jr nz, Audio_duty ; no
	call GetNextMusicByte
	ld b, 0
	ld hl, wChannelPitchBendLengthModifiers
	add hl, bc
	ld [hl], a
	call GetNextMusicByte
	ld d, a
	and $f0
	swap a
	ld b, a
	ld a, d
	and $f
	call Audio_CalculateFrequency
	ld b, 0
	ld hl, wChannelPitchBendTargetFrequencyHighBytes
	add hl, bc
	ld [hl], d
	ld hl, wChannelPitchBendTargetFrequencyLowBytes
	add hl, bc
	ld [hl], e
	ld b, 0
	ld hl, wChannelFlags1
	add hl, bc
	set BIT_PITCH_BEND_ON, [hl]
	call GetNextMusicByte
	ld d, a
	jp Audio_notelength

Audio_duty: ; 0x93a5
	cp $ec ; is this command a duty?
	jr nz, Audio_tempo ; no
	call GetNextMusicByte
	rrca
	rrca
	and $c0
	ld b, 0
	ld hl, wChannelDuties
	add hl, bc
	ld [hl], a ; store duty
	jp Audio_NextCommand

Audio_tempo: ; 0x93ba
	cp $ed ; is this command a tempo?
	jr nz, Audio_stereopanning ; no
	ld a, c
	cp CH4
	jr nc, .sfxChannel
	call GetNextMusicByte
	ld [wMusicTempo], a ; store first param
	call GetNextMusicByte
	ld [wMusicTempo + 1], a ; store second param
	xor a
	ld [wChannelNoteDelayCountersFractionalPart], a ; clear RAM
	ld [wChannelNoteDelayCountersFractionalPart + 1], a
	ld [wChannelNoteDelayCountersFractionalPart + 2], a
	ld [wChannelNoteDelayCountersFractionalPart + 3], a
	jr .musicChannelDone
.sfxChannel
	call GetNextMusicByte
	ld [wSfxTempo], a ; store first param
	call GetNextMusicByte
	ld [wSfxTempo + 1], a ; store second param
	xor a
	ld [wChannelNoteDelayCountersFractionalPart + 4], a ; clear RAM
	ld [wChannelNoteDelayCountersFractionalPart + 5], a
	ld [wChannelNoteDelayCountersFractionalPart + 6], a
	ld [wChannelNoteDelayCountersFractionalPart + 7], a
.musicChannelDone
	jp Audio_NextCommand

Audio_stereopanning: ; 0x93fa
	cp $ee ; is this command a stereopanning?
	jr nz, Audio_PlayNestedSound ; no
	call GetNextMusicByte
	ld [wStereoPanning], a ; store panning
	jp Audio_NextCommand

; this appears to never be used
Audio_PlayNestedSound: ; 0x9407
	cp $ef ; is this command a Play Sound?
	jr nz, Audio_dutycycle ; no
	call GetNextMusicByte
	push bc
	call Audio_PlaySound
	pop bc
	ld a, [wDisableChannelOutputWhenSfxEnds]
	and a
	jr nz, .skip
	ld a, [wChannelSoundIDs + CH7]
	ld [wDisableChannelOutputWhenSfxEnds], a
	xor a
	ld [wChannelSoundIDs + CH7], a
.skip
	jp Audio_NextCommand

Audio_dutycycle: ; 0x9426
	cp $fc ; is this command a dutycycle?
	jr nz, Audio_volume ; no
	call GetNextMusicByte
	ld b, 0
	ld hl, wChannelDutyCycles
	add hl, bc
	ld [hl], a ; store full cycle
	and $c0
	ld hl, wChannelDuties
	add hl, bc
	ld [hl], a ; store first duty
	ld hl, wChannelFlags1
	add hl, bc
	set BIT_ROTATE_DUTY, [hl]
	jp Audio_NextCommand

Audio_volume: ; 0x9444
	cp $f0 ; is this command a volume?
	jr nz, Audio_executemusic ; no
	call GetNextMusicByte
	ld [rNR50], a ; store volume
	jp Audio_NextCommand

Audio_executemusic: ; 0x9450
	cp $f8 ; is this command an executemusic?
	jr nz, Audio_octave ; no
	ld b, $0
	ld hl, wChannelFlags2
	add hl, bc
	set BIT_EXECUTE_MUSIC, [hl]
	jp Audio_NextCommand

Audio_octave: ; 0x945f
	and $f0
	cp $e0 ; is this command an octave?
	jr nz, Audio_sound_noise ; no
	ld hl, wChannelOctaves
	ld b, 0
	add hl, bc
	ld a, d
	and $f
	ld [hl], a ; store low nibble as octave
	jp Audio_NextCommand

Audio_sound_noise:: ; 0x9472
	cp $20 ; is this command a sound/noise?
	jr nz, Audio_sweep
	ld a, c
	cp CH3 ; is this a noise or sfx channel?
	jr c, Audio_sweep ; no
	ld b, 0
	ld hl, wChannelFlags2
	add hl, bc
	bit BIT_EXECUTE_MUSIC, [hl] ; is executemusic being used?
	jr nz, Audio_sweep ; yes
	call Audio_notelength

; This code seems to do the same thing as what Audio_ApplyDutyAndSoundLength
; does below.
	ld d, a
	ld b, 0
	ld hl, wChannelDuties
	add hl, bc
	ld a, [hl]
	or d
	ld d, a
	ld b, REG_DUTY_SOUND_LEN
	call Audio_GetRegisterPointer
	ld [hl], d

	call GetNextMusicByte
	ld d, a
	ld b, REG_VOLUME_ENVELOPE
	call Audio_GetRegisterPointer
	ld [hl], d
	call GetNextMusicByte
	ld e, a
	ld a, c
	cp CH7
	ld a, 0
	jr z, .skip
; Channels 1 through 3 have 2 registers that control frequency, but the noise
; channel a single register (the polynomial counter) that controls frequency,
; so this command has one less byte on the noise channel.
	push de
	call GetNextMusicByte
	pop de
.skip
	ld d, a
	push de
	call Audio_ApplyDutyAndSoundLength
	call Audio_EnableChannelOutput
	pop de
	call Audio_ApplyWavePatternAndFrequency
	ret

Audio_sweep:
	ld a, c
	cp CH4
	jr c, Audio_note ; if not a sfx
	ld a, d
	cp $10 ; is this command a unknownsfx0x10?
	jr nz, Audio_note ; no
	ld b, $0
	ld hl, wChannelFlags2
	add hl, bc
	bit BIT_EXECUTE_MUSIC, [hl]
	jr nz, Audio_note ; no
	call GetNextMusicByte
	ld [rNR10], a
	jp Audio_NextCommand

Audio_note:
	ld a, c
	cp CH3
	jr nz, Audio_notelength ; if not noise channel
	ld a, d
	and $f0
	cp $b0 ; is this command a dnote?
	jr z, Audio_dnote
	jr nc, Audio_notelength ; no
	swap a
	ld b, a
	ld a, d
	and $f
	ld d, a
	ld a, b
	push de
	push bc
	jr asm_94fd

Audio_dnote:
	ld a, d
	and $f
	push af
	push bc
	call GetNextMusicByte ; get dnote instrument
asm_94fd
	ld d, a
	ld a, [wDisableChannelOutputWhenSfxEnds]
	and a
	jr nz, .asm_9508
	ld a, d
	call Audio_PlaySound
.asm_9508
	pop bc
	pop de

Audio_notelength: ; 0x950a
	ld a, d
	push af
	and $f
	inc a
	ld b, 0
	ld e, a  ; store note length (in 16ths)
	ld d, b
	ld hl, wChannelNoteSpeeds
	add hl, bc
	ld a, [hl]
	ld l, b
	call Audio_MultiplyAdd
	ld a, c
	cp CH4
	jr nc, .sfxChannel
	ld a, [wMusicTempo]
	ld d, a
	ld a, [wMusicTempo + 1]
	ld e, a
	jr .skip
.sfxChannel
	ld d, $1
	ld e, $0
	cp CH7
	jr z, .skip ; if noise channel
	call Audio_SetSfxTempo
	ld a, [wSfxTempo]
	ld d, a
	ld a, [wSfxTempo + 1]
	ld e, a
.skip
	ld a, l ; a = note_length * note_speed
	ld b, 0
	ld hl, wChannelNoteDelayCountersFractionalPart
	add hl, bc
	ld l, [hl]
	call Audio_MultiplyAdd
	ld e, l
	ld d, h ; de = note_delay_frac_part + (note_length * note_speed * tempo)
	ld hl, wChannelNoteDelayCountersFractionalPart
	add hl, bc
	ld [hl], e
	ld a, d
	ld hl, wChannelNoteDelayCounters
	add hl, bc
	ld [hl], a
	ld hl, wChannelFlags2
	add hl, bc
	bit BIT_EXECUTE_MUSIC, [hl]
	jr nz, Audio_notepitch
	ld hl, wChannelFlags1
	add hl, bc
	bit BIT_NOISE_OR_SFX, [hl]
	jr z, Audio_notepitch
	pop hl
	ret

Audio_notepitch: ; 0x9568
	pop af
	and $f0
	cp $c0 ; compare to rest
	jr nz, .notRest
	ld a, c
	cp CH4
	jr nc, .next
; If this isn't an SFX channel, try the corresponding SFX channel.
	ld hl, wChannelSoundIDs + CH4
	add hl, bc
	ld a, [hl]
	and a
	jr nz, .done
	; fall through
.next
	ld a, c
	cp CH2
	jr z, .channel3
	cp CH6
	jr nz, .notChannel3
.channel3
	ld b, 0
	ld hl, Audio_HWChannelDisableMasks
	add hl, bc
	ld a, [rNR51]
	and [hl]
	ld [rNR51], a ; disable hardware channel 3's output
	jr .done
.notChannel3
	ld b, REG_VOLUME_ENVELOPE
	call Audio_GetRegisterPointer
	ld a, $8 ; fade in sound
	ld [hli], a
	inc hl
	ld a, $80 ; restart sound
	ld [hl], a
.done
	ret
.notRest
	swap a
	ld b, 0
	ld hl, wChannelOctaves
	add hl, bc
	ld b, [hl]
	call Audio_CalculateFrequency
	ld b, 0
	ld hl, wChannelFlags1
	add hl, bc
	bit BIT_PITCH_BEND_ON, [hl]
	jr z, .skipPitchBend
	call Audio_InitPitchBendVars
.skipPitchBend
	push de
	ld a, c
	cp CH4
	jr nc, .sfxChannel ; if sfx channel
; If this isn't an SFX channel, try the corresponding SFX channel.
	ld hl, wChannelSoundIDs + CH4
	ld d, 0
	ld e, a
	add hl, de
	ld a, [hl]
	and a
	jr z,.sfxChannel

	pop de
	ret
.sfxChannel
	ld b, 0
	ld hl, wChannelVolumes
	add hl, bc
	ld d, [hl]
	ld b, REG_VOLUME_ENVELOPE
	call Audio_GetRegisterPointer
	ld [hl], d
	call Audio_ApplyDutyAndSoundLength
	call Audio_EnableChannelOutput
	pop de
	ld b, $0
	ld hl, wChannelFlags1
	add hl, bc
	bit BIT_PERFECT_PITCH, [hl] ; has toggleperfectpitch been used?
	jr z, .skipFrequencyInc
	inc e                       ; if yes, increment the frequency by 1
	jr nc, .skipFrequencyInc
	inc d
.skipFrequencyInc
	ld hl, wChannelFrequencyLowBytes
	add hl, bc
	ld [hl], e
	call Audio_ApplyWavePatternAndFrequency
	ret

Audio_EnableChannelOutput: ; 0x95f8
	ld b, 0
	ld hl, Audio_HWChannelEnableMasks
	add hl, bc
	ld a, [rNR51]
	or [hl] ; set this channel's bits
	ld d, a
	ld a, c
	cp CH7
	jr z, .noiseChannelOrNoSfx
	cp CH4
	jr nc, .skip ; if sfx channel
; If this isn't an SFX channel, try the corresponding SFX channel.
	ld hl, wChannelSoundIDs + CH4
	add hl, bc
	ld a, [hl]
	and a
	jr nz, .skip
.noiseChannelOrNoSfx
; If this is the SFX noise channel or a music channel whose corresponding
; SFX channel is off, apply stereo panning.
	ld a, [wStereoPanning]
	ld hl, Audio_HWChannelEnableMasks
	add hl, bc
	and [hl]
	ld d, a
	ld a, [rNR51]
	ld hl, Audio_HWChannelDisableMasks
	add hl, bc
	and [hl] ; reset this channel's output bits
	or d ; set this channel's output bits that enabled in [wStereoPanning]
	ld d, a
.skip
	ld a, d
	ld [rNR51], a
	ret

Audio_ApplyDutyAndSoundLength: ; 0x9629
	ld b, 0
	ld hl, wChannelNoteDelayCounters ; use the note delay as sound length
	add hl, bc
	ld d, [hl]
	ld a, c
	cp CH2
	jr z, .skipDuty ; if music channel 3
	cp CH6
	jr z, .skipDuty ; if sfx channel 3
; include duty (except on channel 3 which doesn't have it)
	ld a, d
	and $3f
	ld d, a
	ld hl, wChannelDuties
	add hl, bc
	ld a, [hl]
	or d
	ld d, a
.skipDuty
	ld b, REG_DUTY_SOUND_LEN
	call Audio_GetRegisterPointer
	ld [hl], d
	ret

Audio_ApplyWavePatternAndFrequency: ; 0x964b
	ld a, c
	cp CH2
	jr z, .channel3
	cp CH6
	jr nz, .notChannel3
	; fall through
.channel3
	push de
	ld de, wMusicWaveInstrument
	cp CH2
	jr z, .next
	ld de, wSfxWaveInstrument
.next
	ld a, [de]
	add a
	ld d, 0
	ld e, a
	ld hl, Audio_WavePointers
	add hl, de
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld hl, $ff30 ; wave pattern RAM
	ld b, $f
	ld a, $0 ; stop hardware channel 3
	ld [rNR30], a
.loop
	ld a, [de]
	inc de
	ld [hli], a
	ld a, b
	dec b
	and a
	jr nz, .loop
	ld a, $80 ; start hardware channel 3
	ld [rNR30], a
	pop de
.notChannel3
	ld a, d
	or $80 ; use counter mode (i.e. disable output when the counter reaches 0)
	and $c7 ; zero the unused bits in the register
	ld d, a
	ld b, REG_FREQUENCY_LO
	call Audio_GetRegisterPointer
	ld [hl], e ; store frequency low byte
	inc hl
	ld [hl], d ; store frequency high byte
	call Audio_ApplyFrequencyModifier
	ret

Audio_SetSfxTempo: ; 0x9693
	call Audio_IsCry
	jr nc, .notCry
	ld d, 0
	ld a, [wTempoModifier]
	add $80
	jr nc, .next
	inc d
.next
	ld [wSfxTempo + 1], a
	ld a, d
	ld [wSfxTempo], a
	jr .done
.notCry
	xor a
	ld [wSfxTempo + 1], a
	ld a, $1
	ld [wSfxTempo], a
.done
	ret

Audio_ApplyFrequencyModifier: ; 0x96b5
	call Audio_IsCry
	jr nc, .done
; if playing a cry, add the cry's frequency modifier
	ld a, [wFrequencyModifier]
	add e
	jr nc, .noCarry
	inc d
.noCarry
	dec hl
	ld e, a
	ld [hl], e
	inc hl
	ld [hl], d
.done
	ret

Audio_GoBackOneCommandIfCry: ; 0x96c7
	call Audio_IsCry
	jr nc, .done
	ld hl, wChannelCommandPointers
	ld e, c
	ld d, 0
	sla e
	rl d
	add hl, de
	ld a, [hl]
	sub 1
	ld [hl], a
	inc hl
	ld a, [hl]
	sbc 0
	ld [hl], a
	scf
	ret
.done
	scf
	ccf
	ret

Audio_IsCry: ; 0x96e5
; Returns whether the currently playing audio is a cry in carry.
	ld a, [wChannelSoundIDs + CH4]
	cp CRY_SFX_START
	jr c,.no
	
	cp CRY_SFX_END
	jr c, .yes
.no
	scf
	ccf
	ret
.yes
	scf
	ret

Audio_ApplyPitchBend: ; 0x96f9
	ld hl, wChannelFlags1
	add hl, bc
	bit BIT_PITCH_BEND_DECREASING, [hl]
	jp nz, .frequencyDecreasing
; frequency increasing
	ld hl, wChannelPitchBendCurrentFrequencyLowBytes
	add hl, bc
	ld e, [hl]
	ld hl, wChannelPitchBendCurrentFrequencyHighBytes
	add hl, bc
	ld d, [hl]
	ld hl, wChannelPitchBendFrequencySteps
	add hl, bc
	ld l, [hl]
	ld h, b
	add hl, de
	ld d, h
	ld e, l
	ld hl, wChannelPitchBendCurrentFrequencyFractionalPart
	add hl, bc
	push hl
	ld hl, wChannelPitchBendFrequencyStepsFractionalPart
	add hl, bc
	ld a, [hl]
	pop hl
	add [hl]
	ld [hl], a
	ld a, 0
	adc e
	ld e, a
	ld a, 0
	adc d
	ld d, a
	ld hl, wChannelPitchBendTargetFrequencyHighBytes
	add hl, bc
	ld a, [hl]
	cp d
	jp c, .reachedTargetFrequency
	jr nz, .applyUpdatedFrequency
	ld hl, wChannelPitchBendTargetFrequencyLowBytes
	add hl, bc
	ld a, [hl]
	cp e
	jp c, .reachedTargetFrequency
	jr .applyUpdatedFrequency
.frequencyDecreasing
	ld hl, wChannelPitchBendCurrentFrequencyLowBytes
	add hl, bc
	ld a, [hl]
	ld hl, wChannelPitchBendCurrentFrequencyHighBytes
	add hl, bc
	ld d, [hl]
	ld hl, wChannelPitchBendFrequencySteps
	add hl, bc
	ld e, [hl]
	sub e
	ld e, a
	ld a, d
	sbc b
	ld d, a
	ld hl, wChannelPitchBendFrequencyStepsFractionalPart
	add hl, bc
	ld a, [hl]
	add a
	ld [hl], a
	ld a, e
	sbc b
	ld e, a
	ld a, d
	sbc b
	ld d, a
	ld hl, wChannelPitchBendTargetFrequencyHighBytes
	add hl, bc
	ld a, d
	cp [hl]
	jr c, .reachedTargetFrequency
	jr nz, .applyUpdatedFrequency
	ld hl, wChannelPitchBendTargetFrequencyLowBytes
	add hl, bc
	ld a, e
	cp [hl]
	jr c, .reachedTargetFrequency
.applyUpdatedFrequency
	ld hl, wChannelPitchBendCurrentFrequencyLowBytes
	add hl, bc
	ld [hl], e
	ld hl, wChannelPitchBendCurrentFrequencyHighBytes
	add hl, bc
	ld [hl], d
	ld b, REG_FREQUENCY_LO
	call Audio_GetRegisterPointer
	ld a, e
	ld [hli], a
	ld [hl], d
	ret
.reachedTargetFrequency
; Turn off pitch bend when the target frequency has been reached.
	ld hl, wChannelFlags1
	add hl, bc
	res BIT_PITCH_BEND_ON, [hl]
	res BIT_PITCH_BEND_DECREASING, [hl]
	ret

Audio_InitPitchBendVars: ; 0x978f
	ld hl, wChannelPitchBendCurrentFrequencyHighBytes
	add hl, bc
	ld [hl], d
	ld hl, wChannelPitchBendCurrentFrequencyLowBytes
	add hl, bc
	ld [hl], e
	ld hl, wChannelNoteDelayCounters
	add hl, bc
	ld a, [hl]
	ld hl, wChannelPitchBendLengthModifiers
	add hl, bc
	sub [hl]
	jr nc, .next
	ld a, 1
.next
	ld [hl], a
	ld hl, wChannelPitchBendTargetFrequencyLowBytes
	add hl, bc
	ld a, e
	sub [hl]
	ld e, a
	ld a, d
	sbc b
	ld hl, wChannelPitchBendTargetFrequencyHighBytes
	add hl, bc
	sub [hl]
	jr c, .targetFrequencyGreater
	ld d, a
	ld b, 0
	ld hl, wChannelFlags1
	add hl, bc
	set BIT_PITCH_BEND_DECREASING, [hl]
	jr .next2
.targetFrequencyGreater
; If the target frequency is greater, subtract the current frequency from
; the target frequency to get the absolute difference.
	ld hl, wChannelPitchBendCurrentFrequencyHighBytes
	add hl, bc
	ld d, [hl]
	ld hl, wChannelPitchBendCurrentFrequencyLowBytes
	add hl, bc
	ld e, [hl]
	ld hl, wChannelPitchBendTargetFrequencyLowBytes
	add hl, bc
	ld a, [hl]
	sub e
	ld e, a

; Bug. Instead of borrowing from the high byte of the target frequency as it
; should, it borrows from the high byte of the current frequency instead.
; This means that the result will be 0x200 greater than it should be if the
; low byte of the current frequency is greater than the low byte of the
; target frequency.
	ld a, d
	sbc b
	ld d, a

	ld hl, wChannelPitchBendTargetFrequencyHighBytes
	add hl, bc
	ld a, [hl]
	sub d
	ld d, a
	ld b, 0
	ld hl, wChannelFlags1
	add hl, bc
	res BIT_PITCH_BEND_DECREASING, [hl]

.next2
	ld hl, wChannelPitchBendLengthModifiers
	add hl, bc
.divideLoop
	inc b
	ld a, e
	sub [hl]
	ld e, a
	jr nc, .divideLoop
	ld a, d
	and a
	jr z, .doneDividing
	dec a
	ld d, a
	jr .divideLoop
.doneDividing
	ld a, e ; a = remainder - dividend
	add [hl]
	ld d, b ; d = quotient + 1
	ld b, 0
	ld hl, wChannelPitchBendFrequencySteps
	add hl, bc
	ld [hl], d ; store quotient + 1
	ld hl, wChannelPitchBendFrequencyStepsFractionalPart
	add hl, bc
	ld [hl], a ; store remainder - dividend
	ld hl, wChannelPitchBendCurrentFrequencyFractionalPart
	add hl, bc
	ld [hl], a ; store remainder - dividend
	ret

Audio_ApplyDutyCycle: ; 0x980d
	ld b, 0
	ld hl, wChannelDutyCycles
	add hl, bc
	ld a, [hl]
	rlca
	rlca
	ld [hl], a
	and $c0
	ld d, a
	ld b, REG_DUTY_SOUND_LEN
	call Audio_GetRegisterPointer
	ld a, [hl]
	and $3f
	or d
	ld [hl], a
	ret

Audio_GetRegisterPointer: ; 0x9838
; hl = address of hardware sound register b for software channel c
	ld a, c
	ld hl, Audio_HWChannelBaseAddresses
	add l
	jr nc, .noCarry
	inc h
.noCarry
	ld l, a
	ld a, [hl]
	add b
	ld l, a
	ld h, $ff
	ret

Audio_MultiplyAdd: ; 0x9847
; hl = l + (a * de)
	ld h, 0
.loop
	srl a
	jr nc, .skipAdd
	add hl, de
.skipAdd
	sla e
	rl d
	and a
	jr z, .done
	jr .loop
.done
	ret

Audio_CalculateFrequency: ; 0x9858
; return the frequency for note a, octave b in de
	ld h, 0
	ld l, a
	add hl, hl
	ld d, h
	ld e, l
	ld hl, Audio_Pitches
	add hl, de
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld a, b
.loop
	cp 7
	jr z, .done
	sra d
	rr e
	inc a
	jr .loop
.done
	ld a, 8
	add d
	ld d, a
	ret

Audio_PlaySound:: ; 0x9876
	ld [wSoundID], a
	cp $ff
	jp z, .stopAllAudio
	cp MUSIC_ID_START
	jp c, .playSfx

.playMusic
	xor a
	ld [wUnusedC000], a
	ld [wDisableChannelOutputWhenSfxEnds], a
	ld [wMusicTempo + 1], a
	ld [wMusicWaveInstrument], a
	ld [wSfxWaveInstrument], a
	ld d, $8
	ld hl, wChannelReturnAddresses
	call .FillMem
	ld hl, wChannelCommandPointers
	call .FillMem
	ld d, $4
	ld hl, wChannelSoundIDs
	call .FillMem
	ld hl, wChannelBanks
	call .FillMem
	ld hl, wChannelFlags1
	call .FillMem
	ld hl, wChannelDuties
	call .FillMem
	ld hl, wChannelDutyCycles
	call .FillMem
	ld hl, wChannelVibratoDelayCounters
	call .FillMem
	ld hl, wChannelVibratoExtents
	call .FillMem
	ld hl, wChannelVibratoRates
	call .FillMem
	ld hl, wChannelFrequencyLowBytes
	call .FillMem
	ld hl, wChannelVibratoDelayCounterReloadValues
	call .FillMem
	ld hl, wChannelFlags2
	call .FillMem
	ld hl, wChannelPitchBendLengthModifiers
	call .FillMem
	ld hl, wChannelPitchBendFrequencySteps
	call .FillMem
	ld hl, wChannelPitchBendFrequencyStepsFractionalPart
	call .FillMem
	ld hl, wChannelPitchBendCurrentFrequencyFractionalPart
	call .FillMem
	ld hl, wChannelPitchBendCurrentFrequencyHighBytes
	call .FillMem
	ld hl, wChannelPitchBendCurrentFrequencyLowBytes
	call .FillMem
	ld hl, wChannelPitchBendTargetFrequencyHighBytes
	call .FillMem
	ld hl, wChannelPitchBendTargetFrequencyLowBytes
	call .FillMem
	ld a, $1
	ld hl, wChannelLoopCounters
	call .FillMem
	ld hl, wChannelNoteDelayCounters
	call .FillMem
	ld hl, wChannelNoteSpeeds
	call .FillMem
	ld [wMusicTempo], a
	ld a, $ff
	ld [wStereoPanning], a
	xor a
	ld [rNR50], a
	ld a, $8
	ld [rNR10], a
	ld a, 0
	ld [rNR51], a
	xor a
	ld [rNR30], a
	ld a, $80
	ld [rNR30], a
	ld a, $77
	ld [rNR50], a
	jp .playSoundCommon

.playSfx
	ld l, a
	ld e, a
	ld h, 0
	ld d, h
	add hl, hl
	add hl, de
	ld de, SFX_Pointers
	add hl, de
	
	inc hl
	ld a,[hli]
	ld h,[hl]
	ld l,a		;hl = pointer
	
	ld a, h
	ld [wSfxHeaderPointer], a
	ld a, l
	ld [wSfxHeaderPointer + 1], a
	ld a, [hl]
	and $c0
	rlca
	rlca
	ld c, a
.sfxChannelLoop
	ld d, c
	ld a, c
	add a
	add c
	ld c, a
	ld b, 0
	ld a, [wSfxHeaderPointer]
	ld h, a
	ld a, [wSfxHeaderPointer + 1]
	ld l, a
	add hl, bc
	ld c, d
	ld a, [hl]
	and $f
	ld e, a ; channel ID
	ld d, 0
	ld hl, wChannelSoundIDs
	add hl, de
	ld a, [hl]
	and a
	jr z, .nextChannel		;if the channel sound id is 0, then check next channel
	ld a, e
	cp CH7
	jr nz, .compareSoundIDs		;if noise channel, compare sound ids
	
	ld a, [wSoundID]
	cp CRY_SFX_START
	ret c					;don't play sound if new sound is an instrument
	
	ld a, [hl]
	cp CRY_SFX_START
	jr c, .nextChannel		;check next channel if it is current sound is an instrument
	
.compareSoundIDs
	ld a, [wSoundID]
	cp [hl]
	ret nc				;don't play sound if new sound id is higher than current sound id
						;probably so sfx can play over music (all music ids are higher than sfx)

.nextChannel	;otherwise, stop current channel sound
	xor a
	push de
	ld h, d
	ld l, e
	add hl, hl
	ld d, h
	ld e, l
	ld hl, wChannelReturnAddresses
	add hl, de
	ld [hli], a
	ld [hl], a
	ld hl, wChannelCommandPointers
	add hl, de
	ld [hli], a
	ld [hl], a
	pop de
	ld hl, wChannelSoundIDs
	add hl, de
	ld [hl], a
	ld hl, wChannelBanks
	add hl, de
	ld [hl], a
	ld hl, wChannelFlags1
	add hl, de
	ld [hl], a
	ld hl, wChannelDuties
	add hl, de
	ld [hl], a
	ld hl, wChannelDutyCycles
	add hl, de
	ld [hl], a
	ld hl, wChannelVibratoDelayCounters
	add hl, de
	ld [hl], a
	ld hl, wChannelVibratoExtents
	add hl, de
	ld [hl], a
	ld hl, wChannelVibratoRates
	add hl, de
	ld [hl], a
	ld hl, wChannelFrequencyLowBytes
	add hl, de
	ld [hl], a
	ld hl, wChannelVibratoDelayCounterReloadValues
	add hl, de
	ld [hl], a
	ld hl, wChannelPitchBendLengthModifiers
	add hl, de
	ld [hl], a
	ld hl, wChannelPitchBendFrequencySteps
	add hl, de
	ld [hl], a
	ld hl, wChannelPitchBendFrequencyStepsFractionalPart
	add hl, de
	ld [hl], a
	ld hl, wChannelPitchBendCurrentFrequencyFractionalPart
	add hl, de
	ld [hl], a
	ld hl, wChannelPitchBendCurrentFrequencyHighBytes
	add hl, de
	ld [hl], a
	ld hl, wChannelPitchBendCurrentFrequencyLowBytes
	add hl, de
	ld [hl], a
	ld hl, wChannelPitchBendTargetFrequencyHighBytes
	add hl, de
	ld [hl], a
	ld hl, wChannelPitchBendTargetFrequencyLowBytes
	add hl, de
	ld [hl], a
	ld hl, wChannelFlags2
	add hl, de
	ld [hl], a
	ld a, $1
	ld hl, wChannelLoopCounters
	add hl, de
	ld [hl], a
	ld hl, wChannelNoteDelayCounters
	add hl, de
	ld [hl], a
	ld hl, wChannelNoteSpeeds
	add hl, de
	ld [hl], a
	ld a, e
	cp CH4
	jr nz, .asm_9a2b
	ld a, $8
	ld [rNR10], a ; sweep off
.asm_9a2b
	ld a, c
	and a
	jp z, .playSoundCommon
	dec c
	jp .sfxChannelLoop

.stopAllAudio
	ld a, $80
	ld [rNR52], a ; sound hardware on
	ld [rNR30], a ; wave playback on
	xor a
	ld [rNR51], a ; no sound output
	ld [rNR32], a ; mute channel 3 (wave channel)
	ld a, $8
	ld [rNR10], a ; sweep off
	ld [rNR12], a ; mute channel 1 (pulse channel 1)
	ld [rNR22], a ; mute channel 2 (pulse channel 2)
	ld [rNR42], a ; mute channel 4 (noise channel)
	ld a, $40
	ld [rNR14], a ; counter mode
	ld [rNR24], a
	ld [rNR44], a
	ld a, $77
	ld [rNR50], a ; full volume
	xor a
	ld [wUnusedC000], a
	ld [wDisableChannelOutputWhenSfxEnds], a
	ld [wMuteAudioAndPauseMusic], a
	ld [wMusicTempo + 1], a
	ld [wSfxTempo + 1], a
	ld [wMusicWaveInstrument], a
	ld [wSfxWaveInstrument], a
	ld d, $a0
	ld hl, wChannelCommandPointers
	call .FillMem
	ld a, $1
	ld d, $18
	ld hl, wChannelNoteDelayCounters
	call .FillMem
	ld [wMusicTempo], a
	ld [wSfxTempo], a
	ld a, $ff
	ld [wStereoPanning], a
	ret

; fills d bytes at hl with a
.FillMem
	ld b, d
.loop
	ld [hli], a
	dec b
	jr nz, .loop
	ret

.playSoundCommon
	ld a, [wSoundID]
	ld l, a
	ld e, a
	ld h, 0
	ld d, h
	add hl, hl
	add hl, de
	ld de, SFX_Pointers
	add hl, de
	
	ld a,[hli]	;c = bank
	ld [wAudioSoundIDBank],a
	ld e,[hl]
	inc hl
	ld d,[hl]	;de = pointer
	
	ld hl, wChannelCommandPointers
	ld a, [de] ; get channel number
	ld b, a
	rlca
	rlca
	and $3
	ld c, a
	ld a, b
	and $f
	ld b, c
	inc b
	inc de
	ld c, 0
.commandPointerLoop
	cp c
	jr z, .next
	inc c
	inc hl
	inc hl
	jr .commandPointerLoop
.next
	push hl
	push bc
	push af
	ld b, 0
	ld c, a
	ld hl, wChannelSoundIDs
	add hl, bc
	ld a, [wSoundID]
	ld [hl], a
	ld hl, wChannelBanks
	add hl, bc
	ld a, [wAudioSoundIDBank]
	ld [hl], a
	pop af
	cp CH3
	jr c, .skipSettingFlag
	ld hl, wChannelFlags1
	add hl, bc
	set BIT_NOISE_OR_SFX, [hl]
.skipSettingFlag
	pop bc
	pop hl
	ld a, [de] ; get channel pointer
	ld [hli], a
	inc de
	ld a, [de]
	ld [hli], a
	inc de
	inc c
	dec b
	ld a, b
	and a
	ld a, [de]
	inc de
	jr nz, .commandPointerLoop
	ld a, [wSoundID]
	cp CRY_SFX_START
	jr nc, .asm_9aeb
	jr .done
.asm_9aeb
	ld a, [wSoundID]
	cp CRY_SFX_END
	jr z, .done
	jr c, .cry
	jr .done
.cry
	ld hl, wChannelSoundIDs + CH4
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ld hl, wChannelCommandPointers + CH6 * 2 ; sfx wave channel pointer
	ld de, AudioCryEndchannel
	ld [hl], e
	inc hl
	ld [hl], d ; overwrite pointer to point to endchannel
	ld a, [wSavedVolume]
	and a
	jr nz, .done
	ld a, [rNR50]
	ld [wSavedVolume], a
	ld a, $77
	ld [rNR50], a ; full volume
.done
	ret

Audio_HWChannelBaseAddresses: ; 0x9b17
; the low bytes of each HW channel's base address
	db HW_CH1_BASE, HW_CH2_BASE, HW_CH3_BASE, HW_CH4_BASE ; channels 0-3
	db HW_CH1_BASE, HW_CH2_BASE, HW_CH3_BASE, HW_CH4_BASE ; channels 4-7

Audio_HWChannelDisableMasks: ; 0x9b1f
	db HW_CH1_DISABLE_MASK, HW_CH2_DISABLE_MASK, HW_CH3_DISABLE_MASK, HW_CH4_DISABLE_MASK ; channels 0-3
	db HW_CH1_DISABLE_MASK, HW_CH2_DISABLE_MASK, HW_CH3_DISABLE_MASK, HW_CH4_DISABLE_MASK ; channels 4-7

Audio_HWChannelEnableMasks: ; 0x9b27
	db HW_CH1_ENABLE_MASK, HW_CH2_ENABLE_MASK, HW_CH3_ENABLE_MASK, HW_CH4_ENABLE_MASK ; channels 0-3
	db HW_CH1_ENABLE_MASK, HW_CH2_ENABLE_MASK, HW_CH3_ENABLE_MASK, HW_CH4_ENABLE_MASK ; channels 4-7

Audio_Pitches: ; 0x9b2f
	dw $F82C ; C_
	dw $F89D ; C#
	dw $F907 ; D_
	dw $F96B ; D#
	dw $F9CA ; E_
	dw $FA23 ; F_
	dw $FA77 ; F#
	dw $FAC7 ; G_
	dw $FB12 ; G#
	dw $FB58 ; A_
	dw $FB9B ; A#
	dw $FBDA ; B_

