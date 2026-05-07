extends StaticBody3D

@onready var animation_player_3: AnimationPlayer = $AnimationPlayer3
@onready var mesh_instance_3d_2: MeshInstance3D = $MeshInstance3D2
@onready var mesh_instance_3d_3: MeshInstance3D = $MeshInstance3D3
@onready var button_press_sfx: AudioStreamPlayer = $ButtonPressSFX

var has_pressed = false

# button 3 for level 5, all buttons have to be pressed before progression has to be made 
func interact():
	if not has_pressed:
		button_press_sfx.play()
		animation_player_3.play("pressed")
		has_pressed = true

func on_save_game(interactable_saved_data : Array[InteractableSavedData]):
	
	var my_data = InteractableSavedData.new()
	
	my_data.is_button_pressed = has_pressed
	my_data.scene_path = scene_file_path
	my_data.transform = global_transform
	my_data.my_level = globalvar.current_level
	interactable_saved_data.append(my_data)

func on_before_load_game():
	queue_free()

func on_load_game(interactable_saved_data : InteractableSavedData):
	global_transform = interactable_saved_data.transform
	has_pressed = interactable_saved_data.is_button_pressed
	if interactable_saved_data.is_button_pressed == true:
		mesh_instance_3d_2.mesh.height = 0.01
		mesh_instance_3d_3.mesh.material.albedo_color = Color.GREEN
		mesh_instance_3d_3.mesh.material.emission = Color.GREEN
	else:
		mesh_instance_3d_2.mesh.height = 0.1
		mesh_instance_3d_3.mesh.material.albedo_color = Color.RED
		mesh_instance_3d_3.mesh.material.emission = Color.RED
