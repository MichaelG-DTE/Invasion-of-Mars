class_name EnemyProjectile extends Area3D

var velocity: Vector3
var damage: float


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	# deletes projectile after three seconds
	get_tree().create_timer(3.0).timeout.connect(queue_free)

# finds where the bullet should land, calls the body entered function
func _physics_process(delta: float) -> void:
	var space_state = get_world_3d().direct_space_state
	var start_pos = global_position
	var end_pos = global_position + velocity * delta
	
	var query = PhysicsRayQueryParameters3D.create(start_pos, end_pos)
	query.collision_mask = 1
	var result = space_state.intersect_ray(query)
	
	if result:
		global_position = result.position
		_on_body_entered(result.collider)
		return
	
	global_position = end_pos
	
func setup(vel: Vector3, dmg: float) -> void:
	velocity = vel
	damage = dmg

# if the body has a health component then takes damage
func _on_body_entered(body: Node3D) -> void:
	print("Projectile hit: ", body.name, " at ", global_position)

	var health_component = body.get_node_or_null("HealthComponent")
	
	if health_component and health_component.has_method("take_damage"):
		health_component.take_damage(damage, self)
	queue_free()
	
# there was a function here to spawn impact markers, but I have removed it because it is no longer needed 
