;removed items
TOWN_MAP      EQU $05
BICYCLE       EQU $06
SURFBOARD     EQU $07 ; buggy?
SAFARI_BALL   EQU $08
POKEDEX       EQU $09
BOULDERBADGE  EQU $15
CASCADEBADGE  EQU $16

SAFARI_BAIT   EQU $15 ; overload
SAFARI_ROCK   EQU $16 ; overload

THUNDERBADGE  EQU $17
RAINBOWBADGE  EQU $18
SOULBADGE     EQU $19
MARSHBADGE    EQU $1A
VOLCANOBADGE  EQU $1B
EARTHBADGE    EQU $1C
OLD_AMBER     EQU $1F
FIRE_STONE    EQU $20
THUNDER_STONE EQU $21
WATER_STONE   EQU $22
DOME_FOSSIL   EQU $29
SECRET_KEY    EQU $2B
; XXX ?????   EQU $2C
BIKE_VOUCHER  EQU $2D
LEAF_STONE    EQU $2F
CARD_KEY      EQU $30
;PP_UP        EQU $32
POKE_DOLL     EQU $33
COIN          EQU $3B
S_S__TICKET   EQU $3F
GOLD_TEETH    EQU $40
OAKS_PARCEL   EQU $46
ITEMFINDER    EQU $47
SILPH_SCOPE   EQU $48
LIFT_KEY      EQU $4A
EXP__ALL      EQU $4B
OLD_ROD       EQU $4C
GOOD_ROD      EQU $4D



const_value = 1

	const MASTER_BALL   ; $01
	const ULTRA_BALL    ; $02
	const GREAT_BALL    ; $03
	const POKE_BALL     ; $04
	const SHADOW_BALL   ; $05
	const MATCH_BOX     ; $06
	const RAFT          ; $07
	const NIGHT_BALL    ; $08
	const ARDOR_BALL    ; $09
	const DAY_BALL      ; $0A
	const ANTIDOTE      ; $0B
	const BURN_HEAL     ; $0C
	const ICE_HEAL      ; $0D
	const AWAKENING     ; $0E
	const PARLYZ_HEAL   ; $0F
	const FULL_RESTORE  ; $10
	const MAX_POTION    ; $11
	const HYPER_POTION  ; $12
	const SUPER_POTION  ; $13
	const POTION        ; $14
	const PURIFICATION  ; $15
	const WINTER_BALL   ; $16
	const SHELL         ; $17
	const WHITE_SAND    ; $18
	const SEA_SALT      ; $19
	const VOLCANIC_ASH  ; $1A
	const MUSHROOM      ; $1B
	const HORN          ; $1C
	const ESCAPE_ROPE   ; $1D
	const REPEL         ; $1E
	const ROPE          ; $1F
	const SUMMER_BALL   ; $20
	const HOLO_BALL     ; $21
	const WATERING_PAIL ; $22
	const HP_UP         ; $23
	const PROTEIN       ; $24
	const IRON          ; $25
	const CARBOS        ; $26
	const CALCIUM       ; $27
	const RARE_CANDY    ; $28
	const HEAL_BALL     ; $29
	const HELIX_FOSSIL  ; $2A
	const JAIL_KEYCARD  ; $2B
	const SNAKESKIN     ; $2C
	const POKE_BANDAGE  ; $2D
	const X_ACCURACY    ; $2E
	const ARTIFACT      ; $2F
	const CELL_KEY      ; $30
	const NUGGET        ; $31
	const WHISKERS      ; $32
	const LURE_BALL     ; $33
	const FULL_HEAL     ; $34
	const REVIVE        ; $35
	const MAX_REVIVE    ; $36
	const GUARD_SPEC_   ; $37
	const SUPER_REPEL   ; $38
	const MAX_REPEL     ; $39
	const DIRE_HIT      ; $3A
	const LOG           ; $3B
	const FRESH_WATER   ; $3C
	const SODA_POP      ; $3D
	const LEMONADE      ; $3E
	const MACHETE       ; $3F
	const SILVER        ; $40
	const X_ATTACK      ; $41
	const X_DEFEND      ; $42
	const X_SPEED       ; $43
	const X_SPECIAL     ; $44
	const COIN_CASE     ; $45
	const SCENT         ; $46
	const SWEET_SCENT   ; $47
	const BANSHEE_BALL  ; $48
	const POKE_FLUTE    ; $49
	const TORCH         ; $4A
	const FLASK         ; $4B
	const LIQUID_COURAGE ; $4C
	const GAS_CONTAINER ; $4D
	const SUPER_ROD     ; $4E
	const PP_UP         ; $4F
	const ETHER         ; $50
	const MAX_ETHER     ; $51
	const ELIXER        ; $52
	const MAX_ELIXER    ; $53
	const PLATINUM
	const CRYOGENIC_VIAL
	const NOTE_SHEET
	const OXYGEN_SUIT
	const CARGO
	const EGGSHELLS
	const CRABSHELLS
	const DOGBONE
	const ECTOPLASM
	const SLUDGE_ITEM
	const COUNTER_CURSE
	const GOO_B_GONE
	const LIPIDS

;items that can be held

;berries
	const BERRY         ;10 hp
	const GOLD_BERRY    ;20 hp
	const REPA_BERRY	;5 pp
	const MINT_BERRY    ;sleep
	const PECHA_BERRY   ;poison
	const RAWST_BERRY   ;burn
	const LEPPA_BERRY   ;freeze
	const PERSIM_BERRY  ;confusion
	const CHERI_BERRY   ;paralyze
	const RAZZ_BERRY    ;cursed
	const BLUK_BERRY    ;fear
	const NANAB_BERRY   ;radio

