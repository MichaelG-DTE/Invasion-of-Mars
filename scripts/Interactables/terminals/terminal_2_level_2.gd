extends StaticBody3D

@onready var terminal_access_sfx: AudioStreamPlayer3D = $TerminalAccessSFX
@onready var terminal_page_2: Control = $TerminalPage2

func interact():
	terminal_access_sfx.play()
	globalvar.in_terminal = not globalvar.in_terminal
	terminal_page_2.visible = not terminal_page_2.visible
