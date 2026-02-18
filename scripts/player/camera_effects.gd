class_name CameraEffects extends Camera3D

@export_category("References")
@export var player : PlayerController

@export_category("Effects")
@export var enable_tilt : bool = true

@export_category("Kick & Recoil Settings")
@export_group("Run Tilt")
@export var run_pitch : float = 0.1 # in degrees
@export var run_roll : float = 0.25 # in degrees
@export var max_pitch : float = 1.0 # in degrees
@export var max_roll : float = 2.5 # in degrees
