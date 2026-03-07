extends StaticBody3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D
@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D



func interact():
	if not is_open():
		animation_player.play("open")
	if is_open():
		animation_player.play("close")
		
		
func is_open() -> bool:
	if mesh_instance_3d.position.y and collision_shape_3d.position.y == 1.25:
		return false
	else:
		return true
