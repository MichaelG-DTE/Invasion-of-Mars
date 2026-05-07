extends StaticBody3D

@onready var terminal_page: Control = $TerminalPage
@onready var terminal_page_2: Control = $TerminalPage2
@onready var terminal_access_sfx: AudioStreamPlayer3D = $TerminalAccessSFX
@onready var button_controller: Node3D = $"../ButtonController"
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func interact():
	terminal_access_sfx.play()
	globalvar.in_terminal = not globalvar.in_terminal
	if !button_controller.all_buttons_pressed:
		terminal_page.visible = not terminal_page.visible
	else:
		animation_player.stop()
		terminal_page_2.visible = not terminal_page_2.visible
		globalvar.can_teleport = true

func play_animation():
	animation_player.play("TerminalFlash")
