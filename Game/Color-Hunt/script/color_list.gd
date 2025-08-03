extends Node

@onready var color_rect = $Panel/MarginContainer2/ColorRect
@onready var color_label = $Panel/MarginContainer2/ColorRect/Label
@onready var countdown_label = $Panel/MarginContainer2/Timer/CountdownLabel
@onready var exit_button: Button = $Panel/MarginContainer2/ExitButton
@onready var next_button: Button = $Panel/MarginContainer2/NextButton
@onready var score_label: Label = $Panel/MarginContainer2/ScoreLabel  
@onready var menu_button: Button = $Panel/MarginContainer2/MenuButton
@onready var margin_container: MarginContainer = $Menu/MarginContainer
@onready var menu: Control = $Menu/Menu
@onready var score_popup: PopupPanel = $ScorePopup							# new popup node
@onready var final_score_label: Label = $ScorePopup/FinalScoreLabel		# label inside popup
@onready var finish_button: Button = $ScorePopup/FinishButton				# finish button inside popup

var next_press_count = 0
var paused = false

#Add more color here if you need more color
var colors = [
	{"name": "Red", "color": Color.RED},
	{"name": "Green", "color": Color.GREEN},
	{"name": "Blue", "color": Color.BLUE},
	{"name": "Yellow", "color": Color(1, 1, 0)},
	{"name": "Purple", "color": Color(0.5, 0, 0.5)},
	{"name": "Pink", "color": Color(1, 0.75, 0.8)},
	{"name": "Brown", "color": Color(0.6, 0.3, 0.1)},
	{"name": "Orange", "color": Color(1, 0.5, 0)},
	{"name": "White", "color": Color(1, 1, 1)},
	{"name": "Black", "color": Color(0, 0, 0)}
]

var countdown = 30.0						#here you can change the countdown
var waiting_for_next = false
var score = 0  # default score

func _ready():
	show_random_color()
	update_score_label()
	finish_button.pressed.connect(_on_finish_button_pressed)	# connect button handler

func _process(delta):	
	if not waiting_for_next:
		countdown -= delta
		if countdown <= 0:
			countdown = 0
			countdown_label.text = "Time left: 0s"
			waiting_for_next = true
			next_button.visible = true
			return
		countdown_label.text = "Time left: " + str(int(ceil(countdown))) + "s"
	

# Pick and display a random color
func show_random_color():
	var random_color = colors[randi() % colors.size()]
	color_rect.color = random_color["color"]
	color_label.text = random_color["name"]

	countdown = 30.0
	waiting_for_next = false
	next_button.visible = true

# When "Next" is pressed   #Add 1000 points for each correct by pressing NEXT 
func _on_next_button_pressed():
	score += 1000
	update_score_label()
	next_press_count += 1
	
	if next_press_count >= 20:
		next_button.visible = false
		show_score_popup()
	else:
		show_random_color()

func update_score_label():
	score_label.text = "Score: " + str(score)

func show_score_popup():					# New function to display score
	final_score_label.text = "Great job!\nYour final score is:\n" + str(score)
	score_popup.popup_centered()

func _on_finish_button_pressed():			# Called when Finish is pressed
	get_tree().reload_current_scene()

func _on_menu_button_pressed() -> void:
	get_tree().paused = true
	menu.visible = true
