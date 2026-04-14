extends StaticBody3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var door: StaticBody3D = $"../Door"

var has_pressed := false

func interact():
	if not has_pressed:
		has_pressed = true
		animation_player.play("pressed")
		door.locked = false
		
