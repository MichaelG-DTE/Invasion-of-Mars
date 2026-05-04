extends StaticBody3D
@onready var terminal_page: Control = $TerminalPage
@onready var terminal_access_sfx: AudioStreamPlayer3D = $TerminalAccessSFX

func interact():
	terminal_access_sfx.play()
	globalvar.in_terminal = not globalvar.in_terminal
	terminal_page.visible = not terminal_page.visible
	
