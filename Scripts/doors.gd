extends Area2D

var entered = false

func _on_body_entered(_body: PhysicsBody2D):
	entered = true

func _on_body_exited(_body: PhysicsBody2D):
	entered = false

func _physics_process(_delta):
	if entered == true:
		if Input.is_action_just_pressed("Interact"):
			get_tree().change_scene_to_file("res://Scenes/level1.tscn")
