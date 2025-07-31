extends Control

@onready var instruction_label = $InstructionLabel
@onready var feedback_label = $FeedbackLabel
@onready var clapping: AudioStreamPlayer2D = $Clapping

@onready var shape1: Button = $Shape/Shape1
@onready var shape2: Button = $Shape/Shape2
@onready var shape3: Button = $Shape/Shape3
@onready var menu: Control = $menu/Menu




var shape_data = {
	"Circle": preload("res://Game/Shape-Safari/ui/circle.png"),
	"Square": preload("res://Game/Shape-Safari/ui/icon.svg"),
	"Triangle": preload("res://Game/Shape-Safari/ui/triangle.png")
}

var target_shape = ""
var shapes = ["Circle", "Square", "Triangle"]

func _ready():
	assign_shapes()
	show_instruction()

# Assigns a random shape to each animal
func assign_shapes():
	shapes.shuffle()
	set_animal_shape(shape1, shapes[0])
	set_animal_shape(shape2, shapes[1])
	set_animal_shape(shape3, shapes[2])
	target_shape = shapes[randi() % 3]  # Choose one of the 3 as the target

# Helper to assign the image and meta data
func set_animal_shape(animal: Button, shape_name: String):
	var texture_rect = animal.get_node("ShapeImage")
	texture_rect.texture = shape_data[shape_name]
	animal.set_meta("shape_name", shape_name)

# Displays the current instruction text
func show_instruction():
	instruction_label.text = "Find the " + target_shape + "!"
	feedback_label.text = ""  # Clear any previous feedback

# Handle clicks on animals
func _on_shape_1_pressed() -> void:
	check_match(shape1)


func _on_shape_2_pressed() -> void:
	check_match(shape2)


func _on_shape_3_pressed() -> void:
	check_match(shape3)

# Check if the clicked animal matches the target
func check_match(animal: Button):
	if animal.get_meta("shape_name") == target_shape:
		feedback_label.text = "You found the " + target_shape + "!"
		clapping.play()  # New: Play clapping sound
		await get_tree().create_timer(1.5).timeout
		assign_shapes()
		show_instruction()
	else:
		feedback_label.text = "Try again!"


func _on_menu_button_pressed() -> void:
	get_tree().paused = true
	menu.visible = true
