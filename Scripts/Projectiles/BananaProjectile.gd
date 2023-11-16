extends Projectile
class_name BananaProjectile

var Active = false

func _ready():
	pass 

func Initialize(_direction : Vector2, _speed : float, _damage: int ):
	# make the projectile unaffected by gravity
	gravity_scale = 0
	
	# only the object is created when a new instance of a projectile is made, so we need
	# to add children of the original node manually
	add_child(get_node("/root/Projectiles/BananaProjectile/CollisionShape2D").duplicate())
	add_child(get_node("/root/Projectiles/BananaProjectile/AnimatedSprite2D").duplicate())
	
	# allow the node to execute its _process method
	Active = true
	
	# so that we do not collide with the player
	collision_layer = 2
	collision_mask = 2
	
	# velocity at which the projectile spins
	angular_velocity = 20
	
	# prevent the projectile from spinning less over time
	angular_damp = 0
	angular_damp_mode = RigidBody2D.DAMP_MODE_REPLACE
	
	# allow the use of collision function
	contact_monitor = true
	max_contacts_reported = 1
	
	super.Initialize(_direction, _speed, _damage)
	
	# make the projectile move over time
	add_constant_force(Vector2(Direction.x * Speed, Direction.y * Speed))
func _physics_process(_delta):
	if not Active:
		return
	
	# if the projectile collides with something other than an instance of itself
	# we make it die
	if get_colliding_bodies().size() > 0 and not get_colliding_bodies()[0].is_in_group("projectiles"):
		queue_free()
		
	
	
