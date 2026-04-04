class_name WeaponPickup extends BasePickup

@export var weapon_slot : int = 1
@export var weapon_resource : Weapon
@onready var managers: Node = $"../../../Managers"


func can_pickup(player: PlayerController) -> bool:
	var weapon_data = managers.weapon_manager.weapons[weapon_slot]
	
	# can pickup if weapon not unlocked or ammo not full
	return not weapon_data.unlocked or weapon_data.ammo < weapon_resource.max_ammo

func apply_pickup(player: PlayerController) -> void:
	var weapon_data = managers.weapon_manager.weapons[weapon_slot]
	
	if weapon_data.unlocked:
		# weapon already unlocked
		weapon_data.ammo = weapon_resource.max_ammo
		
	else:
		# unlock weapon and switches to it
		managers.weapon_manager.unlock_weapon(weapon_slot, weapon_resource)
		managers.weapon_manager.switch_to_slot(weapon_slot)
		weapon_data.ammo = weapon_data.weapon.total_ammo
