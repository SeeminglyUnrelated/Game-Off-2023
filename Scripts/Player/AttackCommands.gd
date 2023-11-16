extends Object

# An the base Attack object, we are putting attacks into objects to easily
# replace the attacks with a simple declaration. To create an attack we
# simply need to load this script and call the new() method
class AttackCommand extends Node:
	# base variable
	# NOTE: The object expects the Player to add it as a child
	# before even calling the Initialize method.
	var Player
	# the group the want the attack to target, this way if we later
	# plan to create a same attack system for enemies we can easily re-accomodate
	# the code
	var TargetedGroup
	# the attack can set this to true if it wants to execute more than one cycle
	# in _Process for instance
	var Active = false
	
	func Initialize(targetedGroup : String):
		Player = get_parent()
		TargetedGroup = targetedGroup
	
	func Execute():
		pass


# a test attack, if an attack wants to change animation or childs of the player, the 
# object can easily specify more parameters in its Initialize method
class BananaAttack extends AttackCommand:
	# needed to create new instances of our projectile
	var BananaProjectileScript = preload("res://Scripts/Projectiles/BananaProjectile.gd")
	
	const SPEED = 300
	var lastInput = Time.get_unix_time_from_system()
	func Execute():
		
		# easy cooldown system that doesnt requires a Timer
		if(Time.get_unix_time_from_system() - lastInput < 0.5):
			return
		
		var proj = BananaProjectileScript.new()
		# the node cannot do anything if not added as a child
		add_child(proj)
		
		proj.Initialize(Vector2(Player.lookingAt,0), SPEED, 1)
		proj.global_position = Player.global_position
		
		lastInput = Time.get_unix_time_from_system()
		
 
