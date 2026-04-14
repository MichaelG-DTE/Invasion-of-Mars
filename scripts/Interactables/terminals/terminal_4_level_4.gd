extends StaticBody3D
@onready var terminal_page_4: Control = $TerminalPage4


func interact():
	terminal_page_4.visible = not terminal_page_4.visible
