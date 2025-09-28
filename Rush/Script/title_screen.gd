extends Node2D

func _ready() -> void:
	%"Start Game".pressed.connect(_on_start_game_pressed)
	%"Options".pressed.connect(_on_options_pressed)

func _on_start_game_pressed() -> void:
	print("Pressed Start")

func _on_options_pressed() -> void:
	%OptionsMenu.set_menu_visible(true)
