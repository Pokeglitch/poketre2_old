;to display text with no effectiveness
DisplayAdditionalNoDamageText:
	ld a,[wBattleNoDamageText]
	bit 0,a		;no damage due to landscape?
	jp nz,DisplayLandscapeNoDamageText
	push af
	
	; values for player turn
	ld hl,wEnemyMonAbility1
	ld a,[H_WHOSETURN]
	and a
	jr z,.next
	ld hl,wBattleMonAbility1
.next
	ld a,[hli]
	ld d,a    ; d = type 1 of defender
	ld e,[hl] ; e = type 2 of defender
	pop af
	bit 1,a		;no damage due to ability 1?
	jr nz,DisplayAbility1NoDamageText
	bit 2,a		;no damage due to ability 2?
	jr nz,DisplayAbility2NoDamageText
	bit 3,a		;no damage due to invincibility potion?
	jr nz,DisplayInvincibilityNoDamageText
	ret
	
DisplayInvincibilityNoDamageText:
	ld hl,ProtectedByInvincibilityPotionText
	call PrintText
	jp ClearBattleTextBits

DisplayLandscapeNoDamageText:
	ld hl,wPlayerMoveNum
	ld a,[H_WHOSETURN]
	and a
	jr z,.next	;dont load enemy id if players turn
	ld hl,wEnemyMoveNum
