class_name CameraEffects extends Camera3D

@export_category("References")
@export var player : PlayerController

@export_category("Effects")
@export var enable_tilt : bool = true
@export var enable_fall_kick : bool = true
@export_category("Kick & Recoil Settings")
@export_group("Run Tilt")
@export var run_pitch : float = 0.1 # in degrees
@export var run_roll : float = 0.25 # in degrees
@export var max_pitch : float = 1.0 # in degrees
@export var max_roll : float = 2.5 # in degrees
@export_group("Camera Fall Effect Settings")
@export_subgroup("Fall Kick")
@export var fall_time : float = 0.3

var _fall_value : float = 0.0
var _fall_timer : float = 0.0


func _process(delta: float) -> void:
	calculate_view_offset(delta)
	
	
func calculate_view_offset(delta):
	if not player: # ensures player is being referenced 
		return
	
	_fall_timer -= delta
	
	
	var velocity = player.velocity
	
	var angles = Vector3.ZERO
	var offset = Vector3.ZERO
	
	# camera tilt calculations
	if enable_tilt:
		var forward = global_transform.basis.z
		var right = global_transform.basis.x
		
		var forward_dot = velocity.dot(forward) # returns dot product of forward var
		var forward_tilt = clampf(forward_dot * deg_to_rad(run_pitch), deg_to_rad(-max_pitch), deg_to_rad(max_pitch))
		angles.x += forward_tilt # sets the forward angle to the calculated tilt
		
		var right_dot = velocity.dot(right) # returns dot product of right var
		var side_tilt = clampf(right_dot * deg_to_rad(run_roll), deg_to_rad(-max_roll), deg_to_rad(max_roll))
		angles.z -= side_tilt # sets the side angle to the calculated tilt

	if enable_fall_kick:
		var fall_ratio = max(0.0, _fall_timer / fall_time)
		var fall_kick_amount = fall_ratio * _fall_value
		angles.x -= fall_kick_amount
		offset.y -= fall_kick_amount
		
	position = offset
	rotation = angles # updates the cameras rotation based on the angles

func add_fall_kick(fall_strength: float):
	_fall_value = deg_to_rad(fall_strength)
	_fall_timer = fall_time
