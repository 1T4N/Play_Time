extends Control

@onready var instruction_label = $InstructionLabel
@onready var feedback_label = $FeedbackLabel
@onready var score_label = $ScoreLabel
@onready var timer_label = $GameTimer/TimerLabel
@onready var item_buttons = [
	$Item1,
	$Item2,
	$Item3,
	$Item4,
	$Item5
]
@onready var narrator: AudioStreamPlayer2D = $AudioNarrator
@onready var feedback_audio: AudioStreamPlayer2D = $AudioFeedback
@onready var menu: Control = $menu/Menu
@onready var game_over_label: Label = $GameOverPopup/GameOverLabel
@onready var click_sound: AudioStreamPlayer2D = $click_sound
@onready var correct_sound: AudioStreamPlayer2D = $correct_sound
@onready var wrong_sound: AudioStreamPlayer2D = $wrong_sound


#var game_duration = 60

# Items with fixed positions
var items_data = {
	"Apple": preload("res://Game/Letter-Sound-Hunt/ui/Apple.PNG"),
	"Kite": preload("res://Game/Letter-Sound-Hunt/ui/Kite.PNG"),
	"Pizza": preload("res://Game/Letter-Sound-Hunt/ui/Pizza.PNG"),
	"Slide": preload("res://Game/Letter-Sound-Hunt/ui/Slide.PNG"),
	"Tree": preload("res://Game/Letter-Sound-Hunt/ui/Tree1.PNG")
}

# Narrator audio files
var narrator_audio = {
	"A": preload("res://Game/Letter-Sound-Hunt/sound/letter_A.mp3"),
	"K": preload("res://Game/Letter-Sound-Hunt/sound/letter_k.mp3"),
	"P": preload("res://Game/Letter-Sound-Hunt/sound/letter_P.mp3"),
	"S": preload("res://Game/Letter-Sound-Hunt/sound/letter_S.mp3"),
	"T": preload("res://Game/Letter-Sound-Hunt/sound/letter_T.mp3")
}

# Feedback audio files
var feedback_audio_dict = {
	"Apple": preload("res://Game/Letter-Sound-Hunt/sound/apple.mp3"),
	"Kite": preload("res://Game/Letter-Sound-Hunt/sound/kite.mp3"),
	"Pizza": preload("res://Game/Letter-Sound-Hunt/sound/pizza.mp3"),
	"Slide": preload("res://Game/Letter-Sound-Hunt/sound/slide.mp3"),
	"Tree": preload("res://Game/Letter-Sound-Hunt/sound/tree.mp3")
}

var target_word = ""
var score = 0
var input_locked = false  #Prevents clicking during narration/feedback

func _ready():
	globalGameData.resetData()
	#change the number base on the game
	globalGameData.currentGameID = 3
	
	randomize()
	update_score_label()
	game_over_label.visible = false
	


	narrator.finished.connect(_on_audio_finished)
	feedback_audio.finished.connect(_on_audio_finished)

	start_game()
	
	

func start_game():
	score = 0
	update_score_label()
	#timer_label.text = "Time: " + str(game_duration)
	get_tree().paused = false
	game_over_label.visible = false
	
	# Assign fixed textures to buttons (no shuffle)
	var keys = items_data.keys()
	for i in range(item_buttons.size()):
		var texture_rect = item_buttons[i].get_node("TextureRect")
		item_buttons[i].set_meta("name", keys[i])
	
	generate_round()

func generate_round():
	feedback_label.text = ""
	
	# Pick a random target word from fixed items
	var keys = items_data.keys()
	target_word = keys[randi() % keys.size()]
	
	var first_letter = target_word[0]
	instruction_label.text = "Find a picture starting with the letter " + first_letter + "."

	# 🎤 Play narrator voice if available
	if narrator_audio.has(first_letter):
		input_locked = true
		narrator.stream = narrator_audio[first_letter]
		narrator.play()

func _on_Item_pressed(button):
	if input_locked:  
		return  # 🚫 Ignore clicks until audio finishes

	click_sound.play()  # 🔊 play click sound every time button is pressed

	var name = button.get_meta("name")
	if name == target_word:
		score += 1000
		update_score_label()
		feedback_label.text = name + " starts with letter " + name[0] + "!"

		# 🔊 Play feedback audio for that specific item
		if feedback_audio_dict.has(name):
			input_locked = true
			feedback_audio.stream = feedback_audio_dict[name]
			feedback_audio.play()
			correct_sound.play()  # 🔊 correct sound

		# Play animation on the clicked button's AnimationPlayer
		var local_anim_player = button.get_node("AnimationPlayer")
		if local_anim_player:
			local_anim_player.play("correct_pop")
	else:
		feedback_label.text = "Try again!"
		wrong_sound.play()  # 🔊 wrong sound

func _on_audio_finished():
	# Unlock input if no audio is playing anymore
	if !narrator.playing and !feedback_audio.playing:
		input_locked = false
		# If feedback finished (correct answer), start next round
		if feedback_label.text != "" and "starts with" in feedback_label.text:
			await get_tree().create_timer(0.5).timeout
			generate_round()

func update_score_label():
	globalGameData.currentGameScore = score
	score_label.text = "Score: " + str(score)

func game_over():
	get_tree().paused = true
	game_over_label.visible = true  # Show only "Game Over" label

# Button presses
func _on_item_1_pressed(): _on_Item_pressed($Item1)
func _on_item_2_pressed(): _on_Item_pressed($Item2)
func _on_item_3_pressed(): _on_Item_pressed($Item3)
func _on_item_4_pressed(): _on_Item_pressed($Item4)
func _on_item_5_pressed(): _on_Item_pressed($Item5)

func _on_menu_button_pressed() -> void:
	get_tree().paused = true
	menu.visible = true

# Popup buttons
func _on_restart_pressed() -> void:
	get_tree().reload_current_scene()

func _on_quit_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://GameUI/scenes/Main_Screen.tscn")