.next
	ld a,[hl]
	ld hl,MovesFailInLandscapeNoDamageText
	ld de,3
	call IsInArray
	jr c,.printText	;if the attack failed because it only works in one landscape, then print text
	ld a,[wBattleLandscape]
	and a,$7F				;ignore the "temporary?" bit
	ld hl,LandscapeNoDamageTextTable
	ld de,3
	call IsInArray
	ret nc		;return if not in array (shouldn't happen)
.printText
	inc hl
	ld a,[hli]
	ld h,[hl]
	ld l,a		;hl now points to the text
	call PrintText
	jp ClearBattleTextBits
	
;landscapes that can reduce damage to 0 and the associated text
LandscapeNoDamageTextTable:
	db SKY_SCAPE
	dw SkyNoDamageText
	db UNDERGROUND_SCAPE
	dw UndegroundNoDamageText
	db VIRTUAL_REALITY_SCAPE
	dw VRNoDamageText
	db MOON_SCAPE
	dw MoonNoDamageText
	db $FF
	
;moves that dont work in the current landscape and the associated text:
MovesFailInLandscapeNoDamageText:
	db DIVE
	dw WaterNoDamageText
	db WATERSPOUT
	dw AttackUndergroundNoDamageText
	db ROCK_THROW
	dw NoRocksHereText
	db ICEBALL
	dw NoIceHereText
	db SNOWBALL
	dw NoSnowHereText
	db $FF

DisplayAbility1NoDamageText:
	ld a,d	;load defender ability 1 into a
	call PrintAbilityText
	jp ClearBattleTextBits
	
DisplayAbility2NoDamageText:
	ld a,e	;load defender ability 2 into a
	call PrintAbilityText
	jp ClearBattleTextBits

DisplayEffectiveness: ; 2fb7b (b:7b7b)
	ld a,[wOptions]	;check the options
	bit 5,a
	jr nz,.displayAbilityText	;if set, only display the ability and effective text
	
	ld a,[wExactDamageMultipler]	;load damage into a
	bit 7,a		;STAB?
	jr z,.skipStab	;skip stab if not
	ld hl,STABText
	call PrintText	;print STAB text
	
.skipStab
	ld a,[wBattleDamageText]	;load battle damage text into a
	bit 0,a		;landscape?
	jr z,.checkWeather
	;check to see if weather is also set
	bit 1,a		;weather?
	jr z,.landscapeOnly
	call DisplayLandscapeAndWeatherDamageEffectText	;check for landscape and weather
	jr .checkEnvironment	;skip the weather check
.landscapeOnly
	call DisplayLandscapeDamageEffectText
	jr .checkEnvironment
	
.checkWeather
	bit 1,a		;weather
	call nz,DisplayWeatherDamageEffectText

.checkEnvironment
	bit 2,a		;environment
	call nz,DisplayEnvironmentDamageEffectText
	
	bit 3,a		;time of day?
	call nz,DisplayTimeDamageEffectText
	
	call DisplayHeldItemDamageEffectText
	
.displayAbilityText
	; values for player turn
	ld hl,wBattleMonAbility1
	ld a,[hli]
	ld b,a    ; b = type 1 of attacker
	ld c,[hl] ; c = type 2 of attacker
	ld hl,wEnemyMonAbility1
	ld a,[hli]
	ld d,a    ; d = type 1 of defender
	ld e,[hl] ; e = type 2 of defender
	ld a,[H_WHOSETURN]
	and a
	jr z,.next
; values for enemy turn
	push bc
	push de
	pop bc
	pop de	; swap bc and de

.next
	ld a,[wBattleDamageText]	;load battle damage text into a
	bit 4,a	;attacker ability 1?
	call nz,DisplayAttackerAbility1EffectText
	bit 5,a	;attacker ability 2?
	call nz,DisplayAttackerAbility2EffectText
	bit 6,a	;defender ability 1?
	call nz,DisplayDefenderAbility1EffectText
	bit 7,a	;defender ability 2?
	call nz,DisplayDefenderAbility2EffectText
	
	ld a,[wAdditionalBattleBits1]
	bit 0,a		;pokemon absorbing damage?
	jr nz,ClearBattleTextBits	;don't show effectiveness if the enemy absorbed damage
	ld a, [wExactDamageMultipler]
	and a,$7F	;ignore first bit
	ld hl,EffectivenessTextTable
	ld de,3
	call IsInArray		;is the the damage in the "special text" table?
	jr nc,ClearBattleTextBits		;then don't display extra text
	inc hl
	ld a,[hli]
	ld h,[hl]
	ld l,a		;hl = pointer to text
	call PrintText
	
ClearBattleTextBits:
	xor a
	ld [wBattleDamageText],a
	ld [wBattleNoDamageText],a
	ld [wAdditionalBattleBits1],a
	ret

EffectivenessTextTable:
	db $0F
	dw HalfEffectiveText
	db $14
	dw QuarterEffectiveText
	db $1e
	dw DoubleEffectiveText
	db $32
	dw QuadrupleEffectiveText
	db $FF
	
DisplayLandscapeDamageEffectText:
	push af
	ld a,[wBattleLandscape]
	and a,$7F				;ignore the "temporary?" bit
	ld hl,LandscapeDamageTextTable
	call PrintExtraBattleText
	pop af
	ret
	
DisplayHeldItemDamageEffectText:
	ld hl,wBattleMonHeldItem
	ld de,wEnemyMonHeldItem
	ld a,[H_WHOSETURN]
	and a
	ld a,[wPlayerMoveType]
	jr z,.skipEnemyTurn	;dont swap hl and de if players turn
	push hl
	push de
	pop hl
	pop de
	ld a,[wEnemyMoveType]
.skipEnemyTurn
	push af		;save the type
	add FAN		;add fan (fan is start of the boosting held items)
	cp [hl]
	call z,.boostedText		;if they match, then print the boosted text
	pop af
	push de
	pop hl
	add WINDBREAKER	;add the start of the limiting held items by the defender
	cp [hl]
	call z,.limitedText		;if they match, then print the limited text
	ret
.boostedText
	ld hl,BoostedByHeldItemText
	jr .finish
.limitedText
	ld hl,LimitedByHeldItemText
.finish
	push de
	ld d,a
	
	ld a,[$ffdc]
	push af
	ld a,[wd11e]
	push af
	
	ld a,d
	dec a
	ld [$ffdc], a
	push hl
	call GetItemName
	call CopyStringToCF4B ; copy name to wcf4b
	pop hl
	call PrintText
	pop af
	ld [wd11e], a
	pop af
	ld [$ffdc], a
	pop de
	ret
	
LandscapeDamageTextTable:
	dw GenericScapeDamageEffectText
	dw GenericScapeDamageEffectText
	dw GenericScapeDamageEffectText
	dw SnowScapeDamageEffectText
	dw WaterScapeDamageEffectText
	dw CaveScapeDamageEffectText
	dw SkyScapeDamageEffectText
	dw MoonScapeDamageEffectText
	dw SnowScapeDamageEffectText
	dw UndergroundScapeDamageEffectText
	dw CemeteryScapeDamageEffectText
	dw GenericScapeDamageEffectText
	dw GenericScapeDamageEffectText
	dw PoisonScapeDamageEffectText
	dw FireScapeDamageEffectText
	dw VRScapeDamageEffectText
	
DisplayLandscapeAndWeatherDamageEffectText:
	ld hl,LandscapeAndWeatherTextTable
	jr DisplayWeatherTextCommon
	
DisplayWeatherDamageEffectText:
	ld hl,WeatherTextTable
	;fall through
	
DisplayWeatherTextCommon:
	push af
	ld a,[wBattleWeather]
	call PrintExtraBattleText
.finish
	pop af
	ret
	
;to print the extra battle text from the table in the hl with the index in a
PrintExtraBattleText:
	add a	;double
	ld b,0
	ld c,a
	add hl,bc ;	hl=pointer to text pointer
	ld a,[hli]
	ld h,[hl]
	ld l,a	;hl is pointer to text
	jp PrintText
	
LandscapeAndWeatherTextTable:
	dw MindWeatherAndScapeText
	dw FireWeatherAndScapeText
	dw HailWeatherAndScapeText
	dw ThunderWeatherAndScapeText
	dw WindWeatherAndScapeText
	dw SandWeatherAndScapeText
	dw SnowWeatherAndScapeText
	dw RainWeatherAndScapeText

WeatherTextTable:
	dw MindWeatherEffectText
	dw FireWeatherEffectText
	dw HailWeatherEffectText
	dw ThunderWeatherEffectText
	dw WindWeatherEffectText
	dw SandWeatherEffectText
	dw SnowWeatherEffectText
	dw RainWeatherEffectText

DisplayEnvironmentDamageEffectText:
	push af
	ld a,[wWhichTypeUsed]	;load attack type into a
	ld hl,EnvironmentTextTable
	ld de,3
	call IsInArray
	jr nc,.finish	;finish if the type isn't in array (shouldn't happen)
