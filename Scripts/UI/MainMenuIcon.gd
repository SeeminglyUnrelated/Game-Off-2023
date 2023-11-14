# Paul made this code
# Add any contributors below

extends Sprite2D

@export var Size_Normal = 2
@export var Size_Hovered = 4

@onready var animation_player = $"../AnimationPlayer"

# Functions are reversed because we're checking wether the mouse is NOT over a button
# Should probs find a better solution later but it works ig
func _on_main_menu_mouse_entered() -> void:
	animation_player.play_backwards("scaleUp")


func _on_main_menu_mouse_exited() -> void:
	animation_player.play("scaleUp")
