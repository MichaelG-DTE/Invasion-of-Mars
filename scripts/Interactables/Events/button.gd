extends StaticBody3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var has_pressed := false

func interact():
	if has_pressed == false:
		print("haha button press")
		animation_player.play("pressed")
		$"../TerminalTemp".page_number += 1
		$"../Door".locked = false
		has_pressed = true
