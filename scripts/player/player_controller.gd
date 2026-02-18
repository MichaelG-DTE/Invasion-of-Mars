class_name PlayerController extends CharacterBody3D

@export_category("References")
@export var camera : CameraController
@export var camera_effects : Camera3D
@export var state_chart : StateChart
@export var standing_collision : CollisionShape3D
@export var crouching_collision : CollisionShape3D
@export var crouch_check : ShapeCast3D
@export var interaction_raycast : RayCast3D
@export_category("Movement Settings")
@export_group("Easing")
var acceleration : float = 1.5
var deceleration : float = 14
@export_group("Speed")
@export var default_speed : float = 7.0
@export var sprint_speed : float = 5.0
@export var crouch_speed : float = -5.0
@export_category("Jump Settings")
@export var jump_velocity : float = 8

var _input_dir : Vector2 = Vector2.ZERO
var _movement_velocity : Vector3 = Vector3.ZERO
var sprint_modifier : float = 0.0
var crouch_modifier : float = 0.0
var speed : float = 0.0
var is_sprinting = false
var is_crouching = false

func _physics_process(delta: float) -> void:
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
