
TEXT_1  EQU $20
TEXT_2  EQU $21
TEXT_3  EQU $22
TEXT_4  EQU $23
TEXT_5  EQU $24
TEXT_6  EQU $25
TEXT_7  EQU $26
TEXT_8  EQU $27
TEXT_9  EQU $28
TEXT_10 EQU $29
TEXT_11 EQU $2a

POKEDEX_TEXT EQU $2b
MOVE_NAMES   EQU $2c

INCLUDE "macros.asm"
INCLUDE "hram.asm"


SECTION "Text 1", ROMX, BANK[TEXT_1]

_CardKeySuccessText1:: ; 80000 (20:4000)
	text "Bingo!"
	done

_CardKeySuccessText2:: ; 80009 (20:4009)
	para "The CARD KEY opened the door!"
	done

_CardKeyFailText:: ; 80029 (20:4029)
	text "Darn! It needs a CARD KEY!"
	done

_TrainerNameText:: ; 80045 (20:4045)
	ram_text wcd6d
	text ": "
	done

_NoNibbleText:: ; 8004d (20:404d)
	text "Not even a nibble!"
	prompt

_NothingHereText:: ; 80061 (20:4061)
	text "Looks like there's nothing here."
	prompt

_ItsABiteText:: ; 80082 (20:4082)
	text "Oh!"
	line "It's a bite!"
	prompt

_ExclamationText:: ; 80093 (20:4093)
	text "!"
	done

_GroundRoseText:: ; 80096 (20:4096)
	text "Ground rose up somewhere!"
	done

_BoulderText:: ; 800b1 (20:40b1)
	text "This requires STRENGTH to move!"
	done

_MartSignText:: ; 800d2 (20:40d2)
	text "All your item needs fulfilled!"
	para "# MART"
	done

_PokeCenterSignText:: ; 800fc (20:40fc)
	text "Heal Your #!"
	para "# CENTER"
	done

_FoundItemText:: ; 80119 (20:4119)
	text $52, " found "
	ram_text wcf4b
	text "!"
	done

_NoMoreRoomForItemText:: ; 8012a (20:412a)
	text "No more room for items!"
	done

_OaksAideHiText:: ; 80143 (20:4143)
	text "Hi! Remember me?"
	para "I'm PROF.OAK's AIDE!"

	para "If you caught "
	hex_number hOaksAideRequirement, 1, 3
	text " kinds of #, I'm supposed to give you the "
	ram_text wOaksAideRewardItemName
	text "!"

	para "So, ", $52, "! Have you caught at least "
	hex_number hOaksAideRequirement, 1, 3
	text " kinds of #?"
	done

_OaksAideUhOhText:: ; 801e4 (20:41e4)
	text "Let's see..."
	para "Uh-oh! You have caught only "
	hex_number hOaksAideNumMonsOwned, 1, 3
	text "kinds of #!"

	para "You need "
	hex_number hOaksAideRequirement, 1, 3
	text " kinds if you want the "
	ram_text wOaksAideRewardItemName
	text "."
	done

_OaksAideComeBackText:: ; 80250 (20:4250)
	text "Oh. I see."

	para "When you get "
	hex_number hOaksAideRequirement, 1, 3
	text " kinds, come back for the "
	ram_text wOaksAideRewardItemName
	text "."
	done

_OaksAideHereYouGoText:: ; 8028c (20:428c)
	text "Great! You have caught "
	hex_number hOaksAideNumMonsOwned, 1, 3
	text " kinds  of #!"
	cont "Congratulations!"

	para "Here you go!"
	prompt

_OaksAideGotItemText:: ; 802d9 (20:42d9)
	text $52, " got the "
	ram_text wOaksAideRewardItemName
	text "!"
	done

_OaksAideNoRoomText:: ; 802ec (20:42ec)
	text "Oh! I see you don't have any room for the"
	ram_text wOaksAideRewardItemName
	text "."
	done

INCLUDE "text/maps/viridian_forest.asm"
INCLUDE "text/maps/mt_moon_1f.asm"
INCLUDE "text/maps/mt_moon_b1f.asm"
INCLUDE "text/maps/mt_moon_b2f.asm"
INCLUDE "text/maps/ss_anne_1.asm"
INCLUDE "text/maps/ss_anne_2.asm"
INCLUDE "text/maps/ss_anne_3.asm"
INCLUDE "text/maps/ss_anne_4.asm"
INCLUDE "text/maps/ss_anne_5.asm"
INCLUDE "text/maps/ss_anne_6.asm"
INCLUDE "text/maps/ss_anne_7.asm"
INCLUDE "text/maps/ss_anne_8.asm"
INCLUDE "text/maps/ss_anne_9.asm"
INCLUDE "text/maps/ss_anne_10.asm"
INCLUDE "text/maps/victory_road_3f.asm"
INCLUDE "text/maps/rocket_hideout_b1f.asm"
INCLUDE "text/maps/rocket_hideout_b2f.asm"
INCLUDE "text/maps/rocket_hideout_b3f.asm"
INCLUDE "text/maps/rocket_hideout_b4f.asm"
INCLUDE "text/maps/rocket_hideout_elevator.asm"
INCLUDE "text/maps/silph_co_2f.asm"
INCLUDE "text/maps/silph_co_3f.asm"
INCLUDE "text/maps/silph_co_4f.asm"
INCLUDE "text/maps/silph_co_5f_1.asm"


SECTION "Text 2", ROMX, BANK[TEXT_2]

INCLUDE "text/maps/silph_co_5f_2.asm"
INCLUDE "text/maps/silph_co_6f.asm"
INCLUDE "text/maps/silph_co_7f.asm"
INCLUDE "text/maps/silph_co_8f.asm"
INCLUDE "text/maps/silph_co_9f.asm"
INCLUDE "text/maps/silph_co_10f.asm"
INCLUDE "text/maps/silph_co_11f.asm"
INCLUDE "text/maps/mansion_2f.asm"
INCLUDE "text/maps/mansion_3f.asm"
INCLUDE "text/maps/mansion_b1f.asm"
INCLUDE "text/maps/safari_zone_east.asm"
INCLUDE "text/maps/safari_zone_north.asm"
INCLUDE "text/maps/safari_zone_west.asm"
INCLUDE "text/maps/safari_zone_center.asm"
INCLUDE "text/maps/safari_zone_rest_house_1.asm"
INCLUDE "text/maps/safari_zone_secret_house.asm"
INCLUDE "text/maps/safari_zone_rest_house_2.asm"
INCLUDE "text/maps/safari_zone_rest_house_3.asm"
INCLUDE "text/maps/safari_zone_rest_house_4.asm"
INCLUDE "text/maps/unknown_dungeon_1f.asm"
INCLUDE "text/maps/unknown_dungeon_2f.asm"
INCLUDE "text/maps/unknown_dungeon_b1f.asm"
INCLUDE "text/maps/victory_road_1f.asm"
INCLUDE "text/maps/lance.asm"
INCLUDE "text/maps/hall_of_fame.asm"
INCLUDE "text/maps/champion.asm"
INCLUDE "text/maps/lorelei.asm"
INCLUDE "text/maps/bruno.asm"
INCLUDE "text/maps/agatha.asm"
INCLUDE "text/maps/rock_tunnel_b2f_1.asm"


SECTION "Text 3", ROMX, BANK[TEXT_3]

INCLUDE "text/maps/rock_tunnel_b2f_2.asm"
INCLUDE "text/maps/seafoam_islands_1f.asm"
INCLUDE "text/maps/seafoam_islands_b1f.asm"
INCLUDE "text/maps/seafoam_islands_b2f.asm"
INCLUDE "text/maps/seafoam_islands_b3f.asm"
INCLUDE "text/maps/seafoam_islands_b4f.asm"

_AIBattleWithdrawText:: ; 880be (22:40be)
	text $48," withdrew "
	ram_text wEnemyMonNick
	text "!"
	prompt

_AIBattleUseItemText:: ; 880d5 (22:40d5)
	text $48," used "
	ram_text wcd6d
	text "on "
	ram_text wEnemyMonNick
	text "!"
	prompt

_TradeWentToText:: ; 880ef (22:40ef)
	ram_text wcf4b
	text " went to "
	ram_text wGrassRate
	text "."
	done

_TradeForText:: ; 88103 (22:4103)
	text "For ", $52, "'s "
	ram_text wcf4b
	text ","
	done

_TradeSendsText:: ; 88112 (22:4112)
	ram_text wGrassRate
	text " sends "
	ram_text wcd6d
	text "."
	done

_TradeWavesFarewellText:: ; 88124 (22:4124)
	ram_text wGrassRate
	text " waves farewell as "
	done

_TradeTransferredText:: ; 8813b (22:413b)
	ram_text wcd6d
	text " is transferred."
	done

_TradeTakeCareText:: ; 88150 (22:4150)
	text "Take good care of "
	ram_text wcd6d
	text "."
	done

_TradeWillTradeText:: ; 8816a (22:416a)
	ram_text wGrassRate
	text " will trade "
	ram_text wcd6d
	done

_TradeforText:: ; 88180 (22:4180)
	text "for ", $52, "'s "
	ram_text wcf4b
	text "."
	done

_PlaySlotMachineText:: ; 8818f (22:418f)
	text "A slot machine!"
	line "Want to play?"
	done

_OutOfCoinsSlotMachineText:: ; 881ae (22:41ae)
	text "Darn!"
	line "Ran out of coins!"
	done

_BetHowManySlotMachineText:: ; 881c7 (22:41c7)
	text "Bet how many coins?"
	done

_StartSlotMachineText:: ; 881dc (22:41dc)
	text "Start!"
	done

_NotEnoughCoinsSlotMachineText:: ; 881e4 (22:41e4)
	text "Not enough coins!"
	prompt

