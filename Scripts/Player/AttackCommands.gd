extends Object

class AttackCommand extends Node:
	var Player
	var TargetedGroup
	# the attack can set this to true if it wants to execute more than one cycle
	var Active = false
	
	func Initialize(targetedGroup : String):
		Player = get_parent()
		TargetedGroup = targetedGroup
	
	func Execute():
		pass

class BananaAttack extends AttackCommand:
	var BananaProjectileScript = preload("res://Scripts/Projectiles/BananaProjectile.gd")
	
	const SPEED = 300
	var lastInput = Time.get_unix_time_from_system()
	func Execute():
		
		if(Time.get_unix_time_from_system() - lastInput < 0.5):
			return
		
		var proj = BananaProjectileScript.new()
		add_child(proj)
		
		proj.Initialize(Vector2(Player.lookingAt,0), SPEED, 1)
		proj.global_position = Player.global_position
		
		lastInput = Time.get_unix_time_from_system()
		
 
