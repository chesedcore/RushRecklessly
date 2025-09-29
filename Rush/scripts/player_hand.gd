class_name PlayerHand extends Marker2D

@export var hand: Array[Card] = []

func sort_hand_by_x() -> void:
	hand.sort_custom(
		func(card_one: Card, card_two: Card) -> bool: 
			return card_one.global_position.x < card_two.global_position.x
	)

func from_hand_to_slot(card: Card, slot: Slot) -> void:
	assert(not slot.is_slotted(), "That slot already has a card in it!!")
	assert(card in hand, "That card isn't even in the hand!!")
	hand.erase(card)
	slot.register_card(card)

func from_slot_to_hand(slot: Slot) -> void:
	assert(slot.is_slotted(), "That slot has nothing in it!")
	var card_in_slot := slot.unregister_card()
	assert(card_in_slot not in hand, "That card is already in the hand!")
	hand.push_back(card_in_slot)

const CARD_WIDTH := 125
const GAP_BETWEEN_CARDS := 10
@export var hand_lerp_speed: float = 8.0
func _process(delta: float) -> void:
	var hand_size := hand.size()
	if not hand_size: return
	sort_hand_by_x()
	
	#get the centre start
	var total_width := hand_size * CARD_WIDTH + (hand_size - 1) * GAP_BETWEEN_CARDS
	var start_x := global_position.x - total_width / 2.
	
	#pos calc bullshit
	for i in hand_size:
		var card := hand[i]
		
		#gtfo dragged card
		var picked_card_mutex: CardMutex = LevelHandler.level.card_handler.picked_card
		if picked_card_mutex.is_locked(): 
			if picked_card_mutex.get_ref() == card: continue
		
		var target_pos := Vector2(
			start_x + i * (CARD_WIDTH + GAP_BETWEEN_CARDS),
			global_position.y
		)
		
		card.global_position = card.global_position.lerp(target_pos, hand_lerp_speed * delta)
