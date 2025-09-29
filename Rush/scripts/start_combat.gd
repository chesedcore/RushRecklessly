class_name CombatStarter extends Button


func _on_pressed() -> void:
	ActionHandler.attempt_to_start_combat()
