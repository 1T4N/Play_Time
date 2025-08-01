extends Label
var childrens:Array
var childPointer:int = 0
var lastTracingOrder:int = 0
const addScore = 1000

@onready var animation_player: AnimationPlayer 

var originalPos

func _ready() -> void:
	animation_player = get_node_or_null("../AnimationPlayer")
	await get_tree().create_timer(0.5).timeout  # Waits 1 second
	originalPos = get_parent().position
	#print(originalPos)
	
#region Initialize tracing paths
	childrens = get_children(false)
	#print(childrens)
	
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
	#print(originalPos)
#region Checks if already traced or not
	#checks if part of the letter is already traced, then move to the next one to trace it
	for child in childrens:
		if child.orderID != childPointer:
			continue
		
		#this makes the lettercard Shake after failing the trace
		if child.retry == true:
			const speed = 0.015
			const shakeOffset = 10
			var tween = create_tween()
			tween.set_trans(Tween.TRANS_SINE)
			tween.tween_property(get_parent(),"position",originalPos - Vector2(shakeOffset,0),speed)
			tween.tween_property(get_parent(),"position",originalPos,speed)
			tween.tween_property(get_parent(),"position",originalPos + Vector2(shakeOffset,0),speed)
			tween.tween_property(get_parent(),"position",originalPos,speed)
			tween.tween_property(get_parent(),"position",originalPos - Vector2(shakeOffset,0),speed)
			tween.tween_property(get_parent(),"position",originalPos,speed)
			tween.tween_property(get_parent(),"position",originalPos + Vector2(shakeOffset,0),speed)
			tween.tween_property(get_parent(),"position",originalPos,speed)
			#animation_player.play("shake")
			Input.vibrate_handheld()
			#animation_player.set_speed_scale(2)
			#await animation_player.animation_finished
			#animation_player.set_speed_scale(1)
			await tween.finished
			child.retry = false
			
		
		if child.finished == true:
			print("Next")
			var childrensOfChild = child.get_children()
			for childrenOfChild in childrensOfChild:
				if childrenOfChild is Line2D:
					childrenOfChild.hide()
			child.set_process_mode(PROCESS_MODE_DISABLED)
			childPointer = childPointer + 1
			showNextTrace()
#endregion

func showNextTrace():
#region Finished Tracing
	#This is the part that checks if the final trace is already finished
	if lastTracingOrder < childPointer:
		#Store the score in a global
		globalGameData.currentGameScore = globalGameData.currentGameScore + addScore
		
		#this checks if the letter tracing is already finish which will make the card swipe out and hide itself
		#plays the fade animation after finished
		if animation_player == null:
			return
		var direction = randi_range(0,1)
		if direction == 1:
			animation_player.play("letterCardFadeRight")
		else: 
			animation_player.play("letterCardFadeLeft")
		
		await animation_player.animation_finished
		
		#this shows the game over scene if it detects that there's a script letterCard.gd on the LetterCard(Letter)
		if "isLastCard" in get_parent():
			if not get_parent().isLastCard:
				return
			get_parent().hide()
			get_parent().showGameOver()
			get_tree().paused = true
		
		get_parent().hide()
		
		return
#endregion
		
	for child in childrens:
		if child.orderID != childPointer:
			continue
		child.show()
	
