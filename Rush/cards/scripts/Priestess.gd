class_name Priestess extends CardRes

func _on_summon() -> void:
	var leader := LevelHandler.level.field.get_leader_card_for(card_attached_to)
	if not leader: return
	await leader.heal(1)