;held items that increase certain type attacks
	const FAN ;+AERO
	const IMPLANT ;+BONE
	const SAP ;+BUG
	const MOON_STONE ;+COSMIC
	const UPGRADE	;+CYBER
	const DRAGON_SCALE	;+DRAGON
	const QUARTZ	;+EARTH
	const SUPER_CAP	;+ELECTRIC
	const GRILLS	;+FANG
	const BLACK_BELT	;+FIGHTING
	const CHARCOAL	;+FIRE
	const SKULL ;+GHOST
	const ADHESIVE ;+GOO
	const HORSESHOE	;+HOOF, 
	const CHILLER ;+ICE
	const WAND	;+MAGIC
	const STEEL_COAT	;+METAL
	const ANTENNA ;+MIND
	const KINGS_ROCK ;+PHYSICAL, 10% chance of enemy flinching from attacks that have physical contact
	const THORNS ;+PLANT
	const VENOM_VIAL ;+POISON
	const REVIGATOR ;+RADIO
	const MEGAPHONE	;+SOUND
	const WHETSTONE	;+TALON
	const PUMP ;+WATER

;held items that protect against certain type attacks
	const WINDBREAKER	;-AERO, protect from wind storm
	const CAST ;-BONE
	const BUG_SPRAY ;-BUG
	const NIGHT_LIGHT ;-COSMIC, accuracy doesn't drop at night
	const DUBIOUS_DISC 	;-CYBER
	const DRAGON_GLASS ;-DRAGON
	const SPADE ;-EARTH, protects from sand storm
	const RUBBER_COAT ;-ELECTRIC, protect from thunderstorm
	const CAYENNE ;-FANG
	const PUNCHING_BAG ;-FIGHTING
	const HEAT_BLANKET ;-FIRE, protect from inferno landscape, firestorm
	const CROSS ;-GHOST
	const GREASE ;-GOO
	const REINS ;-HOOF
	const ICE_MELT	;-ICE, protects from snow storm and hail storm
	const DEFEND_CHARM ;-MAGIC, protects from spell environment
	const MAGNET	;-METAL
	const TINFOIL ;-MIND
	const CUSHION ;-PHYSICAL
	const DEWEED ;-PLANT
	const GAS_MASK	;-POISON, protect from poison environments
	const LEAD_JACKET ;-RADIO, protects from fallout environments
	const EARMUFFS ;-SOUND
	const CLIPPERS ;-TALON
	const UMBRELLA ;-WATER, protects from rain storm

;held items that boost stats
	const CLOVER ;increases accuracy
	const CAMOUFLAGE	;increases evade
	const VITAL_BRACE ;increase sp. def
	const FORCE_BRACE ;increase sp. att
	const QUICK_BRACE ;increase speed
	const POWER_BRACE ;increase att
	const GUARD_BRACE ;increase def

;other held items
	const EXP_SHARE	;if alive and in party, will get half exp
	const HAPPY_STONE	;boosts morale gained
	const MACHO_BRACE ;each stat EV gets +5 each time exp is gained
	const LEFTOVERS ;1/16 of hp is restored each turn
	const GOGGLES	;protected from accuracy drop due to weather
	const WEATHER_ORB	;boosts the number of turns weather occurs

;hms and tms
HM_01         EQU $B0
HM_02         EQU $B1
HM_03         EQU $B2
HM_04         EQU $B3
HM_05         EQU $B4
TM_01         EQU $B5
TM_02         EQU $B6
TM_03         EQU $B7
TM_04         EQU $B8
TM_05         EQU $B9
TM_06         EQU $BA
TM_07         EQU $BB
TM_08         EQU $BC
TM_09         EQU $BD
TM_10         EQU $BE
TM_11         EQU $BF
TM_12         EQU $C0
TM_13         EQU $C1
TM_14         EQU $C2
TM_15         EQU $C3
TM_16         EQU $C4
TM_17         EQU $C5
TM_18         EQU $C6
TM_19         EQU $C7
TM_20         EQU $C8
TM_21         EQU $C9
TM_22         EQU $CA
TM_23         EQU $CB
TM_24         EQU $CC
TM_25         EQU $CD
TM_26         EQU $CE
TM_27         EQU $CF
TM_28         EQU $D0
TM_29         EQU $D1
TM_30         EQU $D2
TM_31         EQU $D3
TM_32         EQU $D4
TM_33         EQU $D5
TM_34         EQU $D6
TM_35         EQU $D7
TM_36         EQU $D8
TM_37         EQU $D9
TM_38         EQU $DA
TM_39         EQU $DB
TM_40         EQU $DC
TM_41         EQU $DD
TM_42         EQU $DE
TM_43         EQU $DF
TM_44         EQU $E0
TM_45         EQU $E1
TM_46         EQU $E2
TM_47         EQU $E3
TM_48         EQU $E4
TM_49         EQU $E5
TM_50         EQU $E6
TM_51         EQU $E7
TM_52         EQU $E8
TM_53         EQU $E9
TM_54         EQU $EA
TM_55         EQU $EB
TM_56         EQU $EC
TM_57         EQU $ED
TM_58         EQU $EE
TM_59         EQU $EF
TM_60         EQU $F0
TM_61         EQU $F1
TM_62         EQU $F2
TM_63         EQU $F3
TM_64         EQU $F4
TM_65         EQU $F5
TM_66         EQU $F6
TM_67         EQU $F7
TM_68         EQU $F8
TM_69         EQU $F9
TM_70         EQU $FA
TM_71         EQU $FB
TM_72         EQU $FC
TM_73         EQU $FD
TM_74         EQU $FE
TM_75         EQU $FF