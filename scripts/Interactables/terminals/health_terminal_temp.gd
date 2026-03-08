extends StaticBody3D

var heal_amount := 10.0

var player = Node3D

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player") 

func interact():
	var health = player.get_node_or_null("HealthComponent")
	while health.current_health != 100:
		if health.current_health > 0:
			_apply_health_to_player(player)
			print("Player healed 10 hp")
			if health.current_health == 100:
				break
		else:
			break
		
func _apply_health_to_player(target: Node3D) -> void:
	# check if target has health component
	var health = target.get_node_or_null("HealthComponent")
	
	if health and health.has_method("heal"):
		health.heal(heal_amount)
