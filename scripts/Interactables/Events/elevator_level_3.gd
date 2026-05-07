extends StaticBody3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer


# elevator on level 3
# this elevator does not go up and down automatically because that would soft lock level 3

var lowered = false

func interact():
	if not lowered:
		animation_player.play("elevator")
		lowered = true
		
	else:
		animation_player.play_backwards("elevator")
		lowered = false
