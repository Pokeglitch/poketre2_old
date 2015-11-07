;Play4BitPCM:
;	ld a,[hli]
;	ld c,a
;	ld a,[hli]
;	ld b,a			;bc = size of data
;	ld e,%11110000
;.soundLoop	
;	ld d,[hl]
;	inc hl
;	ld a,2
;.playLoop
;	call LoadNextSoundClipSample
;	swap d
;	dec a
;	jr nz, .playLoop
;	ld a,c
;	or b
;	jr nz, .soundLoop
;	ret
	

LoadNextSoundClipSample:: ; 0199 (0:0199)
	push af
	ld a,2
.loop
	dec a
	jr nz,.loop
	ld a,d
	and e
	srl a
	srl a
	ld [rNR32],a
	pop af
	ret
	
	
Play1BitPCM::
	ld a,[H_LOADEDROMBANK]
	push af
	ld a,b
	call BankswitchCommon

	ld a,[hli]
	ld c,a
	ld a,[hli]
	ld b,a			;bc = size of data
	ld e,%10000000
	
.soundLoop
	ld d,[hl]
	inc hl
	ld a,8
.playLoop
	call LoadNextSoundClipSample
	sla d
	dec a
	jr nz, .playLoop
	
	dec bc
	ld a,c
	or b
	jr nz, .soundLoop
	
	pop af
	call BankswitchCommon
	ret