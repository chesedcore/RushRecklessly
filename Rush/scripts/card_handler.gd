class_name CardHandler extends Node2D

var hovered_card := CardMutex.new()
var picked_card := CardMutex.new()

var _offset_vector := Vector2.ZERO

func _ready() -> void:
	wire_up_signals()

func _process(_delta: float) -> void:
	frame_routine()
	
func wire_up_signals() -> void:
	for card: Card in get_children():
		#when these cards are freed, the connections are also freed. so no need to manually disconnect
		card.area.mouse_entered.connect(hovered_card.acquire.bind(card))
		card.area.mouse_exited.connect(hovered_card.release)

func frame_routine() -> void:
	card_move_system()

func pick_up_card(card: Card) -> void:
	picked_card.acquire(card)
	_offset_vector = card.global_position - get_global_mouse_position()
	Bus.card_picked_up.emit(card)

func card_move_system() -> void:
	var card := picked_card.card
	if not card: return
	card.global_position = get_global_mouse_position() + _offset_vector

func drop_card() -> void:
	assert(picked_card.card)
	var card := picked_card.release()
	Bus.card_dropped.emit(card)

#checks for mouse picks up and drags
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if not hovered_card.card: return #if there is no card being moused over on, why bother
		if event.pressed: pick_up_card(hovered_card.card)
		else: drop_card()
