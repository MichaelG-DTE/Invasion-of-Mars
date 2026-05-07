extends Node

# global variables used across the game

var can_teleport := false
var current_level := 0

# these ones are specifically used for settings
var sensitivity : float = 0.06

var fov : float = 90

# prevents movement if in a terminal
var in_terminal : bool = false
