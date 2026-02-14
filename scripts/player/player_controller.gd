class_name PlayerController extends CharacterBody3D

@export_category("References")
@export var camera : CameraController
@export var state_chart : StateChart
@export var standing_collision : CollisionShape3D
@export_category("Movement Settings")
@export_group("Easing")
var acceleration : float = 3.5
var deceleration : float = 14
@export_group("Speed")
@export var default_speed : float = 8.0
@export var sprint_speed : float = 10.0

var _input_dir : Vector2 = Vector2.ZERO
var _movement_velocity : Vector3 = Vector3.ZERO
var sprint_modifier : float = 0.0
var speed : float = 0.0




func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta #gets gravity value and multiplies by delta

	var speed_modifier = sprint_modifier
	speed = default_speed + speed_modifier
	
	_input_dir = Input.get_vector("Left","Right","Forward","Back")
	var current_velocity = Vector2(_movement_velocity.x, _movement_velocity.z)
	var direction = (transform.basis * Vector3(_input_dir.x, 0, _input_dir.y)).normalized()
	
	if direction:
		current_velocity = lerp(current_velocity, Vector2(direction.x, direction.z) * speed, acceleration * delta) # when moving, accelerate towards max speed value
	else:
		current_velocity = current_velocity.move_toward(Vector2.ZERO, deceleration * delta) #when stopping movement, slow down towards zero
	
	_movement_velocity = Vector3(current_velocity.x, velocity.y, current_velocity.y) #velocity in 3D Space (Vector 3D)
	
	velocity = _movement_velocity
	
	move_and_slide()  

func update_rotation(rotation_input) -> void:
	global_transform.basis = Basis.from_euler(rotation_input)

func sprint() -> void:
	sprint_modifier = sprint_speed
	
func walk() -> void:
	sprint_modifier = 0.0
