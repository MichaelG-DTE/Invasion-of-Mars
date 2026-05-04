extends StaticBody3D

@onready var terminal_page_3: Control = $TerminalPage3
@onready var terminal_access_sfx: AudioStreamPlayer3D = $TerminalAccessSFX

func interact():
	terminal_access_sfx.play()
	globalvar.in_terminal = not globalvar.in_terminal
	terminal_page_3.visible = not terminal_page_3.visible
