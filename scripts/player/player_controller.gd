class_name PlayerController extends CharacterBody3D

@export_category("References")
@export var step_handler : StepHandlerComponent
@export var camera : CameraController
@export var camera_effects : Camera3D
@export var weapon_controller : WeaponController
@export var state_chart : StateChart
@export var standing_collision : CollisionShape3D
@export var crouching_collision : CollisionShape3D
@export var crouch_check : ShapeCast3D
@export var interaction_raycast : RayCast3D
@export var torch : SpotLight3D
@export var health_component : HealthComponent
@export var reticle_draw : Control

@export_category("Movement Settings")
@export_group("Easing")
var acceleration : float = 6
var deceleration : float = 14
@export_group("Speed")
@export var default_speed : float = 7
@export var sprint_speed : float = 4
@export var crouch_speed : float = -5.0
@export_category("Jump Settings")
@export var jump_velocity : float = 7
@export var fall_velocity_threshold : float = -6.5

@onready var animation_player: AnimationPlayer = $Torch/AnimationPlayer
@onready var weapon_zoom: AnimationPlayer = $WeaponZoom
@onready var health: Label = $UserInterface/Control/Health
const MD_ARE_18 = preload("uid://d0mhjhy1536qp")
const MD_BMR_99 = preload("uid://cwb7ejvgbfthi")
const MD_P_11 = preload("uid://d2e3oxubj53dw")
const MD_RICO_KBM = preload("uid://bwnd6lufp0ey2")



var _input_dir : Vector2 = Vector2.ZERO
var _movement_velocity : Vector3 = Vector3.ZERO
var sprint_modifier : float = 0.0
var crouch_modifier : float = 0.0
var speed : float = 0.0
var current_fall_velocity : float 
var previous_velocity : Vector3
var flashlight_rotation := 15.0 # smooth rotation
var flashlight_position := 15.0 # smooth position
var zoom := 50.0
var default_fov := 90.0
var fovtween: Tween


# booleans
var is_sprinting := false
var is_crouching := false
var zoomed_in := false

func _physics_process(delta: float) -> void:
	previous_velocity = velocity
	
	if not is_on_floor():
		velocity += get_gravity() * delta #gets gravity value and multiplies by delta

	var speed_modifier = sprint_modifier + crouch_modifier # modifies speed based on what state player is in
	speed = default_speed + speed_modifier 
	
	_input_dir = Input.get_vector("Left","Right","Forward","Back")
	var current_velocity = Vector2(_movement_velocity.x, _movement_velocity.z)
	var direction = (transform.basis * Vector3(_input_dir.x, 0, _input_dir.y)).normalized() # gets the direction the player is facing
	
	if direction:
		current_velocity = lerp(current_velocity, Vector2(direction.x, direction.z) * speed, acceleration * delta) # when moving, accelerate towards max speed value
	else:
		current_velocity = current_velocity.move_toward(Vector2.ZERO, deceleration * delta) #when stopping movement, slow down towards zero
	
	_movement_velocity = Vector3(current_velocity.x, velocity.y, current_velocity.y) #velocity in 3D Space (Vector 3D)
	
	velocity = _movement_velocity
	
	move_and_slide()  
	 
	if is_on_floor(): # prevents step checks from running while in air
		step_handler.handle_step_climbing()
		
func _process(delta: float) -> void:
	update_flashlight(delta)
	
	if Input.is_action_just_pressed("torch"):
		torch.visible = not torch.visible 
		if torch.visible:
			animation_player.play("torchpoweron")

# simple zoom in and zoom out functionality

	elif Input.is_action_pressed("Zoom"):
		if not zoomed_in:
			change_fov(zoom, 0.3)
			zoomed_in = true
			if weapon_controller.current_weapon == MD_P_11:
				weapon_zoom.play("PistolWeaponZoom")
			elif weapon_controller.current_weapon == MD_ARE_18:
				weapon_zoom.play("ARWeaponZoom")
			elif weapon_controller.current_weapon == MD_BMR_99:
				weapon_zoom.play("PistolWeaponZoom")
			elif weapon_controller.current_weapon == MD_RICO_KBM:
				weapon_zoom.play("RPGWeaponZoom")
				
				
	elif Input.is_action_just_released("Zoom"):
		if zoomed_in:
			change_fov(default_fov, 0.3)
			zoomed_in = false
			if weapon_controller.current_weapon == MD_P_11:
				weapon_zoom.play_backwards("PistolWeaponZoom")
			elif weapon_controller.current_weapon == MD_ARE_18:
				weapon_zoom.play_backwards("ARWeaponZoom")
			elif weapon_controller.current_weapon == MD_BMR_99:
				weapon_zoom.play_backwards("PistolWeaponZoom")
			elif weapon_controller.current_weapon == MD_RICO_KBM:
				weapon_zoom.play_backwards("RPGWeaponZoom")
			
	health.text = "Health: " + str(health_component.current_health)

func change_fov(fov, duration):
	if fovtween:
		fovtween.kill()
	
	fovtween = create_tween()
	fovtween.set_ease(Tween.EASE_OUT)
	fovtween.set_trans(Tween.TRANS_SINE)
	fovtween.tween_property(camera_effects, "fov", fov, duration)
	
func update_flashlight(delta):
	torch.global_transform = Transform3D(
		torch.global_transform.basis.slerp(camera.global_transform.basis, delta * flashlight_rotation),
		torch.global_transform.origin.slerp(camera.global_transform.origin, delta * flashlight_position)
	) # slerp smooths the transform of the torch

func update_rotation(rotation_input) -> void:
	global_transform.basis = Basis.from_euler(rotation_input) # updates rotation of player

func sprint() -> void:
	is_sprinting = true
	sprint_modifier = sprint_speed
	
func walk() -> void:
	is_sprinting = false
	sprint_modifier = 0.0

func stand() -> void:
	is_crouching = false
	crouch_modifier = 0.0
	standing_collision.disabled = false
	crouching_collision.disabled = true
	
func crouch() -> void:
	is_crouching = true
	crouch_modifier = crouch_speed # changes modifier value to crouch speed
	standing_collision.disabled = true
	crouching_collision.disabled = false
	
func jump() -> void:
	if not crouch_check.is_colliding():
		velocity.y += jump_velocity 

func check_fall_speed() -> bool:
	if current_fall_velocity < fall_velocity_threshold:
		current_fall_velocity = 0.0
		return true
		
	else:
		current_fall_velocity = 0.0
		return false
		
func get_input_direction() -> Vector2:
	return _input_dir
	
func trigger():
	print("Just like liberals, you got triggered")

func apply_velocity():
	velocity.y += 8
