extends Control
func _ready() -> void:
	#this resets the data
	globalGameData.resetData()
	globalGameData.currentGameID = 0
	globalGameData.connect("retry",playError)

@onready var error_sfx: AudioStreamPlayer = $errorSFX
@onready var cardSFX: AudioStreamPlayer = $cardSFX
@onready var correctSFX: AudioStreamPlayer = $correctSFX

func playCardSFX():
	cardSFX.play()	
func playCorrectSFX():
	correctSFX.play()
func playError():
	error_sfx.play()
	

@onready var music: AudioStreamPlayer = $music

func _on_music_finished() -> void:
	music.play()
