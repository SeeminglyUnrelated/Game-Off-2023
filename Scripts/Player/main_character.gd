extends CharacterBody2D

const SPEED = 400.0
const JUMP_VELOCITY = -800.0
const WALL_GRAVITY = 100
const WALL_JUMP = -800
const ACCELERATION_INCREMENTATION = 0.05

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var wall_pushing = false

var acceleration = 0.20

var lastdir = 1
#Player Functions
func _physics_process(delta):
	
	var is_wall_sliding = false
	
	#Animation
	if (velocity.x > 1 || velocity.x < -1):
		$Sprite2D.animation = "Running"
	else:
		$Sprite2D.animation = "Idle"

	#Allows player to drop through the platforms
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if Input.is_action_pressed("Down") and collision.get_collider().is_in_group("OneWayCollisions"):
			position.y += 1
		
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		$Sprite2D.animation = "Jumping"

	# Allows player to jump
	if Input.is_action_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	#Quits game
	if Input.is_action_just_pressed("Quit"):
		get_tree().quit()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions
	
	if velocity.x > 0:
		$Sprite2D.flip_h = false
	if velocity.x < 0:
		$Sprite2D.flip_h = true
	

	var direction = Input.get_axis("Left", "Right")
	
	if direction and not wall_pushing:
		if acceleration < 1:
			acceleration += ACCELERATION_INCREMENTATION
		if direction != lastdir:
			acceleration = 0.20
		velocity.x = direction * SPEED * acceleration
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	# Allows the player to wall slide (some parts taken from https://www.youtube.com/watch?v=5FWzWrK6jLM)

	if is_on_wall_only() and velocity.y > 0:
		if Input.is_action_pressed("Left"):
			is_wall_sliding = true
			$Sprite2D.flip_h = true
			
		elif Input.is_action_pressed("Right"):
			is_wall_sliding = true
			$Sprite2D.flip_h = false
	
	if is_wall_sliding:
		velocity.y += WALL_GRAVITY
		velocity.y = min(velocity.y, WALL_GRAVITY)
		$Sprite2D.animation = "Sliding"

	# Allows the player to wall jump.

	if Input.is_action_just_pressed("Jump") and is_wall_sliding:
		wall_pushing = true
		velocity.y = JUMP_VELOCITY
		velocity.x = move_toward(velocity.x, -direction * SPEED*3, SPEED)
		#await get_tree().create_timer(0.5).timeout
		wall_pushing = false
	
	print(velocity.x)
	
	lastdir = direction
	move_and_slide()
