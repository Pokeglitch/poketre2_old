_OaksLabGaryText1:: ; 94d5b (25:4d5b)
	text $53,": Yo ", $52,"! Gramps isn't around!"
	done

_OaksLabText40:: ; 94d79 (25:4d79)
	text $53,": Heh, I don't need to be greedy like you!"

	para "Go ahead and choose, ", $52, "!"
	done

_OaksLabText41:: ; 94dbd (25:4dbd)
	text $53,": My # looks a lot stronger."
	done

_OaksLabText39:: ; 94ddf (25:4ddf)
	text "Those are POKé BALLs. They contain #!"
	done

_OaksLabCharmanderText:: ; 94e06 (25:4e06)
	text "So! You want the fire #, CHARMANDER?"
	done

_OaksLabSquirtleText:: ; 94e2f (25:4e2f)
	text "So! You want the water #, SQUIRTLE?"
	done

_OaksLabBulbasaurText:: ; 94e57 (25:4e57)
	text "So! You want the plant #, BULBASAUR?"
	done

_OaksLabMonReceivedText:: ; 94e80 (25:4e80)
	text "This # is really energetic!"
	para $52, " received a "
	ram_text wcd6d
	text "!"
	prompt

_OaksLabLastMonText:: ; 94eb6 (25:4eb6)
	text "That's PROF.OAK's last #!"
	done

_OaksLabText_1d2f0:: ; 94ed2 (25:4ed2)
	text "OAK: Now, ", $52, ", which # do you want?"
	done

_OaksLabText_1d2f5:: ; 94ef8 (25:4ef8)
	text "OAK: If a wild"
	line "# appears,"
	cont "your # can"
	cont "fight against it!"

IF DEF(_YELLOW)
	para "Afterward, go on"
	line "to the next town."
ENDC
	done

_OaksLabText_1d2fa:: ; 94f36 (25:4f36)
IF DEF(_YELLOW)
	text "OAK: You should"
	line "talk to it and"
	cont "see how it feels."
	done
ELSE
	text "OAK: ", $52, ","
	line "raise your young"
	cont "# by making"
	cont "it fight!"
	done
ENDC

_OaksLabDeliverParcelText1:: ; 94f69 (25:4f69)
	text "OAK: Oh, ", $52, "!"

	para "How is my old"
	line "#?"

	para "Well, it seems to"
	line "like you a lot."

	para "You must be"
	line "talented as a"
	cont "# trainer!"

	para "What? You have"
	line "something for me?"

	para $52, " delivered"
	line "OAK's PARCEL.@@"

_OaksLabDeliverParcelText2:: ; 9500f (25:500f)
	db $0
	para "Ah! This is the"
	line "custom POKé BALL"
	cont "I ordered!"
IF DEF(_YELLOW)
	cont "Thanks, ",$52,"!"

	para "By the way, I must"
	line "ask you to do"
	cont "something for me."
ELSE
	cont "Thank you!"
ENDC
	done

_OaksLabAroundWorldText:: ; 95045 (25:5045)
	text "# around the"
	line "world wait for"
	cont "you, ", $52, "!"
	done

_OaksLabGivePokeballsText1:: ; 9506d (25:506d)
	text "OAK: You can't get"
	line "detailed data on"
	cont "# by just"
	cont "seeing them."

	para "You must catch"
	line "them! Use these"
	cont "to capture wild"
	cont "#."

	para $52, " got 5"
	line "POKé BALLs!@@"

_OaksLabGivePokeballsText2:: ; 950f2 (25:50f2)
	db $0
	para "When a wild"
	line "# appears,"
	cont "it's fair game."

IF DEF(_YELLOW)
	para "Just like I showed"
	line "you, throw a POKé"
ELSE
	para "Just throw a POKé"
ENDC
	line "BALL at it and try"
	line "to catch it!"

	para "This won't always"
	line "work, though."

	para "A healthy #"
	line "could escape. You"
	cont "have to be lucky!"
	done

_OaksLabPleaseVisitText:: ; 9519e (25:519e)
	text "OAK: Come see me"
	line "sometimes."

	para "I want to know how"
	line "your POKéDEX is"
	cont "coming along."
	done

_OaksLabText_1d31d:: ; 951e9 (25:51e9)
	text "OAK: Good to see "
	line "you! How is your "
	cont "POKéDEX coming? "
	cont "Here, let me take"
	cont "a look!"
	prompt

_OaksLabText_1d32c:: ; 95236 (25:5236)
	text "It's encyclopedia-"
	line "like, but the"
	cont "pages are blank!"
	done

