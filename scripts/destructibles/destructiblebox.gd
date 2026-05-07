extends StaticBody3D

# destroys box when loses health (box unused, but same script could be applied to other objects?)
func _on_health_component_died() -> void:
	print(name, " destroyed!")
	queue_free()
