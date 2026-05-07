extends Control
@onready var resume_button_sfx: AudioStreamPlayer = $Resume/ResumeButtonSFX
@onready var quit_button_sfx: AudioStreamPlayer = $QuitToMenu/QuitButtonSFX
@onready var quit_desktop_button_sfx: AudioStreamPlayer = $QuitToDesktop/QuitDesktopButtonSFX
@onready var settings_button_sfx: AudioStreamPlayer = $SettingsButton/SettingsButtonSFX
@onready var settings: Control = $Settings
@onready var user_interface: CanvasLayer = $"../CurrentLevel/Player/UserInterface"
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var quit_to_menu_confirm: Control = $QuitToMenuConfirm
@onready var quit_to_desktop_confirm: Control = $QuitToDesktopConfirm
@onready var quit_button_sfx2: AudioStreamPlayer = $QuitToMenuConfirm/ConfirmQuit/QuitButtonSFX
@onready var return_button_sfx: AudioStreamPlayer = $QuitToMenuConfirm/Return/ReturnButtonSFX
@onready var quit_button_sfx3: AudioStreamPlayer = $QuitToDesktopConfirm/ConfirmQuit/QuitButtonSFX
@onready var return_button_sfx2: AudioStreamPlayer = $QuitToDesktopConfirm/Return/ReturnButtonSFX


func _on_resume_pressed() -> void:
	resume_button_sfx.play()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	get_tree().paused = false
	animation_player.play_backwards("blur")
	user_interface.visible = true
	
func _on_quit_to_menu_pressed() -> void:
	quit_button_sfx.play()
	quit_to_menu_confirm.visible = true

func _on_quit_to_desktop_pressed() -> void:
	quit_desktop_button_sfx.play()
	quit_to_desktop_confirm.visible = true

func _on_settings_pressed() -> void:
	settings_button_sfx.play()
	settings.visible = true

func play_animation():
	animation_player.play("blur")

func _on_menu_confirm_quit_pressed() -> void:
	quit_button_sfx2.play()
	get_tree().paused = false
	await get_tree().create_timer(0.5).timeout
	delete_save_data()
	globalvar.current_level = 0
	get_tree().change_scene_to_file("res://scenes/ui/title_screen.tscn")

func _on_menu_return_pressed() -> void:
	return_button_sfx.play()
	quit_to_menu_confirm.visible = false

func _on_desktop_confirm_quit_pressed() -> void:
	quit_button_sfx3.play()
	await get_tree().create_timer(0.5).timeout
	get_tree().quit()

func _on_desktop_return_pressed() -> void:
	return_button_sfx2.play()
	quit_to_desktop_confirm.visible = false
	
# finds the path to the save game resource and deletes it
func delete_save_data():
	var save_path = "user://savegame.tres"
	DirAccess.remove_absolute(save_path)
	print("deleted save data")
