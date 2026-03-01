class_name AmmoPickup extends BasePickup

@export var weapon_slot : int = 1
@export var ammo_amount : int = 10

func can_pickup(player: PlayerController) -> bool:
	var weapon_data = managers.weapon_manager.weapons[weapon_slot]
	#check weapon exists
	if weapon_slot not in managers.weapon_manager.weapons:
		return false
		
	# can only pickup if weapon is unlocked and TOTAL ammo not full 
	return weapon_data.unlocked and weapon_data.weapon.total_ammo < weapon_data.weapon.starting_ammo

func apply_pickup(player: PlayerController) -> void:
	var weapon_data = managers.weapon_manager.weapons[weapon_slot]
	if weapon_data.weapon.total_ammo < weapon_data.weapon.starting_ammo:
		weapon_data.weapon.total_ammo += ammo_amount
