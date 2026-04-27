extends StaticBody3D
@onready var terminal_page_2: Control = $TerminalPage2
@onready var terminal_access_sfx: AudioStreamPlayer3D = $TerminalAccessSFX

func interact():
	terminal_access_sfx.play()
	terminal_page_2.visible = not terminal_page_2.visible
