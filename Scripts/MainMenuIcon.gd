extends Node2D

@export var Size_Normal = 2
@export var Size_Hovered = 4

func _on_main_menu_mouse_entered():
	set_scale(Vector2(Size_Normal, Size_Normal))

func _on_main_menu_mouse_exited():
	set_scale(Vector2(Size_Hovered, Size_Hovered))
