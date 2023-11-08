# Paul made this code
# Add any contributors below

extends Control

@onready var ButtonSound = $"Main Menu/SFX/ButtonSound"
@onready var ButtonSoundHover = $"Main Menu/SFX/ButtonSound_Hover"

func playButtonSound(type : String = "press") -> void:
	if type == "press":
		ButtonSound.play()
		await ButtonSound.finished
	elif type == "hover":
		ButtonSoundHover.play()
		await ButtonSoundHover.finished
	# AudioStream doesn't wait for sound to finish so we have to do it ourselves

func quitGame() -> void:
	playButtonSound()
	await ButtonSound.finished
	get_tree().quit(0)

func startGame() -> void:
	playButtonSound()
	SceneTransition.change_scene("res://Scenes/game.tscn", "wipe")

func playHoverSound() -> void:
	playButtonSound("hover")

func scrollOptions() -> void:
	$AnimationPlayer.play("scrollOptions")

func scrollMenu() -> void:
	$AnimationPlayer.play_backwards("scrollOptions")
