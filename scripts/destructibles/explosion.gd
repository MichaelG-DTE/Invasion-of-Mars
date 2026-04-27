extends Node3D


var explosion_damage := 50.0
@export var explosionvfx : Node3D
@onready var explosion_sfx: AudioStreamPlayer3D = $ExplosionSFX

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	explosionvfx.call_explosion()
	explosion_sfx.play()
	await get_tree().create_timer(0.5).timeout
	queue_free()
	
func _on_explosion_detection_range_body_entered(body: Node3D) -> void:
	if body.has_method("apply_velocity"):
			body.apply_velocity()
			
	var health_component = body.get_node_or_null("HealthComponent")
	
	if health_component and health_component.has_method("take_damage"):
		health_component.take_damage(explosion_damage, owner)
		
