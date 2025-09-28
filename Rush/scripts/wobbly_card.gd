extends TextureRect

const MAX_ROT = 9.0  #degrees of tilt
const SMOOTHNESS = 8.0
const FLOAT_SPEED = 1.5  #how fast it idly floats

@onready var mat := material as ShaderMaterial
var target_x_rot := 0.0
var target_y_rot := 0.0
var hovering := false
var t := randf_range(0.0, 6.9)  #time accumulator

#func _ready() -> void:
	#set_process(true)
	#set_process_input(true)

func _process(delta) -> void:
	t += delta

	if not hovering:
		#float idly (use an orbital motion to switch up the target x and y)
		target_x_rot = sin(t * FLOAT_SPEED) * MAX_ROT * 0.3
		target_y_rot = cos(t * FLOAT_SPEED) * MAX_ROT * 0.3

	#ease to target, good thing that this also eases when you leave the card
	#so it transitions back to floating smoothly
	mat.set_shader_parameter("x_rot", lerp(mat.get_shader_parameter("x_rot"), target_x_rot, delta * SMOOTHNESS))
	mat.set_shader_parameter("y_rot", lerp(mat.get_shader_parameter("y_rot"), target_y_rot, delta * SMOOTHNESS))

#if Input wasn't a singleton, this would lag BAD
#thanks for the footguns godot :heart:
func _input(event) -> void:
	if event is InputEventMouseMotion and hovering:
		var local_pos: = get_local_mouse_position()
		var center: = size / 2.0
		var offset: = (local_pos - center) / center
		offset = offset.clamp(Vector2(-1, -1), Vector2(1, 1))

		target_x_rot = -offset.y * MAX_ROT
		target_y_rot = offset.x * MAX_ROT

func _on_area_mouse_entered() -> void:
	hovering = true


func _on_area_mouse_exited() -> void:
	hovering = false
