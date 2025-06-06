extends Control

@onready var menu = $MenuComponent
@onready var color_rect = $Panel/MarginContainer2/ColorRect
@onready var color_label = $Panel/MarginContainer2/ColorRect/Label
@onready var countdown_label = $Panel/MarginContainer2/Timer/CountdownLabel
@onready var exit_button: Button = $Panel/MarginContainer2/ExitButton
@onready var next_button: Button = $Panel/MarginContainer2/NextButton

# if you want to add more color add here
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

# Timer variables
var countdown = 30.0  # Initial countdown time (in seconds)
var waiting_for_next = false


func _ready():
	show_random_color()

# Called every frame
func _process(delta):
	if not waiting_for_next:
		countdown -= delta  # Decrease countdown by frame time
		if countdown <= 0:
			countdown = 0  # Prevent negative countdown
			countdown_label.text = "Time left: 0s"
			waiting_for_next = true  # Wait for player to press "Next"
			next_button.visible = true  # Show the "Next" button
			return
		# Update countdown label
		countdown_label.text = "Time left: " + str(int(ceil(countdown))) + "s"

# Function to show a random color and its name
func show_random_color():
	var random_color = colors[randi() % colors.size()]  # Choose random color from the list
	color_rect.color = random_color["color"] 
	color_label.text = random_color["name"] 

	countdown = 30.0 
	waiting_for_next = false  # Allow timer to run again
	next_button.visible = false


func _on_next_button_pressed():
	show_random_color()  # Show another random color


func _on_exit_button_pressed():
	get_tree().quit()  # Close the game


func _on_menu_pressed() -> void:
	print("press")
	menu.show()
