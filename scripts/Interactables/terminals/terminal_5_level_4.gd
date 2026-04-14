extends StaticBody3D
@onready var terminal_page_5: Control = $TerminalPage5


func interact():
	terminal_page_5.visible = not terminal_page_5.visible
	globalvar.can_teleport = true
