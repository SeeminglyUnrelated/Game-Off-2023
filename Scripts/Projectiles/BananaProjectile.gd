extends Projectile
class_name BananaProjectile
# Called when the node enters the scene tree for the first time.
var Sprite
var Collision
var Active = false

func _ready():
	pass 


func Initialize(_direction : Vector2, _speed : float, _damage: int ):
	gravity_scale = 0
	Sprite = get_node("/root/Projectiles/BananaProjectile/CollisionShape2D").duplicate()
	Collision = get_node("/root/Projectiles/BananaProjectile/AnimatedSprite2D").duplicate()
	add_child(Sprite)
	add_child(Collision)
	
	collision_layer = 2
	collision_mask = 2
	angular_velocity = 20
	angular_damp = 0
	angular_damp_mode = RigidBody2D.DAMP_MODE_REPLACE
	Active = true
	contact_monitor = true
	max_contacts_reported = 1
	super.Initialize(_direction, _speed, _damage)
	
	add_constant_force(Vector2(Direction.x * Speed, Direction.y * Speed))
func _physics_process(_delta):
	if not Active:
		return
		
	if get_colliding_bodies().size() > 0 and not get_colliding_bodies()[0].is_in_group("projectiles"):
		queue_free()
		
	
	
