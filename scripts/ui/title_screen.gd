extends Control
@onready var play_button_sfx: AudioStreamPlayer = $Play/PlayButtonSFX
@onready var settings_button_sfx: AudioStreamPlayer = $Settings/SettingsButtonSFX
@onready var quit_button_sfx: AudioStreamPlayer = $Quit/QuitButtonSFX
@onready var credits_button_sfx: AudioStreamPlayer = $Credits/CreditsButtonSFX
@onready var settings_2: Control = $Settings2
@onready var credits_2: Control = $Credits2

func _on_play_pressed() -> void:
	play_button_sfx.play()
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file("res://scenes/system/main_scene.tscn")


func _on_settings_pressed() -> void:
	settings_button_sfx.play()
	await get_tree().create_timer(0.5).timeout
	settings_2.visible = true


func _on_quit_pressed() -> void:
	quit_button_sfx.play()
	await get_tree().create_timer(0.5).timeout
	get_tree().quit()


func _on_credits_pressed() -> void:
	credits_button_sfx.play()
	await get_tree().create_timer(0.5).timeout
	credits_2.visible = true
