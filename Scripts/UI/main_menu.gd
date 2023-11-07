extends Control

@export var ButtonSound : AudioStreamPlayer

func _on_quit_button_pressed():
	ButtonSound.play() 
	await ButtonSound.finished # ButtonSound.play doesn't wait for sound to finish so we have to do it ourselves
	get_tree().quit(0)


func _on_start_button_pressed():
	ButtonSound.play()
	await ButtonSound.finished # ButtonSound.play doesn't wait for sound to finish so we have to do it ourselves
	SceneTransition.change_scene("res://Scenes/game.tscn", "wipe")