.printText
	inc hl
	ld a,[hli]
	ld h,[hl]
	ld l,a	;hl is pointer to text
	call PrintText
.finish
	pop af
	ret
	
EnvironmentTextTable:
	db MAGIC
	dw SpellEnvironmentText
	db SOUND
	dw SoundEnvironmentText
	db RADIO
	dw RadioEnvironmentText
	db POISON
	dw PoisonEnvironmentText
	db $FF
	
DisplayTimeDamageEffectText:
	push af
	ld a,[wBattleEnvironment]	;load environment into a
	bit 0,a	;night time?
	jr nz,.nightTime
	ld hl,SunlightText
	bit 1,a	;swapped?
	jr z,.finish	;if day isn't switched, then print the text
	ld hl,EclipseText	;otherwise, load eclipse text
	jr .finish	;finish
.nightTime
	ld hl,MoonlightText
	bit 1,a	;swapped?
	jr z,.finish	;if night isn't swapped, print the text
	ld hl,SunlightText	;otherwise, load sunlight text
	
.finish
	call PrintText
	pop af
	ret

DisplayAttackerAbility1EffectText:
	push af
	ld a,b	;load attacker ability 1 into a
	call PrintAbilityText
	pop af
	ret

DisplayAttackerAbility2EffectText:
	push af
	ld a,c	;load attacker ability 2 into a
	call PrintAbilityText
	pop af
	ret
	
DisplayDefenderAbility1EffectText:
	push af
	ld a,d	;load defender ability 1 into a
	call PrintAbilityText
	pop af
	ret
	
DisplayDefenderAbility2EffectText:
	push af
	ld a,e	;load defender ability 2 into a
	call PrintAbilityText
	pop af
	ret
	
PrintAbilityText:
	dec a	;abilities start at 1
	ld hl,AbilityTextTable
	jp PrintExtraBattleText
	
