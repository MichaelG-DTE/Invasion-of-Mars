extends StaticBody3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var door: StaticBody3D = $"../Door"
@onready var door_2: StaticBody3D = $"../Door2"

var has_pressed := false

func interact():
	if not has_pressed:
		animation_player.play("pressed")
		door.locked = false
		door_2.locked = false
		has_pressed = true
		
