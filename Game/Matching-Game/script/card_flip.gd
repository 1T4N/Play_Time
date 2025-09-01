extends Control 

@onready var grid = $Panel/MarginContainer/GridContainer                
@onready var help_popup = $PopUp/HelpPopup                
@onready var win_popup = $PopUp/WinPopUp                  
@onready var score_label: Label = $Panel/MarginContainer/ScoreLabel             # Label to display the score
@onready var menu_button: Button = $Panel/MarginContainer/MenuButton
@onready var menu: Control = $menu/Menu
@onready var click_sound: AudioStreamPlayer2D = $click_sound
@onready var match_sound: AudioStreamPlayer2D = $match_sound

# Variables to keep track of selected cards and image resources
var selected_cards = []                               
var card_images = []                                      
var score = 0                                             #Score variable

# Called when the scene is loaded
func _ready():
	#this resets the data
	globalGameData.resetData()
	globalGameData.currentGameID = 2
	
	
	
	
	score = 0                                              #nitialize score
	score_label.text = "Score: 0"                          #et initial score display

	card_images = load_card_images()                       # Load the card images
	var all_images = card_images.duplicate()               # Duplicate the images to make pairs
	all_images += card_images
	all_images.shuffle()                                   # Shuffle the cards

	# Assign images to each card in the grid
	for i in range(grid.get_child_count()):
		var card = grid.get_child(i)
		card.set_image(all_images[i])                      # Set the image for the card
		card.connect("pressed", Callable(self, "_on_card_pressed").bind(card))  # Connect card press signal

# add more image here copy and paste the load code then input the location of the image
func load_card_images():
	return [
		load("res://Game/Matching-Game/ui/Fruits_New/Apple.PNG"),
		load("res://Game/Matching-Game/ui/Fruits_New/Banana.PNG"), 
		load("res://Game/Matching-Game/ui/Fruits_New/Coconut.PNG"),
		load("res://Game/Matching-Game/ui/Fruits_New/Dalandan.PNG"),
		load("res://Game/Matching-Game/ui/Fruits_New/Kiwi.PNG"),  
		load("res://Game/Matching-Game/ui/Fruits_New/Lemon.PNG"), 
		load("res://Game/Matching-Game/ui/Fruits_New/Mango.PNG"),
		load("res://Game/Matching-Game/ui/Fruits_New/Melon.PNG"),
		load("res://Game/Matching-Game/ui/Fruits_New/Strawberry.PNG")
	]

# Called when a card is pressed
func _on_card_pressed(card):
	if click_sound:
		click_sound.play()
	# Ignore the card if already flipped, matched, flipping, or two cards are already selected
	if card.is_flipped or card.is_matched or card.flipping or selected_cards.size() >= 2:  # New: prevent interrupting animation
		return
		
	# Flip the card to show the image
	card.flip()                              
	selected_cards.append(card)

	# If two cards are selected, wait and check for match
	if selected_cards.size() == 2:
		await get_tree().create_timer(1.0).timeout
		check_match()

# Check if the two selected cards match
func check_match():
	var card1 = selected_cards[0]
	var card2 = selected_cards[1]
	
	# Mark both cards as matched
	if card1.image_texture == card2.image_texture:
		if match_sound:
			match_sound.play()
		card1.is_matched = true                  
		card2.is_matched = true

		#Increase score and update display
		score += 1000
		globalGameData.currentGameScore = score
		score_label.text = "Score: " + str(score)
		
	# Flip them back over if no match
	else:
		card1.flip()                            
		card2.flip()
		
	# Reset selection
	selected_cards.clear()                      

	# Check if all cards are matched to show win popup
	if all_cards_matched():
		await get_tree().create_timer(0.5).timeout
		#win_popup.popup_centered()              # Show the win popup
		#gameover
		showGameOver()

#region gameOverPopUP - fylart
@onready var game_over_component: PanelContainer = $GameOverComponent
func showGameOver():
	get_tree().paused = true
	game_over_component.show()
	var childrens = game_over_component.get_children()
	for child in childrens:
		if child.is_in_group("persist"):
			child.save()
#you need to call this function after adding it 
#endregion

# Checks if all cards in the grid are matched
func all_cards_matched() -> bool:
	for card in grid.get_children():
		if not card.is_matched:
			return false
	return true
	

# Show help instructions popup
func _on_help_button_pressed() -> void:
	help_popup.popup_centered()

# Reloads the current scene
func _on_restart_button_pressed() -> void:
	get_tree().reload_current_scene()


func _on_menu_button_pressed() -> void:
	get_tree().paused = true
	menu.visible = true


func _on_menu_exit_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://GameUI/scenes/Main_Screen.tscn")

@onready var timer: Timer = $Timer
@onready var time_label: Label = $TimeLabel


func _process(delta: float) -> void:
	time_label.text = str(int(timer.get_time_left()))
	#print(timer.get_time_left())



func _on_timer_timeout() -> void:
	showGameOver()
	pass # Replace with function body.
