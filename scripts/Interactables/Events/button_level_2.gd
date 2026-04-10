extends StaticBody3D

@export var has_pressed = false
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_player2: AnimationPlayer = $"../SecondButtonLevel2/AnimationPlayer"
@onready var first_button_level_2: StaticBody3D = $"."
@onready var second_button_level_2: StaticBody3D = $"../SecondButtonLevel2"


func interact():
	if !has_pressed:
		has_pressed = true
		if self == first_button_level_2:
			animation_player.play("pressed")
			print("has pressed ", self)
		else:
			animation_player2.play("pressed")
			print("has pressed ", self)
