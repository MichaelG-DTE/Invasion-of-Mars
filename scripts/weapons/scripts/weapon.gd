class_name Weapon extends Resource

# variables for weapon resource

@export var weapon_name: String = "MD P-11"
@export var damage : float = 25.0
@export var max_ammo : int = 12
@export var total_ammo : int = 100
@export var starting_ammo : int = 100
@export var fire_rate: float = 2.0
@export var is_automatic : bool = false
@warning_ignore("shadowed_global_identifier")
@export var range: float = 25.0
@export_range(0, 100) var accuracy: int = 100
@export var projectile_speed: float = 30.0
@export var is_hitscan: bool = true
@export var weapon_model: PackedScene
@export var projectile_scene: PackedScene
@export var pellet_count: int = 1
@export var spread_angle: float = 5.0
@export var weapon_position : Vector3 = Vector3(0.2, -0.2, -0.3)
@export var weapon_slot : int = 1
