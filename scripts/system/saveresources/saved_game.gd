class_name SavedGame
extends Resource

# save game varaibles for player and weapons

@export_category("playervalues")
@export var player_transform : Transform3D
@export var player_health : float
@export var player_shield : float
@export var torch_visible : bool
@export var torch_energy : float
@export var torch_active : bool
@export var current_slot : int

@export_category("pistolsavevalues")
@export var pistol_unlocked : bool
@export var pistol_total_ammo : int
@export var pistol_ammo : int

@export_category("assaultriflesavevalues")
@export var assaultrifle_unlocked : bool
@export var assaultrifle_total_ammo : int
@export var assaultrifle_ammo : int

@export_category("shotgunsavevalues")
@export var shotgun_unlocked : bool
@export var shotgun_total_ammo : int
@export var shotgun_ammo : int

@export_category("rocketlaunchersavevalues")
@export var rocketlauncher_unlocked : bool
@export var rocketlauncher_total_ammo : int
@export var rocketlauncher_ammo : int

@export_category("game events")
@export var saved_data : Array[SavedData] = []
@export var interactables_saved_data : Array[InteractableSavedData] = []
