class_name WeaponController extends Node

@export var camera: Camera3D
@export var current_weapon : Weapon
@export var weapon_model_parent : Node3D
@export var weapon_state_chart : StateChart
@onready var ammo_label: Label = $"../../UserInterface/Control/Ammo"
@onready var current_weapon_label: Label = $"../../UserInterface/Control/CurrentWeapon"
@onready var marker_3d: Marker3D = %Marker3D
@onready var wmc: Node3D = $"../../CameraController/Camera3D/WeaponModelContainer"
@onready var player: PlayerController = $"../.."
@onready var weapon_shoot: AnimationPlayer = $"../../WeaponShoot"
@onready var weapon_reload: AnimationPlayer = $"../../WeaponReload"
@onready var managers: Node = $"../../../../Managers"

var current_weapon_model: Node3D
var can_fire_next : bool = true
var fire_rate_timer : float = 0.0

const MD_ARE_18 = preload("uid://d0mhjhy1536qp")
const MD_BMR_99 = preload("uid://cwb7ejvgbfthi")
const MD_P_11 = preload("uid://d2e3oxubj53dw")
const MD_RICO_KBM = preload("uid://bwnd6lufp0ey2")

func _ready() -> void:
	if current_weapon:
		spawn_weapon_model() # spwans weapon on first loading in
		

func _process(delta: float) -> void:
	var weapon_data = managers.weapon_manager.weapons[managers.weapon_manager.current_slot]
	# fire rate for weapons
	if fire_rate_timer > 0:
		fire_rate_timer -= delta
		if fire_rate_timer <= 0:
			can_fire_next = true
			
	ammo_label.text = "Ammo: " + str(weapon_data.ammo)
	current_weapon_label.text = "Current Weapon: " + get_weapon_name()

func spawn_weapon_model():
	if current_weapon_model:
		current_weapon_model.queue_free() # removes a previous weapon to be replaced by the current weapon
		
	if current_weapon.weapon_model:
		current_weapon_model = current_weapon.weapon_model.instantiate() # spawns the weapon model in the players hand 
		weapon_model_parent.add_child(current_weapon_model)

		current_weapon_model.position = current_weapon.weapon_position

func can_fire() -> bool:
	var weapon_data = managers.weapon_manager.weapons[managers.weapon_manager.current_slot]
	return weapon_data.ammo > 0 and can_fire_next
		
func fire_weapon() -> void:
	if can_fire(): # checks for the ammo amount
		managers.weapon_manager.use_ammo(managers.weapon_manager.current_slot) # removes one bullet
		# weapon firing animation for both shooting and shooting while aiming
		if current_weapon == MD_P_11:
			weapon_shoot.play("PistolShoot")
			if player.zoomed_in:
				weapon_shoot.play("PistolShootAim")
		if current_weapon == MD_ARE_18:
			weapon_shoot.play("AssaultRifleShoot")
			if player.zoomed_in:
				weapon_shoot.play("AssaultRifleShootAim")
		if current_weapon == MD_BMR_99:
			weapon_shoot.play("ShotgunShoot")
			if player.zoomed_in:
				weapon_shoot.play("ShotgunShootAim")
		if current_weapon == MD_RICO_KBM:
			weapon_shoot.play("RocketLauncherShoot")
			if player.zoomed_in:
				weapon_shoot.play("RocketLauncherShootAim")

		# firing cooldown
		can_fire_next = false
		fire_rate_timer = 1.0 / current_weapon.fire_rate
		
		# determines if weapon is hitscan or projectile
		if current_weapon.is_hitscan:
			_perform_hitscan()
		else:
			_spawn_projectile()

func _perform_hitscan() -> void:
	if not camera:
		print("No Camera :(")
		return # checks camera is assigned
	
	var space_state = camera.get_world_3d().direct_space_state # gets access to world physics
	var from = camera.global_position # where the weapon is firing from
	
	# Calculate accuracy spread 
	var accuracy_spread = (100 - current_weapon.accuracy) / 1000.0
	
	for i in current_weapon.pellet_count:
		var forward = -camera.global_transform.basis.z
		
		# Add accuracy randomness
		var accuracy_x = randf_range(-accuracy_spread, accuracy_spread)
		var accuracy_y = randf_range(-accuracy_spread, accuracy_spread)
		var direction = forward + Vector3(accuracy_x, accuracy_y, 0) * camera.global_transform.basis
		
		if current_weapon.pellet_count > 1:
			var spread_x = randf_range(-current_weapon.spread_angle, current_weapon.spread_angle)
			var spread_y = randf_range(-current_weapon.spread_angle, current_weapon.spread_angle)
			direction += Vector3(spread_x, spread_y, 0) * player.velocity.length() / 4
		
		
		var to = from + direction * current_weapon.range # where the raycast will detect collision
		
		var query = PhysicsRayQueryParameters3D.create(from, to) # spawns raycast to collide
		var result = space_state.intersect_ray(query) # where the ray collides
		
		if result:
			print("Hit: ", result.collider.name, "At", result.position)
			_spawn_impact_marker(result.position)
			
			_apply_damage_to_target(result.collider)

