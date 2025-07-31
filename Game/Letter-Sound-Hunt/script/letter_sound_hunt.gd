extends Control

@onready var instruction_label = $InstructionLabel
@onready var feedback_label = $FeedbackLabel
@onready var item_buttons = [
	$HBoxContainer/Item1,
	$HBoxContainer/Item2,
	$HBoxContainer/Item3,
	$HBoxContainer/Item4
]
@onready var narrator = $AudioNarrator
@onready var feedback_audio = $AudioFeedback
@onready var menu: Control = $Menu

var items_data = {
	"Ball": preload("res://Game/Letter-Sound-Hunt/ui/ball.png"),
	"Cat": preload("res://Game/Letter-Sound-Hunt/ui/cat.jpeg"),
	"Sun": preload("res://Game/Letter-Sound-Hunt/ui/sun.png"),
	"Plane": preload("res://Game/Letter-Sound-Hunt/ui/plane.jpg")
	
}

var target_word = ""
var choices = []

func _ready():
	randomize()
	generate_round()

func generate_round():
	#Reset the feedback label at the start of each round
	feedback_label.text = ""

	# Get shuffled item keys
	choices = items_data.keys().duplicate()
	choices.shuffle()

	# Take only the first 3
	choices = choices.slice(0, 3)
	target_word = choices[randi() % choices.size()]

	# Update instruction
	var first_letter = target_word[0]
	instruction_label.text = "Find the item that starts with " + first_letter + "."

	# Assign textures and metadata to each button
	for i in range(3):
		item_buttons[i].texture_normal = items_data[choices[i]]
		item_buttons[i].set_meta("name", choices[i])

func _on_Item_pressed(button):
	var name = button.get_meta("name")
	if name == target_word:
		feedback_label.text = name + " starts with " + name[0] + "!"
		feedback_audio.play()
		await get_tree().create_timer(2.0).timeout
		generate_round()
	else:
		feedback_label.text = "Try again!"

# Connect signals for each button
func _on_item_1_pressed(): _on_Item_pressed($HBoxContainer/Item1)
func _on_item_2_pressed(): _on_Item_pressed($HBoxContainer/Item2)
func _on_item_3_pressed(): _on_Item_pressed($HBoxContainer/Item3)


func _on_menu_button_pressed() -> void:
	get_tree().paused = true
	menu.visible = true
