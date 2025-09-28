##container for a card that requires explicit mutation to prevent accidental assignment.
class_name CardMutex extends Resource

var card: Card

func acquire(c: Card) -> void:
	assert(not card)
	card = c

func release() -> Card:
	assert(card)
	var c := card
	card = null
	return c

func _to_string() -> String:
	if card: return "CardMutex<"+str(card)+">"
	else: return "CardMutex<None>"

func has_item() -> bool:
	return true if card else false
