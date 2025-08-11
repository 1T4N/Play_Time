extends Control
#@onready var touch_the_screen: Button = $"Panel/touch the screen"
@onready var title_screen: Panel = $TitleScreen
@onready var labels: VBoxContainer = $TitleScreen/Labels

@onready var profiler: VBoxContainer = %profiler
@onready var panel_container: PanelContainer = $HBoxContainer/PanelContainer

@export var showProfileAnimSpeed:float = 0.4
@onready var h_box_container: HBoxContainer = $HBoxContainer

@onready var touch_the_screen: Button = $"TitleScreen/touch the screen"


func _ready() -> void:
	h_box_container.set_pivot_offset(h_box_container.get_size()/2)
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property(h_box_container,"scale",Vector2.ZERO, 0.0)
	#h_box_container.hide()
	call_deferred("checkIfChoosedProfile")

func checkIfChoosedProfile():
	if globalGameData.isTransitionPlayed:
		return
	if not ProfileDataGlobals.saveData:
		return
	touch_the_screen.emit_signal("pressed")
	
func _on_touch_the_screen_pressed() -> void:
	
	#this is only because there's a shader in the label, I couldve used BBCode but i didnt knew it at the time
	var childrens = labels.get_children()
	for child in childrens:
		child.material = null
	
	hideTitleScreenAnim()
	#await get_tree().create_timer(0.3).timeout
	h_box_container.show()
	panel_container.show()
	showPanelAnim()
	
	#get_tree().change_scene_to_file("res://GameUI/scenes/Main_Screen.tscn")
 

func hideTitleScreenAnim():
	var tween = create_tween().set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(labels,"modulate",Color("ffffff00"),0.3)
	await tween.finished
	labels.hide()
	
func showPanelAnim():
	h_box_container.set_pivot_offset(h_box_container.get_size()/2)
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property(h_box_container,"scale",Vector2.ONE, showProfileAnimSpeed)
	await tween.finished
	profiler.playAnimations()
	
	

	
