class_name AmmoPickup extends BasePickup

@export var weapon_slot : int = 1
@export var ammo_amount : int = 10
@export var has_picked_up = false

func can_pickup(player: PlayerController) -> bool:
	var weapon_data = $"../../../Managers".weapon_manager.weapons[weapon_slot]
	#check weapon exists
	if weapon_slot not in $"../../../Managers".weapon_manager.weapons:
		return false
		
	# can only pickup if weapon is unlocked and TOTAL ammo not full 
	return weapon_data.unlocked and weapon_data.weapon.total_ammo < weapon_data.weapon.starting_ammo

func apply_pickup(player: PlayerController) -> void:
	has_picked_up = true
	var weapon_data = $"../../../Managers".weapon_manager.weapons[weapon_slot]
	# adds ammo if not already full
	if weapon_data.weapon.total_ammo < weapon_data.weapon.starting_ammo:
		weapon_data.weapon.total_ammo += ammo_amount

func on_save_game(saved_data : Array[InteractableSavedData]):
	# saves if not already picked up
	if has_picked_up:
		return
		
	var my_data = InteractableSavedData.new()
	
	# variables to save
	my_data.transform = global_transform
	my_data.scene_path = scene_file_path
	my_data.my_level = globalvar.current_level
	saved_data.append(my_data)

func on_before_load_game():
	queue_free()
	
func on_load_game(saved_data : InteractableSavedData):
	global_transform = saved_data.transform
	
