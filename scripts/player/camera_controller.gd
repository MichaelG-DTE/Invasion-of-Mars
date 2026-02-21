class_name CameraController extends Node3D

@export_category("References")
@export var player_controller : PlayerController
@export var component_mouse_capture : MouseCapture
@export_category("Camera Controller Settings")
@export_group("Camera Tilt") #creates a drop down menu
@export_range(-90, -60) var lower_tilt_limit : int = -90
@export_range(60, 90) var upper_tilt_limit : int = 90
@export_group("Crouch Camera Change Variables")
@export var crouch_offset : float = 0.0
@export var crouch_speed : float = 3.0
@export_group("Step Smoothing")
@export var step_speed : float = 8.0

var _target_height : float
var _step_smoothing : bool = false

var offset_height : float


var _rotation : Vector3 #underscored to prevent Godot from throwing an error

const DEFAULT_HEIGHT : float = 0.5

func _ready() -> void:
	_rotation = player_controller.rotation
	offset_height = DEFAULT_HEIGHT

func _process(delta: float) -> void:
	update_camera_rotation(component_mouse_capture.mouse_input, delta)
	
	if _step_smoothing:
		_target_height = lerp(_target_height, 0.0, step_speed * delta)
		if abs(_target_height) < 0.01:
			_target_height = 0.0
			_step_smoothing = false
			
		position.y = offset_height + _target_height
	
func update_camera_rotation(input : Vector2, delta) -> void:
	_rotation.x += input.y * delta
	_rotation.y += input.x * delta
	
	#clamps the rotation to the predefined lower and upper limits
	_rotation.x = clamp(_rotation.x, deg_to_rad(lower_tilt_limit), deg_to_rad(upper_tilt_limit))
	#splits the players rotation from the camera rotation, preventing the whole player from looking up and down
	var player_rotation = Vector3(0.0, _rotation.y, 0.0)  
	var camera_rotation = Vector3(_rotation.x, 0.0, 0.0)
	
	transform.basis = Basis.from_euler(camera_rotation)
	player_controller.update_rotation(player_rotation)
	
	_rotation.z = 0.0
	
func update_camera_height(delta: float, direction: int):
	if position.y >= crouch_offset and position.y <= DEFAULT_HEIGHT: # checks if the y position has been changed to be greater than the crouch offset but less than the default height
		position.y = clampf(position.y + (crouch_speed * direction) * delta, crouch_offset, DEFAULT_HEIGHT) # changes the camera position to be lower 

# activates step smoothing to prevent camera jitter
func smooth_step(height_change : float):
	_target_height -= height_change
	_step_smoothing = true
