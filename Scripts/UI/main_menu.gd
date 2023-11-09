# Paul made this code
# Add any contributors below

extends Control

@onready var ButtonSound = $SFX/ButtonSound
@onready var ButtonSoundHover = $SFX/ButtonSound_Hover

func playButtonSound(type : String = "press") -> void:
	if type == "press":
		ButtonSound.play()
		await ButtonSound.finished
	elif type == "hover":
		ButtonSoundHover.play()
		await ButtonSoundHover.finished
	# AudioStream doesn't wait for sound to finish so we have to do it ourselves

func _on_quit_button_pressed() -> void:
	playButtonSound()
	await ButtonSound.finished
	get_tree().quit(0)

func _on_start_button_pressed() -> void:
	playButtonSound()
	SceneTransition.change_scene("res://Scenes/level1.tscn", "wipe")

func button_hovered():
	playButtonSound("hover")
