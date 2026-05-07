class_name PlayerStateMachine extends Node

@export_category("References")
@export var player_controller : PlayerController
@export_category("Debug Vars On Off")
@export var debug_velocity : bool = true
@export var debug_head_hitting : bool = true
@export var debug_crouching : bool = true
@export var debug_sprinting : bool = true
@export var debug_looking : bool = true
@export var debug_step : bool = true

# debug values no longer needed 
func _process(_delta: float) -> void:
	if player_controller: # adds debug stats to the debug chart
		if debug_velocity:
			player_controller.state_chart.set_expression_property("Player Velocity", player_controller.velocity) 
		if debug_head_hitting:
			player_controller.state_chart.set_expression_property("Player Hitting Head", player_controller.crouch_check.is_colliding())
		if debug_crouching:
			player_controller.state_chart.set_expression_property("Player Crouching", player_controller.is_crouching)
		if debug_sprinting:
			player_controller.state_chart.set_expression_property("Player Sprinting", player_controller.is_sprinting)
		if debug_looking:
			player_controller.state_chart.set_expression_property("Looking At", player_controller.interaction_raycast.current_object)
		if debug_step:
			player_controller.state_chart.set_expression_property("Step Collision", player_controller.step_handler.step_status)
