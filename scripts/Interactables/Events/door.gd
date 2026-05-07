extends StaticBody3D

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D
@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D
@export var locked := false
var active := false

# script used for all doors to lift up and lower the doors down

func interact():
	if not locked:
		
		if !active:
			audio_stream_player.play()
			animation_player.play("open")
			active = true
		else:
			audio_stream_player.play()
			animation_player.play("close")
			active = false

func on_save_game(interactable_saved_data : Array[InteractableSavedData]):
	var my_data = InteractableSavedData.new()

	# saves the doors position and whether locked or not
	my_data.is_door_locked = locked
	my_data.transform = global_transform
	my_data.scene_path = scene_file_path
	if not active:
		my_data.door_mesh_height = 1.25
		my_data.door_collision_height = 1.25
		
	if active:
		my_data.door_mesh_height = 3.0
		my_data.door_collision_height = 3.0
	
	my_data.my_level = globalvar.current_level
	
	print("door level : ", my_data.my_level)
	interactable_saved_data.append(my_data)
	
func on_before_load_game():
	queue_free()
	
func on_load_game(interactable_saved_data : InteractableSavedData):
	global_transform = interactable_saved_data.transform
	locked = interactable_saved_data.is_door_locked
	
	mesh_instance_3d.position.y = interactable_saved_data.door_mesh_height
	collision_shape_3d.position.y = interactable_saved_data.door_collision_height
	
	if interactable_saved_data.my_level != globalvar.current_level:
		queue_free()
		
