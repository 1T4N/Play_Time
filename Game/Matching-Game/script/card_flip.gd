extends Control

@onready var grid = $GridContainer                        
@onready var help_popup = $PopUp/HelpPopup                
@onready var win_popup = $PopUp/WinPopUp                  

# Variables to keep track of selected cards and image resources
var selected_cards = []                               
var card_images = []                                      

# Called when the scene is loaded
func _ready():
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
		load("res://ui/chester.jpg"),
		load("res://ui/justine.png"),
		load("res://ui/sandaga.jpeg"),
		load("res://ui/sandaga.jpeg"),
		load("res://ui/sandaga.jpeg"),
		load("res://ui/sandaga.jpeg"),
		load("res://ui/sandaga.jpeg"),
		load("res://ui/sandaga.jpeg"),
		load("res://ui/sandaga.jpeg"),
		load("res://ui/sandaga.jpeg"),
		load("res://ui/sandaga.jpeg"),
		load("res://ui/sandaga.jpeg")
	]

# Called when a card is pressed
func _on_card_pressed(card):
# Ignore the card if already flipped, matched, or two cards are already selected
	if card.is_flipped or card.is_matched or selected_cards.size() >= 2:
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
		card1.is_matched = true                  
		card2.is_matched = true
		
# Flip them back over if no match
	else:
		card1.flip()                            
		card2.flip()
		
# Reset selection
	selected_cards.clear()                      

	# Check if all cards are matched to show win popup
	if all_cards_matched():
		await get_tree().create_timer(0.5).timeout
		win_popup.popup_centered()              # Show the win popup

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


func _on_exit_button_pressed() -> void:
	get_tree().quit()
