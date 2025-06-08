extends Label
var childrens:Array
var childPointer:int = 0

func _ready() -> void:
	childrens = get_children(false)
	print(childrens)
	
	#this hides the progress bar sequencially so it cannot be operated or touch whilst 
	#the index is still not finished
	for child in childrens:
		child.hide()
		if child.orderID == childPointer:
			child.show()

func _process(_delta: float) -> void:
	#checks if part of the letter is already traced, then move to the next one to trace it
	for child in childrens:
		if child.orderID != childPointer:
			continue
		if child.finished == true:
			print("Next")
			child.set_process_mode(PROCESS_MODE_DISABLED)
			childPointer = childPointer + 1
			showNextTrace()

func showNextTrace():
	for child in childrens:
		if child.orderID != childPointer:
			continue
		child.show()
	
