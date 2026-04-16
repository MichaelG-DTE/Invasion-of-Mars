extends StaticBody3D

@onready var terminal_page: Control = $TerminalPage
@onready var terminal_page_2: Control = $TerminalPage2
@onready var button_controller: Node3D = $"../ButtonController"

func interact():
	if not button_controller.all_buttons_pressed:
		terminal_page.visible = not terminal_page.visible
	else:
		terminal_page_2.visible = not terminal_page_2.visible
		globalvar.can_teleport = true
