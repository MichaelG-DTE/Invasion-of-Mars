extends Node

@onready var player: PlayerController = $"../../CurrentLevel/Player"
@onready var weapon_manager: WeaponManager = $"../WeaponManager"

var nav_region
var current_level

@export var pistol_data : WeaponData
@export var are_data : WeaponData
@export var bmr_data : WeaponData
@export var rico_kbm_data : WeaponData

func _ready() -> void:
	SignalBus.connect("save_level", save_game)
	SignalBus.connect("load_level", load_game)
	find_nav_regions()
	find_current_level()

# finds the navigation region for the enemies in the current level
func find_nav_regions():
	var nav_in_levels = get_tree().get_nodes_in_group("NavigationGroup")
	for nav_level in nav_in_levels:
		if nav_level == null:
			return
		else:
			nav_region = nav_level

# finds the current level for the interactables respawning
func find_current_level():
	var levels = get_tree().get_nodes_in_group("level")
	for level in levels:
		if level == null:
			return
		else:
			current_level = level

func save_game():
	var saved_game : SavedGame = SavedGame.new()
	var pistol = pistol_data
	var assaultrifle = are_data
	var shotgun = bmr_data
	var rocketlauncher = rico_kbm_data
	
	# player health, position, shield and torch save values
	saved_game.player_health = player.health_component.current_health
	saved_game.player_shield = player.health_component.current_shield
	saved_game.player_transform = player.global_transform
	saved_game.torch_visible = player.torch.visible
	saved_game.torch_energy = player.torch.light_energy
	saved_game.torch_active = player.torch_visible
	
	if player.weapon_controller.current_weapon == pistol.weapon:
		saved_game.current_slot = pistol.weapon.weapon_slot
	elif player.weapon_controller.current_weapon == assaultrifle.weapon:
		saved_game.current_slot = assaultrifle.weapon.weapon_slot
	elif player.weapon_controller.current_weapon == shotgun.weapon:
		saved_game.current_slot = shotgun.weapon.weapon_slot
	elif player.weapon_controller.current_weapon == rocketlauncher.weapon:
		saved_game.current_slot = rocketlauncher.weapon.weapon_slot
	
	# pistol save values
	saved_game.pistol_unlocked = pistol.unlocked
	saved_game.pistol_ammo = pistol.ammo
	saved_game.pistol_total_ammo = pistol.weapon.total_ammo
	# assault rifle save values
	saved_game.assaultrifle_unlocked = assaultrifle.unlocked
	saved_game.assaultrifle_ammo = assaultrifle.ammo
	saved_game.assaultrifle_total_ammo = assaultrifle.weapon.total_ammo
	# shotgun save values
	saved_game.shotgun_unlocked = shotgun.unlocked
	saved_game.shotgun_ammo = shotgun.ammo
	saved_game.shotgun_total_ammo = shotgun.weapon.total_ammo
	# rocketlauncher save values
	saved_game.rocketlauncher_unlocked = rocketlauncher.unlocked
	saved_game.rocketlauncher_ammo = rocketlauncher.ammo
	saved_game.rocketlauncher_total_ammo = rocketlauncher.weapon.total_ammo
	
	var saved_data : Array[SavedData] = []
	get_tree().call_group("game_events", "on_save_game", saved_data)
	saved_game.saved_data = saved_data
	
	var interactable_save_data : Array[InteractableSavedData] = []
	get_tree().call_group("interactable_events", "on_save_game", interactable_save_data)
	saved_game.interactables_saved_data = interactable_save_data
	
	ResourceSaver.save(saved_game, "user://savegame.tres")

func load_game():
	var saved_game : SavedGame = ResourceLoader.load("user://savegame.tres", "", ResourceLoader.CACHE_MODE_IGNORE) as SavedGame
	var pistol = pistol_data
	var assaultrifle = are_data
	var shotgun = bmr_data
	var rocketlauncher = rico_kbm_data 
	
	# load player values
	player.global_transform = saved_game.player_transform
	player.health_component.current_health = saved_game.player_health
	player.health_component.current_shield = saved_game.player_shield
	player.torch.visible = saved_game.torch_active
	player.torch.light_energy = saved_game.torch_energy
	player.torch_visible = saved_game.torch_active
	
	var new_slot = saved_game.current_slot
	weapon_manager.switch_to_slot(new_slot)
	
	# load pistol values
	pistol.unlocked = saved_game.pistol_unlocked
	pistol.ammo = saved_game.pistol_ammo
	pistol.weapon.total_ammo = saved_game.pistol_total_ammo
	# load assault rifle values
	assaultrifle.unlocked = saved_game.assaultrifle_unlocked
	assaultrifle.ammo = saved_game.assaultrifle_ammo
	assaultrifle.weapon.total_ammo = saved_game.assaultrifle_total_ammo
	# load shotgun values 
	shotgun.unlocked = saved_game.shotgun_unlocked
	shotgun.ammo = saved_game.shotgun_ammo
	shotgun.weapon.total_ammo = saved_game.shotgun_total_ammo
	# load rocketlauncher values
	rocketlauncher.unlocked = saved_game.rocketlauncher_unlocked
	rocketlauncher.ammo = saved_game.rocketlauncher_ammo
	rocketlauncher.weapon.total_ammo = saved_game.rocketlauncher_total_ammo
	
	find_nav_regions()
	find_current_level()
	
	get_tree().call_group("game_events", "on_before_load_game")
	
	# reloads all enemies
	for item in saved_game.saved_data:
		var scene = load(item.scene_path) as PackedScene
		var restored_node = scene.instantiate()
		nav_region.add_child(restored_node)
			
		if restored_node.has_method("on_load_game"):
			restored_node.on_load_game(item)
	
	get_tree().call_group("interactable_events", "on_before_load_game")
	
	# reloads all interactables (buttons, doors, lights, etc)
	for item in saved_game.interactables_saved_data:
		var scene = load(item.scene_path) as PackedScene
		var restored_node = scene.instantiate()
		current_level.add_child(restored_node)
			
		if restored_node.has_method("on_load_game"):
			restored_node.on_load_game(item)
			
	player.dead = false
	player.health_component.is_alive = true
	player.death.play("RESET")
	
