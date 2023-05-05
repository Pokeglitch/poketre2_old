;to display the text id in the overworld:
_DisplayNewOverworldText:
	ld a,[wNewOverworldTextID]
	ld b,0
	ld c,a
	ld hl,NewOverworldTextPointersTable
	add hl,bc
	add hl,bc
	ld a,[hli]
	ld h,[hl]
	ld l,a
	jp PrintText_NoCreatingTextBox_WordWrap
	
NewOverworldTextPointersTable:
	add_overworld_text IsHatchingText
	add_overworld_text PotionWoreOffText
	add_overworld_text DelayedDamageOccuredText
	add_overworld_text LastStandDelayedDamageOccuredText
	add_overworld_text PokemonCF4BFaintedText

PotionWoreOffText:
	text "The potion effect"
	line "wore off."
	prompt
	
IsHatchingText:
	text "The egg is"
	line "hatching!"
	prompt
	
HatchedIntoText:
	text "It hatched into "
	ram_text wcf4b
	db "!"
	prompt
	
DelayedDamageOccuredText:
	ram_text wcf4b
	db " exploded!"
	prompt
	
LastStandDelayedDamageOccuredText:
	ram_text wPlayerName
	db " exploded!"
	prompt
	
PokemonCF4BFaintedText:
	ram_text wcf4b
	db " fainted!"
	prompt