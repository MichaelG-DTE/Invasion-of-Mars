extends Node


@onready var current_level: Node3D = $"../../CurrentLevel"
@onready var pause_menu: Control = $"../../Pause Menu"
@onready var user_interface: CanvasLayer = $"../../CurrentLevel/Player/UserInterface"
@onready var loadingscreen: Control = $"../../Loadingscreen"

const LEVEL_ONE = preload("uid://bupaqukakeo13")
const LEVEL_TWO = preload("uid://cks5kigjjks6e")
const LEVEL_THREE = preload("uid://vvqqydrltyrv")
const LEVEL_FOUR = preload("uid://d2ff3ocau7igq")
const LEVEL_FIVE = preload("uid://cwcy8djptf2xj")
const EPILOGUE = preload("uid://bjuk23ulc7kjw")

var Level_One
var Level_Two
var Level_Three
var Level_Four
var Level_Five
var Epilogue

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		pause_menu.play_animation()
		pause_menu.visible = true
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		user_interface.visible = false
		get_tree().paused = true

func _ready() -> void:
	SignalBus.level_change.connect(change_level)
	SignalBus.end_game.connect(end_game)
	Level_One = LEVEL_ONE.instantiate()
	current_level.add_child(Level_One)

# changes the level based on the global var 'current level'
# removes save data for each level, and queue frees the level
func change_level():
	if globalvar.current_level == 1:
		delete_save_data()
		user_interface.hide()
		loadingscreen.visible = true
		loadingscreen.play()
		Level_One.queue_free()
		await get_tree().create_timer(3.0).timeout
		loadingscreen.stop()
		loadingscreen.visible = false
		user_interface.show()
		Level_Two = LEVEL_TWO.instantiate()
		current_level.add_child(Level_Two)
	elif globalvar.current_level == 2:
		delete_save_data()
		user_interface.hide()
		loadingscreen.visible = true
		loadingscreen.play()
		Level_Two.queue_free()
		await get_tree().create_timer(3.0).timeout
		loadingscreen.stop()
		loadingscreen.visible = false
		user_interface.show()
		Level_Three = LEVEL_THREE.instantiate()
		current_level.add_child(Level_Three)
	elif globalvar.current_level == 3:
		delete_save_data()
		user_interface.hide()
		loadingscreen.visible = true
		loadingscreen.play()
		Level_Three.queue_free()
		await get_tree().create_timer(3.0).timeout
		loadingscreen.stop()
		loadingscreen.visible = false
		user_interface.show()
		Level_Four = LEVEL_FOUR.instantiate()
		current_level.add_child(Level_Four)
	elif globalvar.current_level == 4:
		delete_save_data()
		user_interface.hide()
		loadingscreen.visible = true
		loadingscreen.play()
		Level_Four.queue_free()
		await get_tree().create_timer(3.0).timeout
		loadingscreen.stop()
		loadingscreen.visible = false
		user_interface.show()
		Level_Five = LEVEL_FIVE.instantiate()
		current_level.add_child(Level_Five)
	elif globalvar.current_level == 5:
		delete_save_data()
		user_interface.hide()
		loadingscreen.visible = true
		loadingscreen.play()
		Level_Five.queue_free()
		await get_tree().create_timer(3.0).timeout
		loadingscreen.stop()
		loadingscreen.visible = false
		user_interface.show()
		Epilogue = EPILOGUE.instantiate()
		current_level.add_child(Epilogue)

# finds the path to the save game resource and deletes it
func delete_save_data():
	var save_path = "user://savegame.tres"
	DirAccess.remove_absolute(save_path)
	print("deleted save data")

# goes back to the menu screen and makes the mouse visible
func end_game():
	await get_tree().create_timer(3.0).timeout
	get_tree().change_scene_to_file("res://scenes/ui/title_screen.tscn")
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
