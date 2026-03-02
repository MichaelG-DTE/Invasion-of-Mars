extends WorldEnvironment

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("collapse"):
		animation_player.play("suncollapse")
