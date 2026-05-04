class_name WeaponPickup extends BasePickup

@export var weapon_slot : int = 1
@export var weapon_resource : Weapon
@export var has_picked_up = false

func can_pickup(player: PlayerController) -> bool:
	var weapon_data = $"../../../Managers".weapon_manager.weapons[weapon_slot]
	
	# can pickup if weapon not unlocked or ammo not full
	return not weapon_data.unlocked or weapon_data.ammo < weapon_resource.max_ammo

func apply_pickup(player: PlayerController) -> void:
	var weapon_data = $"../../../Managers".weapon_manager.weapons[weapon_slot]
	
	if weapon_data.unlocked:
		# weapon already unlocked
		weapon_data.ammo = weapon_resource.max_ammo
		
	else:
		# unlock weapon and switches to it
		$"../../../Managers".weapon_manager.unlock_weapon(weapon_slot, weapon_resource)
		$"../../../Managers".weapon_manager.switch_to_slot(weapon_slot)
		weapon_data.ammo = weapon_data.weapon.total_ammo

func on_save_game(saved_data : Array[InteractableSavedData]):
	if has_picked_up:
		return

	var my_data = InteractableSavedData.new()
	my_data.transform = global_transform
	my_data.scene_path = scene_file_path
	my_data.my_level = globalvar.current_level
	my_data.weapon_resource = weapon_resource
	saved_data.append(my_data)

func on_before_load_game():
	queue_free()
	
func on_load_game(saved_data : InteractableSavedData):
	global_transform = saved_data.transform
	weapon_resource = saved_data.weapon_resource
	
