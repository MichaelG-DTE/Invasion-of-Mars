extends Node3D

@onready var player_spawn: Marker3D = $PlayerSpawn

var player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	player.global_position = player_spawn.global_position
	globalvar.can_teleport = false
