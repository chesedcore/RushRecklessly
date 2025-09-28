extends Control

var open_close_tween : Tween

func _ready() -> void:
	%Close.pressed.connect(_on_close_pressed)
	
func _on_close_pressed() -> void:
	set_menu_visible(false)

func set_menu_visible(is_visible: bool) -> void:
	open_close_tween = create_tween()
	var final_val = 1.0 if is_visible else 0.0
	open_close_tween.tween_property(self, "scale:x", final_val, 0.25)
	
