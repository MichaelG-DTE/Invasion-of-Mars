extends StaticBody3D

@onready var terminal_page: Control = $TerminalPage


func interact():
	terminal_page.visible = not terminal_page.visible 
