extends Node

@onready var balloon_image: TextureRect = $BalloonImage
@onready var color_label = $BalloonImage/Label
@onready var countdown_label = $Panel/MarginContainer2/Timer/CountdownLabel
@onready var exit_button: Button = $Panel/MarginContainer2/ExitButton
@onready var next_button: Button = $Panel/MarginContainer2/NextButton
@onready var score_label: Label = $Panel/MarginContainer2/ScoreLabel  
@onready var menu_button: Button = $Panel/MarginContainer2/MenuButton
@onready var margin_container: MarginContainer = $Menu/Menu/MarginContainer
@onready var menu: Control = $Menu/Menu
@onready var score_popup: PopupPanel = $ScorePopup
@onready var final_score_label: Label = $ScorePopup/FinalScoreLabel
#@onready var finish_button: Button = $ScorePopup/FinishButton
@onready var click_sound: AudioStreamPlayer2D = $Click_sound

var next_press_count = 0
var paused = false

# Balloon data (filename + name)
var balloons = [
	{"name": "Purple", "path": "res://Game/Color-Hunt/ui/Purple2_Baloon.PNG"},
	{"name": "Yellow", "path": "res://Game/Color-Hunt/ui/Yellow2_Baloon.PNG"},
	{"name": "Green", "path": "res://Game/Color-Hunt/ui/Green_Baloon.PNG"},
	{"name": "Blue", "path": "res://Game/Color-Hunt/ui/Blue_Baloon..PNG"},
	{"name": "Red", "path": "res://Game/Color-Hunt/ui/Red_Baloon.PNG"},
	{"name": "Orange", "path": "res://Game/Color-Hunt/ui/Orange_Baloon.PNG.PNG"},
	{"name": "Pink", "path": "res://Game/Color-Hunt/ui/Pink_Baloon.PNG"}

]

var countdown = 30.0
var waiting_for_next = false
var score = 0

func _ready():
	show_random_balloon()
	update_score_label()
	#finish_button.pressed.connect(_on_finish_button_pressed)
	
	globalGameData.resetData()
	globalGameData.currentGameID = 1

func _process(delta):	
	if not waiting_for_next:
		countdown -= delta
		if countdown <= 0:
			countdown = 0
			countdown_label.text = "Time left: 0s"
			waiting_for_next = true
			next_button.visible = true
			showGameOver()
			return
		countdown_label.text = "Time left: " + str(int(ceil(countdown))) + "s"

# Pick and display a random balloon
func show_random_balloon():
	var random_balloon = balloons[randi() % balloons.size()]
	balloon_image.texture = load(random_balloon["path"])
	color_label.text = random_balloon["name"]

	countdown = 30.0
	waiting_for_next = false
	next_button.visible = true

# When "Next" is pressed
func _on_next_button_pressed():
	if click_sound:  
		click_sound.play()
	score += 1000
	update_score_label()
	next_press_count += 1
	
	if next_press_count >= 20:
		showGameOver()
	else:
		show_random_balloon()

#region gameOverPopUP
@onready var game_over_component: PanelContainer = $GameOverComponent
func showGameOver():
	get_tree().paused = true
	game_over_component.show()
	var childrens = game_over_component.get_children()
	for child in childrens:
		if child.is_in_group("persist"):
			child.save()

func onTimeEnd():
	showGameOver()
#endregion

func update_score_label():
	score_label.text = "Score: " + str(score)
	globalGameData.currentGameScore = score

func show_score_popup():
	final_score_label.text = "Great job!\nYour final score is:\n" + str(score)
	score_popup.popup_centered()

func _on_finish_button_pressed():
	get_tree().reload_current_scene()

func _on_menu_button_pressed() -> void:
	get_tree().paused = true
	menu.visible = true