_OneMoreGoSlotMachineText:: ; 881f7 (22:41f7)
	text "One more go?"
	done

_LinedUpText:: ; 88206 (22:4206)
	text " lined up!"
	line "Scored "
	ram_text wcf4b
	text " coins!"
	done

_NotThisTimeText:: ; 88226 (22:4226)
	text "Not this time!"
	prompt

_YeahText:: ; 88236 (22:4236)
	text "Yeah!"
	done

_DexSeenOwnedText:: ; 8823e (22:423e)
	text "POKéDEX   Seen:",$4e
	hex_number wDexRatingNumMonsSeen, 1, 3
	line "         Owned:",$4e
	hex_number wDexRatingNumMonsOwned, 1, 3
	done

_DexRatingText:: ; 88267 (22:4267)
	text "POKéDEX Rating", $6d
	done

_GymStatueText1:: ; 88275 (22:4275)
	ram_text wGymCityName
	line "# GYM"
	cont "LEADER: "
	ram_text wGymLeaderName

	para "WINNING TRAINERS:"
	line $53
	done

_GymStatueText2:: ; 882a5 (22:42a5)
	ram_text wGymCityName
	line "# GYM"
	cont "LEADER: "
	ram_text wGymLeaderName

	para "WINNING TRAINERS:"
	line $53
	cont $52
	done

_ViridianCityPokecenterGuyText:: ; 882d7 (22:42d7)
	text "# CENTERs heal your tired, hurt or fainted #!"
	done

_PewterCityPokecenterGuyText:: ; 8830c (22:430c)
	text "Yawn!"

	para "When JIGGLYPUFF sings, # get drowsy..."

	para "...Me too..."
	line "Snore..."
	done

_CeruleanPokecenterGuyText:: ; 88353 (22:4353)
	text "BILL has lots of #!"

	para "He collects rare ones too!"
	done

_LavenderPokecenterGuyText:: ; 88386 (22:4386)
	text "CUBONEs wear skulls, right?"

	para "People will pay a lot for one!"
	done

_MtMoonPokecenterBenchGuyText:: ; 883c2 (22:43c2)
	text "If you have too many #, you should store them via PC!"
	done

_RockTunnelPokecenterGuyText:: ; 883fc (22:43fc)
	text "I heard that GHOSTs haunt LAVENDER TOWN!"
	done

_UnusedBenchGuyText1:: ; 88426 (22:4426)
	text "I wish I could catch #."
	done

_UnusedBenchGuyText2:: ; 88442 (22:4442)
	text "I'm tired from all the fun..."
	done

_UnusedBenchGuyText3:: ; 88460 (22:4460)
	text "SILPH's manager is hiding in the SAFARI ZONE."
	done

_VermilionPokecenterGuyText:: ; 8848e (22:448e)
	text "It is true that a higher level # will be more powerful..."

	para "But, all # will have weak points against specific types."

	para "So, there is no universally strong #."
	done

_CeladonCityPokecenterGuyText:: ; 88531 (22:4531)
	text "If I had a BIKE, I would go to CYCLING ROAD!"
	done

_FuchsiaCityPokecenterGuyText:: ; 8855f (22:455f)
	text "If you're studying #, visit the SAFARI ZONE."

	para "It has all sorts of rare #."
	done

_CinnabarPokecenterGuyText:: ; 885af (22:45af)
	text "# can still learn techniques after canceling evolution."

	para "Evolution can wait until new moves have been learned."
	done

_SaffronCityPokecenterGuyText1:: ; 88621 (22:4621)
	text "It would be great if the ELITE FOUR came and stomped TEAM ROCKET!"
	done

_SaffronCityPokecenterGuyText2:: ; 88664 (22:4664)
	text "TEAM ROCKET took off! We can go out safely again! That's great!"
	done

_CeladonCityHotelText:: ; 886a4 (22:46a4)
	text "My sis brought me on this vacation!"
	done

_BookcaseText:: ; 886c9 (22:46c9)
	text "Crammed full of # books!"
	done

_NewBicycleText:: ; 886e6 (22:46e6)
	text "A shiny new BICYCLE!"
	done

_PushStartText:: ; 886fc (22:46fc)
	text "Push START to open the MENU!"
	done

_SaveOptionText:: ; 8871a (22:471a)
	text "The SAVE option is on the MENU screen."
	done

_StrengthsAndWeaknessesText:: ; 88742 (22:4742)
	text "All # types have strong and weak points against others."
	done

_TimesUpText:: ; 8877e (22:477e)
	text "PA: Ding-dong!"

	para "Time's up!"
	prompt

_GameOverText:: ; 88798 (22:4798)
	text "PA: Your SAFARI GAME is over!"
	done

_CinnabarGymQuizIntroText:: ; 887b7 (22:47b7)
	text "# Quiz!"

	para "Get it right and the door opens to the next room!"

	para "Get it wrong and face a trainer!"

	para "If you want to conserve your # for the GYM LEADER..."

	para "Then get it right!"
	line "Here we go!"
	prompt

_CinnabarQuizQuestionsText1:: ; 8886d (22:486d)
	text "CATERPIE evolves into BUTTERFREE?"
	done

_CinnabarQuizQuestionsText2:: ; 88890 (22:4890)
	text "There are 9 certified # LEAGUE BADGEs?"
	done

_CinnabarQuizQuestionsText3:: ; 888bb (22:48bb)
	text "POLIWAG evolves 3 times?"
	done

_CinnabarQuizQuestionsText4:: ; 888d5 (22:48d5)
	text "Are thunder moves effective against ground type #?"
	done

_CinnabarQuizQuestionsText5:: ; 88915 (22:4915)
	text "# of the same kind and level are not identical?"
	done

_CinnabarQuizQuestionsText6:: ; 88949 (22:4949)
	text "TM28 contains TOMBSTONER?"
	done

_CinnabarGymQuizCorrectText:: ; 88964 (22:4964)
	text "You're absolutely correct!"

	para "Go on through!"
	done

_CinnabarGymQuizIncorrectText:: ; 8898f (22:498f)
	text "Sorry! Bad call!"
	prompt

_MagazinesText:: ; 889a1 (22:49a1)
	text "# magazines!"

	para "# notebooks!"

	para "# graphs!"
	done

_BillsHouseMonitorText:: ; 889cf (22:49cf)
	text "TELEPORTER is displayed on the PC monitor."
	done

_BillsHouseInitiatedText:: ; 889fb (22:49fb)
	text $52, " initiated TELEPORTER's Cell Separator!"
	done

_BillsHousePokemonListText1:: ; 88a25 (22:4a25)
	text "BILL's favorite # list!"
	prompt

_BillsHousePokemonListText2:: ; 88a40 (22:4a40)
	text "Which # do you want to see?"
	done

_OakLabEmailText:: ; 88a60 (22:4a60)
	text "There's an e-mail message here!"

	para "..."

	para "Calling all # trainers!"

	para "The elite trainers of # LEAGUE are ready to take on all comers!"

	para "Bring your best # and see how you rate as a trainer!"

	para "# LEAGUE HQ"
	line "INDIGO PLATEAU"

	para "PS: PROF.OAK, please visit us!"
	cont "..."
	done

_GameCornerCoinCaseText:: ; 88b5b (22:4b5b)
	text "A COIN CASE is required!"
	done

_GameCornerNoCoinsText:: ; 88b75 (22:4b75)
	text "You don't have any coins!"
	done

_GameCornerOutOfOrderText:: ; 88b8f (22:4b8f)
	text "OUT OF ORDER"
	line "This is broken."
	done

_GameCornerOutToLunchText:: ; 88bad (22:4bad)
	text "OUT TO LUNCH"
	line "This is reserved."
	done

_GameCornerSomeonesKeysText:: ; 88bcd (22:4bcd)
	text "Someone's keys!"
	line "They'll be back."
	done

_JustAMomentText:: ; 88bed (22:4bed)
	text "Just a moment."
	done

TMNotebookText:: ; 88bfd (22:4bfd)
	text "It's a pamphlet on TMs."

	para "..."

	para "There are 80 TMs in all."

	para "SILPH CO."
	done

_TurnPageText:: ; 88c6f (22:4c6f)
	text "Turn the page?"
	done

_ViridianSchoolNotebookText5:: ; 88c7f (22:4c7f)
	text "GIRL: Hey! Don't look at my notes!"
	done

_ViridianSchoolNotebookText1:: ; 88ca3 (22:4ca3)
	text "Looked at the notebook!"

	para "First page..."

	para "POKé BALLs are used to catch #."

	para "Up to 6 # can be carried."

	para "People who raise and make # fight are called # trainers."
	prompt

_ViridianSchoolNotebookText2:: ; 88d46 (22:4d46)
	text "Second page..."

	para "A healthy # may be hard to catch, so weaken it first!"

	para "Poison, burns and other damage are effective!"
	prompt

_ViridianSchoolNotebookText3:: ; 88dbd (22:4dbd)
	text "Third page..."

	para "# trainers seek others to engage in # fights."

	para "Battles are constantly fought at # GYMs."
	prompt

_ViridianSchoolNotebookText4:: ; 88e2c (22:4e2c)
	text "Fourth page..."

	para "The goal for # trainers is to beat the top 8 # GYM LEADERs."

	para "Do so to earn the right to face..."

	para "The ELITE FOUR of # LEAGUE!"
	prompt

_FightingDojoText_52a10:: ; 88ec1 (22:4ec1)
	text "Enemies on every side!"
	done

_FightingDojoText_52a1d:: ; 88ed9 (22:4ed9)
	text "What goes around comes around!"
	done

_FightingDojoText:: ; 88ef9 (22:4ef9)
	text "FIGHTING DOJO"
	done

