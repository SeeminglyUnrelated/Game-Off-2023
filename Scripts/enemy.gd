extends CharacterBody2D

const SPEED = 200.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction = 1

enum MODES
{
	neutral,
	alert
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
		
	if mode == MODES.alert:
		velocity.x = direction * SPEED
	else:
		# We hit a wall
		if $Front.is_colliding() and $Front.get_collider().is_in_group("Terrain"):
			direction = -direction
			
	print(direction)

	move_and_slide()
