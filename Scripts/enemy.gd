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

var mode = MODES.neutral

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
	#	velocity.y = JUMP_VELOCITY

	# Set mode to alert
	if ($Front.is_colliding() and $Front.get_collider().is_in_group("Player")):
		mode = MODES.alert
	else: mode = MODES.neutral
		
	if mode == MODES.alert:
		velocity.x = direction * (SPEED * 1.5) # Go a little faster when found player
		$StateShower.texture = Sprite_Alerted
	else:
		# We hit a wall
		if ($Front.is_colliding() and $Front.get_collider().is_in_group("Terrain")):
			var origin = $Front.global_transform.origin
			var collision_point = $Front.get_collision_point()
			var distance = origin.distance_to(collision_point)
			
			# We don't want to turn immediately when we see a wall so...
			if distance <= 100:
				direction = -direction
				scale.x *= -1
		velocity.x = direction * SPEED
			
	print(direction)

	move_and_slide()
