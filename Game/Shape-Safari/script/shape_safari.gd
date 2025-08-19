extends Control 

@onready var instruction_label = $Panel/InstructionLabel
@onready var feedback_label = $Panel/FeedbackLabel
@onready var clapping: AudioStreamPlayer2D = $Clapping
@onready var shape1: Button = $Shape/Shape1
@onready var shape2: Button = $Shape/Shape2
@onready var shape3: Button = $Shape/Shape3
@onready var menu_button: Control = $Panel/MenuButton
@onready var menu: Control = $menu/Menu
@onready var score_label = $Panel/ScoreLabel
@onready var animation_player: AnimationPlayer = $AnimationPlayer
#@onready var game_timer: Timer = $Timer/GameTimer
#@onready var timer_label: Label = $Timer/TimerLabel
@onready var game_over_label: Label = $GameOverLabel

var score: int = 0
var shape_textures = {}
var target_shape = ""
var shapes = ["Circle", "Square", "Triangle"]
var time_left: int = 60  # seconds to play

func _ready():
	shape_textures = {
		"Circle": shape1.get_node("ShapeImage").texture,
		"Square": shape2.get_node("ShapeImage").texture,
		"Triangle": shape3.get_node("ShapeImage").texture
	}
	
	assign_shapes()
	show_instruction()
	score = 0
	update_score()
	
	## Setup timer
	#time_left = 60  # or whatever starting time you want
	#timer_label.text = "Timer: " + str(time_left)  # <-- set immediately at start
	#game_timer.wait_time = 1.0
	#game_timer.start()

func assign_shapes():
	shapes.shuffle()
	set_animal_shape(shape1, shapes[0])
	set_animal_shape(shape2, shapes[1])
	set_animal_shape(shape3, shapes[2])
	target_shape = shapes[randi() % 3]

func set_animal_shape(animal: Button, shape_name: String):
	var texture_rect = animal.get_node("ShapeImage")
	texture_rect.texture = shape_textures[shape_name]
	animal.set_meta("shape_name", shape_name)

func show_instruction():
	instruction_label.text = "Find the " + target_shape + "!"
	feedback_label.text = ""

func _on_shape_1_pressed() -> void:
	check_match(shape1)

func _on_shape_2_pressed() -> void:
	check_match(shape2)

func _on_shape_3_pressed() -> void:
	check_match(shape3)

func check_match(animal: Button):
	if animal.get_meta("shape_name") == target_shape:
		feedback_label.text = "You found the " + target_shape + "!"
		clapping.play()
		
		# Animate clicked shape
		animation_player.stop()
		animation_player.assigned_animation = "correct_pop"
		animation_player.root_node = animal.get_path()
		animation_player.play("correct_pop")
		
		score += 1000
		update_score()
		
		await get_tree().create_timer(1.5).timeout
		assign_shapes()
		show_instruction()
	else:
		feedback_label.text = "Try again!"

func update_score():
	globalGameData.currentGameScore = score
	score_label.text = "Score: " + str(score)

#func _on_game_timer_timeout():
	#time_left -= 1
	#timer_label.text = "Timer: " + str(time_left)
	#
	#if time_left <= 0:
		#game_timer.stop()
		#game_over_label.visible = true

func _on_menu_button_pressed() -> void:
	get_tree().paused = true
	menu.visible = true
