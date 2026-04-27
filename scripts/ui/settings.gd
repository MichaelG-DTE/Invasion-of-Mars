extends Control
@onready var return_button_sfx: AudioStreamPlayer = $Return/ReturnButtonSFX

@export var MasterAudioBusName : String
@export var SFXAudioBusName : String
@export var MusicAudioBusName : String
@export var AmbientAudioBusName : String

var masterpath
var SFXpath
var Musicpath
var Ambientpath

func _ready() -> void:
	masterpath = AudioServer.get_bus_index(MasterAudioBusName)
	SFXpath = AudioServer.get_bus_index(SFXAudioBusName)
	Musicpath = AudioServer.get_bus_index(MusicAudioBusName)
	Ambientpath = AudioServer.get_bus_index(AmbientAudioBusName)
	

func _on_return_pressed() -> void:
	return_button_sfx.play()
	await get_tree().create_timer(0.5).timeout
	visible = false

func _on_m_volume_slider_value_changed(value: float) -> void:
	var convertedvalue = linear_to_db(value)
	AudioServer.set_bus_volume_db(masterpath, convertedvalue)
	if convertedvalue < -80:
		AudioServer.set_bus_mute(masterpath, true)
	else:
		AudioServer.set_bus_mute(masterpath, false)

func _on_sound_effects_slider_value_changed(value: float) -> void:
	var convertedvalue = linear_to_db(value)
	AudioServer.set_bus_volume_db(SFXpath, convertedvalue)
	if convertedvalue < -80:
		AudioServer.set_bus_mute(SFXpath, true)
	else:
		AudioServer.set_bus_mute(SFXpath, false)

func _on_music_slider_value_changed(value: float) -> void:
	var convertedvalue = linear_to_db(value)
	AudioServer.set_bus_volume_db(Musicpath, convertedvalue)
	if convertedvalue < -80:
		AudioServer.set_bus_mute(Musicpath, true)
	else:
		AudioServer.set_bus_mute(Musicpath, false)

func _on_ambient_slider_value_changed(value: float) -> void:
	var convertedvalue = linear_to_db(value)
	
	AudioServer.set_bus_volume_db(Ambientpath, convertedvalue)
	if convertedvalue < -80:
		AudioServer.set_bus_mute(Ambientpath, true)
	else:
		AudioServer.set_bus_mute(Ambientpath, false)

func _on_fullscreen_toggle_toggled(toggled_on: bool) -> void:
	if toggled_on == true:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func _on_quality_button_item_selected(index: int) -> void:
	var options = [1, 0.75, 0.5, 0.25]
	var value = options[index]
	get_tree().root.scaling_3d_scale = value

func _on_sensitivity_value_changed(value: float) -> void:
	globalvar.sensitivity = value

func _on_fov_value_changed(value: float) -> void:
	globalvar.fov = value
