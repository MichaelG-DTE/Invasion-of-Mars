extends Node3D

var door
var animationplayer
var doorlight

func _ready() -> void:
	find_the_stupid_door()
	get_animation_play()

func get_animation_play():
	animationplayer = get_tree().get_first_node_in_group("doorlight")
	doorlight = get_tree().get_first_node_in_group("door_light")

func _process(_delta: float) -> void:
	var buttons = get_tree().get_nodes_in_group("levelbuttons")
	for button in buttons:
		if !button.has_pressed and button.has_pressed:
			return
		find_the_stupid_door()
		get_animation_play()
		door.locked = false
		if door.locked == false:
			animationplayer.play("doorlightchange")
			doorlight.change_var()
		
func find_the_stupid_door():
	var doors = get_tree().get_nodes_in_group("door")
	for neodoor in doors:
		if neodoor == null:
			return
		else:
			door = neodoor
