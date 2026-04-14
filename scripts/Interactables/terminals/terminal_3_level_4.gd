extends StaticBody3D
@onready var terminal_page_3: Control = $TerminalPage3


func interact():
	terminal_page_3.visible = not terminal_page_3.visible
