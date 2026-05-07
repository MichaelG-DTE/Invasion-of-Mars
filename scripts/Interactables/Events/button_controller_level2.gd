extends Node3D

var door
var animationplayer
var doorlight

func _ready() -> void:
	find_the_door()
	get_animation_play()

func get_animation_play():
	animationplayer = get_tree().get_first_node_in_group("doorlight")
	doorlight = get_tree().get_first_node_in_group("door_light")

# checks if both buttons have been pressed and opens the door 
func _process(_delta: float) -> void:
	var buttons = get_tree().get_nodes_in_group("levelbuttons")
	for button in buttons:
		if !button.has_pressed:
			return
		find_the_door()
		get_animation_play()
		door.locked = false
		if door.locked == false:
			animationplayer.play("doorlightchange")
			doorlight.change_var()

# finds the door blocking the exit on level 2
func find_the_door():
	var doors = get_tree().get_nodes_in_group("door")
	for neodoor in doors:
		if neodoor == null:
			return
		else:
			door = neodoor
