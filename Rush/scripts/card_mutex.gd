##container for a card that requires explicit mutation to prevent accidental assignment.
class_name CardMutex extends Resource

var card: Card

func acquire(c: Card) -> void:
	assert(not card, "Card already in this mutex! Check for race conditions!")
	card = c

func release() -> Card:
	assert(card, "No card to get reference from! Check for race conditions!")
	var c := card
	card = null
	return c

func _to_string() -> String:
	if card: return "CardMutex<"+str(card)+">"
	else: return "CardMutex<None>"

func is_locked() -> bool:
	return true if card else false

func get_ref() -> Card:
	assert(card, "No card to get reference from! Check for race conditions!")
	return card

func try_ref() -> Card:
	return card
