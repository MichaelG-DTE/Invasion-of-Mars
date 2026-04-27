class_name VoidTrooper extends GenisysEnemy

@export var follow_speed : float = 3.0
@export var attack_damage := 10.0
@onready var detection_area: Area3D = $DetectionArea
@onready var state_chart: StateChart = $StateChart
@onready var base_collision_shape_3d: CollisionShape3D = $CollisionShape3D
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D
@onready var health_component: HealthComponent = $HealthComponent
@export var projectile_scene : PackedScene
@export var is_shielded := false
@onready var see_cast: RayCast3D = $SeeCast
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var alien_gun_sfx: AudioStreamPlayer3D = $AlienGunSFX

var target : Node3D
var state_machine
var dead := false
var attack_range := 7.50
var following := true
var can_attack := true
var attack_timer := 0.0
var accuracy := 70
var projectile_speed := 30.0
var damage := 10.0
var fire_rate := 4

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
	print(my_data.my_level)
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
	print(saved_data.my_level)
	if saved_data.my_level != globalvar.current_level:
		print("you shouldn't be here")
		queue_free()
	
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
			if can_attack:
				if following:
					if global_position.distance_to(target.global_position) < attack_range:
						state_chart.send_event("ToAttack")
			move_and_slide()

func _process(delta: float) -> void:
	# attack timer for enemies
	if attack_timer > 0:
		attack_timer -= delta
		if attack_timer <= 0:
			can_attack = true

	if health_component.current_shield == 0:
		if is_shielded and !dead:
			$VoidtrooperShieldPlayer.play_backwards("shield activate and deactivate")
	
	

func on_triggered() -> void:
	state_chart.send_event("OnFollow")
	state_machine.travel("Run")

func _on_died() -> void:
	dead = true
	state_machine.travel("Death")
	detection_area.set_deferred("monitoring", false)
	await get_tree().create_timer(3).timeout
	queue_free()

func _on_velocity_computed(safe_velocity: Vector3) -> void:
	following = true
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
		else:
			state_chart.send_event("Idle")

func _on_idle_state_state_physics_processing(_delta: float) -> void:
	if !dead:
		if !following:
			state_machine.travel("Idle")

func _on_attack_state_state_physics_processing(delta: float) -> void:
	# plays attack animation and applies damage to target
	if !dead:
		if can_attack:
			alien_gun_sfx.play()
			var next_pos = navigation_agent_3d.get_next_path_position()
			var direction = (next_pos - global_position).normalized()
			var target_rotation = atan2(direction.x, direction.z)
			rotation.y = lerp_angle(rotation.y, target_rotation, 20 * delta)
			velocity = Vector3.ZERO
			navigation_agent_3d.velocity = Vector3.ZERO
			animation_player.speed_scale = 4.0
			state_machine.travel("Attack")
			_spawn_projectile()
			can_attack = false
		else:
			animation_player.speed_scale = 1.0
			state_chart.send_event("OnFollow")

func apply_velocity():
	velocity.y += 15

func _spawn_projectile() -> void:
	var projectile = projectile_scene.instantiate()
	get_tree().current_scene.add_child(projectile)
		
	# position at camera
		
	projectile.global_transform = $%Marker3D.global_transform
		
	# calculate direction and velocity
	var forward = $%Marker3D.global_transform.basis.z
		
	var accuracy_spread = (100 - accuracy) / 1000.0
	var accuracy_x = randf_range(-accuracy_spread, accuracy_spread)
	var accuracy_y = randf_range(-accuracy_spread, accuracy_spread)
	var direction = forward + Vector3(accuracy_x, accuracy_y, 0) * $%Marker3D.global_transform.basis
		
	@warning_ignore("shadowed_variable_base_class")
	var velocity = direction * projectile_speed
	
	# prepare the projectile
	projectile.setup(velocity, damage)

	can_attack = false
	attack_timer = 1.0 / fire_rate

func _on_see_timer_timeout() -> void:
	if !dead:
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
