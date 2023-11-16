extends Object

# A base Attack object, we are putting attacks into objects to easily
# replace them with a simple declaration. To create an attack we
# simply need to load this script and call the new() method

class AttackCommand extends Node:
	# base variables
	var Player
	# the group the want the attack to target, this way if we later
	# plan to create a same attack system for enemies we can easily re-accomodate
	# the code
	var TargetedGroup
	# Set to true if the attack should execute for more than one cycle
	# in _Process methods
	var Active = false
	
	# NOTE: The object expects to be added as a child of the player
	# before even calling the Initialize method.
	func Initialize(targetedGroup : String):
		Player = get_parent()
		TargetedGroup = targetedGroup
	
	func Execute():
		pass


# A test attack, if an attack wants to change animation or manipulate the player's children, the 
# object can easily specify more parameters in its Initialize method
class BananaAttack extends AttackCommand:
	# Needed to create new instances of our projectile
	var BananaProjectileScript = preload("res://Scripts/Projectiles/BananaProjectile.gd")
	
	const SPEED = 300
	var lastInput = Time.get_unix_time_from_system()
	
	func Execute():
		
		# Easy cooldown system that doesnt requires a Timer
		if(Time.get_unix_time_from_system() - lastInput < 0.5):
			return
		
		var proj = BananaProjectileScript.new()
		# The node cannot do anything if not added as a child
		add_child(proj)
		
		proj.Initialize(Vector2(Player.lookingAt,0), SPEED, 1)
		proj.global_position = Player.global_position
		
		lastInput = Time.get_unix_time_from_system()
		
 
