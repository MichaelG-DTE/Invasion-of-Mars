extends StaticBody3D

@onready var terminal_access_sfx: AudioStreamPlayer3D = $TerminalAccessSFX

var heal_amount : float

var player = Node3D

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player") 

func interact():
	terminal_access_sfx.play()
	var shield = player.get_node_or_null("HealthComponent")
	if shield.current_shield != shield.max_shield:
		heal_amount = shield.max_shield - shield.current_shield
		_apply_health_to_player(player)
	else:
		pass

func _apply_health_to_player(target: Node3D) -> void:
	# check if target has health component
	var shield = target.get_node_or_null("HealthComponent")
	
	if shield and shield.has_method("heal_shield"):
		shield.heal_shield(heal_amount)
