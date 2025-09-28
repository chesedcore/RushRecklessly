extends Node

@export var _bgm: AudioStreamPlayer
@export var _bgm_paused: AudioStreamPlayer

func _ready() -> void:
	_bgm.finished.connect(_replay_bgm.bind(_bgm))
	_bgm_paused.finished.connect(_replay_bgm.bind(_bgm_paused))

func _replay_bgm(bgm_player: AudioStreamPlayer) -> void:
	bgm_player.play()

func play_bgm(stream: AudioStream, is_paused:= false) -> AudioStreamPlayer:
	if _bgm.stream != stream:
		_bgm.stream = stream
		_bgm_paused.stream = stream
		
		_bgm_paused.play(_bgm.get_playback_position())
		_bgm.play(_bgm_paused.get_playback_position())
	
	_set_bgm_bus(is_paused)
	return _bgm

func play_sfx(stream: AudioStream, pitch:= 0.0) -> Node:
	assert(stream, "MONARCH WHY IS THE AUDIO NULL")
	var current_stream := AudioStreamPlayer.new()
	current_stream.bus = &"SFX"
	current_stream.stream = stream
	add_child(current_stream)
	
	current_stream.pitch_scale = randf_range(1.0 - pitch, 1.0 + pitch)
	
	current_stream.finished.connect(current_stream.queue_free)
	current_stream.play()
	return current_stream

func _set_bgm_bus(is_paused: bool) -> void:
	if is_paused:
		_bgm_paused.volume_db = 0.0
		_bgm.volume_db = -80.0
	else:
		_bgm.volume_db = 0.0
		_bgm_paused.volume_db = -80.0
	
