_OakSpeechText1::
;	text "Hello there! Welcome to the world of #! My name is OAK! People call me the # PROF!"
;	prompt

	text "There are about "
	hex_number _testnumber, 1, 3
	more_text "!"
	prompt

_testnumber:
	db 51

_OakSpeechText2A::
	text "This world is inhabited by creatures called #!"
	done

_OakSpeechText2B::
	text $51,"For some people,"
	line "# are"
	cont "pets. Others use them for fights."
	
	para "Myself..."
 
	para "I study #"
	line "as a profession."

 	prompt
	
_OakSpeechText2::
	text "This world is inhabited by creatures called #!"
	
	para "For some people, # are pets. Others use them for fights."

	para "Myself..."

	para "I study # as a profession."
	prompt

_IntroducePlayerText::
	text "First, what is your name?"
	prompt

_IntroduceRivalText::
	text "This is my grandson. He's been your rival since you were a baby."

	para "...Erm, what is his name again?"
	prompt

_OakSpeechText3::
	text $52,"!"

	para "Your very own # legend is about to unfold!"

	para "A world of dreams and adventures with # awaits! Let's go!"
	
	done

