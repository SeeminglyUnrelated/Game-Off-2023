extends Area2D

var entered = false

#Make the collectible visibility dissapear
func _on_body_entered(_body: PhysicsBody2D):
	entered = true

func _on_body_exited(_body: PhysicsBody2D):
	entered = false

#Allows player to pick up the collectable (could also be used for the puzzles where you have to pick something up and place it somewhere else)
func _physics_process(_delta):
	if entered == true:
		queue_free()
