extends Node
var currentGameID

var currentGameScore:int = 0
var LetterTracingTime:int

signal retry
var timeDeduction:int = 5

func resetData():
	globalGameData.currentGameScore = 0
	globalGameData.LetterTracingTime = 0


signal transition(pathToNextScene:String)
var isTransitionPlayed:bool
