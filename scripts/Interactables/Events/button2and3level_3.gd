extends StaticBody3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var firstbutton_level_3: StaticBody3D = $"."


var has_pressed := false

func interact():
	if not has_pressed:
		has_pressed = true
		if self == firstbutton_level_3:
			animation_player.play("pressed")
