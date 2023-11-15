extends CharacterBody2D

# Ability values, feel free to mess around with these
const SPEED = 400.0
const JUMP_VELOCITY = -900
const WALL_GRAVITY = 100
const PUSH_FORCE = 300
var WALL_VELOCITY = -900

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# State variables, don't touch
var wall_pushing = false
var was_wall_jumping = false

# Player Functions
func _physics_process(delta):

	var direction = Input.get_axis("Left", "Right") # Assign values to left and right (-1 = left, 0 = still, 1 = right)
	var is_wall_sliding = false # Refresh wall sliding
	var touching_wall = false # Refresh wall touching
	var touching_physics_object = false # Refresh phys. object check
	
	if $RayLeft.is_colliding() or $RayRight.is_colliding(): # Is player touching wall ? Uses short length rays
		touching_wall = true
		if $RayRight.get_collider() != null and $RayRight.get_collider().is_in_group("PhysicsObjects"):
			touching_physics_object = true
		if $RayLeft.get_collider() != null and $RayLeft.get_collider().is_in_group("PhysicsObjects"):
			touching_physics_object = true

	if not is_on_floor():
		velocity.y += gravity * delta # Applies gravity
	else: # Resets values upon landing
		WALL_VELOCITY = -900
		was_wall_jumping = false

	if direction:
		velocity.x = move_toward(velocity.x, direction * SPEED, 50) # Get input direction and increase velocity accordingly, used for x-axis movement
	else: 
		velocity.x = move_toward(velocity.x, 0, 50) # Slow down after movement key released
	
	if direction and velocity.y > 0 and touching_wall: # Allows player to wall slide
		velocity.y = min(velocity.y, WALL_GRAVITY) # Slows descent while wall sliding
		$Sprite2D.animation = "Sliding"
		is_wall_sliding = true # Used to interupt animations
		
	# Allows the player to wall jump
	if Input.is_action_just_pressed("Jump"):
		if touching_wall and not is_on_floor(): # Allows player to wall jump
			was_wall_jumping = true
			$Sprite2D.animation = "Wall Jumping"
			velocity.y = WALL_VELOCITY
			velocity.x = get_wall_normal()[0] * SPEED * 1.5
			WALL_VELOCITY += 50 # Nerf each jump by x amount..
		if is_on_floor(): # Allows player to jump
			velocity.y = JUMP_VELOCITY
	
	if Input.is_action_just_released("Jump") and velocity.y < 0 and not was_wall_jumping:
		velocity.y = move_toward(velocity.y, 0, -velocity.y * 0.5)
	
	if Input.is_action_pressed("Down"): # Allows player to drop through one way platforms
		if $RayDown.get_collider() != null and $RayDown.get_collider().is_in_group("OneWayCollisions") and direction == 0: # Player needs to be still in order to avoid animation slide bug
			position.y += 1
	
	for i in get_slide_collision_count(): # Allows for pushing of physics objects
		var collisions = get_slide_collision(i)
		if Input.is_action_pressed("Interact") and touching_physics_object and collisions.get_collider().is_in_group("PhysicsObjects"):
			collisions.get_collider().apply_central_impulse(-collisions.get_normal() * PUSH_FORCE)

	if velocity.y > 10000: # For debugging, gets player unstuck
		velocity.y = JUMP_VELOCITY

	if Input.is_action_just_pressed("Quit"): # Quits game
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
		
	print(velocity.x)
		
	move_and_slide()
