class_name Mage extends CardRes

func _on_battle_end() -> void:
	var opposing_card: Card = LevelHandler.level.field.get_opposing_card_to(card_attached_to)
	await opposing_card.take_damage(1)
