class_name CameraEffects extends Camera3D

@export_category("References")
@export var player : PlayerController

@export_category("Effects")
@export var enable_tilt : bool = true
@export var enable_fall_kick : bool = true
@export var enable_damage_kick : bool = true
@export var enable_weapon_kick : bool = true
@export var enable_head_bob : bool = true

@export_category("Kick & Recoil Settings")
@export_group("Run Tilt")
@export var run_pitch : float = 0.1 # in degrees
@export var run_roll : float = 0.25 # in degrees
@export var max_pitch : float = 1.0 # in degrees
@export var max_roll : float = 2.5 # in degrees
@export_group("Camera Fall Effect Settings")
@export_subgroup("Fall Kick")
@export var fall_time : float = 0.3
@export_subgroup("Damage Kick")
@export var damage_time : float = 0.3
@export_subgroup("Weapon Kick")
@export var weapon_decay : float = 0.5
@export_subgroup("Headbob")
@export_range(0.0, 0.1, 0.001) var bob_pitch := 0.1
@export_range(0.0, 0.1, 0.001) var bob_roll := 0.05
@export_range(0.0, 0.4, 0.001) var bob_up := 0.05
@export_range(5.0, 15.0, 0.001) var bob_frequency := 10.0

var _fall_value : float = 0.0
var _fall_timer : float = 0.0

var _damage_pitch : float = 0.0
var _damage_roll : float = 0.0
var _damage_timer : float = 0.0

var _weapon_kick_angles : Vector3 = Vector3.ZERO

var _step_timer : float = 0.0


func _process(delta: float) -> void:
	if !player.dead:
		calculate_view_offset(delta)

# all cameera effects are applied here
func calculate_view_offset(delta):
	if not player: # ensures player is being referenced 
		return
	
	_fall_timer -= delta
	_damage_timer -= delta
	
	var velocity = player.velocity
	
	# head bob checks when on floor and sets the frenquency based on running or walking
	var speed = Vector2(velocity.x, velocity.z).length()
	if speed > 0.1 and player.is_on_floor():
		_step_timer += delta * (speed / bob_frequency)
		_step_timer = fmod(_step_timer, 1.0) # fmod function creates a continious cycle where everytime it reaches 1 it resets to zero looping the headbob
	else:
		_step_timer = 0.0
	var bob_sin = absf(sin(_step_timer * 2.0 * PI) * 0.5)
	
	var angles = Vector3.ZERO
	var offset = Vector3.ZERO
	
	# camera tilt calculations (tilts camera left and right when strafing, rolls camera forward and backwards when running forward or backwards)
	if enable_tilt:
		var forward = global_transform.basis.z
		var right = global_transform.basis.x
		
		var forward_dot = velocity.dot(forward) # returns dot product of forward var
		var forward_tilt = clampf(forward_dot * deg_to_rad(run_pitch), deg_to_rad(-max_pitch), deg_to_rad(max_pitch))
		angles.x += forward_tilt # sets the forward angle to the calculated tilt 
		
		var right_dot = velocity.dot(right) # returns dot product of right var
		var side_tilt = clampf(right_dot * deg_to_rad(run_roll), deg_to_rad(-max_roll), deg_to_rad(max_roll))
		angles.z -= side_tilt # sets the side angle to the calculated tilt

	# fall kick calculations
	if enable_fall_kick:
		var fall_ratio = max(0.0, _fall_timer / fall_time)
		var fall_kick_amount = fall_ratio * _fall_value
		angles.x -= fall_kick_amount
		offset.y -= fall_kick_amount
		
	# damage calculations (Unused)
	if enable_damage_kick:
		var damage_ratio = max(0.0, _damage_timer / damage_time)
		damage_ratio = ease(damage_ratio, -2)
		angles.x += damage_ratio * _damage_pitch
		angles.z += damage_ratio * _damage_roll
		
	# weapon kick calculations (Also unused)
	if enable_weapon_kick:
		_weapon_kick_angles.move_toward(Vector3.ZERO, weapon_decay * delta)
		angles += _weapon_kick_angles
	
	# head bob calculations
	if enable_head_bob:
		var pitch_delta = bob_sin * deg_to_rad(bob_pitch) * speed * delta
		angles.x -= pitch_delta
		
		var roll_delta = bob_sin * deg_to_rad(bob_roll) * speed * delta
		angles.z -= roll_delta
		
		var bob_height = bob_sin * speed * bob_up 
		offset.y += bob_height
		
	position = offset # updates the cameras rotation based on the offset
	rotation = angles # updates the cameras rotation based on the angles

# fall kick is added when player hits floor (called in airborne state processing)
func add_fall_kick(fall_strength: float):
	_fall_value = deg_to_rad(fall_strength)
	_fall_timer = fall_time

# can add damage kick when enemies hit player (unused, may look too disorienting)
func add_damage_kick(pitch: float, roll: float, source: Vector3):
	var forward = global_transform.basis.z
	var right = global_transform.basis.x
	var direction = global_position.direction_to(source)
	var forward_dot = direction.dot(forward)
	var right_dot = direction.dot(right)
	_damage_pitch = deg_to_rad(pitch) * forward_dot
	_damage_roll = deg_to_rad(roll) * right_dot
	_damage_timer = damage_time

# Decided to use animation for weapon shooting, recoil again might be too disorienting)
func add_weapon_kick(pitch: float, yaw: float, roll: float):
	_weapon_kick_angles.x += deg_to_rad(pitch)
	_weapon_kick_angles.y += deg_to_rad(randf_range(-yaw, yaw))
	_weapon_kick_angles.z += deg_to_rad(randf_range(-roll, roll))