AbilityTextTable:
	dw NocturnalText
	dw EarlyBirdText
	dw PredatorText
	dw PoisonSkinText
	dw PorousText
	dw SwimmerText
	dw SlicerText
	dw SleepwalkText
	dw HeadpieceText
	dw StenchText
	dw FlyingDragonText
	dw IllTemperedText
	dw ToughSkinText
	dw PhotosynthesisText
	dw RechargeText
	dw InsomniaText
	dw FlameBodyText
	dw ColdBloodedText
	dw SeeThroughText
	dw InvisibleWallText
	dw TelepathicText
	dw InvisibleText
	dw PickpocketText
	dw VenomousText
	dw RegenerativeText
	dw FluffyText
	dw ConvertText
	dw StrongScaleText
	dw FireStormText
	dw HailStormText
	dw ThunderStormText
	dw GlitchText
	dw CursedBodyText
	dw SharpMindText
	dw RawhideText
	
STABText:
	TX_FAR _STABText
	db "@"

HalfEffectiveText:
	TX_FAR _HalfEffectiveText
	db "@"

QuarterEffectiveText:
	TX_FAR _QuarterEffectiveText
	db "@"

DoubleEffectiveText:
	TX_FAR _DoubleEffectiveText
	db "@"

QuadrupleEffectiveText:
	TX_FAR _QuadrupleEffectiveText
	db "@"

GenericScapeDamageEffectText:
	TX_FAR _GenericScapeDamageEffectText
	db "@"

SnowScapeDamageEffectText:
	TX_FAR _SnowScapeDamageEffectText
	db "@"

WaterScapeDamageEffectText:
	TX_FAR _WaterScapeDamageEffectText
	db "@"

CaveScapeDamageEffectText:
	TX_FAR _CaveScapeDamageEffectText
	db "@"

SkyScapeDamageEffectText:
	TX_FAR _SkyScapeDamageEffectText
	db "@"

MoonScapeDamageEffectText:
	TX_FAR _MoonScapeDamageEffectText
	db "@"

UndergroundScapeDamageEffectText:
	TX_FAR _UndergroundScapeDamageEffectText
	db "@"

CemeteryScapeDamageEffectText:
	TX_FAR _CemeteryScapeDamageEffectText
	db "@"
	
PoisonEnvironmentText:
PoisonScapeDamageEffectText:
	TX_FAR _PoisonScapeDamageEffectText
	db "@"

FireScapeDamageEffectText:
	TX_FAR _FireScapeDamageEffectText
	db "@"

VRScapeDamageEffectText:
	TX_FAR _VRScapeDamageEffectText
	db "@"
	
MindWeatherAndScapeText:
	TX_FAR _MindWeatherAndScapeText
	db "@"
	
FireWeatherAndScapeText:
	TX_FAR _FireWeatherAndScapeText
	db "@"
	
HailWeatherAndScapeText:
	TX_FAR _HailWeatherAndScapeText
	db "@"
	
ThunderWeatherAndScapeText:
	TX_FAR _ThunderWeatherAndScapeText
	db "@"

WindWeatherAndScapeText:
	TX_FAR _WindWeatherAndScapeText
	db "@"
	
SandWeatherAndScapeText:
	TX_FAR _SandWeatherAndScapeText
	db "@"

SnowWeatherAndScapeText:
	TX_FAR _SnowWeatherAndScapeText
	db "@"
	
RainWeatherAndScapeText:
	TX_FAR _RainWeatherAndScapeText
	db "@"
	
MindWeatherEffectText:
	TX_FAR _MindWeatherEffectText
	db "@"
	
FireWeatherEffectText:
	TX_FAR _FireWeatherEffectText
	db "@"
	
HailWeatherEffectText:
	TX_FAR _HailWeatherEffectText
	db "@"
	
ThunderWeatherEffectText:
	TX_FAR _ThunderWeatherEffectText
	db "@"
	
WindWeatherEffectText:
	TX_FAR _WindWeatherEffectText
	db "@"
	
SandWeatherEffectText:
	TX_FAR _SandWeatherEffectText
	db "@"
	
SnowWeatherEffectText:
	TX_FAR _SnowWeatherEffectText
	db "@"
	
RainWeatherEffectText:
	TX_FAR _RainWeatherEffectText
	db "@"
	
SpellEnvironmentText:
	TX_FAR _SpellEnvironmentText
	db "@"
	