_OaksLabText8:: ; 95268 (25:5268)
	text "?"
	done

_OaksLabText_1d340:: ; 9526b (25:526b)
	text "PROF.OAK is the"
	line "authority on"
	cont "#!"

	para "Many #"
	line "trainers hold him"
	cont "in high regard!"
	done

_OaksLabRivalWaitingText:: ; 952bb (25:52bb)
	text $53, ": Gramps!"
	line "I'm fed up with"
	cont "waiting!"
	done

_OaksLabChooseMonText:: ; 952df (25:52df)
IF DEF(_YELLOW)
	text "OAK: Hmm? ",$53,"?"
	line "Why are you here"
	cont "already?"

	para "I said for you to"
	line "come by later..."

	para "Ah, whatever!"
	line "Just wait there."

	para "Look, ",$52,"! Do"
	line "you see that ball"
	cont "on the table?"

	para "It's called a POKé"
	line "BALL. It holds a"
	cont "# inside."

	para "You may have it!"
	line "Go on, take it!"
	done
ELSE
	text "OAK: ", $53, "?"
	line "Let me think..."

	para "Oh, that's right,"
	line "I told you to"
	cont "come! Just wait!"

	para "Here, ", $52, "!"

	para "There are 3"
	line "# here!"

	para "Haha!"

	para "They are inside"
	line "the POKé BALLs."

	para "When I was young,"
	line "I was a serious"
	cont "# trainer!"

	para "In my old age, I"
	line "have only 3 left,"
	cont "but you can have"
	cont "one! Choose!"
	done
ENDC

_OaksLabRivalInterjectionText:: ; 953dc (25:53dc)
	text $53, ": Hey!"
	line "Gramps! What"
	cont "about me?"
	done

_OaksLabBePatientText:: ; 953fc (25:53fc)
	text "OAK: Be patient!"
	line $53, ", you can"
	cont "have one too!"
	done

_OaksLabLeavingText:: ; 95427 (25:5427)
	text "OAK: Hey! Don't go away yet!"
	done

_OaksLabRivalPickingMonText:: ; 95444 (25:5444)
	text $53, ": I'll take this one, then!"
	done

_OaksLabRivalReceivedMonText:: ; 95461 (25:5461)
	text $53, " received a "
	ram_text wcd6d
	text "!"
	prompt

_OaksLabRivalChallengeText:: ; 95477 (25:5477)
	text $53, ": Wait ", $52, "! Let's check out our #!"
	para "Come on, I'll take you on!"
	done

_OaksLabText_1d3be:: ; 954b6 (25:54b6)
	text "WHAT?"
	para "Unbelievable!"
	para "I picked the wrong #!"
	prompt

_OaksLabText_1d3c3:: ; 954e4 (25:54e4)
	text $53, ": Yeah! Am I great or what?"
	prompt

_OaksLabRivalToughenUpText:: ; 95502 (25:5502)
	text $53, ": Okay!"
	line "I'll make my"
	cont "# fight to"
	cont "toughen it up!"

	para $52, "! Gramps!"
	line "Smell you later!"
	done

IF DEF(_YELLOW)
_OaksLabPikachuDislikesPokeballsText1::
	text "OAK: What?"
	done

_OaksLabPikachuDislikesPokeballsText2::
	text "OAK: Would you"
	line "look at that!"

	para "It's odd, but it"
	line "appears that your"
	cont "PIKACHU dislikes"
	cont "POKé BALLs."

	para "You should just"
	line "keep it with you."

	para "That should make"
	line "it happy!"

	para "You can talk to it"
	line "and see how it"
	cont "feels about you."
	done
ENDC

_OaksLabText21:: ; 95551 (25:5551)
	text $53, ": Gramps!"
	done

_OaksLabText22:: ; 9555d (25:555d)
IF DEF(_YELLOW)
	text $53,": Gramps,"
	line "my # has"
	cont "grown stronger!"
	cont "Check it out!"
	done
ELSE
	text $53, ": What did"
	line "you call me for?"
	done
ENDC

_OaksLabText23:: ; 9557b (25:557b)
IF DEF(_YELLOW)
	text "OAK: Ah, ",$53,","
	line "good timing!"

	para "I needed to ask"
	line "both of you to do"
	cont "something for me."
	done
ELSE
	text "OAK: Oh right! I"
	line "have a request"
	cont "of you two."
	done
ENDC

_OaksLabText24:: ; 955a8 (25:55a8)
	text "On the desk there"
	line "is my invention,"
	cont "POKéDEX!"

	para "It automatically"
	line "records data on"
	cont "# you've"
	cont "seen or caught!"

	para "It's a hi-tech"
	line "encyclopedia!"
	done

