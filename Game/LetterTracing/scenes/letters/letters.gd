extends Label
var childrens:Array
var childPointer:int = 0
var lastTracingOrder:int = 0
const addScore = 1000

@onready var animation_player: AnimationPlayer 


func _ready() -> void:
	animation_player = get_node_or_null("../AnimationPlayer")
	
#region Initialize tracing paths
	childrens = get_children(false)
	print(childrens)
	
	#this hides the progress bar sequencially so it cannot be operated or touch whilst 
	#the index is still not finished
	for child in childrens:
		child.hide()
		if child.orderID == childPointer:
			child.show()
		if child.orderID >= lastTracingOrder:
			lastTracingOrder = child.orderID
			#print(lastTracingOrder)
#endregion

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
#region Finished Tracing
	#This is the part that checks if the final trace is already finished
	if lastTracingOrder < childPointer:
		#Store the score in a global
		TracingData.score = TracingData.score + addScore
		
		#plays the fade animation after finished
		if animation_player == null:
			return
		var direction = randi_range(0,1)
		if direction == 1:
			animation_player.play("letterCardFadeRight")
		else: 
			animation_player.play("letterCardFadeLeft")
		
		await animation_player.animation_finished
		get_parent().hide()
		return
#endregion
		
	for child in childrens:
		if child.orderID != childPointer:
			continue
		child.show()
	
