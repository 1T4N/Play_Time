extends Control

@onready var instruction_label = $InstructionLabel
@onready var feedback_label = $FeedbackLabel
@onready var score_label = $ScoreLabel
@onready var timer_label = $GameTimer/TimerLabel
@onready var item_buttons = [
	$HBoxContainer/Item1,
	$HBoxContainer/Item2,
	$HBoxContainer/Item3,
	$HBoxContainer/Item4
]
@onready var narrator = $AudioNarrator
@onready var feedback_audio = $AudioFeedback
@onready var menu: Control = $Menu/Menu
#@onready var game_timer = $GameTimer
@onready var game_over_label: Label = $GameOverPopup/GameOverLabel  #Label that shows "Game Over"

# Game time in seconds
var game_duration = 60

var items_data = {
	"Ball": preload("res://Game/Letter-Sound-Hunt/ui/ball.png"),
	"Cat": preload("res://Game/Letter-Sound-Hunt/ui/cat.jpeg"),
	"Sun": preload("res://Game/Letter-Sound-Hunt/ui/sun.png"),
	"Dog": preload("res://Game/Letter-Sound-Hunt/ui/Poseiden-9-250x250.jpg")
}

var target_word = ""
var choices = []
var score = 0

func _ready():
	randomize()
	update_score_label()
	game_over_label.visible = false  # Make sure "Game Over" is hidden at start
	start_game()

func start_game():
	score = 0
	update_score_label()
	timer_label.text = "Time: " + str(game_duration)
	#game_timer.wait_time = game_duration
	#game_timer.start()
	get_tree().paused = false
	game_over_label.visible = false
	generate_round()

func generate_round():
	feedback_label.text = ""
	choices = items_data.keys().duplicate()
	choices.shuffle()
	choices = choices.slice(0, 4)
	target_word = choices[randi() % choices.size()]
	var first_letter = target_word[0]
	instruction_label.text = "Find the item that starts with " + first_letter + "."
	for i in range(3):
		var texture_rect = item_buttons[i].get_node("TextureRect")
		if items_data.has(choices[i]):
			texture_rect.texture = items_data[choices[i]]
			texture_rect.pivot_offset = texture_rect.texture.get_size() / 2
		item_buttons[i].set_meta("name", choices[i])

func _on_Item_pressed(button):
	var name = button.get_meta("name")
	if name == target_word:
		score += 1000
		update_score_label()
		feedback_label.text = name + " starts with " + name[0] + "!"
		feedback_audio.play()

		# Play animation on the clicked button's AnimationPlayer
		var local_anim_player = button.get_node("AnimationPlayer")
		if local_anim_player:
			local_anim_player.play("correct_pop")

		await get_tree().create_timer(1.0).timeout
		generate_round()
	else:
		feedback_label.text = "Try again!"

func update_score_label():
	globalGameData.currentGameScore = score
	score_label.text = "Score: " + str(score)

#func _process(delta):
	#if game_timer.is_stopped():
		#return
	#var remaining = int(game_timer.time_left)
	#timer_label.text = "Time: " + str(remaining)
	#if remaining <= 0:
		#game_over()

func game_over():
	#game_timer.stop()
	get_tree().paused = true
	game_over_label.visible = true  # Show only "Game Over" label

# Button presses
func _on_item_1_pressed(): _on_Item_pressed($HBoxContainer/Item1)
func _on_item_2_pressed(): _on_Item_pressed($HBoxContainer/Item2)
func _on_item_3_pressed(): _on_Item_pressed($HBoxContainer/Item3)
func _on_item_4_pressed(): _on_Item_pressed($HBoxContainer/Item4)

func _on_menu_button_pressed() -> void:
	get_tree().paused = true
	menu.visible = true

# Popup buttons
func _on_restart_pressed() -> void:
	get_tree().reload_current_scene()

func _on_quit_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://GameUI/scenes/Main_Screen.tscn")
