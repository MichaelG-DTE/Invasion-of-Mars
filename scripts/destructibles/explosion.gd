extends Area3D

@export var explosionvfx : Node3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	explosionvfx.call_explosion()
	
