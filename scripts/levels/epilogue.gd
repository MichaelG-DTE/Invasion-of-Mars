extends Node3D

var player
@onready var player_spawn: Marker3D = $PlayerSpawn

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	player.global_position = player_spawn.global_position
	player.global_rotation = player_spawn.global_rotation
	globalvar.can_teleport = false
	SignalBus.save_level.emit()
