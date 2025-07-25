extends Control
#@onready var touch_the_screen: Button = $"Panel/touch the screen"
@onready var title_screen: Panel = $TitleScreen
@onready var labels: VBoxContainer = $TitleScreen/Labels

@onready var profiler: VBoxContainer = $PanelContainer/MarginContainer/VBoxContainer/profiler
@onready var panel_container: PanelContainer = $PanelContainer

@export var showProfileAnimSpeed:float = 0.4

func _ready() -> void:
	panel_container.set_pivot_offset(panel_container.get_size()/2)
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property(panel_container,"scale",Vector2.ZERO, 0.0)


func _on_touch_the_screen_pressed() -> void:
	#this is only because there's a shader in the label, I couldve used BBCode but i didnt knew it at the time
	var childrens = labels.get_children()
	for child in childrens:
		child.material = null
	
	hideTitleScreenAnim()
	#await get_tree().create_timer(0.3).timeout
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
	panel_container.set_pivot_offset(panel_container.get_size()/2)
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property(panel_container,"scale",Vector2.ONE, showProfileAnimSpeed)
	await tween.finished
	profiler.playAnimations()
	
