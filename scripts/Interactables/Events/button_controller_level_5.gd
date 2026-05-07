extends Node3D


var terminal 
var all_buttons_pressed = false

func _ready() -> void:
	get_terminal()

# finds the terminal placed at the top of the tower on level five
func get_terminal():
	terminal = get_tree().get_first_node_in_group("terminal")

func _process(_delta: float) -> void:
	var buttons = get_tree().get_nodes_in_group("levelbuttons")
	for button in buttons:
		if !button.has_pressed:
			return
			
	all_buttons_pressed = true
	if all_buttons_pressed == true:
		get_terminal()
		terminal.play_animation()
		
