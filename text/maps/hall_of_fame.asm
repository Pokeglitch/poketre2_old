_HallofFameRoomText1:: ; 85fb5 (21:5fb5)
	text "OAK: Er-hem!"
IF DEF(_YELLOW)
	line "Congratulations,"
ELSE
	line "Congratulations"
ENDC
	cont $52, "!"

	para "This floor is the"
	line "# HALL OF"
	cont "FAME!"

	para "# LEAGUE"
	line "champions are"
	cont "honored for their"
	cont "exploits here!"

	para "Their # are"
	line "also recorded in"
	cont "the HALL OF FAME!"

	para $52, "! You have"
	line "endeavored hard"
	cont "to become the new"
	cont "LEAGUE champion!"

	para "Congratulations,"
	line $52, ", you and"
	cont "your # are"
	cont "HALL OF FAMERs!"
	done

