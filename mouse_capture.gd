class_name MouseCapture extends Node


@export_category("Camera Capture Settings") # organises the export varibles into sections to improve code readabilityt
@export var mouse_mode = Input.MOUSE_MODE_CAPTURED # sets mouse mode to stay within the screen
@export var mouse_visibility = Input.MOUSE_MODE_HIDDEN #sets mouse cursor to invisible
@export var sensitivity : float = 0.005 # adjust later

var capture_mouse : bool # sets the mouse mode as captured or not based on boolean var
var mouse_input : Vector2 # gets the input from mouse as coordinates