func _spawn_impact_marker(position: Vector3) -> void:
	var marker = MeshInstance3D.new()
	var box = BoxMesh.new()
	box.size = Vector3(0.1,0.1,0.1)
	marker.mesh = box
	
	var material = StandardMaterial3D.new()
	material.albedo_color = Color.RED
	marker.set_surface_override_material(0, material)
	
	get_tree().current_scene.add_child(marker)
	marker.global_position = position
	
	# remove after 2 seconds
	get_tree().create_timer(2.0).timeout.connect(marker.queue_free)

func _spawn_projectile() -> void:
	if not current_weapon.projectile_scene:
		print("No projectile assigned")
		return
		
	if not camera:
		print("No camera assigned")
		return
		
	# spawn projectile
	
	var projectile = current_weapon.projectile_scene.instantiate() as Projectile
	get_tree().current_scene.add_child(projectile)
	
	# position at Marker3D
	
	projectile.global_transform = marker_3d.global_transform
	
	# calculate direction and velocity
	var forward = -marker_3d.global_transform.basis.z
	
	var accuracy_spread = (100 - current_weapon.accuracy) / 1000.0
	var accuracy_x = randf_range(-accuracy_spread, accuracy_spread)
	var accuracy_y = randf_range(-accuracy_spread, accuracy_spread)
	var direction = forward + Vector3(accuracy_x, accuracy_y, 0) * marker_3d.global_transform.basis
	
	var velocity = direction * current_weapon.projectile_speed
	
	# prepare the projectile
	projectile.setup(velocity, current_weapon.damage)

func switch_weapon(weapon_data: WeaponData) -> void:
	current_weapon = weapon_data.weapon
	# sets the position of the weapon model container depending on the weapon and its zoomed in state
	if current_weapon == MD_P_11:
		wmc.position.z = -1
		wmc.position.x = 0
		if player.zoomed_in:
			wmc.position.x = -0.25
	if current_weapon == MD_ARE_18:
		wmc.position.z = 0
		wmc.position.x = 0
		if player.zoomed_in:
			wmc.position.x = -0.12
			wmc.position.z = -0.1
	if current_weapon == MD_BMR_99:
		wmc.position.z = 0
		wmc.position.x = 0
		if player.zoomed_in:
			wmc.position.x = -0.3
	if current_weapon == MD_RICO_KBM:
		wmc.position.z = 0
		wmc.position.x = 0
		if player.zoomed_in:
			wmc.position.x = -0.05
	if current_weapon_model:
		current_weapon_model.queue_free()
		
	spawn_weapon_model()
	
	weapon_state_chart.send_event("OnIdle")

func has_ammo() -> bool: # helper function for finding ammo
	var weapon_data = managers.weapon_manager.weapons[managers.weapon_manager.current_slot]
	return weapon_data.ammo > 0

func reload_weapon():
	if current_weapon.total_ammo > 0:
		ammo_label.text = "Reloading..."
		var weapon_data = managers.weapon_manager.weapons[managers.weapon_manager.current_slot]
		weapon_data.ammo = current_weapon.max_ammo
		current_weapon.total_ammo -= current_weapon.max_ammo

		# play animations here
		# animations are separated by weapon because I may change the animation to be unique for each weapon later
		if current_weapon == MD_P_11:
			weapon_reload.play("Reload")
		if current_weapon == MD_ARE_18:
			weapon_reload.play("Reload")
		if current_weapon == MD_BMR_99:
			weapon_reload.play("Reload")
		if current_weapon == MD_RICO_KBM:
			weapon_reload.play("Reload")
		await weapon_reload.animation_finished
		ammo_label.text = "Reloaded!"
		
		weapon_state_chart.send_event("OnIdle")
		
func _apply_damage_to_target(target: Node3D) -> void:
	# check if target has health component
	var health_component = target.get_node_or_null("HealthComponent")
	
	if health_component and health_component.has_method("take_damage"):
		health_component.take_damage(current_weapon.damage, owner)

func get_weapon_name():
	var weapon_data = managers.weapon_manager.weapons[managers.weapon_manager.current_slot]
	return str(weapon_data.weapon.weapon_name)
