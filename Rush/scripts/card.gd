class_name Card extends Node2D

@export var area: Area2D
@export var image_rect: TextureRect
@export var card_res: CardRes
var is_locked_down: bool = false
var allegiance: Slot.ZONE

static func from(res: CardRes) -> Card:
	var card: Card = preload("res://scenes/card.tscn").instantiate()
	card.card_res = res
	return card 

func _ready() -> void:
	if not card_res: return
	image_rect.texture = card_res.image
	card_res.card_attached_to = self

func heal(amt: int) -> void:
	card_res.hp += amt

func take_damage(amt: int) -> void:
	card_res.hp -= amt
	card_res.hp = maxi(card_res.hp, 0)
