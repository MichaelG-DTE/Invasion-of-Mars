class_name CameraController extends Node3D

@export_category("References")
#@export var player_controller : Player
@export var component_mouse_capture : MouseCapture
@export_category("Camera Controller Settings")
@export_group("Camera Tilt") #creates a drop down menu
@export_range(-90, -60) var lower_tilt_limit : int = -90
@export_range(60, 90) var upper_tilt_limit : int = 90

var _rotation : Vector3 #underscored to prevent Godot from throwing an error

func update_camera_rotation(input : Vector2) -> void:
	_rotation.x += input.y
	_rotation.y += input.x
	
	#clamps the rotation to the predefined lower and upper limits
	_rotation.x = clamp(_rotation.x, deg_to_rad(lower_tilt_limit), deg_to_rad(upper_tilt_limit)) 
	#splits the players rotation from the camera rotation, preventing the whole player from looking up and down
	var player_rotation = Vector3(0.0, _rotation.y, 0.0)  
	var camera_rotation = Vector3(_rotation.x, 0.0, 0.0)
	
	rotation.z = 0.0
	
#func update_camera_height(delta: float, direction: int):
#	if position.y >= crouch_offset and position.y <= DEFAULT_HEIGHT:
#		position.y = clampf(position.y + (crouch_speed * direction) * delta, crouch_offset, DEFAULT_HEIGHT)
