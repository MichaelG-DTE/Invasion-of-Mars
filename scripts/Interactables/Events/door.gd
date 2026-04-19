extends StaticBody3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D
@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D
@export var locked := false


func interact():
	if not locked:
		if not is_open():
			animation_player.play("open")
		if is_open():
			animation_player.play("close")
		
		
func is_open() -> bool:
	if mesh_instance_3d.position.y and collision_shape_3d.position.y == 1.25:
		return false
	else:
		return true

func on_save_game(interactable_saved_data : Array[InteractableSavedData]):
	var my_data = InteractableSavedData.new()
	my_data.is_door_locked = locked
	my_data.transform = global_transform
	my_data.scene_path = scene_file_path
	if not is_open():
		my_data.door_mesh_height = 1.25
		my_data.door_collision_height = 1.25
		
	if is_open():
		my_data.door_mesh_height = 3.0
		my_data.door_collision_height = 3.0
	
	interactable_saved_data.append(my_data)
	
func on_before_load_game():
	queue_free()
	
func on_load_game(interactable_saved_data : InteractableSavedData):
	global_transform = interactable_saved_data.transform
	locked = interactable_saved_data.is_door_locked
	
	mesh_instance_3d.position.y = interactable_saved_data.door_mesh_height
	collision_shape_3d.position.y = interactable_saved_data.door_collision_height
