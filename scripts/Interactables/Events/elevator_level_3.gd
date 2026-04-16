extends StaticBody3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var lowered = false

func interact():
	if not lowered:
		animation_player.play("elevator")
		lowered = true
		
	else:
		animation_player.play_backwards("elevator")
		lowered = false
