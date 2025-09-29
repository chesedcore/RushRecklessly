class_name Slot extends CenterContainer

var registered_card := CardMutex.new()
@export var area: Area2D
@export var panel: Panel

var following := true
var is_locked_down :=  false

enum ZONE {
	PLAYER,
	ENEMY,
}
@export var zone_owned_by: ZONE = ZONE.PLAYER

func register_card(card: Card) -> void:
	registered_card.acquire(card)

func unregister_card() -> Card:
	if not registered_card.is_locked(): return null
	return registered_card.release()

func is_slotted() -> bool:
	return registered_card.is_locked()

func _ready() -> void:
	area.mouse_entered.connect(_on_hover)
	area.mouse_exited.connect(_on_unhover)

func _process(delta: float) -> void:
	move_card_inside(delta)

func move_card_inside(delta: float) -> void:
	if not following: return
	if not registered_card.is_locked(): return
	var card := registered_card.get_ref()
	var target_position = self.global_position
	card.global_position = card.global_position.lerp(target_position, delta * 10)

var tween: Tween
func pop_out() -> void:
	if tween: tween.kill()
	tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property(self, "scale", Vector2.ONE * 1.15, 0.6)

func pop_in() -> void:
	if tween: tween.kill()
	tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property(self, "scale", Vector2.ONE, 0.6)

func _on_hover() -> void:
	if not zone_owned_by == ZONE.PLAYER: return
	if not LevelHandler.level.card_handler.picked_card.is_locked(): return
	pop_out()

func _on_unhover() -> void:
	if not zone_owned_by == ZONE.PLAYER: return
	pop_in()
