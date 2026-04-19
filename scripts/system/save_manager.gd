extends Node

@onready var player: PlayerController = $"../../CurrentLevel/Player"
@onready var weapon_manager: WeaponManager = $"../WeaponManager"

@onready var level_one: Node3D = $"../../CurrentLevel/Level One"
@onready var level_two: Node3D = $"../../CurrentLevel/LevelTwo"
@onready var level_three: Node3D = $"../../CurrentLevel/LevelThree"
@onready var level_four: Node3D = $"../../CurrentLevel/LevelFour"
@onready var level_five: Node3D = $"../../CurrentLevel/LevelFive"

@onready var navigation_region_3d_lvl_1: NavigationRegion3D = $"../../CurrentLevel/Level One/NavigationRegion3D"
@onready var navigation_region_3d_lvl_2: NavigationRegion3D = $"../../CurrentLevel/LevelTwo/NavigationRegion3D"
@onready var navigation_region_3d_lvl_3: NavigationRegion3D = $"../../CurrentLevel/LevelThree/NavigationRegion3D"
@onready var navigation_region_3d_lvl_4: NavigationRegion3D = $"../../CurrentLevel/LevelFour/NavigationRegion3D"
@onready var navigation_region_3d_lvl_5: NavigationRegion3D = $"../../CurrentLevel/LevelFive/NavigationRegion3D"

@export var pistol_data : WeaponData
@export var are_data : WeaponData
@export var bmr_data : WeaponData
@export var rico_kbm_data : WeaponData

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
	var saved_game : SavedGame = load("user://savegame.tres") as SavedGame
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
	
	get_tree().call_group("game_events", "on_before_load_game")
	
	for item in saved_game.saved_data:
		var scene = load(item.scene_path) as PackedScene
		var restored_node = scene.instantiate()
		if globalvar.current_level == 1:
			navigation_region_3d_lvl_1.add_child(restored_node)
		if globalvar.current_level == 2:
			navigation_region_3d_lvl_2.add_child(restored_node)
		if globalvar.current_level == 3:
			navigation_region_3d_lvl_3.add_child(restored_node)
		if globalvar.current_level == 4:
			navigation_region_3d_lvl_4.add_child(restored_node)
		if globalvar.current_level == 5:
			navigation_region_3d_lvl_5.add_child(restored_node)
		
		if restored_node.has_method("on_load_game"):
			restored_node.on_load_game(item)
	
	get_tree().call_group("interactable_events", "on_before_load_game")
	
	for item in saved_game.interactables_saved_data:
		var scene = load(item.scene_path) as PackedScene
		var restored_node = scene.instantiate()
		if globalvar.current_level == 1:
			level_one.add_child(restored_node)
		if globalvar.current_level == 2:
			level_two.add_child(restored_node)
		if globalvar.current_level == 3:
			level_three.add_child(restored_node)
		if globalvar.current_level == 4:
			level_four.add_child(restored_node)
		if globalvar.current_level == 5:
			level_five.add_child(restored_node)
		
		if restored_node.has_method("on_load_game"):
			restored_node.on_load_game(item)
	
# save and load testing inputs
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("save"):
		save_game()
	elif Input.is_action_just_pressed("load"):
		load_game()
