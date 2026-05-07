class_name PlayerState extends Node

# base node for the player state machine

var player_controller : PlayerController

func _ready() -> void:
	if %StateMachine and %StateMachine is PlayerStateMachine:
		player_controller = %StateMachine.player_controller
