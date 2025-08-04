extends PanelContainer
const WhatGame = preload("res://GameUI/scenes/Component/whatGame.gd")
@onready var score: Label = $MarginContainer/Score

func _ready() -> void:
	var game = WhatGame.new(self.name)
	
	if not ProfileDataGlobals.saveData.has(game.gameName):
		score.text = "No Data"
		return
	
	var scores:Array = ProfileDataGlobals.saveData[game.gameName].scores
	score.text = str(scores.max())
	
