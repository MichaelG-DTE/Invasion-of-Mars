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
@export var wmc : Node3D
@export var mouse_capture : MouseCapture
@export_category("Movement Settings")
@export_group("Easing")
var acceleration : float = 6
var deceleration : float = 14
@export_group("Speed")
@export var default_speed : float = 7
@export var sprint_speed : float = 4
@export var crouch_speed : float = -5.0
@export var aim_speed : float = -2.0
@export_category("Jump Settings")
@export var jump_velocity : float = 7.5
@export var fall_velocity_threshold : float = -7
@export_category("WeaponSwaySettings")
@export var weapon_sway_amount := 5.0
@export var weapon_rotation_amount := 0.1
@export_category("WeaponBobSettings")
@export var bob_speed := 0.01
@export var bob_amount := 0.01

# on ready variables
@onready var animation_player: AnimationPlayer = $Torch/AnimationPlayer
@onready var weapon_zoom: AnimationPlayer = $WeaponZoom
@onready var health: TextureProgressBar = $UserInterface/Control/Health
@onready var shield: TextureProgressBar = $UserInterface/Control/Shield
@onready var death: AnimationPlayer = $Death
@onready var torch_sfx: AudioStreamPlayer = $TorchSFX

# gun references
const MD_ARE_18 = preload("uid://d0mhjhy1536qp")
const MD_BMR_99 = preload("uid://cwb7ejvgbfthi")
const MD_P_11 = preload("uid://d2e3oxubj53dw")
const MD_RICO_KBM = preload("uid://bwnd6lufp0ey2")

var _input_dir : Vector2 = Vector2.ZERO
var _movement_velocity : Vector3 = Vector3.ZERO
var sprint_modifier : float = 0.0
var crouch_modifier : float = 0.0
var aim_modifier : float = 0.0
var speed : float = 0.0
var current_fall_velocity : float 
var previous_velocity : Vector3
var flashlight_rotation := 15.0 # smooth rotation
var flashlight_position := 15.0 # smooth position
var zoom := 50.0
var fovtween: Tween
var startY
var dead = false

# booleans
var is_sprinting := false
var is_crouching := false
var zoomed_in := false
var torch_visible := false

func _ready() -> void:
	health_component.died.connect(on_dead)
	# sets the weapon holder position to its starting position (zero)
	startY = wmc.position.y
	wmc.position.z = -1

func _physics_process(delta: float) -> void:
	if !dead:
		previous_velocity = velocity
		
		if not is_on_floor():
			velocity += get_gravity() * delta #gets gravity value and multiplies by delta

		var speed_modifier = sprint_modifier + crouch_modifier + aim_modifier # modifies speed based on what state player is in
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
		weapon_tilt(_input_dir.x, delta)
		weapon_sway(delta)
		weapon_bob()
	
func _process(delta: float) -> void:
	if !dead:
		update_flashlight(delta)
		
		if Input.is_action_just_pressed("torch"):
			torch_sfx.play()
			if not torch_visible:
				animation_player.play("torchpoweron")
				torch_visible = true
			else:
				if torch_visible:
					animation_player.play_backwards("torchpoweron")
					torch_visible = false

# zoom in and zoom out on the weapons 

		elif Input.is_action_pressed("Zoom"):
			if not zoomed_in:
				aim()
				change_fov(zoom, 0.3)
				if weapon_controller.current_weapon == MD_P_11:
					weapon_zoom.play("PistolWeaponZoom")
				elif weapon_controller.current_weapon == MD_ARE_18:
					weapon_zoom.play("ARWeaponZoom")
				elif weapon_controller.current_weapon == MD_BMR_99:
					weapon_zoom.play("BMRWeaponZoom")
				elif weapon_controller.current_weapon == MD_RICO_KBM:
					weapon_zoom.play("RPGWeaponZoom")
					
		elif Input.is_action_just_released("Zoom"):
			if zoomed_in:
				stop_aiming()
				change_fov(globalvar.fov, 0.3)
				if weapon_controller.current_weapon == MD_P_11:
					weapon_zoom.play_backwards("PistolWeaponZoom")
				elif weapon_controller.current_weapon == MD_ARE_18:
					weapon_zoom.play_backwards("ARWeaponZoom")
				elif weapon_controller.current_weapon == MD_BMR_99:
					weapon_zoom.play_backwards("BMRWeaponZoom")
				elif weapon_controller.current_weapon == MD_RICO_KBM:
					weapon_zoom.play_backwards("RPGWeaponZoom")
	
	# labels!!! REMEMBER THESE ARE HERE
	health.value = health_component.current_health
	shield.value = health_component.current_shield

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
	SignalBus.terminal_change.emit()

func apply_velocity():
	if !dead:
		velocity.y += 8

func aim() -> void:
	zoomed_in = true
	aim_modifier = aim_speed

func stop_aiming() -> void:
	zoomed_in = false
	aim_modifier = 0.0

func weapon_tilt(input_x, delta):
	if !dead:
		if wmc:
			if is_on_floor():
				wmc.rotation.z = lerp(wmc.rotation.z, -input_x * weapon_rotation_amount, 10 * delta) 

func weapon_sway(delta):
	if !dead:
		wmc.rotation.x = lerp(wmc.rotation.x, -mouse_capture.mouse_input.y / 2 * weapon_rotation_amount,  4 * delta) 
		wmc.rotation.y = lerp(wmc.rotation.y, -mouse_capture.mouse_input.x / 2 * weapon_rotation_amount, 4 * delta) 
		wmc.rotation.y = clamp(wmc.rotation.y, -0.6, 0.6)
		wmc.rotation.x = clamp(wmc.rotation.x, -0.6, 0.6)

func weapon_bob():
	if !dead:
		if is_on_floor():
			var time = float(Time.get_ticks_msec())
			wmc.position.y = startY + sin(time * bob_speed) * bob_amount * (velocity.length() / speed)

func on_dead():
	dead = true
	death.play("Death")
	await get_tree().create_timer(5.0).timeout
	SignalBus.load_level.emit()
