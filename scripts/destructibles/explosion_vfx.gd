extends Node3D

@onready var sparks: GPUParticles3D = $Sparks
@onready var flash: GPUParticles3D = $Flash
@onready var fire: GPUParticles3D = $Fire
@onready var smoke: GPUParticles3D = $Smoke

# sets the explosion parts (which are one shot (means they will only happen once)) to emit, causing a explosion effect
func call_explosion():
	sparks.emitting = true
	flash.emitting = true
	fire.emitting = true
	smoke.emitting = true
