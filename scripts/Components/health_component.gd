class_name HealthComponent extends Node

#reusable health component for any entity

signal health_changed(new_health : float, max_health : float)
signal shield_changed(new_shield : float, max_shield : float)
signal damage_taken(amount : float, source : Node3D)
signal died()

@export var max_health : float = 100.0
@export var max_shield : float = 100.0
@export var start_at_max : bool = true
@export var has_shields : bool = true

var current_health : float
var current_shield : float
var is_alive : bool = true

func _ready() -> void:
	if start_at_max and has_shields:
		current_health = max_health
		current_shield = max_shield
	if not has_shields:
		current_health = max_health
		max_shield = 0.0

func take_damage(amount : float, source : Node3D = null) -> void:
	if not is_alive:
		return

	# if the owner has shields, then it removes shield health first, then health next 
	var actual_damage = max(0.0, amount) # prevents taking negative damage
	if current_shield <= 0:
		current_health = max(0.0, current_health - actual_damage)
	elif has_shields:
		current_shield = max(0,0, current_shield - actual_damage)
		
	damage_taken.emit(actual_damage, source)
	
	
	if current_shield <= 0:
		health_changed.emit(current_health, max_health)
	elif has_shields:
		shield_changed.emit(current_shield, max_shield)
	
	if current_health <= 0.0:
		_handle_death()

# heals shields and health

func heal(amount: float) -> void:
	if not is_alive:
		return
		
	var actual_heal = max(0.0, amount) # prevents negative healing
	
	# sets the current health to minium of the current health + the healed amount
	current_health = min(max_health, current_health + actual_heal)
	health_changed.emit(current_health, max_health)

func heal_shield(amount: float) -> void:
	if not is_alive:
		return

	var actual_heal = max(0.0, amount) # prevents negative healing
	
	# sets the current shield to minium of the current health + the healed amount
	current_shield = min(max_shield, current_shield + actual_heal)
	shield_changed.emit(current_shield, max_shield)

func _handle_death() -> void:
	if not is_alive:
		return
		
	is_alive = false
	current_health = 0.0
	died.emit()
	
