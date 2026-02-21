class_name MouseCapture extends Node


@export_category("Camera Capture Settings") # organises the export varibles into sections to improve code readabilityt
@export var current_mouse_mode = Input.MOUSE_MODE_CAPTURED # sets mouse mode to stay within the screen
@export var mouse_visibility = Input.MOUSE_MODE_HIDDEN #sets mouse cursor to invisible
@export var y_sensitivity : float = 0.1 # adjust later
@export var x_sensitivity : float = 0.1

var capture_mouse : bool # sets the mouse mode as captured or not based on boolean var
var mouse_input : Vector2 # gets the input from mouse as coordinates

func _unhandled_input(event: InputEvent) -> void:
	# this sets the mouse mode based on the input of mouse motion
	capture_mouse = event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED
	if capture_mouse:
		mouse_input.x += -event.screen_relative.x * x_sensitivity
		mouse_input.y += -event.screen_relative.y * y_sensitivity

func _ready() -> void:
	Input.mouse_mode = current_mouse_mode

func  _process(_delta: float) -> void:
	mouse_input = Vector2.ZERO
