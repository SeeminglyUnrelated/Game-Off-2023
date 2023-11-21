extends Object

# A base Attack object, we are putting attacks into objects to easily
# replace them with a simple declaration. To create an attack we
# simply need to load this script and call the new() method

class attack_command extends Node:
	# base variables
	var player
	# the group the want the attack to target, this way if we later
	# plan to create a same attack system for enemies we can easily re-accomodate
	# the code
	var targeted_group
	# Set to true if the attack should execute for more than one cycle
	# in _Process methods
	var active = false
	
	# NOTE: The object expects to be added as a child of the player
	# before even calling the Initialize method.
	func Initialize(targetedGroup : String):
		player = get_parent()
		targeted_group = targetedGroup
	
	func Execute():
		pass


# A test attack, if an attack wants to change animation or manipulate the player's children, the 
# object can easily specify more parameters in its Initialize method
class banana_attack extends attack_command:
	# Needed to create new instances of our projectile
	var banana_projectile_script = preload("res://Scripts/Projectiles/banana_projectile.gd")
	
	const SPEED = 300
	var last_input = Time.get_unix_time_from_system()
	
	func Execute():
		
		# Easy cooldown system that doesnt requires a Timer
		if(Time.get_unix_time_from_system() - last_input < 0.5):
			return
		
		var proj = banana_projectile_script.new()
		# The node cannot do anything if not added as a child
		add_child(proj)
		
		proj.Initialize(Vector2(player.looking_at,0), SPEED, 1)
		proj.global_position = player.global_position
		
		last_input = Time.get_unix_time_from_system()
		
 
