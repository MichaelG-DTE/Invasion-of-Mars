extends RayCast3D
@onready var interact_text: Label = %InteractText
@onready var user_interface: CanvasLayer = $"../../../UserInterface"


var current_object

func _process(_delta: float) -> void:
	interact_text.hide()
	if is_colliding():
		var object = get_collider()
		if object == current_object:
			if object.has_method("interact"):
				interact_text.show()
				if Input.is_action_just_pressed("Interact"):
					object.interact()
					if object.name == "TerminalTemp":
						user_interface.visible = not user_interface.visible
					if object.name == "Terminal1Level2":
						user_interface.visible = not user_interface.visible
					if object.name == "Terminal2Level2":
						user_interface.visible = not user_interface.visible
			else:
				interact_text.hide()
		else:
			current_object = object
	else:
		current_object = null # not colliding with anything
