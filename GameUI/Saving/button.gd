extends Button
@export_range(0,2,1) var profileID:int

func _ready() -> void:
	set_pivot_offset(get_size()/2)
	#print(profileID)
	var save_file = FileAccess.open_encrypted_with_pass("user://profileID" + str(profileID) + ".json",FileAccess.READ,ProfileDataGlobals.securityKey)

	#checks if save file exist, if not then it would display the text placeholder
	if save_file == null:
		print("Failed to open path: ", save_file)
		return
		
	var contents = save_file.get_as_text()
	var data = JSON.parse_string(contents)
	
	print(contents)
	text = data.profile.name

	#Sets the initials scale to zero since you cant do it if its not via tween
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property(self,"scale",Vector2.ZERO, 0.0)
	
	
	
	#while save_file.get_position() < save_file.get_length():
		##region You can disregard this part but its good to know what it does
		#var json_string = save_file.get_line()
#
		## Creates the helper class to interact with JSON.
		#var json = JSON.new()
#
		## Check if there is any error while parsing the JSON string, skip in case of failure.
		#var parse_result = json.parse(json_string)
		#if not parse_result == OK:
			#print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			#continue
		##endregion
		#
		#var node_data = json.data
		#print(node_data)
		#for i in node_data.keys():
			#if i == "profile":
				#text = node_data[i]["name"]
			#pass
		#
	#tweening()
	pass
	
func tweening():
	set_pivot_offset(get_size()/2)
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property(self,"scale",Vector2(1, 1), 0.3)
	