_OaksLabText25:: ; 9562a (25:562a)
	text "OAK: ", $52, " and"
	line $53, "! Take"
	cont "these with you!"

	para $52, " got"
	line "POKéDEX from OAK!@@"

_OaksLabText26:: ; 95664 (25:5664)
	text "To make a complete"
	line "guide on all the"
	cont "# in the"
	cont "world..."

	para "That was my dream!"

	para "But, I'm too old!"
	line "I can't do it!"

	para "So, I want you two"
	line "to fulfill my"
	cont "dream for me!"

	para "Get moving, you"
	line "two!"

	para "This is a great"
	line "undertaking in"
	cont "# history!"
	done

_OaksLabText27:: ; 95741 (25:5741)
	text $53, ": Alright"
	line "Gramps! Leave it"
	cont "all to me!"

	para $52, ", I hate to"
	line "say it, but I"
	cont "don't need you!"

	para "I know! I'll"
	line "borrow a TOWN MAP"
	cont "from my sis!"

	para "I'll tell her not"
	line "to lend you one,"
	cont $52, "! Hahaha!"
	done

_OaksLabText_1d405:: ; 957eb (25:57eb)
	text "I study # as"
	line "PROF.OAK's AIDE."
	done

_OaksLabText_441cc:: ; 9580c (25:580c)
	text "POKéDEX comp-"
	line "letion is:"

	para "@"
	TX_NUM hDexRatingNumMonsSeen, 1, 3
	text " # seen"
	line "@"
	TX_NUM hDexRatingNumMonsOwned, 1, 3
	text " # owned"

	para "PROF.OAK's"
	line "Rating:"
	prompt

_OaksLabText_44201:: ; 95858 (25:5858)
	text "You still have"
	line "lots to do."
	cont "Look for #"
	cont "in grassy areas!"
	done

_OaksLabText_44206:: ; 95893 (25:5893)
	text "You're on the"
	line "right track! "
	cont "Get a FLASH HM"
	cont "from my AIDE!"
	done

_OaksLabText_4420b:: ; 958cc (25:58cc)
	text "You still need"
	line "more #!"
	cont "Try to catch"
	cont "other species!"
	done

_OaksLabText_44210:: ; 95903 (25:5903)
	text "Good, you're"
	line "trying hard!"
	cont "Get an ITEMFINDER"
	cont "from my AIDE!"
	done

_OaksLabText_44215:: ; 9593d (25:593d)
	text "Looking good!"
	line "Go find my AIDE"
	cont "when you get 50!"
	done

_OaksLabText_4421a:: ; 9596d (25:596d)
	text "You finally got at"
	line "least 50 species!"
	cont "Be sure to get"
	cont "EXP.ALL from my"
	cont "AIDE!"
	done

_OaksLabText_4421f:: ; 959b8 (25:59b8)
IF DEF(_YELLOW)
	text "Oh! This is get-"
	line "ting even better!"
ELSE
	text "Ho! This is geting"
	line "even better!"
ENDC
	done

_OaksLabText_44224:: ; 959d9 (25:59d9)
	text "Very good!"
	line "Go fish for some"
	cont "marine #!"
	done

_OaksLabText_44229:: ; 95a03 (25:5a03)
	text "Wonderful!"
	line "Do you like to"
	cont "collect things?"
	done

_OaksLabText_4422e:: ; 95a2e (25:5a2e)
	text "I'm impressed!"
	line "It must have been"
	cont "difficult to do!"
	done

_OaksLabText_44233:: ; 95a60 (25:5a60)
	text "You finally got at"
	line "least 100 species!"
	cont "I can't believe"
	cont "how good you are!"
	done

_OaksLabText_44238:: ; 95aa8 (25:5aa8)
	text "You even have the"
	line "evolved forms of"
	cont "#! Super!"
	done

_OaksLabText_4423d:: ; 95ad9 (25:5ad9)
	text "Excellent! Trade"
	line "with friends to"
	cont "get some more!"
	done

_OaksLabText_44242:: ; 95b0a (25:5b0a)
	text "Outstanding!"
	line "You've become a"
	cont "real pro at this!"
	done

_OaksLabText_44247:: ; 95b39 (25:5b39)
	text "I have nothing"
	line "left to say!"
	cont "You're the"
	cont "authority now!"
	done

_OaksLabText_4424c:: ; 95b6f (25:5b6f)
	text "Your POKéDEX is"
IF DEF(_YELLOW)
	line "fully complete!"
ELSE
	line "entirely complete!"
ENDC
	cont "Congratulations!"
	done

