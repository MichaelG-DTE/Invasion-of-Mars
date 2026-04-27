extends Control
@onready var return_button_sfx: AudioStreamPlayer = $Return/ReturnButtonSFX

func _on_return_pressed() -> void:
	return_button_sfx.play()
	await get_tree().create_timer(0.5).timeout
	visible = false