_IndigoPlateauHQText:: ; 88f08 (22:4f08)
	text "INDIGO PLATEAU"
	line "# LEAGUE HQ"
	done

_RedBedroomSNESText:: ; 88f27 (22:4f27)
	text $52, " is playing the SNES!"
	para "...Okay!"
	line "It's time to go!"
	done

_Route15UpstairsBinocularsText:: ; 88f58 (22:4f58)
	text "Looked into the binoculars..."

	para "A large, shining bird is flying toward the sea."
	done

_AerodactylFossilText:: ; 88fa7 (22:4fa7)
	text "AERODACTYL Fossil"
	line "A primitive and rare #."
	done

_KabutopsFossilText:: ; 88fd5 (22:4fd5)
	text "KABUTOPS Fossil"
	line "A primitive and rare #."
	done

_LinkCableHelpText1:: ; 89001 (22:5001)
	text "TRAINER TIPS"

	para "Using a Game Link Cable"
	prompt

_LinkCableHelpText2:: ; 89027 (22:5027)
	text "Which heading do you want to read?"
	done

_LinkCableInfoText1:: ; 8904b (22:504b)
	text "When you have linked your GAME BOY with another GAME BOY, talk to the attendant on the right in any # CENTER."
	prompt

_LinkCableInfoText2:: ; 890bd (22:50bd)
	text "COLOSSEUM lets you play against a friend."
	prompt

_LinkCableInfoText3:: ; 890e8 (22:50e8)
	text "TRADE CENTER is used for trading #."
	prompt

_ViridianSchoolBlackboardText1:: ; 89110 (22:5110)
	text "The blackboard describes # STATUS changes during battles."
	prompt

_ViridianSchoolBlackboardText2:: ; 8914e (22:514e)
	text "Which heading do you want to read?"
	done

_ViridianBlackboardSleepText:: ; 89172 (22:5172)
	text "A # can't attack if it's asleep!"

	para "# will stay asleep even after battles."

	para "Use AWAKENING to wake them up!"
	prompt

_ViridianBlackboardPoisonText:: ; 891de (22:51de)
	text "When poisoned, a #'s health steadily drops."

	para "Poison lingers after battles."

	para "Use an ANTIDOTE to cure poison!"
	prompt

_ViridianBlackbaordPrlzText:: ; 8924b (22:524b)
	text "Paralysis could make # moves misfire!"

	para "Paralysis remains after battles."

	para "Use PARLYZ HEAL for treatment!"
	prompt

_ViridianBlackboardBurnText:: ; 892b5 (22:52b5)
	text "A burn reduces power and speed."
	
	para "It also causes ongoing damage."

	para "Burns remain after battles."

	para "Use BURN HEAL to cure a burn!"
	prompt

_ViridianBlackboardFrozenText:: ; 8932f (22:532f)
	text "If frozen, a # becomes totally immobile!"

	para "It stays frozen even after the battle ends."

	para "Use ICE HEAL to thaw out #!"
	prompt

_VermilionGymTrashText:: ; 893a7 (22:53a7)
	text "Nope, there's only trash here."
	done

_VermilionGymTrashSuccesText1:: ; 893c6 (22:53c6)
	text "Hey! There's a switch under the trash!"
	para "Turn it on!"

	para "The 1st electric lock opened!"
	done

_VermilionGymTrashSuccesText2:: ; 89418 (22:5418)
	text "Hey! There's another switch under the trash!"
	para "Turn it on!"
	prompt

_VermilionGymTrashSuccesText3:: ; 89451 (22:5451)
	text "The 2nd electric lock opened!"

	para "The motorized door opened!"
	done

_VermilionGymTrashFailText:: ; 8948c (22:548c)
	text "Nope! There's only trash here."
	para "Hey! The electric locks were reset!"
	done

_FoundHiddenItemText:: ; 894d0 (22:54d0)
	text $52, " found "
	ram_text wcd6d
	text "!"
	done

_HiddenItemBagFullText:: ; 894e1 (22:54e1)
	text "But, ", $52, " has no more room for other items!"
	done

_FoundHiddenCoinsText:: ; 8950b (22:550b)
	text $52, " found "
	dec_number hCoins, %110, 2
	text " coins!"
	done

_FoundHiddenCoins2Text:: ; 89523 (22:5523)
	text $52, " found "
	dec_number hCoins, %110, 2
	text " coins!"
	done

_DroppedHiddenCoinsText:: ; 8953b (22:553b)
	text "Oops! Dropped some coins!"
	done

_IndigoPlateauStatuesText1:: ; 89557 (22:5557)
	text "INDIGO PLATEAU"
	prompt

_IndigoPlateauStatuesText2:: ; 89567 (22:5567)
	text "The ultimate goal of trainers!"
	para "# LEAGUE HQ"
	done

_IndigoPlateauStatuesText3:: ; 89596 (22:5596)
	text "The highest # authority"
	para "# LEAGUE HQ"
	done

_PokemonBooksText:: ; 895c1 (22:55c1)
	text "Crammed full of # books!"
	done

_DiglettSculptureText:: ; 895de (22:55de)
	text "It's a sculpture of DIGLETT."
	done

_ElevatorText:: ; 895fb (22:55fb)
	text "This is an elevator."
	done

_TownMapText:: ; 89611 (22:5611)
	text "A TOWN MAP."
	done

_PokemonStuffText:: ; 8961f (22:561f)
	text "Wow! Tons of # stuff!"
	done

_OutOfSafariBallsText:: ; 89639 (22:5639)
	text "PA: Ding-dong!"

	para "You are out of SAFARI BALLs!"
	prompt

_WildRanText:: ; 89666 (22:5666)
	text "Wild "
	ram_text wEnemyMonNick
	text " ran!"
	prompt

_EnemyRanText:: ; 89677 (22:5677)
	text "Enemy "
	ram_text wEnemyMonNick
	text " ran!"
	prompt

_HurtByPoisonText:: ; 89689 (22:5689)
	text $5a, "'s"
	line "hurt by poison!"
	prompt
	
_HurtByBurnText:: ; 8969d (22:569d)
	text $5a, "'s"
	line "hurt by the burn!"
	prompt

_HurtByLeechSeedText:: ; 896b3 (22:56b3)
	text "LEECH SEED saps"
	line $5a, "!"
	prompt

_EnemyMonFaintedText:: ; 0x896c7
	text "Enemy "
	ram_text wEnemyMonNick
	text " fainted!"
	prompt

_MoneyForWinningText:: ; 896dd (22:56dd)
	text $52, " got ¥"
	dec_number wAmountMoneyWon, %110, 3
	text " for winning!"
	prompt

_TrainerDefeatedText:: ; 896f9 (22:56f9)
	text $52," defeated ",$48,"!"
	prompt

_PlayerMonFaintedText:: ; 8970c (22:570c)
	ram_text wBattleMonNick
	text " fainted!"
	prompt

_UseNextMonText:: ; 8971a (22:571a)
	text "Use next #?"
	done

_Sony1WinText:: ; 8972a (22:572a)
	text $53, ": Yeah! Am I great or what?"
	prompt

_PlayerBlackedOutText2:: ; 89748 (22:5748)
	text $52, " is out of useable #!"

	para $52, " blacked out!"
	prompt

_LinkBattleLostText:: ; 89772 (22:5772)
	text $52, " lost to",$48,"!"
	prompt

_TrainerAboutToUseText:: ; 89784 (22:5784)
	text $48," is about to use "
	ram_text wEnemyMonNick
	text "!"

	para "Will ", $52," change #?"
	done

_TrainerSentOutText:: ; 897b4 (22:57b4)
	text $48, " sent out "
	ram_text wEnemyMonNick
	text "!"
	done

_NoWillText:: ; 897c9 (22:57c9)
	text "There's no will to fight!"
	prompt

_CantEscapeText:: ; 897e3 (22:57e3)
	text "Can't escape!"
	prompt

_NoRunningText:: ; 897f1 (22:57f1)
	text "No! There's no running from a trainer battle!"
	prompt

_GotAwayText:: ; 8981f (22:581f)
	text "Got away safely!"
	prompt

_ItemsCantBeUsedHereText:: ; 89831 (22:5831)
	text "Items can't be used here."
	prompt

_AlreadyOutText:: ; 8984b (22:584b)
	ram_text wBattleMonNick
	text " is already out!"
	prompt

_MoveNoPPText:: ; 89860 (22:5860)
	text "Not enough energy for this move!"
	prompt

_MoveDisabledText:: ; 8987b (22:587b)
	text "The move is disabled!"
	prompt

_NotEnoughEnergyLeft:: ; 89892 (22:5892)
	ram_text wBattleMonNick
	text " doesn't have enough energy to move!"
	para_then
	ram_text wBattleMonNick
	text " fell asleep!"
	prompt

_OnlyDisabledMoveLeft:: ; 89892 (22:5892)
	ram_text wBattleMonNick
	text " only has disabled moves!"
	prompt

_MultiHitText:: ; 898aa (22:58aa)
	text "Hit the enemy "
	hex_number wPlayerNumHits,1,1
	text " times!"
	prompt

_ScaredText:: ; 898c7 (22:58c7)
	ram_text wBattleMonNick
	text " is too scared to move!"
	prompt

_GetOutText:: ; 898e3 (22:58e3)
	text "GHOST: Get out..."
	line "Get out..."
	prompt

_FastAsleepText:: ; 89901 (22:5901)
	text $5A," is fast asleep!"
	prompt

_WokeUpText:: ; 89914 (22:5914)
	text $5A," woke up!"
	prompt

_RegainedEnergy:: ; 89914 (22:5914)
	text $5A," regained some energy!"
	prompt

_IsFrozenText:: ; 89920 (22:5920)
	text $5A," is frozen solid!"
	prompt

