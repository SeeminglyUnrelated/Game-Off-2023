extends CharacterBody2D

const SPEED = 400.0
const JUMP_VELOCITY = -900
const WALL_GRAVITY = 100
const PUSH_FORCE = 300

var WALL_VELOCITY = -900

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var wall_pushing = false
var was_wall_jumping = false

# Player Functions
func _physics_process(delta):

	# Assign values to left and right
	var direction = Input.get_axis("Left", "Right")
	
	# Makes gravity take effect
	if not is_on_floor():
		velocity.y += gravity * delta

	# Allows player to jump
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration
	if direction and not wall_pushing:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	# Allows player to drop through one way platforms
	if Input.is_action_pressed("Down") and $RayDown.get_collider() != null and $RayDown.get_collider().is_in_group("OneWayCollisions"):
		position.y += 1
	
	# Allows the player to wall slide
	var is_wall_sliding = false

	if velocity.y > 0:
		if Input.is_action_pressed("Left") and $RayLeft.is_colliding():
			is_wall_sliding = true
	
		elif Input.is_action_pressed("Right") and $RayRight.is_colliding():
			is_wall_sliding = true
	
	if is_wall_sliding:
		velocity.y += WALL_GRAVITY
		velocity.y = min(velocity.y, WALL_GRAVITY)
		$Sprite2D.animation = "Sliding"
	
	# Allows the player to wall jump
	if Input.is_action_just_pressed("Jump") and $RayLeft.is_colliding() and not is_on_floor()  or Input.is_action_just_pressed("Jump") and $RayRight.is_colliding() and not is_on_floor():
			wall_pushing = true
			was_wall_jumping = true
			$Sprite2D.animation = "Wall Jumping"
			velocity.y = WALL_VELOCITY
			if $RayLeft.is_colliding():	
				velocity.x = SPEED * 4.5
			if $RayRight.is_colliding():
				velocity.x = -SPEED * 4.5
			WALL_VELOCITY += 50 # Nerf each jump by x amount..
			await get_tree().create_timer(0.05).timeout # This stinks! But it will work for now
			wall_pushing = false
	
	# Reset values upon landing
	if is_on_floor():
		WALL_VELOCITY = -900
		was_wall_jumping = false
	
	# Allows for pushing of physics objects
	for i in get_slide_collision_count():
		var collisions = get_slide_collision(i)
		if Input.is_action_pressed("Interact") and $RayRight.get_collider() != null and $RayRight.get_collider().is_in_group("PhysicsObjects") and collisions.get_collider().is_in_group("PhysicsObjects"):
			collisions.get_collider().apply_central_impulse(-collisions.get_normal() * PUSH_FORCE)
		if Input.is_action_pressed("Interact") and $RayLeft.get_collider() != null and $RayLeft.get_collider().is_in_group("PhysicsObjects") and collisions.get_collider().is_in_group("PhysicsObjects"):
			collisions.get_collider().apply_central_impulse(-collisions.get_normal() * PUSH_FORCE)
	
	# Quits game
	if Input.is_action_just_pressed("Quit"):
		get_tree().quit()
	
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
