;table containing which type to boost (based upon the landscape, in order)
LandscapeType15Table:
	db $FF
	db PLANT
	db $FF
	db ICE
	db WATER
	db EARTH
	db AERO
	db COSMIC
	db ICE
	db EARTH
	db GHOST
	db PLANT
	db PLANT
	db POISON
	db FIRE
	db CYBER
	db $FF
	
;table containing which types to set the damage 0 (based upon the landscape)
LandscapeType0Table:
	db SKY_SCAPE,EARTH
	db UNDERGROUND_SCAPE,AERO
	db $FF
	
;table listing the environments that are outdoors
OutdoorLandscapes:
	db GRASS_SCAPE,CLIFF_TOP_SCAPE,SNOW_SCAPE,WATER_SCAPE,SKY_SCAPE,SNOW_CLIFF_TOP_SCAPE,PLASMA_JUNGLE_SCAPE
	db $FF
	
;table listing which types to boost based upon the weather, starts at 0
WeatherType15Table:
	db MIND
	db FIRE
	db ICE
	db ELECTRIC
	db AERO
	db EARTH
	db ICE
	db WATER
	
;table listing which types to boost based upon the environment, (skips first two bits)
EnvironmentType15Table:
	db MAGIC
	db SOUND
	db RADIO
	db POISON
	db $FF
	db $FF

;table containing all head-based moves
HeadBasedMovesTables:
	db HEADBUTT
	db HORN_ATTACK
	db HORN_DRILL
	db POISON_STING
	db PECK
	db DRILL_PECK
	db TRIPLE_PECK
	db SKULL_BASH
	db STING
	db GORE
	db SPEARHEAD
	db INJECTION
	db $FF

;table containing all "Physical" moves
PhysicalMovesTable:
	db POUND
	db KARATE_CHOP
	db COMET_PUNCH
	db MEGA_PUNCH
	db PAY_DAY
	db FIRE_PUNCH
	db ICE_PUNCH
	db THUNDERPUNCH
	db SCRATCH
	db VICEGRIP
	db DISEMBOWEL
	db STAB
	db WING_ATTACK
	db FLY
	db BIND
	db SLAM
	db VINE_WHIP
	db STOMP
	db DOUBLE_KICK
	db MEGA_KICK
	db JUMP_KICK
	db SAND_ATTACK
	db HEADBUTT
	db HORN_ATTACK
	db FURY_ATTACK
	db HORN_DRILL
	db TACKLE
	db BODY_SLAM
	db TAKE_DOWN
	db THRASH
	db OSTEOBLAST
	db SPLINTER
	db POISON_STING
	db PIN_MISSILE
	db BITE
	db ACID
	db SNOWBALL
	db LAVA
	db PECK
	db DRILL_PECK
	db SUBMISSION
	db LOW_KICK
	db COUNTER
	db BLOODSUCK
	db LEECH_SEED
	db RAZOR_LEAF
	db BUG_BITE
	db STRING_SHOT
	db DRAGON_RAGE
	db ROCK_THROW
	db FISSURE
	db DIG
	db QUICK_ATTACK
	db RAGE
	db TRIPLE_PECK
	db ACID_SILK
	db ASTEROID_PELT
	db BIDE
	db SELFDESTRUCT
	db EGG_BOMB
	db LICK
	db SLUDGE
	db BONE_CLUB
	db WATERFALL
	db CLAMP
	db SKULL_BASH
	db SPIKE_CANNON
	db CONSTRICT
	db HI_JUMP_KICK
	db LEECH_LIFE
	db STING
	db SKY_ATTACK
	db RAPTOR_STRIKE
	db CHARGE
	db WIGHT_WALKER
	db FURY_SWIPES
	db BONEMERANG
	db ROCK_SLIDE
	db HYPER_FANG
	db SUPER_FANG
	db SLASH
	db STRUGGLE
	db DRAGONSPEED
	db LANDSLIDE
	db QUICKSAND
	db AMP_STAMP
	db CHOMP
	db BONE_CRUSHER
	db SABERTOOTH
	db FERAL
	db MONKEY_FIST
	db HAYMAKER
	db ROUNDHOUSE
	db CHOKEHOLD
	db STICKY_BOMB
	db GOO_TOSS
	db SLIME
	db REAR_KICK
	db GORE
	db BULLDOZE
	db AVALANCHE
	db ICEBALL
	db ICICLE_SPEAR
	db GLACIAL_FALL
	db HEAVY_METAL
	db STEEL_BURST
	db SHRAPNEL
	db IRON_TAIL
	db FLYTRAP
	db TAIL_SLAP
	db SPEARHEAD
	db POLLEN_BLAST
	db POISON_IVY
	db TIMBER
	db THORN_MACE
	db INJECTION
	db VENOM_SHOT
	db RAZOR_CLAW
	db LANDMINE
	db CROSS_SLASH
	db SHRED
	db $FF
	
; piercing types
PiercingTypesTable:
	db TALON
	db FANG
	db $FF
	
; piercing attacks
PiercingMovesTable:
	db HORN_DRILL
	db SPLINTER
	db POISON_STING
	db PIN_MISSILE
	db PECK
	db DRILL_PECK
	db BLOODSUCK
	db BUG_BITE
	db TRIPLE_PECK
	db SPIKE_CANNON
	db STING
	db GORE
	db ICICLE_SPEAR
	db SHRAPNEL
	db SPEARHEAD
	db INJECTION
	db VENOM_SHOT
	db THORN_MACE
	db $FF
	
; non physical types
NonPhysicalTypeTable:
	db CYBER
	db GHOST
	db $FF