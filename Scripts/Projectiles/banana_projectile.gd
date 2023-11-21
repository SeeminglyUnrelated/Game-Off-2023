extends projectile
class_name banana_projectile

var active = false

func _ready():
	pass 

func Initialize(_direction : Vector2, _speed : float, _damage: int ):
	# Make the projectile unaffected by gravity
	gravity_scale = 0
	
	# Only the object is created when a new instance of a projectile is made, so we need
	# to add children of the original node manually
	add_child(get_node("/root/Projectiles/BananaProjectile/CollisionShape2D").duplicate())
	add_child(get_node("/root/Projectiles/BananaProjectile/AnimatedSprite2D").duplicate())
	
	# Allow the node to execute its _process method
	active = true
	
	# So that we do not collide with the player
	collision_layer = 2
	collision_mask = 2
	
	# Velocity at which the projectile spins
	angular_velocity = 20
	
	# Prevent the projectile from spinning less over time
	angular_damp = 0
	angular_damp_mode = RigidBody2D.DAMP_MODE_REPLACE
	
	# Allow the use of collision function
	contact_monitor = true
	max_contacts_reported = 1
	
	super.Initialize(_direction, _speed, _damage)
	
	# Make the projectile move over time
	add_constant_force(Vector2(direction.x * speed, direction.y * speed))
func _physics_process(_delta):
	if not active:
		return
	
	# If the projectile collides with something other than an instance of itself
	# we make it die
	if get_colliding_bodies().size() > 0 and not get_colliding_bodies()[0].is_in_group("projectiles"):
		queue_free()
		
	
	