extends StaticBody3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var mesh_instance_3d_2: MeshInstance3D = $MeshInstance3D2
@onready var mesh_instance_3d_3: MeshInstance3D = $MeshInstance3D3
@onready var button_press_sfx: AudioStreamPlayer = $ButtonPressSFX

var has_pressed := false
var door


# finds door to unlock with button to advance through the alien ship
func finddoor():
	var doors = get_tree().get_nodes_in_group("door")
	for neodoor in doors:
		if neodoor == null:
			return
		else:
			door = neodoor

func _ready() -> void:
	finddoor()

# deactivates the doors lock
func interact():
	if not has_pressed:
		button_press_sfx.play()
		has_pressed = true
		animation_player.play("pressed")
		finddoor()
		door.locked = false
		
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
