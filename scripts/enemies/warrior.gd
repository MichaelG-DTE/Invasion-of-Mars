class_name Warrior extends GenisysEnemy

@export var follow_speed : float = 3.0
@export var attack_damage := 10.0
@export var is_shielded := false
@onready var detection_area: Area3D = $DetectionArea
@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D
@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D
@onready var state_chart: StateChart = $StateChart
@onready var health_component: HealthComponent = $HealthComponent
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var see_cast: RayCast3D = $SeeCast

var target : Node3D
var state_machine
var dead := false
var attack_range := 2.0
var following := false
var can_attack := true
var attack_timer := 3.0

# same comments as the voidtrooper, see voidtrooper script for explanations

func on_save_game(saved_data : Array[SavedData]):
	if dead:
		return
	
	var my_data = SavedData.new()
	
	my_data.transform = global_transform
	my_data.scene_path = scene_file_path
	my_data.health = health_component.current_health
	my_data.shield = health_component.current_shield
	my_data.is_following = following
	if is_shielded:
		my_data.shield_visible = %ShieldSphere.visible
	my_data.my_level = globalvar.current_level
	
	saved_data.append(my_data)

func on_before_load_game():
	queue_free()

func on_load_game(saved_data : SavedData):
	global_transform = saved_data.transform
	health_component.current_health = saved_data.health
	health_component.current_shield = saved_data.shield
	following = saved_data.is_following
	if is_shielded:
		%ShieldSphere.visible = saved_data.shield_visible
	
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
		if !globalvar.in_terminal:
			# give the enemies gravity
			if not is_on_floor():
				velocity.y -= 20.0 * delta
				
			if following:
				if can_attack:
					if global_position.distance_to(target.global_position) < attack_range:
						state_chart.send_event("ToAttack")
				move_and_slide()
	
func _process(delta: float) -> void:
	# attack timer for enemies
	if attack_timer > 0:
		attack_timer -= delta
		if attack_timer <= 0:
			can_attack = true
			attack_timer = 3.0
			
	if health_component.current_shield == 0:
		if is_shielded and !dead:
			$ShieldPlayer.play_backwards("shield activate and deactivate")

func on_triggered() -> void:
	following = true
	state_chart.send_event("OnFollow")
	state_machine.travel("Run")
	
func _on_died() -> void:
	dead = true
	state_machine.travel("Death")
	detection_area.call_deferred("queue_free")
	collision_shape_3d.call_deferred("queue_free")
	await get_tree().create_timer(3).timeout
	queue_free()
	
func _on_velocity_computed(safe_velocity: Vector3) -> void:
	velocity.x = safe_velocity.x
	velocity.z = safe_velocity.z

func _on_follow_state_state_physics_processing(delta: float) -> void:
	if !dead:
		if !globalvar.in_terminal:
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
				var direction = (next_pos - self.global_position).normalized()
				
				# set velocity
				navigation_agent_3d.velocity = direction * follow_speed
				
				# rotate enemy
				if direction.length() > 0.01:
					var target_rotation = atan2(direction.x, direction.z)
					rotation.y = lerp_angle(rotation.y, target_rotation, 5.0 * delta)
			else:
				state_chart.send_event("Idle")

func _on_idle_state_state_physics_processing(_delta: float) -> void:
	if !dead:
		if !following:
			state_machine.travel("Idle")

func _apply_damage_to_target(attacked: Node3D) -> void:
	# check if target has health component
	var health = attacked.get_node_or_null("HealthComponent")
	
	if health and health.has_method("take_damage"):
		health.take_damage(attack_damage, attacked)

func _on_attack_state_state_physics_processing(_delta: float) -> void:
	# plays attack animation and applies damage to target
	if !dead:
		if can_attack:
			state_machine.travel("Attack")
			_apply_damage_to_target(target)
			can_attack = false
		else:
			state_chart.send_event("OnFollow")

func apply_velocity():
	velocity.y += 15

func _on_see_timer_timeout() -> void:
	if !dead:
		if !globalvar.in_terminal:
			var overlaps = $DetectionArea.get_overlapping_bodies()
			if overlaps.size() > 0:
				for overlap in overlaps:
					if overlap.is_in_group("player"):
						var playerposition = overlap.global_position
						see_cast.look_at(playerposition, Vector3.UP)
						see_cast.force_raycast_update()
						
						if see_cast.is_colliding():
							var collider = see_cast.get_collider()
							if collider.is_in_group("player"):
								# sends the enemies to the run state and follows the player
								on_triggered()
							else:
								# stops the enemies from moving if they don't see the player
								state_chart.send_event("OnIdle")
								state_machine.travel("Idle")
								velocity = Vector3.ZERO
								navigation_agent_3d.velocity = Vector3.ZERO
