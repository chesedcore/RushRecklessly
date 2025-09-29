@abstract class_name CardRes extends Resource

@export_multiline var flavour_text: String
@export var hp: int
@export var atk: int
@export var image: CompressedTexture2D
var card_attached_to: Card

func _on_summon() -> void: pass
func _on_battle_start() -> void: pass
func _on_battle_end() -> void: pass
func _on_destroyed() -> void: pass
