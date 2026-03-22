extends StaticBody3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var has_pressed := false

func interact():
	if has_pressed == false:
		print("haha button press")
		animation_player.play("pressed")
		SignalBus.button_pressed.emit()
		has_pressed = true
