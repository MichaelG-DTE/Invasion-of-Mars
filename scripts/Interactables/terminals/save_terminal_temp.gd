extends StaticBody3D

@onready var label: Label = $Label
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	label.hide()

func interact():
	label.show()
	animation_player.play("Saved")
	SignalBus.save_level.emit()