SoundEnvironmentText:
	TX_FAR _SoundEnvironmentText
	db "@"
	
RadioEnvironmentText:
	TX_FAR _RadioEnvironmentText
	db "@"
	
SunlightText:
	TX_FAR _SunlightText
	db "@"
	
MoonlightText:
	TX_FAR _MoonlightText
	db "@"
	
EclipseText:
	TX_FAR _EclipseText
	db "@"

NocturnalText:
	TX_FAR _NocturnalText
	db "@"

EarlyBirdText:
	TX_FAR _EarlyBirdText
	db "@"

PredatorText:
	TX_FAR _PredatorText
	db "@"

PoisonSkinText:
	TX_FAR _PoisonSkinText
	db "@"

PorousText:
	TX_FAR _PorousText
	db "@"

SwimmerText:
	TX_FAR _SwimmerText
	db "@"

SlicerText:
	TX_FAR _SlicerText
	db "@"

SleepwalkText:
	TX_FAR _SleepwalkText
	db "@"

HeadpieceText:
	TX_FAR _HeadpieceText
	db "@"

StenchText:
	TX_FAR _StenchText
	db "@"

FlyingDragonText:
	TX_FAR _FlyingDragonText
	db "@"

IllTemperedText:
	TX_FAR _IllTemperedText
	db "@"

ToughSkinText:
	TX_FAR _ToughSkinText
	db "@"

PhotosynthesisText:
	TX_FAR _PhotosynthesisText
	db "@"

RechargeText:
	TX_FAR _RechargeText
	db "@"

InsomniaText:
	TX_FAR _InsomniaText
	db "@"

FlameBodyText:
	TX_FAR _FlameBodyText
	db "@"

ColdBloodedText:
	TX_FAR _ColdBloodedText
	db "@"

SeeThroughText:
	TX_FAR _SeeThroughText
	db "@"

InvisibleWallText:
	TX_FAR _InvisibleWallText
	db "@"

TelepathicText:
	TX_FAR _TelepathicText
	db "@"

InvisibleText:
	TX_FAR _InvisibleText
	db "@"

PickpocketText:
	TX_FAR _PickpocketText
	db "@"

VenomousText:
	TX_FAR _VenomousText
	db "@"

RegenerativeText:
	TX_FAR _RegenerativeText
	db "@"

FluffyText:
	TX_FAR _FluffyText
	db "@"

ConvertText:
	TX_FAR _ConvertText
	db "@"

StrongScaleText:
	TX_FAR _StrongScaleText
	db "@"

FireStormText:
	TX_FAR _FireStormText
	db "@"

HailStormText:
	TX_FAR _HailStormText
	db "@"

ThunderStormText:
	TX_FAR _ThunderStormText
	db "@"

GlitchText:
	TX_FAR _GlitchText
	db "@"

CursedBodyText:
	TX_FAR _CursedBodyText
	db "@"

SharpMindText:
	TX_FAR _SharpMindText
	db "@"

RawhideText:
	TX_FAR _RawhideText
	db "@"

SkyNoDamageText:
	TX_FAR _SkyNoDamageText
	db "@"

WaterNoDamageText:
	TX_FAR _WaterAttackOnlyInWaterText
	db "@"
	
AttackUndergroundNoDamageText:
	TX_FAR _AttackUndergroundNoDamageText
	db "@"

UndegroundNoDamageText:
	TX_FAR _UndegroundNoDamageText
	db "@"

VRNoDamageText:
	TX_FAR _VRNoDamageText
	db "@"
	
MoonNoDamageText:
	TX_FAR _MoonNoDamageText
	db "@"
	
NoRocksHereText:
	TX_FAR _NoRocksHereText
	db "@"
NoIceHereText:
	TX_FAR _NoIceHereText
	db "@"
NoSnowHereText:
	TX_FAR _NoSnowHereText
	db "@"
	
ProtectedByInvincibilityPotionText:
	TX_FAR _ProtectedByInvincibilityPotionText
	db "@"
	
BoostedByHeldItemText:
	TX_FAR _BoostedByHeldItemText
	db "@"
LimitedByHeldItemText:
	TX_FAR _LimitedByHeldItemText
	db "@"