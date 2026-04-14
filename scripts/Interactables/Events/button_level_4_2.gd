extends StaticBody3D

@onready var animation_player_2: AnimationPlayer = $AnimationPlayer2
@onready var door_3: StaticBody3D = $"../Door3"


var has_pressed := false

func interact():
	if not has_pressed:
		has_pressed = true
		animation_player_2.play("pressed")
		door_3.locked = false
