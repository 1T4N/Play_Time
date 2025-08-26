extends Control
@export var snap_distance: float = 48.0
@onready var ui_congrats = $CanvasLayer/CongratsLabel
@onready var targets = $Targets 
@onready var pieces_container = $Pieces
@onready var score_label = $CanvasLayer/ScoreLabel
@onready var menu_button: Button = $MarginContainer/MenuButton
@onready var menu: Control = $Menu
@onready var timer_label = $Timer/TimerLabel
@onready var game_timer:Timer = $Timer/GameTimer


var score: int = 0                                      
var time_left: int

# Points for each shape type
var shape_points = {
	"Square": 500,
	"Triangle": 1000,
	"Circle": 1500
}

# Called when the scene is ready
func _ready():
	ui_congrats.visible = false           
	update_score_label()                  


# Attempts to place a piece on its matching target
func try_place_piece(piece):
	for target in targets.get_children():
		if not target.has_method("is_vacant"):
			continue
			
		# Skip if target is already occupied
		if not target.is_vacant():
			continue
			
		# If IDs match and piece is close enough, snap it into place
		if target.required_id == piece.piece_id and piece.global_position.distance_to(target.global_position) <= snap_distance:
			piece.snap_to(target.global_position)
			target.occupy(piece)
			_add_score(piece.points)
			_check_completion()
			return

	piece.reset_position()

func _add_score(points: int):
	score += points
	update_score_label()

func update_score_label():
	globalGameData.currentGameScore = score
	score_label.text = "Score: " + str(score)

@onready var timer: Control = $Timer

# Checks if all targets are filled
func _check_completion():
	for target in targets.get_children():
		if target.has_method("is_vacant") and target.is_vacant():
			return  

	timer.showGameOver()
	#ui_congrats.visible = true
	#game_timer.stop()


func _on_menu_button_pressed() -> void:
	get_tree().paused = true   
	game_timer.stop()         
	menu.visible = true       


func _on_menu_exit_button_pressed() -> void:
	get_tree().paused = false  
	game_timer.start()         
	menu.visible = false       



							
