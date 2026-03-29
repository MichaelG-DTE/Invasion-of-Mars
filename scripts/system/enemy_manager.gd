extends Node

var enemies 
var enemy_position_array := []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	enemies = get_tree().get_first_node_in_group("enemies")
	#get_enemy_positions()
	
func get_enemy_positions():
	for enemy in enemies:
		var enemy_data = {
		"x" = enemy.global_position.x,
		"y" = enemy.global_position.y,
		"z" = enemy.global_position.z
		}
		enemy_position_array.append(enemy_data)
	print(enemy_position_array)
