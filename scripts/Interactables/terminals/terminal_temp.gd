extends StaticBody3D
@onready var terminal_page: Control = $TerminalPage
@onready var terminal_page_2: Control = $TerminalPage2
@onready var terminal_page_3: Control = $TerminalPage3
@onready var terminal_page_4: Control = $TerminalPage4
@onready var terminal_access_sfx: AudioStreamPlayer3D = $TerminalAccessSFX


var page_number = 1
var in_terminal = false


func _ready() -> void:
	SignalBus.terminal_change.connect(change_terminal_page)

func interact():
	terminal_access_sfx.play()
	in_terminal = true
	if page_number == 1:
		terminal_page.visible = not terminal_page.visible
	if page_number == 2:
		terminal_page.visible = false
		terminal_page_2.visible = not terminal_page_2.visible
	if page_number == 3:
		terminal_page_3.visible = not terminal_page_3.visible
	if page_number == 4:
		terminal_page_4.visible = not terminal_page_4.visible
		globalvar.can_teleport = true
		
func _process(_delta: float) -> void:
	if in_terminal:
		if page_number >= 2 and page_number <= 3:
			if Input.is_action_just_pressed("right arrow"):
				page_number += 1
				print(page_number)
				terminal_page_3.visible = true
				terminal_page_2.visible = false
			elif Input.is_action_just_pressed("left arrow"):
				page_number -= 1
				print(page_number)
				terminal_page_2.visible = true
				terminal_page_3.visible = false

func change_terminal_page():
	page_number = 4
	print("Terminal Changed")
	
