extends Node

@onready var level_one: Node3D = $"../../CurrentLevel/Level One"
@onready var current_level: Node3D = $"../../CurrentLevel"

const LEVEL_ONE = preload("uid://bupaqukakeo13")
const LEVEL_TWO = preload("uid://cks5kigjjks6e")
const LEVEL_THREE = preload("uid://vvqqydrltyrv")
const LEVEL_FOUR = preload("uid://d2ff3ocau7igq")
const LEVEL_FIVE = preload("uid://cwcy8djptf2xj")

var Level_Two
var Level_Three
var Level_Four
var Level_Five

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("quit"):
		get_tree().quit()

func _ready() -> void:
	SignalBus.level_change.connect(change_level)
	
func change_level():
	if globalvar.current_level == 1:
		level_one.queue_free()
		Level_Two = LEVEL_TWO.instantiate()
		current_level.add_child(Level_Two)
	elif globalvar.current_level == 2:
		Level_Two.queue_free()
		Level_Three = LEVEL_THREE.instantiate()
		current_level.add_child(Level_Three)
	elif globalvar.current_level == 3:
		Level_Three.queue_free()
		Level_Four = LEVEL_FOUR.instantiate()
		current_level.add_child(Level_Four)
	elif globalvar.current_level == 4:
		Level_Four.queue_free()
		Level_Five = LEVEL_FIVE.instantiate()
		current_level.add_child(Level_Five)