_FullyParalyzedText:: ; 89934 (22:5934)
	text $5A,"'s fully paralyzed!"
	prompt

_FlinchedText:: ; 89949 (22:5949)
	text $5A," flinched!"
	prompt

_MustRechargeText:: ; 89956 (22:5956)
	text $5A," must recharge!"
	prompt

_DisabledNoMoreText:: ; 89968 (22:5968)
	text $5A,"'s disabled no more!"
	prompt

_IsConfusedText:: ; 8997e (22:597e)
	text $5A," is confused!"
	prompt

_HurtItselfText:: ; 8998e (22:598e)
	text "It hurt itself in its confusion!"
	prompt

_ConfusedNoMoreText:: ; 899b0 (22:59b0)
	text $5A,"'s confused no more!"
	prompt

_SavingEnergyText:: ; 899c6 (22:59c6)
	text $5A," is saving energy!"
	prompt

_UnleashedEnergyText:: ; 899db (22:59db)
	text $5A," unleashed energy!"
	prompt

_ThrashingAboutText:: ; 899f0 (22:59f0)
	text $5A,"'s thrashing about!"
	done

_AttackContinuesText:: ; 89a05 (22:5a05)
	text $5A,"'s attack continues!"
	done

_CantMoveText:: ; 89a1b (22:5a1b)
	text $5A," can't move!"
	prompt

_MoveIsDisabledText:: ; 89a29 (22:5a29)
	text $5a, "'s "
	ram_text wcd6d
	text " is disabled!"
	prompt

_MonUsedText:: ; 89a40 (22:5a40)
	text $5a, " used "
	ram_text wcf4b
	text "!"
	done

_AttackMissedText:: ; 89a76 (22:5a76)
	text $5a, "'s attack missed!"
	prompt

_KeptGoingAndCrashedText:: ; 89a89 (22:5a89)
	text $5a," kept going and crashed!"
	prompt

_UnaffectedText:: ; 89aa4 (22:5aa4)
	text $59, "'s unaffected!"
	prompt

_DoesntAffectMonText:: ; 89ab4 (22:5ab4)
	text "It doesn't affect ",$59, "!"
	prompt

_CriticalHitText:: ; 89ac9 (22:5ac9)
	text "Critical hit!"
	prompt

_OHKOText:: ; 89ad8 (22:5ad8)
	text "One-hit KO!"
	prompt

_LoafingAroundText:: ; 89ae5 (22:5ae5)
	ram_text wBattleMonNick
	text " is loafing around."
	prompt

_BeganToNapText:: ; 89afd (22:5afd)
	ram_text wBattleMonNick
	text " began to nap!"
	prompt

_WontObeyText:: ; 89b10 (22:5b10)
	ram_text wBattleMonNick
	text " won't obey!"
	prompt

_TurnedAwayText:: ; 89b20 (22:5b20)
	ram_text wBattleMonNick
	text " turned away!"
	prompt

_IgnoredOrdersText:: ; 89b32 (22:5b32)
	ram_text wBattleMonNick
	text " ignored orders!"
	prompt

_SubstituteTookDamageText:: ; 89b47 (22:5b47)
	text "The SUBSTITUTE took damage for ",$59, "!"
	prompt

_SubstituteBrokeText:: ; 89b6a (22:5b6a)
	text $59, "'s SUBSTITUTE broke!"
	prompt

_BuildingRageText:: ; 89b80 (22:5b80)
	text $5a, "'s RAGE is building!"
	prompt

_MirrorMoveFailedText:: ; 89b96 (22:5b96)
	text "The MIRROR MOVE failed!"
	prompt

_HitXTimesText:: ; 89baf (22:5baf)
	text "Hit "
	hex_number wEnemyNumHits, 1, 1
	text " times!"
	prompt

_GainedText:: ; 89bc2 (22:5bc2)
	ram_text wcd6d
	text " gained "
	done

_WithExpAllText:: ; 89bd0 (22:5bd0)
	text "with EXP.ALL, "
	done

_BoostedText:: ; 89be1 (22:5be1)
	text "a boosted "
	done
	
_ExpPointsText:: ; 89bee (22:5bee)
	hex_number wExpAmountGained, 2, 4
	text " EXP. Points!"
	prompt

_GrewLevelText:: ; 89c01 (22:5c01)
	ram_text wcd6d
	text " grew to level "
	hex_number wCurEnemyLVL, 1, 3
	text "!"
	done

_WildMonAppearedText:: ; 89c1d (22:5c1d)
	text "Wild "
	ram_text wEnemyMonNick
	text " appeared!"
	prompt

_HookedMonAttackedText:: ; 89c33 (22:5c33)
	text "The hooked "
	ram_text wEnemyMonNick
	text " attacked!"
	prompt

_EnemyAppearedText:: ; 89c4f (22:5c4f)
	ram_text wEnemyMonNick
	text " appeared!"
	prompt

_TrainerWantsToFightText:: ; 89c5e (22:5c5e)
	text $48, " wants to fight!"
	prompt

_UnveiledGhostText:: ; 89c73 (22:5c73)
	text "SILPH SCOPE unveiled the GHOST's identity!"
	prompt

_GhostCantBeIDdText:: ; 89c9e (22:5c9e)
	text "Darn! The GHOST can't be ID'd!"
	prompt

_GoText:: ; 89cbc (22:5cbc)
	text "Go "
	ram_text wBattleMonNick
	text "!"
	done

_DoItText:: ; 89cc3 (22:5cc3)
	text "Do it! "
	done

_GetmText:: ; 89ccd (22:5ccd)
	text "Get'm! "
	done

_EnemysWeakText:: ; 89cd6 (22:5cd6)
	text "The enemy's weak!"
	line "Get'm! "
	done

_PlayerMon1Text:: ; 89cf0 (22:5cf0)
	ram_text wBattleMonNick
	text "!"
	done

_PlayerMon2Text:: ; 89cf6 (22:5cf6)
	ram_text wBattleMonNick
	text " "
	done

_EnoughText:: ; 89cfd (22:5cfd)
	text "enough!"
	done

_OKExclamationText:: ; 89d07 (22:5d07)
	text "OK!"
	done

_GoodText:: ; 89d0d (22:5d0d)
	text "good!"
	done

_ComeBackText:: ; 89d15 (22:5d15)
	text "Come back!"
	done

_SafariZoneEatingText:: ; 89d53 (22:5d53)
	text "Wild "
	ram_text wEnemyMonNick
	text " is eating!"
	prompt

_SafariZoneAngryText:: ; 89d6a (22:5d6a)
	text "Wild "
	ram_text wEnemyMonNick
	text " is angry!"
	prompt

; money related
_PickUpPayDayMoneyText:: ; 89d80 (22:5d80)
	text $52, " picked up "
	dec_number wTotalPayDayMoney, %111, 3
	text "!"
	prompt

_ClearSaveDataText:: ; 89d96 (22:5d96)
	text "Clear all saved data?"
	done

_WhichFloorText:: ; 89dad (22:5dad)
	text "Which floor do you want? "
	done

_PartyMenuNormalText:: ; 89dc8 (22:5dc8)
	text "Choose a #."
	done

_PartyMenuItemUseText:: ; 89dd8 (22:5dd8)
	text "Use item on which #?"
	done

_PartyMenuBattleText:: ; 89df1 (22:5df1)
	text "Bring out which #?"
	done

_PartyMenuUseTMText:: ; 89e08 (22:5e08)
	text "Teach to which #?"
	done

_PartyMenuSwapMonText:: ; 89e1f (22:5e1f)
	text "Move # where?"
	done

_PotionText:: ; 89e31 (22:5e31)
	ram_text wcd6d
	text " recovered by "
	hex_number wHPBarHPDifference, 2, 3
	text "!"
	done

_AntidoteText:: ; 89e4b (22:5e4b)
	ram_text wcd6d
	text " was cured of poison!"
	done

_ParlyzHealText:: ; 89e65 (22:5e65)
	ram_text wcd6d
	text "'s rid of paralysis!"
	done

_BurnHealText:: ; 89e7d (22:5e7d)
	ram_text wcd6d
	text "'s burn was healed!"
	done

_IceHealText:: ; 89e94 (22:5e94)
	ram_text wcd6d
	text " was defrosted!"
	done

_AwakeningText:: ; 89ea8 (22:5ea8)
	ram_text wcd6d
	text " woke up!"
	done

_FullHealText:: ; 89eb6 (22:5eb6)
	ram_text wcd6d
	text "'s health returned!"
	done

_ReviveText:: ; 89ecd (22:5ecd)
	ram_text wcd6d
	text " is revitalized!"
	done

_RareCandyText:: ; 89ee2 (22:5ee2)
	ram_text wcd6d
	text " grew to level "
	hex_number wCurEnemyLVL, $1,$3
	text "!"
	done

_TurnedOnPC1Text:: ; 89efe (22:5efe)
	text $52, " turned on the PC."
	prompt

_AccessedBillsPCText:: ; 89f13 (22:5f13)
	text "Accessed BILL's PC."

	para "Accessed # Storage System."
	prompt

_AccessedSomeonesPCText:: ; 89f45 (22:5f45)
	text "Accessed someone's PC."

	para "Accessed # Storage System."
	prompt

_AccessedMyPCText:: ; 89f7a (22:5f7a)
	text "Accessed my PC."

	para "Accessed Item Storage System."
	prompt

_TurnedOnPC2Text:: ; 89fa9 (22:5fa9)
	text $52, " turned on the PC."
	prompt

_WhatDoYouWantText:: ; 89fbe (22:5fbe)
	text "What do you want to do?"
	done

_WhatToDepositText:: ; 89fd7 (22:5fd7)
	text "What do you want to deposit?"
	done

