_DayCareAllRightThenText:: ; 8c000 (23:4000)
	text "All right then,"
	line "@@"

_DayCareComeAgainText:: ; 8c013 (23:4013)
IF DEF(_YELLOW)
	text "Come again."
ELSE
	text "come again."
ENDC
	done

_DayCareNoRoomForMonText:: ; 8c020 (23:4020)
	text "You have no room"
	line "for this #!"
	done

_DayCareOnlyHaveOneMonText:: ; 8c041 (23:4041)
	text "You only have one"
	line "# with you."
	done

_DayCareCantAcceptMonWithHMText:: ; 8c063 (23:4063)
	text "I can't accept a"
	line "# that"
	cont "knows an HM move."
	done

_DayCareHeresYourMonText:: ; 8c090 (23:4090)
	text "Thank you! Here's"
	line "your #!"
	prompt

_DayCareNotEnoughMoneyText:: ; 8c0ad (23:40ad)
	text "Hey, you don't"
	line "have enough ¥!"
	done

