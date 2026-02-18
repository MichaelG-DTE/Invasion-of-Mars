class_name PlayerStateMachine extends Node

@export_category("References")
@export var player_controller : PlayerController

func _process(_delta: float) -> void:
	if player_controller: # adds debug stats to the debug chart
		player_controller.state_chart.set_expression_property("Player Velocity", player_controller.velocity) 
		player_controller.state_chart.set_expression_property("Player Hitting Head", player_controller.crouch_check.is_colliding())
		player_controller.state_chart.set_expression_property("Player Crouching", player_controller.is_crouching)
		player_controller.state_chart.set_expression_property("Player Sprinting", player_controller.is_sprinting)
		player_controller.state_chart.set_expression_property("Looking At", player_controller.interaction_raycast.current_object)