_DepositHowManyText:: ; 89ff5 (22:5ff5)
	text "How many?"
	done

_ItemWasStoredText:: ; 8a000 (22:6000)
	ram_text wcd6d
	text " was stored via PC."
	prompt

_NothingToDepositText:: ; 8a018 (22:6018)
	text "You have nothing to deposit."
	prompt

_NoRoomToStoreText:: ; 8a036 (22:6036)
	text "No room left to store items."
	prompt

_WhatToWithdrawText:: ; 8a054 (22:6054)
	text "What do you want to withdraw?"
	done

_WithdrawHowManyText:: ; 8a073 (22:6073)
	text "How many?"
	done

_WithdrewItemText:: ; 8a07e (22:607e)
	text "Withdrew "
	ram_text wcd6d
	text "."
	prompt

_NothingStoredText:: ; 8a08f (22:608f)
	text "There is nothing stored."
	prompt

_CantCarryMoreText:: ; 8a0a9 (22:60a9)
	text "You can't carry any more items."
	prompt

_WhatToTossText:: ; 8a0c9 (22:60c9)
	text "What do you want to toss away?"
	done

_TossHowManyText:: ; 8a0e9 (22:60e9)
	text "How many?"
	done

_AccessedHoFPCText:: ; 8a0f4 (22:60f4)
	text "Accessed # LEAGUE's site."

	para "Accessed the HALL OF FAME List."
	prompt

_SwitchOnText:: ; 0x8a131
	text "Switch on!"
	prompt

_WhatText:: ; 0x8a13d
	text "What?"
	done

_DepositWhichMonText:: ; 0x8a144
	text "Deposit which #?"
	done

_MonWasStoredText:: ; 0x8a159
	ram_text wcf4b
	text " was stored in Box "
	ram_text wBoxNumString
	text "."
	prompt

_CantDepositLastMonText:: ; 0x8a177
	text "You can't deposit the last #!"
	prompt

_BoxFullText:: ; 0x8a198
	text "Oops! This Box is full of #."
	prompt

_MonIsTakenOutText:: ; 0x8a1b9
	ram_text wcf4b
	text " is taken out."
	prompt

_NoMonText:: ; 0x8a1d7
	text "What? There are no # here!"
	prompt

_CantTakeMonText:: ; 0x8a1f6
	text "You can't take any more #."

	para "Deposit # first."
	prompt

_ReleaseWhichMonText:: ; 0x8a228
	text "Release which #?"
	done

_OnceReleasedText:: ; 0x8a23d
	text "Once released, "
	ram_text wcf4b
	text " is gone forever. OK?"
	done

_MonWasReleasedText:: ; 0x8a268
	ram_text wcf4b
	text " was released outside."
	para "Bye "
	ram_text wcf4b
	text "!"
	prompt

_RequireCoinCaseText:: ; 8a28e (22:628e)
	text "A COIN CASE is required!"
	done

_ExchangeCoinsForPrizesText:: ; 8a2a9 (22:62a9)
	text "We exchange your coins for prizes."
	prompt

_WhichPrizeText:: ; 8a2cd (22:62cd)
	text "Which prize do you want?"
	done

_HereYouGoText:: ; 8a2e7 (22:62e7)
	text "Here you go!"
	done

_SoYouWantPrizeText:: ; 8a2f6 (22:62f6)
	text "So, you want "
	ram_text wcd6d
	text "?"
	done

_SorryNeedMoreCoinsText:: ; 8a30b (22:630b)
	text "Sorry, you need more coins."
	done

_OopsYouDontHaveEnoughRoomText:: ; 8a329 (22:6329)
	text "Oops! You don't have enough room."
	done

_OhFineThenText:: ; 8a34c (22:634c)
	text "Oh, fine then."
	done

_GetDexRatedText:: ; 8a35d (22:635d)
	text "Want to get your POKéDEX rated?"
	done

_ClosedOaksPCText:: ; 8a37b (22:637b)
	text "Closed link to PROF.OAK's PC.@@"

_AccessedOaksPCText:: ; 8a39a (22:639a)
	text "Accessed PROF. OAK's PC."

	para "Accessed POKéDEX Rating System."
	prompt

_WhereWouldYouLikeText:: ; 8a3d0 (22:63d0)
	text "Where would you like to go?"
	done

_PleaseWaitText:: ; 8a3ed (22:63ed)
	text "OK, please wait just a moment."
	done

_LinkCanceledText:: ; 8a40d (22:640d)
	text "The link was canceled."
	done

INCLUDE "text/oakspeech.asm"

_DoYouWantToNicknameText:: ; 0x8a605
	text "Do you want to give a nickname to "
	ram_text wcd6d
	text "?"
	done

_YourNameIsText:: ; 8a62f (22:662f)
	text "Right! So your name is ", $52, "!"
	prompt

_HisNameIsText:: ; 8a64a (22:664a)
	text "That's right! I remember now! His name is ", $53, "!"
	prompt

_WillBeTradedText:: ; 8a677 (22:6677)
	ram_text wNameOfPlayerMonToBeTraded
	text " and "
	ram_text wcd6d
	text " will be traded."
	done

INCLUDE "text/maps/digletts_cave_route_2_entrance.asm"
INCLUDE "text/maps/viridian_forest_exit.asm"
INCLUDE "text/maps/route_2_house.asm"
INCLUDE "text/maps/route_2_gate.asm"
INCLUDE "text/maps/viridian_forest_entrance.asm"
INCLUDE "text/maps/mt_moon_pokecenter.asm"
INCLUDE "text/maps/saffron_gates.asm"
INCLUDE "text/maps/daycare_1.asm"


SECTION "Text 4", ROMX, BANK[TEXT_4]

INCLUDE "text/maps/daycare_2.asm"
INCLUDE "text/maps/underground_path_route_5_entrance.asm"
INCLUDE "text/maps/underground_path_route_6_entrance.asm"
INCLUDE "text/maps/underground_path_route_7_entrance.asm"
INCLUDE "text/maps/underground_path_route_7_entrance_unused.asm"
INCLUDE "text/maps/underground_path_route_8_entrance.asm"
INCLUDE "text/maps/rock_tunnel_pokecenter.asm"
INCLUDE "text/maps/rock_tunnel_b1f.asm"
INCLUDE "text/maps/power_plant.asm"
INCLUDE "text/maps/route_11_gate.asm"
INCLUDE "text/maps/route_11_gate_upstairs.asm"
INCLUDE "text/maps/digletts_cave_route_11_entrance.asm"
INCLUDE "text/maps/route_12_gate.asm"
INCLUDE "text/maps/route_12_gate_upstairs.asm"
INCLUDE "text/maps/route_12_house.asm"
INCLUDE "text/maps/route_15_gate.asm"
INCLUDE "text/maps/route_15_gate_upstairs.asm"
INCLUDE "text/maps/route_16_gate.asm"
INCLUDE "text/maps/route_16_gate_upstairs.asm"
INCLUDE "text/maps/route_16_house.asm"
INCLUDE "text/maps/route_18_gate.asm"
INCLUDE "text/maps/route_18_gate_upstairs.asm"
INCLUDE "text/maps/pokemon_league_gate.asm"
INCLUDE "text/maps/victory_road_2f.asm"
INCLUDE "text/maps/bills_house.asm"
INCLUDE "text/maps/route_1.asm"
INCLUDE "text/maps/route_2.asm"
INCLUDE "text/maps/route_3.asm"
INCLUDE "text/maps/route_4.asm"
INCLUDE "text/maps/route_5.asm"
INCLUDE "text/maps/route_6.asm"
INCLUDE "text/maps/route_7.asm"
INCLUDE "text/maps/route_8.asm"
INCLUDE "text/maps/route_9.asm"
INCLUDE "text/maps/route_10.asm"
INCLUDE "text/maps/route_11_1.asm"


SECTION "Text 5", ROMX, BANK[TEXT_5]

INCLUDE "text/maps/route_11_2.asm"
INCLUDE "text/maps/route_12.asm"
INCLUDE "text/maps/route_13.asm"
INCLUDE "text/maps/route_14.asm"
INCLUDE "text/maps/route_15.asm"
INCLUDE "text/maps/route_16.asm"
INCLUDE "text/maps/route_17.asm"
INCLUDE "text/maps/route_18.asm"
INCLUDE "text/maps/route_19.asm"
INCLUDE "text/maps/route_20.asm"
INCLUDE "text/maps/route_21.asm"
INCLUDE "text/maps/route_22.asm"
INCLUDE "text/maps/route_23.asm"
INCLUDE "text/maps/route_24_1.asm"


SECTION "Text 6", ROMX, BANK[TEXT_6]

INCLUDE "text/maps/route_24_2.asm"
INCLUDE "text/maps/route_25.asm"

_FileDataDestroyedText:: ; 945f1 (25:45f1)
	text "The file data is destroyed!"
	prompt

_WouldYouLikeToSaveText:: ; 9460e (25:460e)
	text "Would you like to SAVE the game?"
	done

_GameSavedText:: ; 94630 (25:4630)
	text $52, " saved the game!"
	done

_OlderFileWillBeErasedText:: ; 94643 (25:4643)
	text "The older file will be erased to save. Okay?"
	done

_WhenYouChangeBoxText:: ; 94671 (25:4671)
	text "When you change a # BOX, data will be saved."

	para "Is that okay?"
	done

_ChooseABoxText:: ; 946b0 (25:46b0)
	text "Choose a # BOX."
	done

_EvolvedText:: ; 946c2 (25:46c2)
	ram_text wcf4b
	text " evolved  into "
	ram_text wcd6d
	text "!"
	done

_StoppedEvolvingText:: ; 946dd (25:46dd)
	text "Huh? "
	ram_text wcf4b
	text " stopped evolving!"
	prompt

