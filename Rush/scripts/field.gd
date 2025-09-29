class_name Field extends VBoxContainer

@export_category("Enemy Zones")
@export var enemy_leader_zone: Slot
@export var enemy_follower_zone: Slot
@export var enemy_follower_zone_2: Slot
@onready var enemy_zones: Array[Slot] = [
	enemy_leader_zone,
	enemy_follower_zone,
	enemy_follower_zone_2,
]

@export_category("Player Zones")
@export var player_leader_zone: Slot
@export var player_follower_zone: Slot
@export var player_follower_zone_2: Slot
@onready var player_zones: Array[Slot] = [
	player_leader_zone,
	player_follower_zone,
	player_follower_zone_2,
]

func get_all_slots() -> Array[Slot]:
	return player_zones + enemy_zones

func _ready() -> void:
	Bus.card_dropped.connect(_on_card_dropped)
	Bus.card_picked_up.connect(_on_card_picked_up)

func _on_card_dropped(card: Card) -> void:
	var results := raycast_for_slots_at(get_global_mouse_position())
	register_if_card_dropped_by(results, card)

func _on_card_picked_up(card: Card) -> void:
	var results := raycast_for_slots_at(card.global_position)
	unregister_if_card_dropped_by(results, card)

func raycast_for_slots_at(pos: Vector2) -> Array[Dictionary]:
	var world_state := get_world_2d().direct_space_state
	var params := PhysicsPointQueryParameters2D.new()
	params.position = pos
	params.collide_with_areas = true
	params.collision_mask = 2
	var results := world_state.intersect_point(params)
	return results

func register_if_card_dropped_by(res: Array[Dictionary], card: Card) -> void:
	if not res: return
	var area: Backref = res[0]["collider"]
	var slot: Slot = area.ref
	if slot.zone_owned_by == Slot.ZONE.ENEMY: return
	if slot.is_slotted(): return
	LevelHandler.level.player_hand.from_hand_to_slot(card, slot)
	slot.is_locked_down = true
	card.is_locked_down = true

func unregister_if_card_dropped_by(res: Array[Dictionary], card: Card) -> void:
	if not res: return
	var area: Backref = res[0]["collider"]
	var slot: Slot = area.ref
	
	if slot.is_locked_down: return
	
	if slot.zone_owned_by == Slot.ZONE.ENEMY: 
		LevelHandler.level.card_handler.picked_card.release()
		return
	if slot.is_slotted():
		var card_in_the_actual_slot := slot.registered_card.get_ref()
		if card_in_the_actual_slot == card:
			LevelHandler.level.player_hand.from_slot_to_hand(slot)

func generate_opposing_card_pairs() -> Array[Array]:
	var pairs: Array[Array]
	for i in 3:
		var player_side_card: Card = player_leader_zone.registered_card.get_ref()
		var enemy_side_card: Card = enemy_leader_zone.registered_card.get_ref()
		
		var iterated_zone_player: Slot = player_zones[i]
		if iterated_zone_player.is_slotted():
			player_side_card = iterated_zone_player.registered_card.get_ref()
		
		var iterated_zone_enemy: Slot = enemy_zones[i]
		if iterated_zone_enemy.is_slotted():
			enemy_side_card = iterated_zone_enemy.registered_card.get_ref()
		
		pairs.push_back([player_side_card, enemy_side_card])
	
	return pairs

func get_opposing_card_to(card: Card) -> Card:
	if card == player_leader_zone.registered_card.get_ref():
		return enemy_leader_zone.registered_card.get_ref()
	elif card == enemy_leader_zone.registered_card.get_ref():
		return player_leader_zone.registered_card.get_ref()
	
	if card == player_follower_zone.registered_card.get_ref():
		return generate_opposing_card_pairs()[1][1]
	
	elif card == enemy_follower_zone.registered_card.get_ref():
		return generate_opposing_card_pairs()[1][0]
	
	if card == player_follower_zone_2.registered_card.get_ref():
		return generate_opposing_card_pairs()[2][1]
	
	return generate_opposing_card_pairs()[2][0]
