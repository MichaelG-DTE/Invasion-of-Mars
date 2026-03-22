extends WorldEnvironment

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	SignalBus.button_pressed.connect(collapse)

func collapse():
	animation_player.play("suncollapse")
