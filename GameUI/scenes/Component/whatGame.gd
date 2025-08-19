extends Node
var gameName:String

func _init(nodeName:String):
	match nodeName:
		"Letter Tracing":
			gameName = "letterTracingData"
		"Shape Safari":
			gameName = "shapeSafariData"
		"Color Hunt":
			gameName = "colorHuntData"
		"Sound Hunt":
			gameName = "soundHuntData"
		"Matching Game":
			gameName = "matchingGameData"
		"Puzzle Builder":
			gameName = "puzzleBuilderData"
