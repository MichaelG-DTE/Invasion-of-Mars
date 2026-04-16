extends Node

var level = 1

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("quit"):
		get_tree().quit()
	elif event.is_action_pressed("reset"):
		get_tree().reload_current_scene()

func _ready() -> void:
	SignalBus.level_change.connect(change_level)
	
func change_level():
	print("level change")
