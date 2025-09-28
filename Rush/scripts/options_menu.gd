extends Control

var open_close_tween : Tween

func _ready() -> void:
	%Close.pressed.connect(_on_close_pressed)
	#region Volume Sliders
	%MasterSlider.value_changed.connect(_on_volume_changed.bind(AudioServer.get_bus_index(&"Master")))
	%BGMSlider.value_changed.connect(_on_volume_changed.bind(AudioServer.get_bus_index(&"BGM")))
	%SFXSlider.value_changed.connect(_on_volume_changed.bind(AudioServer.get_bus_index(&"SFX")))
	#endregion

func _on_volume_changed(new_value: float, bus_idx: int) -> void:
	AudioServer.set_bus_volume_db(bus_idx, linear_to_db(new_value))

func _on_close_pressed() -> void:
	set_menu_visible(false)

func set_menu_visible(is_visible: bool) -> void:
	if is_visible:
		SoundManager._set_bgm_bus(true)
	else:
		SoundManager._set_bgm_bus(false)
	open_close_tween = create_tween()
	var final_val = 1.0 if is_visible else 0.0
	open_close_tween.tween_property(self, "scale:x", final_val, 0.25)
