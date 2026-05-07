class_name InteractableSavedData
extends Resource

# interactable objects have their data saved using this resource

@export var is_button_pressed : bool
@export var is_door_locked : bool
@export var scene_path : String
@export var transform : Transform3D
@export var door_mesh_height : float
@export var door_collision_height : float
@export var my_level : int
@export var weapon_resource : Weapon
@export var door_light_status : bool
