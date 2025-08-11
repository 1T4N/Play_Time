extends Control

@onready var instruction_label = $InstructionLabel
@onready var feedback_label = $FeedbackLabel
@onready var clapping: AudioStreamPlayer2D = $Clapping

@onready var shape1: Button = $Shape/Shape1
@onready var shape2: Button = $Shape/Shape2
@onready var shape3: Button = $Shape/Shape3
@onready var menu: Control = $menu/Menu

# We extract the 3 texture rects and their textures at runtime
var shape_textures = {}

var target_shape = ""
var shapes = ["Circle", "Square", "Triangle"]

func _ready():
	# Get the original textures from the scene (set manually in editor)
	shape_textures = {
		"Circle": shape1.get_node("ShapeImage").texture,
		"Square": shape2.get_node("ShapeImage").texture,
		"Triangle": shape3.get_node("ShapeImage").texture
	}
	assign_shapes()
	show_instruction()

# Assign random shape to each button
func assign_shapes():
	shapes.shuffle()
	set_animal_shape(shape1, shapes[0])
	set_animal_shape(shape2, shapes[1])
	set_animal_shape(shape3, shapes[2])
	target_shape = shapes[randi() % 3]

# Apply texture and metadata
func set_animal_shape(animal: Button, shape_name: String):
	var texture_rect = animal.get_node("ShapeImage")
	texture_rect.texture = shape_textures[shape_name]
	animal.set_meta("shape_name", shape_name)

# Show instruction
func show_instruction():
	instruction_label.text = "Find the " + target_shape + "!"
	feedback_label.text = ""

# Click handlers
func _on_shape_1_pressed() -> void:
	check_match(shape1)

func _on_shape_2_pressed() -> void:
	check_match(shape2)

func _on_shape_3_pressed() -> void:
	check_match(shape3)

# Check for match
func check_match(animal: Button):
	if animal.get_meta("shape_name") == target_shape:
		feedback_label.text = "You found the " + target_shape + "!"
		clapping.play()
		await get_tree().create_timer(1.5).timeout
		assign_shapes()
		show_instruction()
	else:
		feedback_label.text = "Try again!"

# Menu button
func _on_menu_button_pressed() -> void:
	get_tree().paused = true
	menu.visible = true
