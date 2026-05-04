extends Node3D

var player
@onready var player_spawn: Marker3D = $PlayerSpawn
@onready var new_player_position: Marker3D = $Geometry/Epilogue/NewPlayerPosition

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	player.global_position = player_spawn.global_position
	player.global_rotation = player_spawn.global_rotation
	globalvar.can_teleport = false
	SignalBus.save_level.emit()

func _process(_delta: float) -> void:
	if globalvar.can_teleport == true:
		player.global_position = new_player_position
