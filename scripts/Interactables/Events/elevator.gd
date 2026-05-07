extends StaticBody3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

# first elevator on level 5
# both have separate scripts because they go to different heights so need separate animation players (also to prevent both going up and down at once)
# elevators automatically go up and down to prevent soft locks

var lowered = false

func interact():
	if not lowered:
		animation_player.play("elevator")
		lowered = true
		await animation_player.animation_finished
		await get_tree().create_timer(5.0).timeout
		animation_player.play_backwards("elevator")
		lowered = false
