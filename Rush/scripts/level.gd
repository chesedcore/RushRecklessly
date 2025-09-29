class_name Level extends Control

@export var card_handler: CardHandler
@export var player_hand: PlayerHand
@export var enemy_hand: EnemyHand
@export var field: Field
@export var warning: RichTextLabel

func _ready() -> void:
	LevelHandler.level = self
	Bus.level_init.emit()

func get_opposing_card_to(card: Card) -> Card:
	return field.get_opposing_card_to(card)

func display_warning_leader_missing() -> void:
	warning.set_text(
		"[shake]There must be a card in the Leader (centre) zone![/shake]"
	)

func clear_warnings() -> void:
	warning.set_text("")
