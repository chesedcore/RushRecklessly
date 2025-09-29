extends Node

var in_combat: bool = false

func attempt_to_start_combat() -> void:
	if not LevelHandler.level.field.player_leader_zone.is_slotted():
		LevelHandler.level.display_warning_leader_missing()
		return
	LevelHandler.level.clear_warnings()
	start_combat()

func stop_slot_pull() -> void:
	var all_slots := LevelHandler.level.field.get_all_slots()
	for slot in all_slots:
		slot.following = false

func reset_slot_pull() -> void:
	var all_slots := LevelHandler.level.field.get_all_slots()
	for slot in all_slots:
		slot.following = true

func start_combat() -> void:
	in_combat = true
	Bus.combat_started.emit()
	Gate.main_locked.emit()
	stop_slot_pull()
	await resolve_combat_start_effects()
	await clash_pairs()
	await resolve_combat_end_effects()
	reset_slot_pull()
	bounce_cards_to_hand()
	LevelHandler.level.enemy_hand.slot_into_zones()
	Gate.main_unlocked.emit()
	Bus.combat_ended.emit()
	in_combat = false
	

func bounce_cards_to_hand() -> void:
	for slot in LevelHandler.level.field.player_zones:
		slot.is_locked_down = false
		if not slot.is_slotted(): continue
		var card := slot.registered_card.get_ref()
		card.is_locked_down = false
		LevelHandler.level.player_hand.from_slot_to_hand(slot)
	
	var tween: Tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	for slot in LevelHandler.level.field.enemy_zones:
		slot.is_locked_down = false
		if not slot.is_slotted(): continue
		var card := slot.registered_card.get_ref()
		card.is_locked_down = false
		tween.parallel().tween_property(card, "global_position", LevelHandler.level.enemy_hand.global_position, 0.5)
		slot.unregister_card()

func resolve_combat_start_effects() -> void:
	var all_slots := LevelHandler.level.field.get_all_slots()
	for slot in all_slots:
		if not slot.is_slotted(): continue
		var card := slot.registered_card.get_ref()
		if not card.card_res: continue
		@warning_ignore("redundant_await")
		await card.card_res._on_battle_start()

func resolve_combat_end_effects() -> void:
	var all_slots := LevelHandler.level.field.get_all_slots()
	for slot in all_slots:
		if not slot.is_slotted(): continue
		var card := slot.registered_card.get_ref()
		if not card.card_res: continue
		@warning_ignore("redundant_await")
		await card.card_res._on_battle_end()

func clash_pairs() -> void:
	var opposing_pairs := LevelHandler.level.field.generate_opposing_card_pairs()
	for card_pair: Array[Card] in opposing_pairs:
		var player_card: Card = card_pair[0]
		var enemy_card: Card = card_pair[1]
		await animate_combat_between(player_card, enemy_card)

func animate_combat_between(player_card: Card, enemy_card: Card) -> void:
	if not player_card or not enemy_card: return
	var original_position_player := player_card.global_position
	var original_position_enemy := enemy_card.global_position
	var midpoint := (player_card.global_position + enemy_card.global_position) / 2
	var tween := create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_EXPO)
	tween.tween_property(player_card, "global_position", midpoint, 0.5)
	tween.parallel().tween_property(enemy_card, "global_position", midpoint, 0.5)
	await tween.finished
	await perform_damage_calculation(player_card, enemy_card)
	var fallback_tween := create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	fallback_tween.tween_property(player_card, "global_position", original_position_player, 0.5)
	fallback_tween.parallel().tween_property(enemy_card, "global_position", original_position_enemy, 0.5)
	await fallback_tween.finished

func perform_damage_calculation(player_card: Card, enemy_card: Card) -> void:
	if not player_card.card_res or not enemy_card.card_res: return
	
	enemy_card.card_res.hp = player_card.card_res.atk
	enemy_card.card_res.hp = max(0, enemy_card.card_res.hp)
	
	player_card.card_res.hp = enemy_card.card_res.atk
	player_card.card_res.hp = max(0, player_card.card_res.hp)
