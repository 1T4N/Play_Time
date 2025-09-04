extends Control 

@onready var instruction_label = $Panel/InstructionLabel  
@onready var feedback_label = $Panel/FeedbackLabel        
@onready var clapping: AudioStreamPlayer2D = $Clapping     
@onready var shape1: Button = $Shape/HBoxContainer/Shape1  
@onready var shape2: Button = $Shape/HBoxContainer/Shape2  
@onready var shape3: Button = $Shape/HBoxContainer/Shape3  
@onready var menu_button: Control = $Panel/MenuButton     
@onready var menu: Control = $menu/Menu                  
@onready var score_label = $Panel/ScoreLabel               
@onready var animation_player: AnimationPlayer = $AnimationPlayer 
@onready var game_over_label: Label = $GameOverLabel       
@onready var click_sound: AudioStreamPlayer2D = $ClickSound 
@onready var narrator: AudioStreamPlayer2D = $Narrator
@onready var wrong_sound: AudioStreamPlayer2D = $Wrong_sound
@onready var correct_sound: AudioStreamPlayer2D = $CorrectSound
@onready var wrong_click: AudioStreamPlayer2D = $wrong_click


var score: int = 0
var shape_textures = {}
var target_shape = "" 
var shapes = ["Circle", "Square", "Triangle"]
var time_left: int = 60
var can_click: bool = true

# Shape Narrator audio
var shape_sounds = {
	"Circle": preload("res://Game/Shape-Safari/sound/circle_sound.mp3"),
	"Square": preload("res://Game/Shape-Safari/sound/squire_sound.mp3"),
	"Triangle": preload("res://Game/Shape-Safari/sound/triangle.mp3")
}

func _ready():
	globalGameData.resetData()
	#change the number base on the game
	globalGameData.currentGameID = 4
	
	
	# Assign textures to each shape type from the scene
	shape_textures = {
		"Circle": shape1.get_node("ShapeImage").texture,
		"Square": shape2.get_node("ShapeImage").texture,
		"Triangle": shape3.get_node("ShapeImage").texture
	}
	assign_shapes()
	show_instruction()
	score = 0
	update_score()


# Assign random shapes to the buttons 
func assign_shapes():
	shapes.shuffle() # Shuffle the shape order
	set_animal_shape(shape1, shapes[0])
	set_animal_shape(shape2, shapes[1])
	set_animal_shape(shape3, shapes[2])
	target_shape = shapes[randi() % 3]

func set_animal_shape(animal: Button, shape_name: String):
	var texture_rect = animal.get_node("ShapeImage")
	texture_rect.texture = shape_textures[shape_name]
	texture_rect.pivot_offset = texture_rect.texture.get_size() / 2
	animal.set_meta("shape_name", shape_name)              # Store shape name

# Display instruction text + play narrator sound
func show_instruction():
	instruction_label.text = "Find the shape of " + target_shape + "!"
	feedback_label.text = ""

	# Play narrator sound for the target shape
	if shape_sounds.has(target_shape):
		narrator.stop()
		narrator.stream = shape_sounds[target_shape]
		narrator.play()

func _on_shape_1_pressed() -> void:
	if can_click: 
		click_sound.stop()
		click_sound.play()
		check_match(shape1)

func _on_shape_2_pressed() -> void:
	if can_click: 
		click_sound.stop()
		click_sound.play()
		check_match(shape2)

func _on_shape_3_pressed() -> void:
	if can_click: 
		click_sound.stop()
		click_sound.play()
		check_match(shape3)

# Check if the clicked shape matches
func check_match(animal: Button):
	can_click = false				# Block further clicks until feedback finishes

	if animal.get_meta("shape_name") == target_shape:
		feedback_label.text = "You found the " + target_shape + "!"
		clapping.play()
		correct_sound.play()
		
		
		# Play animation on the correct shape
		animation_player.stop()
		animation_player.assigned_animation = "correct_pop"
		animation_player.root_node = animal.get_path()
		animation_player.play("correct_pop")
		
		# Update score
		score += 1000
		update_score()
		
		# Wait before showing new shapes
		await get_tree().create_timer(1.5).timeout
		assign_shapes()
		show_instruction()
	else:
		feedback_label.text = "Try again!"
		wrong_sound.play()
		wrong_click.play()
	
	await get_tree().create_timer(0.5).timeout
	can_click = true

func update_score():
	globalGameData.currentGameScore = score
	score_label.text = "Score: " + str(score)

func _on_menu_button_pressed() -> void:
	get_tree().paused = true
	menu.visible = true