_IsEvolvingText:: ; 946fb (25:46fb)
	text "What? "
	ram_text wcf4b
	text " is evolving!"
	done

_FellAsleepText:: ; 94715 (25:4715)
	text $59," fell asleep!"
	prompt

_AlreadyAsleepText:: ; 94725 (25:4725)
	text $59, "'s already asleep!"
	prompt

_PoisonedText:: ; 94739 (25:4739)
	text $59," was poisoned!"
	prompt

_BadlyPoisonedText:: ; 9474a (25:474a)
	text $59, "'s badly poisoned!"
	prompt

_BurnedText:: ; 9475e (25:475e)
	text $59," was burned!"
	prompt

_FrozenText:: ; 9476d (25:476d)
	text $59," was frozen solid!"
	prompt

_FireDefrostedText:: ; 94782 (25:4782)
	text "Fire defrosted ",$59, "!"
	prompt

_MonsStatsRoseText:: ; 94795 (25:4795)
	text $5a, "'s "
	ram_text wcf4b
	done

_GreatlyRoseText:: ; 947a0 (25:47a0)
	text " greatly"
	done

_RoseText:: ; 947ab (25:47ab)
	text " rose!"
	prompt

_MonsStatsFellText:: ; 947b3 (25:47b3)
	text $59, "'s "
	ram_text wcf4b
	done

_GreatlyFellText:: ; 947be (25:47be)
	text " greatly"
	done

_FellText:: ; 947c9 (25:47c9)
	text " fell!"
	prompt

_RanFromBattleText:: ; 947d1 (25:47d1)
	text $5a," ran from battle!"
	prompt

_RanAwayScaredText:: ; 947e5 (25:47e5)
	text $59," ran away scared!"
	prompt

_WasBlownAwayText:: ; 947f9 (25:47f9)
	text $59," was blown away!"
	prompt

_ChargeMoveEffectText:: ; 9480c (25:480c)
	text $5a
	done

_MadeWhirlwindText:: ; 94810 (25:4810)
	text " made a whirlwind!"
	prompt

_TookInSunlightText:: ; 94824 (25:4824)
	text " took in sunlight!"
	prompt

_LoweredItsHeadText:: ; 94838 (25:4838)
	text " lowered its head!"
	prompt

_SkyAttackGlowingText:: ; 9484c (25:484c)
	text " is glowing!"
	prompt

_FlewUpHighText:: ; 9485a (25:485a)
	text " flew up high!"
	prompt

_DugAHoleText:: ; 9486a (25:486a)
	text " dug a hole!"
	prompt

_BecameConfusedText:: ; 94878 (25:4878)
	text $59," became confused!"
	prompt

_MimicLearnedMoveText:: ; 9488c (25:488c)
	text $5a," learned "
	ram_text wcd6d
	text "!"
	prompt

_MoveWasDisabledText:: ; 9489e (25:489e)
	text $59, "'s "
	ram_text wcd6d
	text " was disabled!"
	prompt

_NothingHappenedText:: ; 948b6 (25:48b6)
	text "Nothing happened!"
	prompt

_NoEffectText:: ; 948c9 (25:48c9)
	text "No effect!"
	prompt

_ButItFailedText:: ; 948d5 (25:48d5)
	text "But, it failed! "
	prompt

_DidntAffectText:: ; 948e7 (25:48e7)
	text "It didn't affect ",$59, "!"
	prompt

_IsUnaffectedText:: ; 948fb (25:48fb)
	text $59," is unaffected!"
	prompt

_ParalyzedMayNotAttackText:: ; 9490d (25:490d)
	text $59, "'s paralyzed! It may not attack!"
	prompt

_SubstituteText:: ; 9492f (25:492f)
	text "It created a SUBSTITUTE!"
	prompt

_HasSubstituteText:: ; 94949 (25:4949)
	text $5a," has a SUBSTITUTE!"
	prompt

_TooWeakSubstituteText:: ; 9495e (25:495e)
	text "Too weak to make a SUBSTITUTE!"
	prompt

_CoinsScatteredText:: ; 9497e (25:497e)
	text "Coins scattered everywhere!"
	prompt

_GettingPumpedText:: ; 9499b (25:499b)
	text $5a, "'s getting pumped!"
	prompt

_WasSeededText:: ; 949af (25:49af)
	text $59," was seeded!"
	prompt

_EvadedAttackText:: ; 949be (25:49be)
	text $59," evaded attack!"
	prompt

_HitWithRecoilText:: ; 949d0 (25:49d0)
	text $5a, "'s hit with recoil!"
	prompt

_ConvertedTypeText:: ; 949e5 (25:49e5)
	text "Converted type to",$59,"'s!"
	prompt

_StatusChangesEliminatedText:: ; 949fc (25:49fc)
	text "All STATUS changes are eliminated!"
	prompt

_StartedSleepingEffect:: ; 94a20 (25:4a20)
	text $5a," started sleeping!"
	done

_FellAsleepBecameHealthyText:: ; 94a35 (25:4a35)
	text $5a," fell asleep and became healthy!"
	done

_RegainedHealthText:: ; 94a58 (25:4a58)
	text $5a," regained health!"
	prompt

_TransformedText:: ; 94a6c (25:4a6c)
	text $5a," transformed into"
	ram_text wcd6d
	text "!"
	prompt

_LightScreenProtectedText:: ; 94a87 (25:4a87)
	text $5a, "'s protected against special attacks!"
	prompt

_ReflectGainedArmorText:: ; 94aae (25:4aae)
	text $5a," gained armor!"
	prompt

_ShroudedInMistText:: ; 94abf (25:4abf)
	text $5a, "'s shrouded in mist!"
	prompt

_SuckedHealthText:: ; 94ad5 (25:4ad5)
	text "Sucked health from ",$59, "!"
	prompt

_DreamWasEatenText:: ; 94aec (25:4aec)
	text $59, "'s dream was eaten!"
	prompt

_TradeCenterText1:: ; 94b01 (25:4b01)
	text "!"
	done

_ColosseumText1:: ; 94b04 (25:4b04)
	text "!"
	done

INCLUDE "text/maps/reds_house_1f.asm"
INCLUDE "text/maps/blues_house.asm"
INCLUDE "text/maps/oaks_lab.asm"
INCLUDE "text/maps/viridian_mart.asm"
INCLUDE "text/maps/school.asm"
INCLUDE "text/maps/viridian_house.asm"
INCLUDE "text/maps/viridian_gym.asm"
INCLUDE "text/maps/museum_1f.asm"
INCLUDE "text/maps/museum_2f.asm"
INCLUDE "text/maps/pewter_gym_1.asm"


SECTION "Text 7", ROMX, BANK[TEXT_7]

INCLUDE "text/maps/pewter_gym_2.asm"
INCLUDE "text/maps/pewter_house_1.asm"
INCLUDE "text/maps/pewter_mart.asm"
INCLUDE "text/maps/pewter_house_2.asm"
INCLUDE "text/maps/pewter_pokecenter.asm"
INCLUDE "text/maps/cerulean_trashed_house.asm"
INCLUDE "text/maps/cerulean_trade_house.asm"
INCLUDE "text/maps/cerulean_pokecenter.asm"
INCLUDE "text/maps/cerulean_gym.asm"
INCLUDE "text/maps/bike_shop.asm"
INCLUDE "text/maps/cerulean_mart.asm"
INCLUDE "text/maps/cerulean_badge_house.asm"
INCLUDE "text/maps/lavender_pokecenter.asm"
INCLUDE "text/maps/pokemon_tower_1f.asm"
INCLUDE "text/maps/pokemon_tower_2f.asm"
INCLUDE "text/maps/pokemon_tower_3f.asm"
INCLUDE "text/maps/pokemon_tower_4f.asm"
INCLUDE "text/maps/pokemon_tower_5f.asm"
INCLUDE "text/maps/pokemon_tower_6f.asm"
INCLUDE "text/maps/pokemon_tower_7f.asm"
INCLUDE "text/maps/fujis_house.asm"
INCLUDE "text/maps/lavender_mart.asm"
INCLUDE "text/maps/lavender_house.asm"
INCLUDE "text/maps/name_rater.asm"
INCLUDE "text/maps/vermilion_pokecenter.asm"
INCLUDE "text/maps/fan_club.asm"
INCLUDE "text/maps/vermilion_mart.asm"
INCLUDE "text/maps/vermilion_gym_1.asm"


SECTION "Text 8", ROMX, BANK[TEXT_8]

INCLUDE "text/maps/vermilion_gym_2.asm"
INCLUDE "text/maps/vermilion_house.asm"
INCLUDE "text/maps/vermilion_dock.asm"
INCLUDE "text/maps/vermilion_fishing_house.asm"
INCLUDE "text/maps/celadon_dept_store_1f.asm"
INCLUDE "text/maps/celadon_dept_store_2f.asm"
INCLUDE "text/maps/celadon_dept_store_3f.asm"
INCLUDE "text/maps/celadon_dept_store_4f.asm"
INCLUDE "text/maps/celadon_dept_store_roof.asm"
INCLUDE "text/maps/celadon_mansion_1f.asm"
INCLUDE "text/maps/celadon_mansion_2f.asm"
INCLUDE "text/maps/celadon_mansion_3f.asm"
INCLUDE "text/maps/celadon_mansion_4f_outside.asm"
INCLUDE "text/maps/celadon_mansion_4f_inside.asm"
INCLUDE "text/maps/celadon_pokecenter.asm"
INCLUDE "text/maps/celadon_gym.asm"
INCLUDE "text/maps/celadon_game_corner.asm"
INCLUDE "text/maps/celadon_dept_store_5f.asm"
INCLUDE "text/maps/celadon_prize_room.asm"
INCLUDE "text/maps/celadon_diner.asm"
INCLUDE "text/maps/celadon_house.asm"
INCLUDE "text/maps/celadon_hotel.asm"
INCLUDE "text/maps/fuchsia_mart.asm"
INCLUDE "text/maps/fuchsia_house.asm"
INCLUDE "text/maps/fuchsia_pokecenter.asm"
INCLUDE "text/maps/wardens_house.asm"
INCLUDE "text/maps/safari_zone_entrance.asm"
INCLUDE "text/maps/fuchsia_gym_1.asm"


