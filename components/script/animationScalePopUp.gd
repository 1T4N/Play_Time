extends Button 
var isFinishedInitializing:bool = false

func _ready() -> void:
	mouse_entered.connect(_on_button_mouse_entered)
	mouse_exited.connect(_on_button_mouse_exited)

func scaleUpAnimation():
	set_pivot_offset(get_size()/2)
	var tween = create_tween().set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(self,"scale",Vector2.ZERO,0)
	tween.tween_property(self,"self_modulate",Color.WHITE,0.3)
	tween.tween_property(self,"scale",Vector2.ONE,0.3)



@export var hoverAnimationScale:float = 1.1

func _on_button_mouse_entered():
	if not isFinishedInitializing:
		return
	set_default_cursor_shape(CURSOR_POINTING_HAND)
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property(self,"scale",Vector2(hoverAnimationScale, hoverAnimationScale), 0.3)
	pass

func _on_button_mouse_exited():
	if not isFinishedInitializing:
		return
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property(self,"scale",Vector2.ONE, 0.3)
	pass
