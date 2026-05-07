extends StaticBody3D

@onready var label: Label = $Label
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var terminal_access_sfx: AudioStreamPlayer3D = $TerminalAccessSFX

func _ready() -> void:
	label.hide()

# calls the signal to save the level when interacting with the save terminal
func interact():
	terminal_access_sfx.play()
	label.show()
	animation_player.play("Saved")
	SignalBus.save_level.emit()
