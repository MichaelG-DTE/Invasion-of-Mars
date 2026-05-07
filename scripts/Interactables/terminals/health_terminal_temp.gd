extends StaticBody3D

# terminal that healths the players HEALTH only not shield

@onready var terminal_access_sfx: AudioStreamPlayer3D = $TerminalAccessSFX

var heal_amount : float

var player = Node3D

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player") 

func interact():
	terminal_access_sfx.play()
	var health = player.get_node_or_null("HealthComponent")
	# only heals if not at max health already
	if health.current_health < health.max_health:
		heal_amount = health.max_health - health.current_health
		_apply_health_to_player(player)
	else:
		pass
		
func _apply_health_to_player(target: Node3D) -> void:
	# check if target has health component
	var health = target.get_node_or_null("HealthComponent")
	
	if health and health.has_method("heal"):
		health.heal(heal_amount)
