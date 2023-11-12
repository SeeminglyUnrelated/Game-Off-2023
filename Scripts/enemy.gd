# Paul is the one to blame for any mess

extends CharacterBody2D

const SPEED = 200.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction = 1

@export var Sprite_Alerted : CompressedTexture2D
@export var Sprite_Dazed : CompressedTexture2D

enum MODES
{
	neutral,
	alert,
	dazed
}

var dazedTimer = 100
var mode = MODES.neutral

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Set mode to alert
	if ($Front.is_colliding() and $Front.get_collider().is_in_group("Player")):
		mode = MODES.alert
	elif ($Back.is_colliding() and $Back.get_collider().is_in_group("Player")):
		if mode != MODES.alert:
			direction = -direction
			scale.x *= -1
		mode = MODES.alert
	elif mode == MODES.alert: # We've just exited the alert mode
		dazedTimer = 100
		mode = MODES.dazed
	elif dazedTimer == 0:
		mode = MODES.neutral
		
	if mode == MODES.alert:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.speed_scale = 0.5
		velocity.x = direction * (SPEED * 1.5) # Go a little faster when found player
		$StateShower.texture = Sprite_Alerted
	elif mode == MODES.dazed:
		$AnimatedSprite2D.animation = "idle"
		$AnimatedSprite2D.speed_scale = 1
		$StateShower.texture = Sprite_Dazed
		# Stops texteru from being flipped with the rest of the enemy
		$StateShower.flip_h = true if direction == -1 else false
		
		dazedTimer -= 1
		velocity.x = 0
	else:
		$StateShower.texture = null
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.speed_scale = 0.2
		
		# We saw a wall
		if ($Front.is_colliding() and $Front.get_collider().is_in_group("Terrain")):
			var origin = $Front.global_transform.origin
			var collision_point = $Front.get_collision_point()
			var distance = origin.distance_to(collision_point)
			
			# We don't want to turn immediately when we see a wall so...
			if distance <= 100:
				direction = -direction
				
				# Kind of hacky way to flip the enemy but oh well...
				scale.x *= -1
		velocity.x = direction * SPEED

	move_and_slide()
