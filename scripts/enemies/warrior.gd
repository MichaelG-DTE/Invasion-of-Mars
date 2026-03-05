class_name Warrior extends GenisysEnemy

@export var follow_speed : float = 3.0
@onready var detection_area: Area3D = $DetectionArea
@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D
@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D
@onready var state_chart: StateChart = $StateChart
@onready var health_component: HealthComponent = $HealthComponent
@onready var animation_tree: AnimationTree = $AnimationTree

var target : Node3D
var state_machine
var dead := false
var following := true

var attack_range := 2.0
var attack_damage := 10

func _ready() -> void:
	super._ready()
	
	# find target = target is player
	target = get_tree().get_first_node_in_group("player")
	
	# connect signals
	health_component.died.connect(_on_died)
	navigation_agent_3d.velocity_computed.connect(_on_velocity_computed)
	state_machine = animation_tree.get("parameters/playback")

	
func _physics_process(delta: float) -> void:
	if !dead:
		# give the enemies gravity
		if not is_on_floor():
			velocity.y -= 20.0 * delta
		if following:
			if global_position.distance_to(target.global_position) < attack_range:
				_on_attack_state_state_physics_processing(delta)
			move_and_slide()


func on_triggered() -> void:
	state_chart.send_event("OnFollow")
	state_machine.travel("Run")
	following = true
	
func _on_died() -> void:
	detection_area.set_deferred("monitoring", false)
	collision_shape_3d.set_deferred("monitoring", false)
	# sets dead to true, preventing movement
	# disables collision and detection
	dead = true
	state_machine.travel("Death")

	await get_tree().create_timer(3).timeout
	queue_free()
	
func _on_velocity_computed(safe_velocity: Vector3) -> void:
	velocity.x = safe_velocity.x
	velocity.z = safe_velocity.z

func _on_follow_state_state_physics_processing(delta: float) -> void:
	if !dead:
		if following:
			if not target:
				return
					
			# set target position for navmesh
			navigation_agent_3d.target_position = target.global_position
				
			# check if navigation finished
			if navigation_agent_3d.is_navigation_finished():
				navigation_agent_3d.velocity = Vector3.ZERO
				return
					
			# get next positon 
			var next_pos = navigation_agent_3d.get_next_path_position()
			var direction = (next_pos - global_position).normalized()
				
			# set velocity
			navigation_agent_3d.velocity = direction * follow_speed
				
			# rotate enemy
			if direction.length() > 0.01:
				var target_rotation = atan2(direction.x, direction.z)
				rotation.y = lerp_angle(rotation.y, target_rotation, 5.0 * delta)


func _on_detection_area_body_entered(body: Node3D) -> void:
	# triggers the enemy to pathfind to player
	if body.is_in_group("player"):
		on_triggered()

func _on_idle_state_state_physics_processing(_delta: float) -> void:
	# enemy idles when unactivated
	if !dead:
		state_machine.travel("Idle")
		

func _on_attack_state_state_physics_processing(_delta: float) -> void:
	# plays attack animation
	if !dead:
		state_machine.travel("Attack")
		state_chart.send_event("OnIdle")
		
func _apply_damage_to_target(attacked: Node3D) -> void:
	# check if target has health component
	var health = attacked.get_node_or_null("HealthComponent")
	
	if health and health.has_method("take_damage"):
		health.take_damage(attack_damage, owner)