SECTION "Text 9", ROMX, BANK[TEXT_9]

INCLUDE "text/maps/fuchsia_gym_2.asm"
INCLUDE "text/maps/fuchsia_meeting_room.asm"
INCLUDE "text/maps/fuchsia_fishing_house.asm"
INCLUDE "text/maps/mansion_1f.asm"
INCLUDE "text/maps/cinnabar_gym.asm"
INCLUDE "text/maps/cinnabar_lab.asm"
INCLUDE "text/maps/cinnabar_lab_trade_room.asm"
INCLUDE "text/maps/cinnabar_lab_metronome_room.asm"
INCLUDE "text/maps/cinnabar_lab_fossil_room.asm"
INCLUDE "text/maps/cinnabar_pokecenter.asm"
INCLUDE "text/maps/cinnabar_mart.asm"
INCLUDE "text/maps/indigo_plateau_lobby.asm"
INCLUDE "text/maps/copycats_house_1f.asm"
INCLUDE "text/maps/copycats_house_2f.asm"
INCLUDE "text/maps/fighting_dojo.asm"
INCLUDE "text/maps/saffron_gym.asm"
INCLUDE "text/maps/saffron_house.asm"
INCLUDE "text/maps/saffron_mart.asm"
INCLUDE "text/maps/silph_co_1f.asm"
INCLUDE "text/maps/saffron_pokecenter.asm"
INCLUDE "text/maps/mr_psychics_house.asm"

_PokemartGreetingText:: ; a259c (28:659c)
	text "Hi there!"
	next "May I help you?"
	done

_PokemonFaintedText:: ; a25b7 (28:65b7)
	ram_text wcd6d
	text " fainted!"
	done

_PlayerBlackedOutText:: ; a25c5 (28:65c5)
	text $52, " is out of useable #!"

	para $52, " blacked out!"
	prompt

_RepelWoreOffText:: ; a25ef (28:65ef)
	text "REPEL's effect wore off."
	done

_PokemartBuyingGreetingText:: ; a2608 (28:6608)
	text "Take your time."
	done

_PokemartTellBuyPriceText:: ; a2619 (28:6619)
	ram_text wcf4b
	text "?"
	line "That will be "
	dec_number hMoney, %111, 3
	text ". OK?"
	done

_PokemartBoughtItemText:: ; a2639 (28:6639)
	text "Here you are!"
	line "Thank you!"
	prompt

_PokemartNotEnoughMoneyText:: ; a2653 (28:6653)
	text "You don't have enough money."
	prompt

_PokemartItemBagFullText:: ; a2670 (28:6670)
	text "You can't carry any more items."
	prompt

_PokemonSellingGreetingText:: ; a2690 (28:6690)
	text "What would you like to sell?"
	done

_PokemartTellSellPriceText:: ; a26ae (28:66ae)
	text "I can pay you "
	dec_number hMoney, %111, 3
	text " for that."
	done

_PokemartItemBagEmptyText:: ; a26cf (28:66cf)
	text "You don't have anything to sell."
	prompt

_PokemartUnsellableItemText:: ; a26f0 (28:66f0)
	text "I can't put a price on that."
	prompt

_PokemartThankYouText:: ; a270d (28:670d)
	text "Thank you!"
	done

_PokemartAnythingElseText:: ; a2719 (28:6719)
	text "Is there anything else I can do?"
	done

_LearnedMove1Text:: ; a273b (28:673b)
	ram_text wLearnMoveMonName
	text " learned "
	ram_text wcf4b
	text "!"
	done

_WhichMoveToForgetText:: ; a2750 (28:6750)
	text "Which move should be forgotten?"
	done

_AbandonLearningText:: ; a2771 (28:6771)
	text "Abandon learning "
	ram_text wcf4b
	text "?"
	done

_DidNotLearnText:: ; a278a (28:678a)
	ram_text wLearnMoveMonName
	text " did not learn "
	ram_text wcf4b
	text "!"
	prompt

_TryingToLearnText:: ; a27a4 (28:67a4)
	ram_text wLearnMoveMonName
	text " is trying to learn "
	ram_text wcf4b
	text "!"

	para "But, "
	ram_text wLearnMoveMonName
	line " can't learn more than 4 moves!"

	para "Delete an older move to make room for "
	ram_text wcf4b
	text "?"
	done

_OneTwoAndText:: ; a2819 (28:6819)
	text "1, 2 and..."
	done

_PoofText:: ; a2827 (28:6827)
	text " Poof!"
	done

_ForgotAndText:: ; a2830 (28:6830)
	text $51
	ram_text wLearnMoveMonName
	text " forgot "
	ram_text wcd6d
	text "!"

	para "And..."
	prompt

_HMCantDeleteText:: ; a284d (28:684d)
	text "HM techniques can't be deleted!"
	prompt

_PokemonCenterWelcomeText:: ; a286d (28:686d)
	text "Welcome to our # CENTER!"

	para "We heal your # back to perfect health!"
	prompt

_ShallWeHealYourPokemonText:: ; a28b4 (28:68b4)
	text "Shall we heal your #?"
	done

_NeedYourPokemonText:: ; a28ce (28:68ce)
	text "OK. We'll need your #."
	done

_PokemonFightingFitText:: ; a28e8 (28:68e8)
	text "Thank you!"
	line "Your # are fighting fit!"
	prompt

_PokemonCenterFarewellText:: ; a2910 (28:6910)
	text "We hope to see you again!"
	done

_CableClubNPCAreaReservedFor2FriendsLinkedByCableText:: ; a292b (28:692b)
	text "This area is reserved for 2 friends who are linked by cable."
	done

_CableClubNPCWelcomeText:: ; a2969 (28:6969)
	text "Welcome to the Cable Club!"
	done

_CableClubNPCPleaseApplyHereHaveToSaveText:: ; a2985 (28:6985)
	text "Please apply here."

	para "Before opening the link, we have to save the game."
	done

_CableClubNPCPleaseWaitText:: ; a29cc (28:69cc)
	text "Please wait."
	done

_CableClubNPCLinkClosedBecauseOfInactivityText:: ; a29db (28:69db)
	text "The link has been closed because of inactivity."

	para "Please contact your friend and come again!"
	done


SECTION "Text 10", ROMX, BANK[TEXT_10]

_CableClubNPCPleaseComeAgainText:: ; a4000 (29:4000)
	text "Please come again!"
	done

_CableClubNPCMakingPreparationsText:: ; a4014 (29:4014)
	text "We're making preparations. Please wait."
	done

_UsedStrengthText:: ; a403c (29:403c)
	ram_text wcd6d
	text " used STRENGTH."
	done

_CanMoveBouldersText:: ; a4051 (29:4051)
	ram_text wcd6d
	text " can move boulders."
	prompt

_CurrentTooFastText:: ; a4069 (29:4069)
	text "The current is much too fast!"
	prompt

_CyclingIsFunText:: ; a4088 (29:4088)
	text "Cycling is fun! Forget SURFing!"
	prompt

_FlashLightsAreaText:: ; a40a9 (29:40a9)
	text "A blinding FLASH lights the area!"
	prompt

_WarpToLastPokemonCenterText:: ; a40cc (29:40cc)
	text "Warp to the last # CENTER."
	done

_CannotUseTeleportNowText:: ; a40eb (29:40eb)
	ram_text wcd6d
	text " can't use TELEPORT now."
	prompt

_CannotFlyHereText:: ; a4107 (29:4107)
	ram_text wcd6d
	text " can't FLY here."
	prompt

_NotHealthyEnoughText:: ; a411b (29:411b)
	text "Not healthy enough."
	prompt

_NewBadgeRequiredText:: ; a4130 (29:4130)
	text "No! A new BADGE is required."
	prompt

_CannotUseItemsHereText:: ; a414e (29:414e)
	text "You can't use items here."
	prompt

_CannotGetOffHereText:: ; a4168 (29:4168)
	text "You can't get off here."
	prompt

_GotMonText:: ; a4180 (29:4180)
	text $52, " got "
	ram_text wcd6d
	text "!"
	done

_SetToBoxText:: ; a418f (29:418f)
	text "There's no more room for #!"
	ram_text wBoxMonNicks
	text " was sent to # BOX "
	ram_text wcf4b
	text " on PC!"
	done

_BoxIsFullText:: ; a41d6 (29:41d6)
	text "There's no more room for #!"

	para "The # BOX is full and can't accept any more!"

	para "Change the BOX at a # CENTER!"
	done

INCLUDE "text/maps/pallet_town.asm"
INCLUDE "text/maps/viridian_city.asm"
INCLUDE "text/maps/pewter_city.asm"
INCLUDE "text/maps/cerulean_city.asm"
INCLUDE "text/maps/lavender_town.asm"
INCLUDE "text/maps/vermilion_city.asm"
INCLUDE "text/maps/celadon_city.asm"
INCLUDE "text/maps/fuchsia_city.asm"
INCLUDE "text/maps/cinnabar_island.asm"
INCLUDE "text/maps/saffron_city.asm"

_ItemUseBallText00:: ; a6729 (29:6729)
	text "It dodged the thrown BALL!"

	para "This # can't be caught!"
	prompt

