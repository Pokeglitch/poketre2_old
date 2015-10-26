;bits for smart string
CheckWordWrap EQU 7
CountingLetters EQU 6
FirstLineBreak EQU 5

CharsPerRow EQU 18


;bits for totems
RoleReversalTotem	EQU 0
LastStandTotem		EQU 1
IronTotem			EQU 2
MasterTrainerTotem	EQU 3

;for the best time/high score flags:
CantSetHighScoreBit EQU 0

;Mr Mime Flags:
MrMimeRoaming EQU 0
MrMimeEncountered EQU 1
MrMimeCaughtOrFainted EQU 2

;bits for secondary status
Toxic2			EQU 0
DelayedDamage2	EQU 1
Cursed2			EQU 2
Confused2		EQU 3
Fear2			EQU 4

;bits for skill/learned traits
AccuracySkill	EQU 0
EvasionSkill	EQU 1
EnergySkill		EQU 2
BoostUnder60Skill EQU 4
LongerMultiSkill EQU 5
NoFlinchSkill	EQU 6
PacingSkill		EQU 7

;bits for Traits:
FemaleTrait		EQU 0
EggTrait		EQU 1
HoloTrait		EQU 2
ShadowTrait		EQU 3
GenderlessTrait	EQU 4
HealBallTrait	EQU 5
ParentTrait		EQU 6
CaughtInCurrentBattleTrait	EQU 7

;bits for pre-setting traits
PresetHolo		EQU 0
PresetShadow	EQU 1
PresetHealBall	EQU 2
PresetEgg		EQU 3
PresetLastStand	EQU 4

;bits for pre-battle settings
HordeBattleBit	EQU 0
EnemyCanUseLastStand	EQU 7

;bits for major checkpoints
SummonedGhosts		EQU 1

;bits for CheatCodes
InvertCheat			EQU 0
SketchSpritesCheat	EQU 1
IWHBYDCheat			EQU 2
LuckyCharmCheat		EQU 3
FreePCCheat			EQU 4
FiresaleCheat		EQU 5
DesolateCheat		EQU 6
SmallFryCheat		EQU 7

;bits for 2nd set of cheat codes
BootcampCheat		EQU 0
SantasSackCheat		EQU 1
AgainstMeCheat		EQU 2
HealthNutCheat		EQU 3
RedBullCheat		EQU 4
AlCaponeCheat		EQU 5
MakeItRainCheat		EQU 6
SmartphoneCheat		EQU 7


;bits for sprite filters
HoloFilter		EQU 1
ShadowFilter	EQU 2
InvisibleFilter EQU 3
NightFilter		EQU 4

;bits for which screen
OverworldScreen	EQU 0
StartMenuScreen	EQU 1
BattleScreen	EQU 2
ItemMenuScreen	EQU 3
PartyMenuScreen	EQU 4
TradeScreen		EQU 5
PCScreen		EQU 6
EvolutionScreen	EQU 7
TaskMenuScreen	EQU 8
StatsScreen		EQU 9
TextInputScreen	EQU 10
TrainerCardScreen EQU 11
GameOverScreen	EQU 12

;text box constants
TextBoxTopLeft EQU $C0
TextBoxTop EQU $C1
TextBoxTopRight EQU $C2
TextBoxLeft EQU $C3
TextBoxCenter EQU $C4
TextBoxRight EQU $C5
TextBoxBottomLeft EQU $C6
TextBoxBottom EQU $C7
TextBoxBottomRight EQU $C8