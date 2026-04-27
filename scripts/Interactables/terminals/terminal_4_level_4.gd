extends StaticBody3D
@onready var terminal_page_4: Control = $TerminalPage4
@onready var terminal_access_sfx: AudioStreamPlayer3D = $TerminalAccessSFX


func interact():
	terminal_access_sfx.play()
	terminal_page_4.visible = not terminal_page_4.visible
