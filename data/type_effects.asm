;new type chart
;this table contains the pointers to the type dataset
TypeEffects: ; 3e474 (f:6474)
	dw AeroTypeEffects
	dw BoneTypeEffects
	dw BugTypeEffects
	dw CosmicTypeEffects
	dw CyberTypeEffects
	dw DragonTypeEffects
	dw EarthTypeEffects
	dw ElectricTypeEffects
	dw FangTypeEffects
	dw FightingTypeEffects
	dw FireTypeEffects
	dw GhostTypeEffects
	dw GooTypeEffects
	dw HoofTypeEffects
	dw IceTypeEffects
	dw MagicTypeEffects
	dw MetalTypeEffects
	dw MindTypeEffects
	dw PhysicalTypeEffects
	dw PlantTypeEffects
	dw PoisonTypeEffects
	dw RadioTypeEffects
	dw SoundTypeEffects
	dw TalonTypeEffects
	dw WaterTypeEffects
	dw ShadowTypeEffects
	dw HoloTypeEffects

AeroTypeEffects:
	db BUG,PLANT,HOOF,SOUND,COSMIC,FIRE,$FF	;2
	db ELECTRIC,EARTH,FANG,METAL,$FF	;0.5
	db $FF								;0

BoneTypeEffects:
	db BUG,FANG,TALON,$FF				;2
	db FIGHTING,RADIO,METAL,GOO,$FF		;0.5
	db GHOST,$FF						;0

BugTypeEffects:
	db POISON,PLANT,MIND,GOO,SOUND,$FF			;2
	db FIGHTING,AERO,GHOST,FIRE,FANG,RADIO,$FF	;0.5
	db $FF										;0

CosmicTypeEffects:
	db AERO,EARTH,PLANT,RADIO,METAL,$FF	;2
	db ELECTRIC,ICE,MAGIC,$FF			;0.5
	db $FF								;0

CyberTypeEffects:
	db ELECTRIC,CYBER,$FF		;2
	db BONE,$FF					;0.5
	db $FF						;0

DragonTypeEffects:
	db AERO,DRAGON,BONE,FIRE,$FF		;2
	db MAGIC,RADIO,METAL,$FF	;0.5
	db $FF						;0

EarthTypeEffects:
	db ELECTRIC,POISON,EARTH,FIRE,ICE,BONE,CYBER,$FF	;2
	db FIGHTING,BUG,PLANT,HOOF,COSMIC,$FF				;0.5
	db AERO,$FF											;0

ElectricTypeEffects:
	db AERO,WATER,MAGIC,RADIO,METAL,CYBER,$FF	;2
	db ELECTRIC,PLANT,DRAGON,BONE,GOO,$FF		;0.5
	db EARTH,$FF								;0

FangTypeEffects:
	db FIGHTING,ICE,GOO,COSMIC,$FF				;2
	db ELECTRIC,POISON,FIRE,BUG,BONE,METAL,$FF	;0.5
	db GHOST,CYBER,$FF							;0

FightingTypeEffects:
	db EARTH,WATER,ICE,BONE,$FF				;2
	db AERO,BUG,MIND,TALON,METAL,GOO,$FF	;0.5
	db GHOST,CYBER,$FF						;0

FireTypeEffects:
	db BUG,PLANT,ICE,RADIO,METAL,GOO,$FF	;2
	db EARTH,FIRE,WATER,DRAGON,COSMIC,$FF	;0.5
	db $FF									;0

GhostTypeEffects:
	db GHOST,MIND,$FF	;2
	db MAGIC,METAL,$FF	;0.5
	db $FF				;0

GooTypeEffects:
	db ELECTRIC,TALON,MAGIC,HOOF,SOUND,$FF	;2
	db POISON,WATER,BONE,GOO,$FF			;0.5
	db $FF									;0

HoofTypeEffects:
	db EARTH,BUG,FIRE,PLANT,BONE,$FF	;2
	db AERO,WATER,METAL,$FF				;0.5
	db GHOST,CYBER,$FF					;0

IceTypeEffects:
	db AERO,EARTH,DRAGON,COSMIC,$FF	;2
	db FIRE,WATER,ICE,$FF			;0.5
	db $FF							;0

MagicTypeEffects:
	db FIGHTING,GHOST,DRAGON,METAL,$FF		;2
	db AERO,MIND,ICE,HOOF,COSMIC,CYBER,$FF	;0.5
	db $FF									;0

MetalTypeEffects:
	db FIGHTING,EARTH,ICE,FANG,BONE,CYBER,$FF	;2
	db ELECTRIC,FIRE,WATER,TALON,SOUND,$FF		;0.5
	db $FF										;0

MindTypeEffects:
	db FIGHTING,POISON,FANG,TALON,MAGIC,$FF	;2
	db MIND,RADIO,METAL,SOUND,CYBER,$FF		;0.5
	db $FF									;0

PhysicalTypeEffects:
	db FIGHTING,BONE,SOUND,$FF		;2
	db EARTH,MIND,TALON,METAL,$FF	;0.5
	db GHOST,CYBER,$FF				;0

PlantTypeEffects:
	db ELECTRIC,POISON,EARTH,WATER,COSMIC,$FF	;2
	db AERO,BUG,FIRE,PLANT,DRAGON,HOOF,$FF		;0.5
	db $FF										;0

PoisonTypeEffects:
	db BUG,PLANT,HOOF,METAL,$FF	;2
	db POISON,GHOST,EARTH,$FF	;0.5
	db CYBER,$FF				;0

RadioTypeEffects:
	db ELECTRIC,MAGIC,BONE,METAL,COSMIC,$FF	;2
	db EARTH,RADIO,SOUND,$FF				;0.5
	db $FF									;0

SoundTypeEffects:
	db AERO,GHOST,WATER,MIND,DRAGON,RADIO,METAL,$FF	;2
	db FIGHTING,EARTH,BUG,PLANT,ICE,GOO,COSMIC,$FF	;0.5
	db $FF											;0

TalonTypeEffects:
	db FIGHTING,EARTH,BUG,PLANT,$FF			;2
	db ELECTRIC,FIRE,ICE,BONE,METAL,GOO,$FF	;0.5
	db GHOST,CYBER,$FF						;0

WaterTypeEffects:
	db EARTH,FIRE,FANG,RADIO,METAL,GOO,CYBER,$FF	;2
	db WATER,PLANT,DRAGON,MAGIC,SOUND,$FF			;0.5
	db $FF											;0

ShadowTypeEffects:
	db FIGHTING,AERO,ELECTRIC,POISON,GHOST,EARTH,BUG,FIRE,WATER,PLANT,MIND,ICE,FANG,TALON,DRAGON,MAGIC,RADIO,BONE,HOOF,METAL,GOO,SOUND,COSMIC,CYBER,$FF	;2
	db SHADOW,$FF	;0.5
	db $FF			;0

HoloTypeEffects:
	db SHADOW,$FF	;2
	db $FF	;0.5
	db $FF	;0