extends Button
@export_range(0,2,1) var profileID:int
var IsCreateProfile:bool = false

#This contains the save datas
var datas

func _ready() -> void:
	#this initialize the text if there is an existing savefile on that profile
	#set_pivot_offset(get_size()/2)
	#print(profileID)
	var save_file = FileAccess.open_encrypted_with_pass("user://profileID" + str(profileID) + ".json",FileAccess.READ,ProfileDataGlobals.securityKey)

	#checks if save file exist, if not then it would display the text placeholder
	if save_file == null:
		print("Failed to open path: ", save_file)
		IsCreateProfile = true
		return
		
	var contents = save_file.get_as_text()
	datas = JSON.parse_string(contents)
	
	#print(contents)
	text = "Name: " + datas.profile.name + "\nAge: " + datas.profile.age

	##Sets the initials scale to zero since you cant do it if its not via tween
	#var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	#tween.tween_property(self,"scale",Vector2.ZERO, 0.0)
	pass
	
#func tweening():
	#set_pivot_offset(get_size()/2)
	#var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	#tween.tween_property(self,"scale",Vector2(1, 1), 0.3)
	
	
