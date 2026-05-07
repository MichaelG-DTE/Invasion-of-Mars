extends StaticBody3D

# saves door lights colour if changed and saved, or resets to red if changed and not saved

var is_changed = false
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var csg_box_3d: CSGBox3D = $CSGBox3D

func on_save_game(interactable_saved_data : Array[InteractableSavedData]):
	
	var my_data = InteractableSavedData.new()
	my_data.door_light_status = is_changed
	my_data.scene_path = scene_file_path
	my_data.transform = global_transform
	interactable_saved_data.append(my_data)

func on_before_load_game():
	queue_free()

func on_load_game(interactable_saved_data : InteractableSavedData):
	global_transform = interactable_saved_data.transform
	if interactable_saved_data.door_light_status == true:
		csg_box_3d.material.albedo_color = Color.GREEN
		csg_box_3d.material.emission = Color.GREEN
	else:
		csg_box_3d.material.albedo_color = Color.RED
		csg_box_3d.material.emission = Color.RED

func change_var():
	is_changed = true
	
