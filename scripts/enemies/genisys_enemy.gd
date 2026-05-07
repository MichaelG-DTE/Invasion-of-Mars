class_name GenisysEnemy extends CharacterBody3D

@export var enemy_groups: Array[String] = []

# base enemy used for all enemies, kinda doesn't do anything 

func _ready() -> void:
	for group in enemy_groups:
		add_to_group(group)
		
func on_triggered() -> void:
	# override in child classes
	pass
