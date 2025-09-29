class_name EnemyHand extends Marker2D

var enemy_hand: Array[Card] = [
	Card.from(Data.gallius),
	Card.from(Data.gallius),
	Card.from(Data.gallius),
]

func _ready() -> void:
	await Bus.level_init
	materialise_hand()
	slot_into_zones()

func materialise_hand() -> void:
	for card in enemy_hand:
		self.add_child(card)

func slot_into_zones() -> void:
	Gate.animation_started.emit()
	await get_tree().create_timer(1).timeout
	var slots: Array[int] = [0,1,2]
	for card: Card in enemy_hand:
		var picked_index: int = slots.pick_random()
		slots.erase(picked_index)
		var picked_slot: Slot = LevelHandler.level.field.enemy_zones[picked_index]
		picked_slot.register_card(card)
	Gate.animation_ended.emit()
