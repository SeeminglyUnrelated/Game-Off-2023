extends CharacterBody2D

const SPEED = 400.0
const JUMP_VELOCITY = -900
const WALL_GRAVITY = 100
var WALL_VELOCITY = -900


var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var wall_pushing = false
var was_wall_jumping = false

#Player Functions
func _physics_process(delta):
	

	#Allows player to drop through the platforms
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if Input.is_action_pressed("Down") and collision.get_collider().is_in_group("OneWayCollisions"):
			position.y += 1
		
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	


	# Allows player to jump
	if Input.is_action_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	#Quits game
	if Input.is_action_just_pressed("Quit"):
		get_tree().quit()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions
	

	var direction = Input.get_axis("Left", "Right")
	if direction and not wall_pushing:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	# Allows the player to wall slide (some parts taken from https://www.youtube.com/watch?v=5FWzWrK6jLM)
	
	var is_wall_sliding = false

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

	if Input.is_action_just_pressed("Jump") and is_on_wall_only() and direction != 0:
		wall_pushing = true
		was_wall_jumping = true
		$Sprite2D.animation = "Wall Jumping"
		velocity.y = WALL_VELOCITY
		WALL_VELOCITY += 75 # Nerf each jump by x amount..
		velocity.x = -direction * SPEED * 4.5
		await get_tree().create_timer(0.05).timeout # This stinks! But it will work for now
		wall_pushing = false
		print(WALL_VELOCITY)
		
		
	if is_on_floor():
		WALL_VELOCITY = -900
		was_wall_jumping = false
		
		
	# - ANIMATIONS - #
	
	if (velocity.x > 1 || velocity.x < -1) and velocity.y == 0 and not was_wall_jumping:
		$Sprite2D.animation = "Running"
	if velocity.x == 0 and velocity.y == 0:
		$Sprite2D.animation = "Idle"
		
	if velocity.y < 0 and not was_wall_jumping:
		$Sprite2D.animation = "Jumping"
	if velocity.y > 0 and not is_wall_sliding:
		$Sprite2D.animation = "Falling"
		
	if velocity.x > 0:
		$Sprite2D.flip_h = false
	if velocity.x < 0:
		$Sprite2D.flip_h = true
		
	
	move_and_slide()
