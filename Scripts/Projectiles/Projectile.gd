extends RigidBody2D

# Base projectile object inherited by other projectile.
# Should be added as a child node before manipulating
class_name Projectile

var Direction
var Speed
# Unimplemented yet
var Damage

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Parameters:
# _direction, a vector who's values should be between 0 and 1 for proper aiming
# _speed, multiplied to the direction vector to give its velocity
# _damage, unimplemented
func Initialize(_direction : Vector2, _speed : float, _damage: int ):
	Direction = _direction
	Speed = _speed
	Damage = _damage
	
	add_to_group("projectiles", true)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
