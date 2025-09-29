extends Node

var animation_lock := CountedLock.new("AnimationLock")
var window_lock := CountedLock.new("WindowLock")
var phase_lock := CountedLock.new("PhaseLock")
var locks: Array[CountedLock] = [animation_lock, window_lock, phase_lock]

signal animation_started
signal animation_ended
signal window_opened
signal window_closed
signal main_locked
signal main_unlocked

func is_unlocked() -> bool:
	for lock in locks:
		if not lock.is_unlocked():
			print_rich("[color=blue]" + str(lock) + "is still locked![/color]")
			return false
	return true

func _ready() -> void:
	animation_started.connect(animation_lock.add_lock)
	animation_ended.connect(animation_lock.remove_lock)
	window_opened.connect(window_lock.add_lock)
	window_closed.connect(window_lock.remove_lock)
	main_locked.connect(phase_lock.add_lock)
	main_unlocked.connect(phase_lock.remove_lock)