_ItemUseBallText01:: ; a675f (29:675f)
	text "You missed the #!"
	prompt

_ItemUseBallText02:: ; a6775 (29:6775)
	text "Darn! The # broke free!"
	prompt

_ItemUseBallText03:: ; a6791 (29:6791)
	text "Aww! It appeared to be caught! "
	prompt

_ItemUseBallText04:: ; a67b2 (29:67b2)
	text "Shoot! It was so close too!"
	prompt

_ItemUseBallText05:: ; a67cf (29:67cf)
	text "All right!",$51
	ram_text wEnemyMonNick
	text " was caught!"
	done

_ItemUseBallText07:: ; a67ee (29:67ee)
	ram_text wBoxMonNicks
	text " was transferred to BILL's PC!"
	prompt

_ItemUseBallText08:: ; a6810 (29:6810)
	ram_text wBoxMonNicks
	text " was transferred to someone's PC!"
	prompt

_ItemUseBallText06:: ; a6835 (29:6835)
	text "New POKéDEX data will be added for "
	ram_text wEnemyMonNick
	text "!"
	done

_SurfingGotOnText:: ; a685e (29:685e)
	text $52, " got on "
	ram_text wcd6d
	text "!"
	prompt

_SurfingNoPlaceToGetOffText:: ; a686f (29:686f)
	text "There's no place to get off!"
	prompt

_VitaminStatRoseText:: ; a688c (29:688c)
	ram_text wcd6d
	text "'s "
	ram_text wcf4b
	text " rose."
	prompt

_VitaminNoEffectText:: ; a689e (29:689e)
	text "It won't have any effect."
	prompt

_ThrewBaitText:: ; a68b8 (29:68b8)
	text $52, " threw some BAIT."
	done

_ThrewRockText:: ; a68cc (29:68cc)
	text $52, " threw a ROCK."
	done

_PlayedFluteNoEffectText:: ; a68dd (29:68dd)
	text "Played the POKé FLUTE."

	para "Now, that's a catchy tune!"
	prompt

_FluteWokeUpText:: ; a690c (29:690c)
	text "All sleeping # woke up."
	prompt

_PlayedFluteHadEffectText:: ; a6928 (29:6928)
	text $52, " played the POKé FLUTE."
	done

_CoinCaseNumCoinsText:: ; a6940 (29:6940)
	text "Coins",$4e
	dec_number wPlayerCoins, %110, 2
	text " "
	prompt

_ItemfinderFoundItemText:: ; a694f (29:694f)
	text "Yes! ITEMFINDER indicates there's an item nearby."
	prompt

_ItemfinderFoundNothingText:: ; a6981 (29:6981)
	text "Nope! ITEMFINDER isn't responding."
	prompt

_RaisePPWhichTechniqueText:: ; a69a4 (29:69a4)
	text "Raise PP of which technique?"
	done

_RestorePPWhichTechniqueText:: ; a69c2 (29:69c2)
	text "Restore PP of which technique?"
	done

_PPMaxedOutText:: ; a69e2 (29:69e2)
	ram_text wcf4b
	text "'s PP is maxed out."
	prompt

_PPIncreasedText:: ; a69f9 (29:69f9)
	ram_text wcf4b
	text "'s PP increased."
	prompt

_PPRestoredText:: ; a6a0d (29:6a0d)
	text "PP was restored."
	prompt

_BootedUpTMText:: ; a6a1f (29:6a1f)
	text "Booted up a TM!"
	prompt

_BootedUpHMText:: ; a6a30 (29:6a30)
	text "Booted up an HM!"
	prompt

_TeachMachineMoveText:: ; a6a42 (29:6a42)
	text "It contained "
	ram_text wcf4b
	text "!"

	para "Teach "
	ram_text wcf4b
	text " to a #?"
	done

_MonCannotLearnMachineMoveText:: ; a6a6e (29:6a6e)
	ram_text wcd6d
	text " is not compatible with"
	ram_text wcf4b
	text "."

	para "It can't learn "
	ram_text wcf4b
	text "."
	prompt

_ItemUseNotTimeText:: ; a6aa6 (29:6aa6)
	text "OAK: ", $52, "!"
	line "This isn't the time to use that! "
	prompt

_ItemUseNotYoursToUseText:: ; a6ad0 (29:6ad0)
	text "This isn't yours to use!"
	prompt

_ItemUseNoEffectText:: ; a6ae9 (29:6ae9)
	text "It won't have any effect."
	prompt

_ThrowBallAtTrainerMonText1:: ; a6b03 (29:6b03)
	text "The trainer blocked the BALL!"
	prompt

_ThrowBallAtTrainerMonText2:: ; a6b22 (29:6b22)
	text "Don't be a thief!"
	prompt

_NoCyclingAllowedHereText:: ; a6b34 (29:6b34)
	text "No cycling allowed here."
	prompt

_NoSurfingHereText:: ; a6b4e (29:6b4e)
	text "No SURFing on "
	ram_text wcd6d
	text " here!"
	prompt

_BoxFullCannotThrowBallText:: ; a6b69 (29:6b69)
	text "The # BOX is full! Can't use that item!"
	prompt


SECTION "Text 11", ROMX, BANK[TEXT_11]

_ItemUseText001:: ; a8000 (2a:4000)
	text $52," used "
	done

_ItemUseText002:: ; a8009 (2a:4009)
	ram_text wcf4b
	text "!"
	done

_GotOnBicycleText1:: ; a800f (2a:400f)
	text $52, " got on the"
	done

_GotOnBicycleText2:: ; a801e (2a:401e)
	ram_text wcf4b
	text "!"
	prompt

_GotOffBicycleText1:: ; a8024 (2a:4024)
	text $52, " got off"
	done

_GotOffBicycleText2:: ; a8030 (2a:4030)
	text "the "
	ram_text wcf4b
	text "."
	prompt

_ThrewAwayItemText:: ; a803c (2a:403c)
	text "Threw away "
	ram_text wcd6d
	text "."
	prompt

_IsItOKToTossItemText:: ; a804f (2a:404f)
	text "Is it OK to toss "
	ram_text wcf4b
	text "?"
	prompt

_TooImportantToTossText:: ; a8068 (2a:4068)
	text "That's too important to toss!"
	prompt

_AlreadyKnowsText:: ; a8088 (2a:4088)
	ram_text wcd6d
	text " knows "
	ram_text wcf4b
	text "!"
	prompt

_ConnectCableText:: ; a809a (2a:409a)
	text "Okay, connect the cable like so!"
	prompt

_TradedForText:: ; a80bc (2a:40bc)
	text $52, " traded "
	ram_text wInGameTradeGiveMonName
	text " for "
	ram_text wInGameTradeReceiveMonName
	text "!"
	done

_WannaTrade1Text:: ; a80d8 (2a:40d8)
	text "I'm looking for "
	ram_text wInGameTradeGiveMonName
	text "!"

	para "Wanna trade one for "
	ram_text wInGameTradeReceiveMonName
	text "? "
	done

_NoTrade1Text:: ; a810b (2a:410b)
	text "Awww!"
	line "Oh well..."
	done

_WrongMon1Text:: ; a811d (2a:411d)
	text "What? That's not "
	ram_text wInGameTradeGiveMonName
	text "!"

	para "If you get one, come back here!"
	done

_Thanks1Text:: ; a8155 (2a:4155)
	text "Hey thanks!"
	done

_AfterTrade1Text:: ; a8162 (2a:4162)
	text "Isn't my old "
	ram_text wInGameTradeReceiveMonName
	text " great?"
	done

_WannaTrade2Text:: ; a817c (2a:417c)
	text "Hello there! Do you want to trade your "
	ram_text wInGameTradeGiveMonName
	line " for "
	ram_text wInGameTradeReceiveMonName
	text "?"
	done

_NoTrade2Text:: ; a81b5 (2a:41b5)
	text "Well, if you don't want to..."
	done

_WrongMon2Text:: ; a81d3 (2a:41d3)
	text "Hmmm? This isn't "
	ram_text wInGameTradeGiveMonName
	text "."

	para "Think of me when you get one."
	done

_Thanks2Text:: ; a8209 (2a:4209)
	text "Thanks!"
	done

_AfterTrade2Text:: ; a8212 (2a:4212)
	text "Hello there! Your old "
	ram_text wInGameTradeGiveMonName
	text " is magnificent!"
	done

_WannaTrade3Text:: ; a8240 (2a:4240)
	text "Hi! Do you have "
	ram_text wInGameTradeGiveMonName
	text "?"

	para "Want to trade it for "
	ram_text wInGameTradeReceiveMonName
	text "?"
	done

_NoTrade3Text:: ; a8274 (2a:4274)
	text "That's too bad."
	done

_WrongMon3Text:: ; a8284 (2a:4284)
	text "...This is no "
	ram_text wInGameTradeGiveMonName
	text "."

	para "If you get one, trade it with me!"
	done

_Thanks3Text:: ; a82bc (2a:42bc)
	text "Thanks, pal!"
	done

_AfterTrade3Text:: ; a82c9 (2a:42c9)
	text "How is my old "
	ram_text wInGameTradeReceiveMonName
	text "?"

	para "My "
	ram_text wInGameTradeGiveMonName
	text " is doing great!"
	done

_NothingToCutText:: ; a82f8 (2a:42f8)
	text "There isn't anything to CUT!"
	prompt

_UsedCutText:: ; a8315 (2a:4315)
	TX_RAM wcd6d
	text " hacked away with CUT!"
	prompt

INCLUDE "text/pokedex2.asm"

SECTION "Pokedex Text", ROMX, BANK[POKEDEX_TEXT]

INCLUDE "text/pokedex.asm"


SECTION "Move Names", ROMX, BANK[MOVE_NAMES]

INCLUDE "text/move_names.asm"

