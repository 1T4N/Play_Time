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
@onready var narrator = $AudioNarrator
@onready var feedback_audio = $AudioFeedback
@onready var menu: Control = $Menu/Menu
@onready var game_over_label: Label = $GameOverPopup/GameOverLabel  # Label that shows "Game Over"

# Game time in seconds
var game_duration = 60

# Items with fixed positions
var items_data = {
	"Apple": preload("res://Game/Letter-Sound-Hunt/ui/Apple.PNG"),
	"Kite": preload("res://Game/Letter-Sound-Hunt/ui/Kite.PNG"),
	"Pizza": preload("res://Game/Letter-Sound-Hunt/ui/Pizza.PNG"),
	"Slide": preload("res://Game/Letter-Sound-Hunt/ui/Slide.PNG"),
	"Tree": preload("res://Game/Letter-Sound-Hunt/ui/Tree1.PNG")
}

var target_word = ""
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
	get_tree().paused = false
	game_over_label.visible = false
	
	# Assign fixed textures to buttons (no shuffle)
	var keys = items_data.keys()
	for i in range(item_buttons.size()):
		var texture_rect = item_buttons[i].get_node("TextureRect")
		texture_rect.texture = items_data[keys[i]]
		texture_rect.pivot_offset = texture_rect.texture.get_size() / 2
		item_buttons[i].set_meta("name", keys[i])
	
	generate_round()

func generate_round():
	feedback_label.text = ""
	
	# Pick a random target word from fixed items
	var keys = items_data.keys()
	target_word = keys[randi() % keys.size()]
	
	var first_letter = target_word[0]
	instruction_label.text = "Find the item that starts with " + first_letter + "."

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
