extends Node


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("quit"):
		get_tree().quit()
	elif event.is_action_pressed("reset"):
		get_tree().reload_current_scene()
