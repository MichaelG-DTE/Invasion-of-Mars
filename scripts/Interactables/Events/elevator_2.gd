extends StaticBody3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer


var lowered = false

func interact():
	if not lowered:
		animation_player.play("elevate")
		lowered = true
		await animation_player.animation_finished
		await get_tree().create_timer(5.0).timeout
		animation_player.play_backwards("elevate")
		lowered = false
