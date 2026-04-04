extends StaticBody3D

@onready var terminal_page_2: Control = $TerminalPage2

func interact():
	terminal_page_2.visible = not terminal_page_2.visible
