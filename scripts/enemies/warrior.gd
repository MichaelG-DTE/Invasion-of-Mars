class_name Warrior extends GenisysEnemy

@export var follow_speed : float = 3.0

@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D
@onready var state_chart: StateChart = $StateChart
@onready var health_component: HealthComponent = $HealthComponent

var target : Node3D

func _ready() -> void:
	super._ready()
	
	# find target = target is player
	target = get_tree().get_first_node_in_group("player")
	
	# connect signals
	health_component.died.connect(_on_died)
	navigation_agent_3d.velocity_computed.connect(_on_velocity_computed)
	

func _physics_process(delta: float) -> void:
	# give the enemies gravity
	if not is_on_floor():
		velocity.y -= 20.0 * delta
		
	move_and_slide()
	

func on_triggered() -> void:
	state_chart.send_event("OnFollow")
	
func _on_died() -> void:
	queue_free()
	
func _on_velocity_computed(safe_velocity: Vector3) -> void:
	velocity.x = safe_velocity.x
	velocity.z = safe_velocity.z

func _on_follow_state_state_physics_processing(delta: float) -> void:
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
	if body.is_in_group("player"):
		on_triggered()
